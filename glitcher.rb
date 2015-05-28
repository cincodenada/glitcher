#!/usr/bin/ruby
require 'optparse'

options = {
    :bytes => 20,
    :replace => nil,
    :num => 5,
    :start => 0,
    :end => 1,
}
OptionParser.new do |opts|
    opts.banner = "Usage: glitcher.rb [options] INFILE"

    opts.on('-b','--bytes [BYTES]',Integer,'Number of bytes to replace') do |b|
        options[:bytes] = b
    end

    opts.on('-r','--replace [STRING]',String,'String to replace bytes with') do |r|
        options[:replace] = r
        options[:bytes] = r.bytesize
    end

    opts.on('-n','--num [NUM]',Integer,'Number of replacements to do') do |n|
        options[:num] = n
    end

    opts.on('--range [[start],end]',Array,'Range of bytes to replace, as offsets or percentages','(suffixed with %)') do |list|
        list.each_index do |idx|
            if '%' == list[idx][-1]
                list[idx][-1] = ''
                list[idx] = list[idx].to_f/100
            end
        end

        if list.length == 1
            options[:end] = list[0].to_f
        elsif list.length >= 2
            options[:start] = list[0].to_f
            options[:end] = list[1].to_f
        end
    end
end.parse!

if ARGV.length == 0
    abort("No input file specified!")
end

infile = ARGV[0]
if ARGV.length >= 2
    outfile = ARGV[1]
else
    outfile = "outfile"
end

total_bytes = File.size(infile)
[:start,:end].each do |elm|
    if options[elm] <= 1
        options[elm] *= total_bytes
    end
    options[elm] = options[elm].to_i
end

fin = File.open(infile)
fout = File.open(outfile,"wb")
offsets = []
options[:num].times do
    offsets << (rand(options[:end]-options[:start]) + options[:start]).to_i
end

prev_end = 0
offsets.sort!.each do |offset|
    IO.copy_stream(fin, fout, offset-prev_end, prev_end)
    if options[:replace].nil?
        replacement = ''
        options[:bytes].times do
            replacement += rand(255).chr
        end
    else
        replacement = options[:replace]
    end
    fout.write(replacement)
    prev_end = offset + options[:bytes]
end

if prev_end < total_bytes
    IO.copy_stream(fin, fout, total_bytes - prev_end, prev_end)
end
