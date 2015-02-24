# variables
## package base name
CONTRIBUTION = metrix
## package list
PACKAGES = ${CONTRIBUTION}.sty
## TDS-ZIP file name
TDS = ${CONTRIBUTION}.tds.zip
## final ZIP file name
ZIP = ${CONTRIBUTION}.zip
## cleanup command
CLEANUP = find -E . -type f -regex "\./metrix(.?|-doc)\.(aux|glo|gls|hd|idx|ilg|ind|lof|log|lot|out|pdf|toc)" -delete

# generate ZIP
${ZIP}: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.ins ${PACKAGES} README ${CONTRIBUTION}.pdf
	# ctanify
	ctanify ${CONTRIBUTION}.ins ${PACKAGES} README ${CONTRIBUTION}.pdf
	# tidy up
	$(CLEANUP)
	rm ${CONTRIBUTION}.sty
	
# generate *.sty files
%.sty: ${CONTRIBUTION}.ins ${CONTRIBUTION}.dtx
	latex $<

# generate documentation file
${CONTRIBUTION}.pdf: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.sty
	# tidy up
	$(CLEANUP)
	# generate doc
	pdflatex ${CONTRIBUTION}.dtx 
	pdflatex ${CONTRIBUTION}.dtx
	makeindex -s gglo.ist -o ${CONTRIBUTION}.gls ${CONTRIBUTION}.glo
	makeindex -s l3doc.ist -o ${CONTRIBUTION}.ind ${CONTRIBUTION}.idx
	pdflatex ${CONTRIBUTION}.dtx
	pdflatex ${CONTRIBUTION}.dtx