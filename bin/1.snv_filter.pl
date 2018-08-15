#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %calculate;
my %snv;
my %id;
my %type;
my %hash;
open IN, "$ARGV[0]" or die "No open file";
while ( <IN> ) {

	my ($id, $path) = split;
	my @t = split /:/, $id;
	my $cancer = $t[0];
	my $sample = $t[1];

	open IN2,"<$path" or die $!;
	while(<IN2>){
		chomp;
		next if(/Chr/);
	
		my @t = split /\t/;
		$snv{$t[0]}{$t[1]}{$t[6]}++;
		$hash{$t[0]}{$t[1]}{$t[6]} = "$t[4]:$t[5]";

		push @{$type{$t[0]}{$t[1]}{$t[6]}{$t[7]}} ,"$cancer:$sample";
	}


}close IN;


open OUT1, ">snv.txt" or die $!;
foreach my $chr (sort keys %snv){
	foreach my $pos (sort keys %{$snv{$chr}}){
		foreach my $mut (sort keys %{$snv{$chr}{$pos}}){
			my ($t,$tri_base) = split /:/, $hash{$chr}{$pos}{$mut};
			my ($ref,$alt) = split //,$t;
			print OUT1 "$chr\t$pos\t$ref\t$alt\t$tri_base\t$snv{$chr}{$pos}{$mut}";
			foreach my $type2 (sort keys %{$type{$chr}{$pos}{$mut}}){
				print OUT1 "\t$mut\t$type2\t";
				foreach my $sample(@{$type{$chr}{$pos}{$mut}{$type2}}){
					print OUT1 "$sample;";
				}
				print OUT1 "\n";
			}
		}
	}
}

