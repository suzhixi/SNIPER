#!usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %id;
open SNV_IN_ncRNA, "<$ARGV[1]" or die $!;
while(<SNV_IN_ncRNA>){
	chomp;
	my @t = split /\t/;
	$id{$t[6]}++;	
}
close SNV_IN_ncRNA;

my %pos;
open UNLUNG_LIST, "<$ARGV[0]" or die $!;
while(<UNLUNG_LIST>){
    chomp;
    my ($id,$path) = split /\t/;
    my @tt = split /_/,$id;
    my $enst = $tt[0];
	next unless (defined $id{$enst});
    open IN, "<$path" or die $!;
    while(<IN>){
        chomp;
        next if(/#/);
        my @t = split /\t/;
        $pos{$enst}{$t[0]}="$t[1]";
    }

}

open SNV_IN_ncRNA, "<$ARGV[1]" or die $!;
while(<SNV_IN_ncRNA>){
    chomp;
    my @t = split /\t/;

    next if (!defined $pos{$t[6]}{$t[11]});
    foreach my $k (@t){
        print "$k\t";
    }
    print "$pos{$t[6]}{$t[11]}\n";
}

