#!/usr/bin/env ruby
require 'digest'
require 'fileutils'

puts "Scanning for files..."
files = Dir.glob("{images,assets,jekyll-site/assets}/**/*", File::FNM_DOTMATCH).select { |f| File.file?(f) }
by_hash = Hash.new { |h, k| h[k] = [] }

puts "Calculating MD5 hashes for #{files.size} files..."
files.each do |f|
  next if File.basename(f) == '.DS_Store' || f.include?('/.git/')
  hash = Digest::MD5.file(f).hexdigest
  by_hash[hash] << f
end

def calculate_score(path)
  # High score means KEEP THIS ONE.
  score = 0
  
  # 1. Prefer jekyll-site/assets/images over others
  if path.start_with?('jekyll-site/assets/')
    score += 100
  elsif path.start_with?('assets/images/')
    score += 50
  end

  # 2. Prefer explicit 'original' or 'pixar' folders to keep organization clean
  if path.include?('/original/') || path.include?('/pixar/')
    score += 30
  end

  # 3. Penalize the 'viaggio_recovered' as they are often just backups/dumps
  if path.include?('viaggio_recovered')
    score -= 20
  end

  # 4. Prefer files inside a valid date folder (e.g. 20260205 or 2026-02-05)
  if path.match?(/\/\d{4}-?\d{2}-?\d{2}\//)
    score += 15
  end

  score
end

deleted_count = 0
space_saved = 0

by_hash.each do |hash, group|
  next if group.size < 2

  # Sort by score descending. Highest score first.
  # If scores are equal, keep the shortest path string (often simpler).
  sorted_group = group.sort_by { |f| [-calculate_score(f), f.length, f] }
  
  keeper = sorted_group.first
  
  # Check if we should delete the others
  sorted_group[1..-1].each do |dupe|
    puts "KEEP: #{keeper}"
    puts "  -> DELETE: #{dupe}"
    
    size = File.size(dupe)
    space_saved += size
    
    # Actually delete the file
    File.delete(dupe)
    deleted_count += 1
  end
end

puts "\n✅ Deleted #{deleted_count} duplicate files."
puts "💾 Space saved: #{(space_saved / 1024.0 / 1024.0).round(2)} MB"
