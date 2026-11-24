#!/usr/bin/env ruby
# Verifica la presenza e l'integrità dei file audio (audio_story.html) nei post Jekyll.

repo_root = File.expand_path("..", __dir__)
posts_dir = File.join(repo_root, "jekyll-site", "_posts")
site_root = File.join(repo_root, "jekyll-site")

filter_day = ENV["TEST_SUDAFRICA_DAY"]
posts = Dir.glob(File.join(posts_dir, "*.md")).sort

if filter_day && !filter_day.empty?
  iso_day = filter_day.gsub(/^(\d{4})(\d{2})(\d{2})$/, '\1-\2-\3')
  posts = posts.select { |p| File.basename(p).start_with?(iso_day) }
end

broken = []
with_audio = []
without_audio = []

posts.each do |post_path|
  name = File.basename(post_path)
  content = File.read(post_path)
  includes = content.scan(/\{%\s*include\s+audio_story\.html\s+([^%]+)%\}/).flatten

  if includes.empty?
    without_audio << name
    next
  end

  langs = []
  includes.each do |attrs|
    attrs.scan(/(it|en)=["']([^"']+)["']/).each do |lang, rel_path|
      langs << lang.upcase
      full_path = File.join(site_root, rel_path.sub(%r{^/}, ""))
      if !File.exist?(full_path) || File.size(full_path) == 0
        broken << "#{name} (#{lang.upcase}): #{rel_path} mancante o vuoto"
      end
    end
  end
  with_audio << "#{name} [#{langs.uniq.join('+')}]"
end

puts "🎙️ Post con audio (#{with_audio.size}):"
with_audio.each { |p| puts "  ✅ #{p}" }
puts "🔇 Post senza audio (#{without_audio.size})" unless without_audio.empty?

if broken.any?
  puts "❌ File audio rotti o mancanti:"
  broken.each { |b| puts "  - #{b}" }
  exit(1)
end

puts "✅ Tutti i file audio referenziati sono validi!"
