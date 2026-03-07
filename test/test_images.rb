#!/usr/bin/env ruby
require 'yaml'

# This script checks all posts in jekyll-site/_posts for broken image links.
# It checks both the front matter (thumbnail-img, cover-img) and the body (markdown and HTML images).

posts_dir = File.expand_path('../../jekyll-site/_posts', __FILE__)
site_dir = File.expand_path('../../jekyll-site', __FILE__)

puts "🔍 Checking for broken images in #{posts_dir}"

broken_images = Hash.new { |hash, key| hash[key] = [] }

Dir.glob(File.join(posts_dir, '*.md')).each do |file|
  content = File.read(file)
  
  # Parse front matter
  if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
    front_matter_str = $1
    begin
      front_matter = YAML.safe_load(front_matter_str, permitted_classes: [Time, Date])
      
      ['thumbnail-img', 'cover-img'].each do |key|
        if front_matter[key]
          img_path = front_matter[key]
          # Remove leading slash to make it relative to site_dir
          relative_img_path = img_path.sub(/\A\//, '')
          full_img_path = File.join(site_dir, relative_img_path)
          
          if !File.exist?(full_img_path)
            broken_images[File.basename(file)] << "Front matter '#{key}': #{img_path}"
          end
        end
      end
    rescue => e
      puts "⚠️ Error parsing front matter in #{File.basename(file)}: #{e.message}"
    end
  end

  # Find HTML img tags: <img src="/assets/..."
  content.scan(/<img[^>]+src=["']([^"']+)["']/i).each do |match|
    img_path = match[0]
    next if img_path.start_with?('http') # Skip external images
    
    relative_img_path = img_path.sub(/\A\//, '')
    full_img_path = File.join(site_dir, relative_img_path)
    
    if !File.exist?(full_img_path)
      broken_images[File.basename(file)] << "HTML tag: #{img_path}"
    end
  end

  # Find Markdown images: ![alt](/assets/...)
  content.scan(/!\[.*?\]\((.*?)\)/).each do |match|
    img_path = match[0]
    next if img_path.start_with?('http') # Skip external images
    
    relative_img_path = img_path.sub(/\A\//, '')
    full_img_path = File.join(site_dir, relative_img_path)
    
    if !File.exist?(full_img_path)
      broken_images[File.basename(file)] << "Markdown link: #{img_path}"
    end
  end
end

if broken_images.empty?
  puts "✅ All image links are valid! No broken images found."
  exit 0
else
  puts "❌ Found broken images:"
  broken_images.each do |file, errors|
    puts "\nIn #{file}:"
    errors.each { |err| puts "  - #{err}" }
  end
  exit 1
end
