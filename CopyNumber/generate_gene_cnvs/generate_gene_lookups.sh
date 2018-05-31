# use bedtools intersect on the list of all_genes to see where we have overlaps
bedtools intersect -a all_genelist.bed -b IA9.bed -wo > IA9_all_genelist.bed
# finally output the columns we're interested in
awk '{print $1 "\t" $4 "\t" $8 "\t" $9}' IA9_all_genelist.bed >> complete_genes_of_interest.txt
#next call create_copy_number_table.pl