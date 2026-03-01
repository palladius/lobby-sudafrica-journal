#!/usr/bin/env ruby

require 'date'

# Define the horizon: 5 to 25 February
START_DATE = Date.new(2026, 2, 5)
END_DATE = Date.new(2026, 2, 25)

# The root directory of the journal
DIR = File.expand_path('..', __dir__)

def run_tests_for_date(date)
  date_str = date.strftime('%Y-%m-%d')
  date_no_dash = date.strftime('%Y%m%d')
  file_path = File.join(DIR, "#{date_str}.md")
  
  puts "Testing #{date_str}..."
  
  unless File.exist?(file_path)
    puts "  [SKIP] File #{date_str}.md does not exist."
    return
  end

  content = File.read(file_path)
  lines = content.lines

  # Test 1: Google Photos link in first 10 lines
  google_photos_link = "https://photos.google.com/search/#{date_str}"
  first_10_lines = lines[0...10].join
  if first_10_lines.include?(google_photos_link)
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
      
      if img_path.start_with?(expected_real) || img_path.start_with?(expected_pixar)
        # also check if the file actually exists
        full_img_path = File.join(DIR, img_path)
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

if ARGV.empty?
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
