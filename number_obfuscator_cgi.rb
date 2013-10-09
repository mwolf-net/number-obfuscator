#!/usr/bin/ruby

# This is a CGI script which will generate an obfuscated equation in PNG
# format, given two GET or POST parameters n and d.  Use of mod_ruby is
# strongly recommended, since then the prime numbers used for factoring need to
# be generated only once.
#
# PLEASE NOTE: this is a first version. It attempts to thoroughly sanitize its
# input, but there might be security bugs. Also, this is a rather heavy
# application which could easily bring a moderately powerful server to its
# knees with just a few concurrent users!
#
# Written by Martin Wolf, martin@mwolf.net. Free to copy and use as long as my
# name is kept in the source.

require 'cgi'
require 'tempfile'
require 'number_obfuscator'

srand

cgi = CGI.new
n = cgi['n'].to_i
d = cgi['d'].to_i
n, d = 0, 0 if n > 1000000000 || n < 1 || d < 1 || d > 8

print cgi.header(
  'type' => 'image/png',
  'Cache-Control' => 'no-cache',
  'Content-Disposition' => 'inline; filename=obfuscated.png')

e = Obfuscator.generate(n, d)
tempfile = Tempfile.new('obfuscated')
pngfile  = tempfile.path + ".png"
Obfuscator.makePNG(e, pngfile)
tempfile.close(true)
f = File.open(pngfile)
f.each_byte {|ch| putc ch; }
f.close
File.delete(pngfile)

