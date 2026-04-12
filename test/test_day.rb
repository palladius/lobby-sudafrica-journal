#!/usr/bin/env ruby

require 'date'
Encoding.default_external = Encoding::UTF_8

# Define the horizon: 5 to 25 February
START_DATE = Date.new(2026, 2, 5)
END_DATE = Date.new(2026, 2, 25)

# The root directory of the journal
DIR = File.expand_path('..', __dir__)

def run_tests_for_date(date)
  date_str = date.strftime('%Y-%m-%d')
  date_no_dash = date.strftime('%Y%m%d')
  
  # Try Jekyll post first
  posts_dir = File.join(DIR, 'jekyll-site', '_posts')
  candidates = Dir.glob(File.join(posts_dir, "#{date_str}-*.md"))
  file_path = candidates.first if candidates.any?
  is_jekyll = !file_path.nil?

  # Try root file if Jekyll doesn't exist (legacy)
  unless file_path && File.exist?(file_path)
    file_path = File.join(DIR, "#{date_str}.md")
  end

  puts "Testing #{date_str}..."
  
  unless file_path && File.exist?(file_path)
    puts "  [SKIP] No journal file found for #{date_str} in root or jekyll-site/_posts."
    return
  end

  content = File.read(file_path)
  lines = content.lines

  # Test 1: Google Photos link in first 10 lines
  google_photos_link = "https://photos.google.com/search/#{date_str}"
  first_10_lines = lines[0...10].join
  is_reviewed = first_10_lines.match?(/^page-status:\s*REVIEWED/)
  
  if is_jekyll
    if is_reviewed
      puts "  [PASS] Google Photos link check skipped (Jekyll post is REVIEWED)."
    else
      # If not reviewed, Jekyll layout provides the banner with the link
      puts "  [PASS] Google Photos link provided by Jekyll layout banner (post is NOT REVIEWED)."
    end
  elsif is_reviewed
    puts "  [PASS] Google Photos link check skipped (root file is REVIEWED)."
  elsif first_10_lines.include?(google_photos_link)
    puts "  [PASS] Google Photos link found in the first 10 lines."
  else
    puts "  [FAIL] Missing or incorrect Google Photos link in the first 10 lines."
  end

  # Test 2: Image links format
  # We look for img tags or markdown images
  fails = 0
  lines.each_with_index do |line, idx|
    # match markdown pictures ![alt](path) or HTML <img src="path">
    images = line.scan(/!\[.*?\]\((.*?)\)|<img.*?src="(.*?)".*?>/)
    images.each do |md_img, html_img|
      img_path = md_img || html_img
      next unless img_path # skip empty
      
      # It must start with images/real/YYYYMMDD or images/pixar/YYYYMMDD
      # unless it's an external link
      next if img_path.start_with?('http')

      expected_real = "images/real/#{date_no_dash}/"
      expected_pixar = "images/pixar/#{date_no_dash}/"
      expected_jekyll = "/assets/images/#{date_str}/"
      expected_jekyll_rel = "assets/images/#{date_str}/"
      
      # Additional allowed structures
      date_parts = date_str.split('-') # ["2026", "02", "23"]
      expected_jekyll_pixar = "/assets/images/pixar/#{date_parts[0]}/#{date_parts[1]}/#{date_parts[2]}/"
      expected_jekyll_original = "/assets/images/original/#{date_parts[0]}/#{date_parts[1]}/#{date_parts[2]}/"
      
      if img_path.start_with?(expected_real) || img_path.start_with?(expected_pixar) || 
         img_path.start_with?(expected_jekyll) || img_path.start_with?(expected_jekyll_rel) ||
         img_path.start_with?(expected_jekyll_pixar) || img_path.start_with?(expected_jekyll_original)
        # also check if the file actually exists
        img_path_rel = img_path.sub(/\A\//, '')
        if img_path_rel.start_with?('assets/')
          full_img_path = File.join(DIR, 'jekyll-site', img_path_rel)
        else
          full_img_path = File.join(DIR, img_path_rel)
        end
        
        if File.exist?(full_img_path)
          # ok
        else
          puts "  [WARN] Image referenced but missing on disk: #{img_path} (Line #{idx+1})"
        end
      else
        puts "  [FAIL] Invalid image path: '#{img_path}' (Line #{idx+1}). Expected to start with #{expected_real} or #{expected_pixar}"
        fails += 1
      end
    end
  end
  puts "  [PASS] All image paths are formatted correctly." if fails == 0

  # Test 3: Check there are no OTHER files mentioning the date XXXX-YY-MM
  # (to force us to aggregate)
  other_files = Dir.glob(File.join(DIR, "*.md")) - [file_path]
  ignore_list = ['README.md', 'README_original.md', 'README_completo.md', 'GEMINI.md', 'TODO.md', 'WORKFLOW.md']
  
  warning_emitted = false
  other_files.each do |other_file|
    file_name = File.basename(other_file)
    next if ignore_list.include?(file_name)

    other_content = File.read(other_file)
    if other_content.include?(date_str) || other_content.include?(date_no_dash)
        puts "  [WARN] Date #{date_str} (or #{date_no_dash}) is mentioned in another file: #{file_name} - Consider aggregating!"
        warning_emitted = true
    end
  end
  puts "  [PASS] No other top-level markdown files mention #{date_str} or #{date_no_dash}." unless warning_emitted

  puts "--------------------------------------------------------"
end

filter_day_env = ENV['TEST_SUDAFRICA_DAY']

if !filter_day_env.nil? && !filter_day_env.empty?
  puts "Running tests for single day (env): #{filter_day_env}"
  puts "========================================================"
  begin
    date = Date.parse(filter_day_env)
    run_tests_for_date(date)
  rescue ArgumentError
    puts "Invalid date format in TEST_SUDAFRICA_DAY. Please use YYYY-MM-DD or YYYYMMDD"
    exit 1
  end
elsif ARGV.empty?
  puts "Running tests for all dates between #{START_DATE} and #{END_DATE}"
  puts "========================================================"
  (START_DATE..END_DATE).each do |date|
    run_tests_for_date(date)
  end
else
  # Run for specific date provided as argument
  date_arg = ARGV[0]
  begin
    date = Date.parse(date_arg)
    run_tests_for_date(date)
  rescue ArgumentError
    puts "Invalid date format. Please use YYYY-MM-DD"
    exit 1
  end
end
