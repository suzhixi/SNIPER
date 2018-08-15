#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;


my %start;
my %end;
my %id;
open TYPE,"../gencode.v19.annotation.gtf" or die $!;
while(<TYPE>){
	chomp;
    next if(/#/);
    my @tt = split /\t/;
    next if ($tt[2] eq "gene");
	next if ($tt[2] eq "transcript");
	next if ($tt[2] eq "Selenocysteine");

    my @t = split /;/,$tt[8];
    my @gene_id = split /"/, $t[0];
    my @gene_symbol = split /"/, $t[4];
    my @transcript_id = split /"/,$t[1];
    my @gene_type = split /"/,$t[2];
    my @transcript_type = split /"/,$t[5];
	if($tt[2] eq "CDS"){
		push @{$start{$transcript_id[1]}}, $tt[3];
		push @{$end{$transcript_id[1]}}, $tt[4];
	}
	$id{$transcript_id[1]} = "$gene_id[1]:$gene_symbol[1]:$gene_type[1]:$transcript_type[1]";
}

while(<>){
	chomp;
	my @t = split /\t/;
	my $enst = $t[-1];	
	my $strand = $t[4];

	my $anno;
	if(!defined $start{$enst}){
		$anno = "non-CDS";
	}
	else{
		my ($start,$end);
		if($strand eq "+"){
			my @array1 = sort {$a <=> $b} @{$start{$enst}};	
			my @array2 = sort {$a <=> $b} @{$end{$enst}};
			$start = $array1[0];
			$end = $array2[-1];

			if($t[1] < $start){
            	my $pos = $t[1]-$start;
            	$anno = "5UTR";				
        	}
			elsif($t[1] > $end+3){
				$anno = "3UTR";		
			}
			elsif($t[1] >= $start && $t[1]<=$start+2){
				my $pos = $t[1] - $start + 1;
				$anno = "start_codon:$pos";
			}
			elsif($t[1] > $end && $t[1] <= $end+3){
				my $pos = $t[1] - $end;
				$anno = "stop_codon:$pos";
			}
			else{
				$anno = "CDS";	
			}
		}	
		else{
			my @array1 = sort {$a <=> $b} @{$start{$enst}};
            my @array2 = sort {$a <=> $b} @{$end{$enst}};
            $start = $array2[-1];
            $end = $array1[0];	
			if($t[1] > $start ){
				$anno = "5UTR";
			}
			elsif($t[1] < $end-3){
				$anno = "3UTR";
			}
			elsif($t[1]<=$start && $t[1]>=$start-2){
				my $pos = $start - $t[1] + 1;
				$anno = "start_codon:$pos";
			}
			elsif($t[1]<$end && $t[1] >= $end-3 ){
				my $pos = $end - $t[1];
				$anno = "stop_codon:$pos";
			}
			else{
                $anno = "CDS";
            }
		}
		
		
	}
	
	for my $i(@t){
		print "$i\t";	
	}
	print "$anno";
	my @m = split /:/,$id{$enst};
	for my $i(@m){
        print "\t$i";
    }
	print "\n";
}
