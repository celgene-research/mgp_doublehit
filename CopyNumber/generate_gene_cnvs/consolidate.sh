#this code generates a file with all the gains/losses from a cfreec directory
find . -name "*gz_CNVs" > cnvlist.txt
awk '{printf "%s\t%s\n", FILENAME, $0}' `cat cnvlist.txt` > complete_CNVs.txt
awk '{gsub(/\./.*/," ")}'
#this file will need manual processing, because the files contain paths, so you have to make them go from something like this:
#./HUMAN_37_pulldown_PD5870a.pileup-HUMAN_37_pulldown_PD5870b.pileup.strvar/HUMAN_37_pulldown_PD5870a.pileup.gz_CNVs
#to something like this:
#HUMAN_37_pulldown_PD5870a
# next, convert to a bed file using convert_to_bed.pl