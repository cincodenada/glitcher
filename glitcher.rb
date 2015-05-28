require 'optparse'

options = {
    :bytes => 20,
    :replace => nil,
    :num => 1,
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

p options
