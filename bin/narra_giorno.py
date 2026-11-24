#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "google-genai",
# ]
# ///
"""Generate expressive IT + EN audio narrations using gemini-3.8-flash-tts.
Splits long narratives by paragraph so audio is never truncated and never reads prompt instructions.
"""
import argparse
import os
import subprocess
import sys
import wave
from google import genai
from google.genai import types


def save_pcm_as_mp3(pcm_bytes: bytes, mp3_path: str, sample_rate: int = 24000) -> None:
    os.makedirs(os.path.dirname(mp3_path), exist_ok=True)
    wav_path = mp3_path + ".tmp.wav"
    with wave.open(wav_path, "wb") as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(sample_rate)
        wf.writeframes(pcm_bytes)
    subprocess.run(
        ["ffmpeg", "-y", "-i", wav_path, "-codec:a", "libmp3lame", "-b:a", "128k", mp3_path],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    os.remove(wav_path)


def chunk_paragraphs(text: str, max_chars: int = 380) -> list[str]:
    """Split pure narration text into natural chunks <= max_chars."""
    paras = [p.strip() for p in text.split("\n") if p.strip()]
    chunks: list[str] = []
    cur = ""
    for p in paras:
        if cur and len(cur) + 1 + len(p) > max_chars:
            chunks.append(cur)
            cur = p
        else:
            cur = f"{cur}\n{p}" if cur else p
    if cur:
        chunks.append(cur)
    return chunks


def strip_wav_header(data: bytes) -> bytes:
    """If Gemini returns a WAV container instead of raw PCM, strip the RIFF/data header."""
    if data[:4] == b"RIFF" and b"data" in data[:128]:
        idx = data.index(b"data")
        return data[idx + 8:]
    return data


def apply_edge_fade(pcm: bytes, sample_rate: int = 24000, fade_ms: int = 15) -> bytes:
    """Apply a tiny 15ms fade-in/fade-out on 16-bit mono PCM to eliminate any boundary clicks."""
    import array
    samples = array.array("h")
    samples.frombytes(pcm[: len(pcm) - (len(pcm) % 2)])
    n = min(int(sample_rate * fade_ms / 1000), len(samples) // 2)
    for i in range(n):
        gain = i / n
        samples[i] = int(samples[i] * gain)
        samples[-1 - i] = int(samples[-1 - i] * gain)
    return samples.tobytes()


def generate_tts_chunk(client: genai.Client, text: str, voice_name: str, model: str) -> bytes:
    response = client.models.generate_content(
        model=model,
        contents=text,
        config=types.GenerateContentConfig(
            response_modalities=["AUDIO"],
            speech_config=types.SpeechConfig(
                voice_config=types.VoiceConfig(
                    prebuilt_voice_config=types.PrebuiltVoiceConfig(
                        voice_name=voice_name
                    )
                )
            ),
        ),
    )
    pcm = bytearray()
    for cand in (response.candidates or []):
        if not cand.content or not cand.content.parts:
            continue
        for part in cand.content.parts:
            if part.inline_data is not None and part.inline_data.data:
                pcm.extend(strip_wav_header(part.inline_data.data))
    if not pcm:
        raise RuntimeError(f"No audio returned for chunk: {text[:60]!r}")
    return apply_edge_fade(bytes(pcm))


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate full-length expressive narration with Gemini 3.8 Flash TTS")
    parser.add_argument("--text-file", required=True, help="Path to pure narration text file (NO prompt instructions!)")
    parser.add_argument("--output", required=True, help="Output MP3 path")
    parser.add_argument("--voice", default="Puck", help="Prebuilt voice name (Puck, Aoede, Kore, Charon, Fenrir)")
    parser.add_argument("--model", default=os.environ.get("TTS_MODEL", "gemini-3.8-flash-tts"), help="Gemini TTS model")
    args = parser.parse_args()

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("ERROR: GEMINI_API_KEY is not set", file=sys.stderr)
        sys.exit(1)

    with open(args.text_file, "r", encoding="utf-8") as f:
        text = f.read().strip()

    chunks = chunk_paragraphs(text, max_chars=380)
    print(f"Generating TTS ({args.model}, voice={args.voice}, {len(chunks)} chunks) -> {args.output}")

    client = genai.Client(api_key=api_key, http_options=types.HttpOptions(api_version="v1beta"))
    silence_350ms = b"\x00\x00" * int(24000 * 0.35)  # 16-bit mono PCM @ 24kHz
    full_pcm = bytearray()

    for idx, chunk in enumerate(chunks, 1):
        print(f"  [{idx}/{len(chunks)}] ({len(chunk)} chars)...")
        pcm = generate_tts_chunk(client, chunk, args.voice, args.model)
        full_pcm.extend(pcm)
        if idx < len(chunks):
            full_pcm.extend(silence_350ms)

    save_pcm_as_mp3(bytes(full_pcm), args.output, sample_rate=24000)
    dur_s = len(full_pcm) / (24000 * 2)
    print(f"Saved {args.output} ({os.path.getsize(args.output) // 1024} KB, {dur_s:.1f}s)")


if __name__ == "__main__":
    main()
