#!usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
###gencode中“-”链的排列顺序是从小到大，注意

my %hash;
my $num = 0;
open IN1, "<NR.bed" or die $!;
while (<IN1>){
	chomp;
	my @tt = split /\t/;
	my @t = split /;/,$tt[6];
    my @gene_id = split /"/, $t[0];
    my @gene_symbol = split /"/, $t[4];
    my @transcript_id = split /"/,$t[1];
    my @gene_type = split /"/,$t[2];
    my @transcript_type = split /"/,$t[5];

	$num++;
	$hash{$num}="$tt[4]:$transcript_id[1]";
}
#print Dumper(\%hash);

my %nr;
my %pos;
$num = 0;
open FAS, "<NR.bed.fasta.txt" or die $!;
while(<FAS>){
	chomp;
	my @t = split /\t/;
	my $seq = $t[1];
	my @chr = split /[-:]/,$t[0];
	$seq =~ tr/atgcn/ATGCN/;

	$num++;
	my ($strand,$id) = split /:/,$hash{$num};

	if($strand eq "+"){
         $nr{$id}{$chr[0]}{$strand} .= $seq;
    }
    else{
         if(defined $nr{$id}{$chr[0]}{$strand}){
			 $nr{$id}{$chr[0]}{$strand} = $seq.$nr{$id}{$chr[0]}{$strand};
		 }
		 else{
			$nr{$id}{$chr[0]}{$strand} = $seq;	 
		 }
    }

	push @{$pos{$id}{$chr[0]}{$strand}}, "$t[0]";
}
#print Dumper(\%pos);

my %primary;
open (AA, "primary_transcripts.txt");
while(<AA>){
    chomp;
    my ($ensg, $enst) = split /\t/;
    $primary{$enst} = $ensg;
}

open OUT, ">All.NR.filter.fasta" or die $!;
foreach my $id (sort keys %nr){
	next unless(defined $primary{$id});
	foreach my $chr (sort keys %{$nr{$id}}){
#	next unless (/chr[\dXY]/);
	foreach my $strand (sort keys %{$nr{$id}{$chr}}){
		my $seq = $nr{$id}{$chr}{$strand};

		if($strand eq "-"){
			$seq = reverse $seq;
			$seq =~ tr/TCGA/AGCT/;
		}
		
		my @len = split //,$seq;
		
	
		print OUT ">$id:$strand:$chr";
		print OUT "\n$seq\n";
	}}
}



