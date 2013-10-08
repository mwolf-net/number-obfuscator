VERSION      = 0.7
MYSERVER     = martin@mwolf.net:/var/www/code/obfuscator
SRCFILES     = o.rb primes.rb number_obfuscator.rb
HTML         = obfuscate.html
HTMLTEMPLATE = ${HTML}.template
FILES        = ${SRCFILES} Makefile ${HTMLTEMPLATE}
TGZFILE      = obfuscator-${VERSION}.tgz
OLDVERSIONS  = obfuscator-*.tgz
UPLOADFILES  = ${SRCFILES} ${TGZFILE} ${HTML}

.PHONY: all clean backup upload

all: ${TGZFILE}

${TGZFILE}: ${FILES}
	tar czf $@ $+

clean:
	rm -f ${OLDVERSIONS} *~ *.bak ${HTML}

upload: ${UPLOADFILES}
	scp $+ ${MYSERVER}

backup: ${TGZFILE}
	cp $+ backup-$+
	
${HTML}: ${HTMLTEMPLATE} Makefile
	sed 's/XXXVERSIONXXX/${TGZFILE}/g' ${HTMLTEMPLATE} > $@

