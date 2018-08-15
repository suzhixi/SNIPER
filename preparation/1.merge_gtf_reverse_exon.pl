#!usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
###gencode中“-”链的排列顺序是从大到小，注意

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
#print "#####HASH\n\n";
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
#print "#####NR\n\n";
#print Dumper(\%nr);
#print "#####POS\n\n";
#print Dumper(\%pos);


open OUT2, ">Chrpos_RNApos_ok.txt" or die $!;
foreach my $id (sort keys %nr){
	foreach my $chr (sort keys %{$nr{$id}}){
		foreach my $strand (sort keys %{$nr{$id}{$chr}}){
			my $seq = $nr{$id}{$chr}{$strand};
			my @len = split //,$seq;
		
			my $rna_pos=0;
			my (%start,%end);
			for(my $i=0; $i<@{$pos{$id}{$chr}{$strand}}; $i++){
				my ($dna_chr,$dna_start,$dna_end) = split /[:-]/,${$pos{$id}{$chr}{$strand}}[$i];
				$start{$dna_start}=$i;
				$end{$dna_end}=$i;
			}

			my @sort;
			for my $i(sort {$a <=> $b} keys %start){
				push @sort, $start{$i};
			}
		


		if ($strand eq "+"){
			for(my $i=0;$i<@sort;$i++){
				my ($dna_chr,$dna_start,$dna_end) = split /[:-]/,${$pos{$id}{$chr}{$strand}}[$sort[$i]];
				
				for(my $j=$dna_start+1;$j<=$dna_end;$j++){  #for -2 +1
					$rna_pos++;
					my $dna_base = $len[$rna_pos-1];

					my $dna_triple = ".";	
					if($rna_pos>0 && $rna_pos<@len){ $dna_triple = "$len[$rna_pos-2]$len[$rna_pos-1]$len[$rna_pos]";}		
					print OUT2 "$chr\t$j\t$dna_base\t$dna_triple\t$strand\t";

					
					print OUT2 "$chr\t$rna_pos\t$dna_base\t$dna_triple\t$id\n";

				}	
			}

		}
		elsif ($strand eq "-"){
			$seq = reverse $seq;
			@len = split //,$seq;
			
			for(my $i=@sort-1;$i>=0;$i--){
				my ($dna_chr,$dna_start,$dna_end) = split /[:-]/,${$pos{$id}{$chr}{$strand}}[$sort[$i]];
				
				for(my $j=$dna_end;$j>=$dna_start+1;$j--){   #for -2 +1
					$rna_pos++;
					my $dna_base = $len[$rna_pos-1];
					my $dna_triple = ".";
					if($rna_pos>0 && $rna_pos<@len){ 
						$dna_triple = "$len[$rna_pos]$len[$rna_pos-1]$len[$rna_pos-2]";#注意此处的方向：RNA位置的从小到大，对应，chr位置的从大到小
					}
					print OUT2 "$chr\t$j\t$dna_base\t$dna_triple\t$strand\t";
                 	
					my $rna_base = $dna_base;
					$rna_base =~ tr/ATCG/TAGC/; 
					my $rna_triple = ".";
					if($rna_pos>0 && $rna_pos<@len){
						$rna_triple = "$len[$rna_pos-2]$len[$rna_pos-1]$len[$rna_pos]";
					}
					$rna_triple =~ tr/ATCG/TAGC/;
					print OUT2 "$chr\t$rna_pos\t$rna_base\t$rna_triple\t$id\n";
					
				}
			}
		}
        }
	}
}

