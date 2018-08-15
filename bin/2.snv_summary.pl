#!usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;

#############创建6type和96type################################
my @type6 = qw/C>T C>A C>G T>C T>A T>G/;
my @base = qw/A T C G/;
my @type96;
for(my $i=0;$i<4;$i++){
        foreach my $j (@type6){
                my ($ref,$alt)  = split />/,$j;
                for(my $k=0;$k<4;$k++){
                        push @type96, "$base[$i]$ref$base[$k]>$base[$i]$alt$base[$k]";
                }
        }
}


my %snv;
my %mutation;
open SNV, "<$ARGV[0]" or die $!;
while(<SNV>){
    chomp;
    my ($chr,$pos,$ref,$alt,$tri_ori,$num,$type1,$type2,$sample) = split /\t/;
    push @{$snv{$chr}{$pos}},"$type1";
    $mutation{$chr}{$pos}{$type1}="$type2~$num~$sample";
}
#print Dumper(\%snv);


my %count;
open POS, "<./Chrpos_RNApos.txt" or die $!;
while(<POS>){
    chomp;
    my @t = split /\t/;
    my $chr = $t[0];
    my $pos = $t[1];
    my $ref_original=$t[2];
    my $strand = $t[4];
    my $rna_pos = $t[6];
    my $rna_ref_original = $t[7];
    my $id = $t[9];

    my $anno = $t[10];
    my $gene_id = $t[11];
    my $gene_type = $t[13];
    my $transcript_type = $t[14];
    my $gene_symbol = $t[12];


	next if ($anno eq "CDS");
    if(defined $snv{$t[0]}{$t[1]}){
        for(my $i=0;$i< @{$snv{$t[0]}{$t[1]}}; $i++){
            my $mut = ${$snv{$t[0]}{$t[1]}}[$i];
            my ($type2,$num,$sample) = split /~/,$mutation{$chr}{$pos}{$mut};

            my ($ref,$alt) = split />/,$mut;
            if($ref_original=~/[GA]/){
                $alt =~ tr/ATGC/TACG/;
            }
            my $mut_original="$ref_original>$alt";

            print "$chr\t$pos\t$ref_original\t$alt\t$gene_id\t$gene_type\t$id\t$transcript_type\t$gene_symbol\t$strand";

            $mut_original =~ tr/ATCG/UAGC/; #CHANGE TO RNA sequence
            ($ref,$alt) = split />/,$mut_original;
            print "\t$chr\t$rna_pos\t$ref\t$alt\t$ref$rna_pos$alt\t${$snv{$t[0]}{$t[1]}}[$i]\t$type2\t$num\t$sample\t$anno\n";
		}
	}
}
