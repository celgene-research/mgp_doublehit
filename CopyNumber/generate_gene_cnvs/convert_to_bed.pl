#!/usr/bin/perl

#change this to the txt file of interest, e.g. MMRF.txt
open(DATA, "<IA9_newlist.txt") or die "Couldn't open file file.txt, $!";
open(POUT, ">IA9_newlist.bed");

#only keep loh-neutral if the confidence is less than this
$threshold = 10;

while(<DATA>){
	$line = $_;
	chomp($line);
	@results = split("\t", $line);
	if($#results == 9)
	{
		if($results[5] eq "normal" && $results[7] != -1 && $results[7] < $threshold)
		{
			print POUT "$results[1]\t$results[2]\t$results[3]\t$results[5]\t$results[0]\n";
		}
		elsif($results[5] eq "loss" && $results[4] == 0)
		{
			print POUT "$results[1]\t$results[2]\t$results[3]\thomozygous_deletion\t$results[0]\n";
		}
		elsif($results[5] eq "gain" && $results[4] >= 4)
		{
			print POUT "$results[1]\t$results[2]\t$results[3]\tamplification\t$results[0]\n";
		}
		elsif($results[5] ne "normal")
		{
			print POUT "$results[1]\t$results[2]\t$results[3]\t$results[5]\t$results[0]\n";
		}
	}
	else
	{
		if($results[5] eq "loss" && $results[4] == 0)
		{
			print POUT "$results[1]\t$results[2]\t$results[3]\thomozygous_deletion\t$results[0]\n";
		}
		elsif($results[5] eq "gain" && $results[4] > 5)
		{
			print POUT "$results[1]\t$results[2]\t$results[3]\tamplification\t$results[0]\n";
		}
		elsif($results[5] ne "normal")
		{
			print POUT "$results[1]\t$results[2]\t$results[3]\t$results[5]\t$results[0]\n";
		}
	}
}