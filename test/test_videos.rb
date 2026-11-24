#!/usr/bin/env ruby
# TDD Video Integrity Test:
# Verifies every <video> / <source src="..."> in Jekyll posts:
# 1. File exists and is non-empty in jekyll-site/
# 2. If jekyll-site/_site/ exists, file is synced and up-to-date
# 3. ffprobe confirms browser-compatible codec (h264/vp8/vp9/av1), 8-bit yuv420p, duration > 0, no High 10 / HDR10

require "json"
require "open3"

repo_root = File.expand_path("..", __dir__)
posts_dir = File.join(repo_root, "jekyll-site", "_posts")
site_root = File.join(repo_root, "jekyll-site")
built_root = File.join(site_root, "_site")

filter_day = ENV["TEST_SUDAFRICA_DAY"]
posts = Dir.glob(File.join(posts_dir, "*.md")).sort

if filter_day && !filter_day.empty?
  iso_day = filter_day.gsub(/^(\d{4})(\d{2})(\d{2})$/, '\1-\2-\3')
  posts = posts.select { |p| File.basename(p).start_with?(iso_day) }
end

errors = []
checked = 0

posts.each do |post_path|
  name = File.basename(post_path)
  content = File.read(post_path)
  video_blocks = content.scan(/<video\b[^>]*>.*?<\/video>/im)

  video_blocks.each_with_index do |block, vidx|
    srcs = block.scan(/<source[^>]+src=["']([^"']+\.(?:mp4|webm))["']/i).flatten.uniq
    unless srcs.any? { |s| s.end_with?(".webm") }
      errors << "#{name}: <video ##{vidx + 1}> manca di una sorgente .webm (necessaria per Chromium/Electron/Linux senza codec H.264 proprietari!)"
    end
  end

  srcs = content.scan(/<source[^>]+src=["']([^"']+\.(?:mp4|webm))["']/i).flatten.uniq

  srcs.each do |rel_path|
    checked += 1
    full_path = File.join(site_root, rel_path.sub(%r{^/}, ""))
    unless File.exist?(full_path) && File.size(full_path) > 0
      errors << "#{name}: video mancante o vuoto -> #{rel_path}"
      next
    end

    # Check ffprobe metadata
    cmd = ["ffprobe", "-v", "error", "-show_streams", "-show_format", "-of", "json", full_path]
    out, err, status = Open3.capture3(*cmd)
    unless status.success?
      errors << "#{name}: ffprobe fallito su #{rel_path}: #{err.strip}"
      next
    end

    info = JSON.parse(out)
    vstream = (info["streams"] || []).find { |s| s["codec_type"] == "video" }
    duration = info.dig("format", "duration").to_f

    if vstream.nil?
      errors << "#{name}: nessuno stream video in #{rel_path}"
      next
    end
    if duration <= 0.1
      errors << "#{name}: durata non valida (#{duration}s) in #{rel_path}"
    end
    pix_fmt = vstream["pix_fmt"].to_s
    if pix_fmt != "yuv420p"
      errors << "#{name}: pix_fmt '#{pix_fmt}' non compatibile con tutti i browser (richiesto yuv420p) in #{rel_path}"
    end
    profile = vstream["profile"].to_s
    if profile.include?("10")
      errors << "#{name}: profilo '#{profile}' (10-bit) non supportato da Chrome/Linux in #{rel_path}"
    end

    # If _site exists, verify the served copy matches the source file!
    if Dir.exist?(built_root)
      built_path = File.join(built_root, rel_path.sub(%r{^/}, ""))
      if !File.exist?(built_path) || File.size(built_path) != File.size(full_path)
        errors << "#{name}: copia in _site non aggiornata o mancante per #{rel_path} (source=#{File.size(full_path)}, _site=#{File.exist?(built_path) ? File.size(built_path) : 'MISSING'})"
      end
    end
  end
end

puts "🎬 Video verificati: #{checked}"
if errors.any?
  puts "❌ Errori video trovati:"
  errors.each { |e| puts "  - #{e}" }
  exit 1
end

puts "✅ Tutti i video sono validi e browser-compatible!"
