require 'minitest/autorun'
require 'csv'
require 'pathname'

class TestImagesMappings < Minitest::Test
  def setup
    @root = Pathname.new(File.expand_path('..', __dir__))
    @csv_path = @root.join('images_mappings.csv')
    @assets_base = @root.join('jekyll-site', 'assets', 'images')
  end

  def test_csv_data_integrity
    failures = []
    
    unless @csv_path.exist?
      flunk "The images_mappings.csv file does not exist at #{@csv_path}."
    end

    # Check Headers
    headers = CSV.read(@csv_path.to_s, headers: true).headers
    expected_headers = ['Timestamp', 'OriginalPhotoPath', 'PixarPhotoPath', 'PixarPhotoDescription']
    unless headers == expected_headers
      failures << "CSV headers mismatch. Expected #{expected_headers}, got #{headers}"
    end

    # Check Content
    CSV.foreach(@csv_path.to_s, headers: true, return_headers: false).with_index(2) do |row, line_number|
      # 1. Timestamp validation
      unless row['Timestamp'] =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(Z|[+-]\d{2}:?\d{2})$/
        failures << "Line #{line_number}: Invalid Timestamp format: '#{row['Timestamp']}'"
      end

      # 2. Original Image existence
      if row['OriginalPhotoPath']
        original_rel = row['OriginalPhotoPath'].gsub(/^\.?\//, '')
        original_full = @assets_base.join(original_rel)
        unless original_full.exist?
          failures << "Line #{line_number}: Original image missing: #{original_rel} (Full path: #{original_full})"
        end
      else
        failures << "Line #{line_number}: OriginalPhotoPath is nil"
      end

      # 3. Pixar Image existence
      if row['PixarPhotoPath']
        pixar_rel = row['PixarPhotoPath'].gsub(/^\.?\//, '')
        pixar_full = @assets_base.join(pixar_rel)
        unless pixar_full.exist?
          failures << "Line #{line_number}: Pixar image missing: #{pixar_rel} (Full path: #{pixar_full})"
        end
      else
        failures << "Line #{line_number}: PixarPhotoPath is nil"
      end

      # 4. Description check
      if row['PixarPhotoDescription'].nil? || row['PixarPhotoDescription'].strip.empty?
        failures << "Line #{line_number}: Description is empty"
      end
    end
    
    assert_empty failures, "Found data integrity issues in images_mappings.csv:\n" + failures.join("\n")
  end
end
