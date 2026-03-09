#!/usr/bin/env ruby

puts "🧪 Eseguo Unit Tests (Date from Feb 5 to 25)..."
unless system("ruby", File.join(__dir__, "test_day.rb"))
  exit(1)
end

puts "🖼️ Eseguo Test Immagini..."
unless system("ruby", File.join(__dir__, "test_images.rb"))
  exit(1)
end

puts "📝 Eseguo Test Front Matter..."
unless system("ruby", File.join(__dir__, "test_front_matter.rb"))
  exit(1)
end

puts "\n✅ Tutti i test sono passati con successo!"
