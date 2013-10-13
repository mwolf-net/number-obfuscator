Gem::Specification.new do |s|
  s.name = 'number_obfuscator'
  s.version = 0.9
  s.description = "Randomly generate arithmetic expressions for a given number"
  s.summary = "A fun little toy"
  s.authors = ["Martin Wolf"]
  s.email = 'martin@mwolf.net'
  s.homepage = 'http://mwolf-net.github.io/number-obfuscator'
  s.files = [
    "lib/number_obfuscator.rb",
    "lib/number_obfuscator_cgi.rb",
    "lib/primes.rb"]
  s.executables << 'number_obfuscator'
end


