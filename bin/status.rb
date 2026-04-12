#!/usr/bin/env ruby

require 'date'
Encoding.default_external = Encoding::UTF_8

DIR = File.expand_path('..', __dir__)
POSTS_DIR = File.join(DIR, 'jekyll-site', '_posts')

C_GRAY   = "\e[90m"
C_YELLOW = "\e[33m"
C_GREEN  = "\e[32m"
C_RESET  = "\e[0m"

files = Dir.glob(File.join(POSTS_DIR, "*.md"))

results = []

files.each do |file|
  content = File.read(file)
  
  # Parse Frontmatter
  yaml_block = content[/^---\s*\n(.*?)\n---(\s*\n|$)/m, 1]
  title = "Unknown Title"
  title_emoji = "  "
  status = "EMPTY"
  date = File.basename(file).match(/^(\d{4}-\d{2}-\d{2})/) ? $1 : "9999-99-99"
  
  if yaml_block
    title_match = yaml_block.match(/^title:\s*"(.*?)"/) || yaml_block.match(/^title:\s*(.*)/)
    title = title_match ? title_match[1] : "Unknown Title"
    
    emoji_match = yaml_block.match(/^title_emoji:\s*"(.*?)"/) || yaml_block.match(/^title_emoji:\s*(.*)/)
    # Pad emoji to ~2 spaces in display
    # If the user explicitly sets spacing in the markdown, we obey it, 
    # but we can fallback to ljust(2) if they didn't.
    if emoji_match && !emoji_match[1].strip.empty?
      raw_emoji = emoji_match[1]
      title_emoji = raw_emoji + " "  # guarantee space between emoji and title
    else
      title_emoji = "  "
    end
    
    status_match = yaml_block.match(/^page-status:\s*(\w+)/)
    status = status_match ? status_match[1] : "EMPTY"
  end
  
  # Count images
  real_count = content.scan(/images\/(real|original)\//).size
  banana_count = content.scan(/images\/pixar\//).size
  
  results << { date: date, title_emoji: title_emoji, title: title, status: status, real: real_count, banana: banana_count }
end

# Sort by Date
results.sort_by! { |r| r[:date] }

# Output
puts "\n#{C_GRAY}========================================================================#{C_RESET}"
puts "                 📓 Journal Pages Status Dashboard"
puts "#{C_GRAY}========================================================================#{C_RESET}\n\n"

counts = Hash.new(0)

results.each do |r|
  counts[r[:status]] += 1
  
  case r[:status]
  when "REVIEWED"
    color = C_GREEN
  when "PENDING"
    color = C_YELLOW
  when "EMPTY", "TODO"
    color = C_GRAY
  else
    color = C_GRAY
  end
  
  status_str = r[:status][0...5].ljust(5)
  counts_str = format("%2d/%-2d", r[:banana], r[:real])
  
  puts "#{r[:date]} #{color}#{status_str}#{C_RESET} #{counts_str} | #{r[:title]}"
end

puts "\n#{C_GRAY}------------------------------------------------------------------------#{C_RESET}"
puts "Summary: "
puts "  🟩 REVIEWED: #{C_GREEN}#{counts['REVIEWED']}#{C_RESET}"
puts "  🟨 PENDING:  #{C_YELLOW}#{counts['PENDING']}#{C_RESET}"
puts "  ⬜ EMPTY:    #{C_GRAY}#{counts['EMPTY']}#{C_RESET}"
puts "#{C_GRAY}========================================================================#{C_RESET}\n"
