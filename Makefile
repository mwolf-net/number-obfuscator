VERSION      = 0.81
MYSERVER     = martin@mwolf.net:/var/www/code/obfuscator
SRCFILES     = number_obfuscator_cgi.rb primes.rb number_obfuscator.rb
HTML         = obfuscate.html README.html
FILES        = ${SRCFILES} ${HTML} Makefile
TGZFILE      = obfuscator-${VERSION}.tgz
OLDVERSIONS  = obfuscator-*.tgz
UPLOADFILES  = ${SRCFILES} ${TGZFILE} ${HTML}

.PHONY: all clean backup upload html testpicture

all: ${TGZFILE}

testpicture: obfuscated.png
	gnome-open $<

${TGZFILE}: ${FILES}
	tar czf $@ $+

clean:
	rm -f ${OLDVERSIONS} *~ *.bak

upload: ${UPLOADFILES}
	scp $+ ${MYSERVER}

html: ${HTML}

%.html: %.md
	markdown $< > $@

%.png: %.dvi
	convert -format PNG $< $@

%.dvi: %.tex
	texi2dvi $<

obfuscated.tex: number_obfuscator.rb Makefile
	ruby number_obfuscator.rb 38 6 tex > $@

