Gem::Specification.new do |s|
  s.name = 'number_obfuscator'
  s.version = 0.9
  s.description = "Randomly generate arithmetic expressions for a given number"
  s.summary = "A fun little toy to create intimidating arithmetic expressions"
  s.authors = ["Martin Wolf"]
  s.email = 'martin@mwolf.net'
  s.homepage = 'http://mwolf-net.github.io/number-obfuscator'
  s.files = ["lib/number_obfuscator.rb"] + Dir["lib/number_obfuscator/*.rb"]
  s.executables << 'number_obfuscator'
  s.add_development_dependency "mocha", ["~> 0.14"]
end


