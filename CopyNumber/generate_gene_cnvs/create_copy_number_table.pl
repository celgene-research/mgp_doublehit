#!/usr/bin/perl

#genelist.txt should contain all genes of interest
open(DATA, "<genelist.txt") or die "Couldn't open file file.txt, $!";
@gene_symbols = ();
while(<DATA>){
	$line = $_;
	chomp($line);
	push(@gene_symbols, $line);
}
#@gene_symbols = sort(@gene_symbols);
close(DATA);

#samplelist.txt should contain all samples of interest
open(DATA, "<samplelist.txt") or die "Couldn't open file file.txt, $!";
@sample_ids = ();
while(<DATA>){
	$line = $_;
	chomp($line);
	push(@sample_ids, $line);
}
@sample_ids = sort(@sample_ids);
close(DATA);

#read the file, and create the hash
open(DATA, "<complete_genes_of_interest.txt") or die "Couldn't open file complete_genes_of_interest.txt, $!";

%cna_hash;
while(<DATA>){
	chomp($_);
	$line = $_;
	@results = split("\t", $line);
	#print "$results[1]:$results[3]=$results[2]\n";
	if($results[2] eq "gain")
	{
		$cna_hash{$results[1]}{$results[3]} = 3
	}
	if($results[2] eq "loss")
	{
		$cna_hash{$results[1]}{$results[3]} = 1
	}
	if($results[2] eq "normal")
	{
		$cna_hash{$results[1]}{$results[3]} = -2
	}
	if($results[2] eq "amplification")
	{
		$cna_hash{$results[1]}{$results[3]} = 4
	}
	if($results[2] eq "homozygous_deletion")
	{
		$cna_hash{$results[1]}{$results[3]} = 0
	}
}
open(POUT, ">copy_number_table.txt");

print POUT "\t";
foreach $gene (@gene_symbols)
{
	print POUT "$gene\t";
}
print POUT "\n";
foreach $sample (@sample_ids)
{
	print POUT "$sample\t"; 
	foreach $gene (@gene_symbols)
	{
		if(exists($cna_hash{$gene}{$sample}))
		{
			print POUT $cna_hash{$gene}{$sample} . "\t";
		}
		else
		{
			print POUT "2\t";
		}
	}
	print POUT "\n";
}