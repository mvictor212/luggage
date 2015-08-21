#!/usr/bin/env ruby
def read_du(filename)
  data = Hash.new(0)
  return unless filename
  input = File.read(filename)
  input.split("\n").each do |line|
    next unless /^(\d+)\s*(.+)$/.match(line)
    data[$2] = $1.to_i
  end
  data
end

left =  read_du(ARGV[0])
right = read_du(ARGV[1])

diff = {}

(left.keys + right.keys).uniq.sort.each do |key|
  diff = right[key] - left[key]
  col1 = diff.to_s.ljust(15)
  col2 = "#{diff / 1024}M".ljust(6)
  col3 = key
  puts "#{col1}#{col2}#{col3}"
end

# puts left.inspect

