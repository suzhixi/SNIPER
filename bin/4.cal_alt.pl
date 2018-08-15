#!usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
my $pwd = `pwd`;
chomp $pwd;

my $RNAplfold = "/mnt/data/hfn/Tools/ViennaRNA-2.2.5/src/bin/RNAplfold";

my %nrseq;
open SEQ,"<All.NR.filter.fasta" or die $!;
while(<SEQ>){
	chomp;
	my @t = split /[>:]/;
	my $id = $t[1];

	my $seq = <SEQ>;
	chomp $seq;
	$nrseq{$id} = $seq;
}
#print Dumper(\%nrseq);

`mkdir -p RNAplfold`;
open IN3, "<$ARGV[0]" or die $!;
while(<IN3>){
	chomp;
	my @t = split /\t/;
	my $rna_ref = $t[12];
	my $rna_alt = $t[13];
	my $enst = $t[6];
	my $pos = $t[11];
	my $strand = $t[9];
	my $chr = $t[0];
		
	my $seq = $nrseq{$enst};
	my $ori = $seq;
	$seq =~ substr($seq, $pos-1, 1, $rna_alt);

	open OUT, ">>RNAplfold/$enst.fasta"; 
	if($seq eq $ori){
		$rna_alt=~tr/ATCG/TAGC/;
		$seq =~ substr($seq, $pos-1, 1, $rna_alt);
		print OUT  ">$enst:$pos:$rna_ref:$rna_alt\n$seq\n";
	}
	else{
		print OUT  ">$enst:$pos:$rna_ref:$rna_alt\n$seq\n";	
	}
	`cd $pwd/RNAplfold; $RNAplfold  -W 200 -L 150 -c 0 -u 1 < $enst.fasta; rm -rf *dp.ps;`;	
}
