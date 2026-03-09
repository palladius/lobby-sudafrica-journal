#!/usr/bin/env ruby
require 'yaml'

# This script checks all posts in jekyll-site/_posts for required frontmatter fields.
# Fields required: layout, title, date, cover-img, thumbnail-img

posts_dir = File.expand_path('../../jekyll-site/_posts', __FILE__)
filter_day = ENV['TEST_SUDAFRICA_DAY'] # e.g., 20260210

puts "🔍 Checking frontmatter in #{posts_dir}"
puts "📅 Filtering for day: #{filter_day}" if filter_day

missing_fields = Hash.new { |hash, key| hash[key] = [] }
required_fields = ['layout', 'title', 'date', 'cover-img', 'thumbnail-img']

Dir.glob(File.join(posts_dir, '*.md')).each do |file|
  basename = File.basename(file)
  
  if filter_day
    # Post filenames start with YYYY-MM-DD
    # We strip dashes from the filter_day if needed, but assuming user provides YYYYMMDD or YYYY-MM-DD
    normalized_filter = filter_day.gsub('-', '')
    normalized_file_date = basename[0..9].gsub('-', '')
    next unless normalized_file_date == normalized_filter
  end

  content = File.read(file)
  
  if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
    front_matter_str = $1
    begin
      front_matter = YAML.safe_load(front_matter_str, permitted_classes: [Time, Date])
      
      required_fields.each do |field|
        if front_matter[field].nil? || front_matter[field].to_s.strip.empty?
          missing_fields[basename] << field
        end
      end
    rescue => e
      puts "⚠️ Error parsing front matter in #{basename}: #{e.message}"
      missing_fields[basename] << "VALID_YAML_PARSE_FAILED"
    end
  else
    missing_fields[basename] << "NO_FRONT_MATTER_FOUND"
  end
end

if missing_fields.empty?
  puts "✅ All posts have the required frontmatter fields!"
  exit 0
else
  puts "❌ Found posts with missing or empty frontmatter fields:"
  missing_fields.each do |file, fields|
    puts "\nIn #{file}:"
    fields.each { |f| puts "  - Missing field: #{f}" }
  end
  exit 1
end
