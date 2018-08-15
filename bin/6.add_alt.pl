#!usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
my %dis;
open IN1, "<dis.txt" or die $!;
while(<IN1>){
    chomp;
    my($enst,$rna_pos,$ref,$alt,$k1,$k2) = split /\t/;

    $dis{$enst}{$rna_pos}{$ref}{$alt} = "$k1:$k2";
}


open IN3, "<$ARGV[0]" or die $!;
while(<IN3>){
	chomp;
	my @t = split /\t/;
	
	foreach my $i(@t){
		print "$i\t";	
	}	
	if(defined $dis{$t[6]}{$t[11]}{$t[12]}{$t[13]}){
		my ($k1,$k2) = split /:/,$dis{$t[6]}{$t[11]}{$t[12]}{$t[13]};
		print "$k1\t$k2\n";	
	}
	else{
		$t[13] =~ tr/ATCG/TAGC/;
		my ($k1,$k2) = split /:/,$dis{$t[6]}{$t[11]}{$t[12]}{$t[13]};
		print "$k1\t$k2\n";	
	}
}
