VERSION      = 0.9
MYSERVER     = martin@mwolf.net:/var/www/code/obfuscator
SRCFILES     = lib/number_obfuscator/primes.rb lib/number_obfuscator.rb bin/number_obfuscator
HTML         = deploy/obfuscate.html README.html
FILES        = ${SRCFILES} ${HTML} Makefile
TGZFILE      = obfuscator-${VERSION}.tgz
OLDVERSIONS  = obfuscator-*.tgz
UPLOADFILES  = ${SRCFILES} ${TGZFILE} ${HTML}
GEMNAME      = number_obfuscator
GEM          = ${GEMNAME}-${VERSION}.gem
GEMSPEC      = number_obfuscator.gemspec
TESTPICTURE  = obfuscated.png

# Testpicture isn't really phony, but we want a fresh one every time!
.PHONY: all clean install uninstall upload html testpicture test gem ${TESTPICTURE}

all: test gem ${TGZFILE}

clean:
	rm -f ${OLDVERSIONS} ${GEM} ${HTML} ${TESTPICTURE} *~ *.bak
	rm -rf doc

test:
	ruby test/ts_obfuscator.rb

install: ${GEM}
	sudo gem install ${GEM}

uninstall:
	sudo gem uninstall ${GEMNAME}

gem: ${GEM}

${GEM}: ${GEMSPEC} ${SRCFILES}
	gem build $<

testpicture: ${TESTPICTURE}
	gnome-open $<

${TGZFILE}: ${FILES}
	tar czf $@ $+

upload: ${UPLOADFILES}
	scp $+ ${MYSERVER}

html: ${HTML}

%.html: %.md
	markdown $< > $@

obfuscated.png: bin/number_obfuscator Makefile
	number_obfuscator 38 4 png

%.dvi: %.tex
	texi2dvi $<

obfuscated.tex: bin/number_obfuscator Makefile
	number_obfuscator 38 6 tex > $@

