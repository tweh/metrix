# variables
## package base name
CONTRIBUTION = metrix
## package list
PACKAGES = ${CONTRIBUTION}.sty
## TDS-ZIP file name
FILE = ${CONTRIBUTION}.tds.zip
## final ZIP file name
ZIP = metrix
## cleanup command
CLEANUP = find -E . -type f -regex "\./metrix(.?|-doc)\.(aux|glo|gls|hd|idx|ilg|ind|lof|log|lot|out|pdf|toc)" -delete

# generate TDS-ZIP
${FILE}: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.ins ${PACKAGES} README ${CONTRIBUTION}.pdf
	# source files
	mkdir -p ${CONTRIBUTION}/source/latex/${CONTRIBUTION}/
	cp ${CONTRIBUTION}.dtx ${CONTRIBUTION}/source/latex/${CONTRIBUTION}/${CONTRIBUTION}.dtx
	cp ${CONTRIBUTION}.ins ${CONTRIBUTION}/source/latex/${CONTRIBUTION}/${CONTRIBUTION}.ins
	# sty/cls files
	mkdir -p ${CONTRIBUTION}/tex/latex/${CONTRIBUTION}/
	for p in $(PACKAGES); do cp $$p ${CONTRIBUTION}/tex/latex/${CONTRIBUTION}/$$p; done
	# documentation
	mkdir -p ${CONTRIBUTION}/doc/latex/${CONTRIBUTION}/
	cp ${CONTRIBUTION}.pdf ${CONTRIBUTION}/doc/latex/${CONTRIBUTION}/${CONTRIBUTION}.pdf
	cp README ${CONTRIBUTION}/doc/latex/${CONTRIBUTION}/README
	# zip folder
	cd ${CONTRIBUTION} ; zip -r ../${FILE} * -x "*.DS_Store"
	# tidy up
	$(CLEANUP)
	rm -rf ${CONTRIBUTION}
	
# generate *.sty files
%.sty: ${CONTRIBUTION}.ins ${CONTRIBUTION}.dtx
	latex $<

# generate documentation file
${CONTRIBUTION}.pdf: ${CONTRIBUTION}.dtx
	# tidy up
	$(CLEANUP)
	# generate doc
	pdflatex ${CONTRIBUTION}.dtx 
	pdflatex ${CONTRIBUTION}.dtx
	makeindex -s gglo.ist -o ${CONTRIBUTION}.gls ${CONTRIBUTION}.glo
	makeindex -s l3doc.ist -o ${CONTRIBUTION}.ind ${CONTRIBUTION}.idx
	pdflatex ${CONTRIBUTION}.dtx
	pdflatex ${CONTRIBUTION}.dtx