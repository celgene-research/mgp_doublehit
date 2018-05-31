Workflow:

1) Generate a file that contains all CNVs using consolidate.sh
2) Manually correct the sample names by removing extensions and paths
3) Convert the text file to a bed file by using convert_to_bed.pl
4) Get overlaps using bedtools intersect and parse the output into the needed format by using generate_gene_lookups.sh
5) finally, run create_copy_number_table.pl to generate the copy number table

Notes:
You can combine results from multiple datasets if you use the same genelists.
Some processes need manual correction and intervention. Please read the script to see what needs adjustment.