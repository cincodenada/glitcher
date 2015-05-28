Glitcher.rb
===========

This is just a quick script created on a whim to play with some very basic
glitch art.  It takes an input file and outputs a copy with random segments of
the file replaced with random bytes or, optionally, a specified phrase.

It was inspired by a delightful [Reddit discussion][1] about what happens to
files when you delete them.  Thanks to [/u/askmeforbunnypics][2] for the
interesting response, and inspiration.  I decided to write it up in Ruby
because it's a pretty basic task, and Ruby is on my list of languages to get
more familiar with.  I quite enjoyed it, actually - I can see the appeal, the
code felt very organized and expressive.

Now, onto the fun part!

Usage
-----

Just provide it a filename, and it will run with some sensible defaults.
Simply running `ruby glitcher.rb infile.jpg` will create `outfile` that is a
glitched copy.  Note that it's quite possible that the output image may not
open, as the overwitten bits may have been some crucial parts of the file, and
rewriting them rendered the file unreadable!  In that case, simply run it again
to re-roll the dice.

There are also several options to tweak what exactly gets replaced.  For a
quick overview, run `ruby glitcher.py -h`, or look below:

    glitcher.rb [options] INFILE
        -b, --bytes [BYTES]              Number of bytes to replace
        -r, --replace [STRING]           String to replace bytes with
        -n, --num [NUM]                  Number of replacements to do
            --range [[start],end]        Range of bytes to replace, as offsets or percentages
                                         (suffixed with %)

Most options are pretty straightforward - the program replaces `NUM` strings of
`BYTES`-long segments of the file with random data.  If you specify a
replacement string with `-r`, it will use that instead of random data.  In this
case, the `-b` option will be ignored and instead it will use the length of the
replacement.

You can also specify a range of bytes in the file to operate on - it will leave
anything outside the specified range untouched.  You can specify a start and
end, in bytes or percentage.  To specify percentage, simply add a "%" to the
end of the nubmer.  If only one number is specified, the program will mess
around from the beginning of the file to the specified location.  You can mix
and match percentages and bytes at will.

Some examples of the above options in action:

    # Place 123 instances of the string "testing" throughout the file
    glitcher.rb -r testing -n 123 infile.jpg

    # Replace one segment of 10 bytes somewhere in the first 100 bytes
    glitcher.rb -n1 -b10 --range 100 infile.jpg
    
    # Replace 10 segments of 50 bytes, leaving the first 5% of the file untouched
    glitcher.rb -n10 -b50 --range 5%,100% infile.jpg

    # Place 10 instances of "another example" anywhere in the first 50% of the file,
    # but not in the first 100 bytes
    glitcher.rb -n10 -r "another example" --range 100,50% infile.jpg

Details
-------

Defaults are pretty straightforward at the top of the file, but for quick
reference, as of this writing they are 5 replacements of 20 bytes each, spread
throughout the whole file.

Due to implementation details, you can't specify a start/end of 1 byte.  It
will instead be interpreted as 100%.  This will likely be fixed sometime when
it's not approaching 1am my time.

Disclaimer
----------

As this only makes copies of things, it should be fairly safe, but all the
same, use this at your own risk - if you run it on a giant file when your hard
disk space is low and somehow end up hosing something, you have only yourself
to blame. 

[1]: http://www.reddit.com/r/NoStupidQuestions/comments/37gzsi/when_i_permanently_delete_a_file_on_my_computer/crmrwu0?context=3 "When I permanently delete a file on my computer, where does it go?"
[2]: http://www.reddit.com/user/askmeforbunnypics "AskMeForBunnyPics on Reddit"
