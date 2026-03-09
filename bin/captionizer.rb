#!/usr/bin/env ruby
require 'optparse'
require 'erb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: captionizer.rb -i IMAGE1 -j IMAGE2 -c CAPTION"
  opts.on('-i', '--image1 PATH', 'Path to first image') { |v| options[:image1] = v }
  opts.on('-j', '--image2 PATH', 'Path to second image') { |v| options[:image2] = v }
  opts.on('-c', '--caption TEXT', 'Caption text') { |v| options[:caption] = v }
  opts.on('--hover', 'Enable hover preview for second image') { options[:hover] = true }
end.parse!

raise "Missing arguments" unless options[:image1] && options[:image2] && options[:caption]

template = <<-HTML
<div class="captionizer">
  <div class="image1" style="text-align:center;">
    <img src="<%= options[:image1] %>" alt="Image 1" style="max-width:100%; height:auto;"/>
  </div>
  <p class="caption" style="font-size:0.9em; color:#555; text-align:center; margin-top:0.5rem;">
    <%= options[:caption] %>
  </p>
  <div class="image2" style="text-align:center; margin-top:1rem;">
    <% if options[:hover] %>
      <a href="<%= options[:image2] %>" class="hover-image" title="Hover to preview">
        <img src="<%= options[:image2] %>" alt="Image 2" style="max-width:100%; height:auto; opacity:0.8;"/>
      </a>
    <% else %>
      <a href="<%= options[:image2] %>">Link to second image</a>
    <% end %>
  </div>
</div>
HTML

renderer = ERB.new(template)
puts renderer.result(binding)
