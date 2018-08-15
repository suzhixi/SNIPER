#!usr/bin/perl -w 
use strict;
use warnings;
use Data::Dumper;
use Statistics::R;
my $file1=shift;
my $file2=shift;
my $cutoff=shift; 
my $filter=shift;

my %hash;
my %mut;
my %sum1;

my $top1 = 0.065;
my $top2 = 2.483;

open IN, "<$file1" or die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	next unless ($t[19] eq $filter);

    my $enst = $t[6];
    my $type = $t[5];
	my $num = $t[17];
	my $gene = $t[8];
	my $rna_pos = $t[11];

	$hash{$enst} = "$gene:$type";
	
	if ($t[21]>=$top1 && $t[22]>=$top2){
    	$mut{$enst}{"ribo"}+=$num;
    }
	$sum1{$enst}+=$num;
}
#print Dumper(\%mut);

my %random;
while(<IN2>){
	chomp;	
	my ($enst, $r, $nr) = split /\t/;
	$random{$enst}{"ribo"} = $r;
	$random{$enst}{"nribo"} = $nr;
}
foreach my $enst (keys %hash){
		my ($gene,$type) = split /:/,$hash{$enst};


		my ($a1,$a2,$b1,$b2);
        if(!defined $mut{$enst}{"ribo"}){
            $a1 = 0;
        }
		else{ $a1 = $mut{$enst}{"ribo"}; }
        

		if(!defined $random{$enst}{"ribo"}){
			$b1 = 0;
		}
		else{$b1 = $random{$enst}{"ribo"}; }
		
		next if ($a1==0 && $b1 == 0);
		
		$a2=0;
		$b2=0;
		if(defined $sum1{$enst}){
			$a2 = $sum1{$enst};	
		}
		if(defined $random{$enst}{"nribo"}){
			$b2 = $b1 + $random{$enst}{"nribo"};	
		}

		next if ($a2 == 0 && $b2 == 0);
		next if ($a1 == 0 && $a2 == 0);
		next if ($b1 == 0 && $b2 == 0);

		my $k = $a2 - $a1;
		$a2 = $k;

		$k = $b2 - $b1;
		$b2 = $k;

		my $p1 = Chisq($a1,$a2,$b1,$b2);
		my $p2 = fisher_great($a1,$a2,$b1,$b2);
		my $p3 = fisher_less($a1,$a2,$b1,$b2);
		my $p4 = geohyper($a1-1,$a1+$b1,$a1+$b1+$a2+$b2,$a1+$a2);
		print "$enst\t$gene\t$type\t$a1\t$a2\t$b1\t$b2\t$p1\t$p2\t$p3\t$p4\n";		
    
}


sub Chisq{
    my ($a1,$a2,$b1,$b2) = @_;

    open AA, ">ctest_$a1:$a2:$b1:$b2" or die $!;
    print AA "d1<-c($a1,$a2)\nd2<-c($b1,$b2)\nchisq.test(rbind(d1,d2))\$p\.value";
    my $result = `Rscript ctest_$a1:$a2:$b1:$b2`;
    my @t  = split /\n/,$result;
	$t[-1] =~ s/^\s+//g;
    $t[-1] =~ s/\[1\] //g;

    `rm -rf ctest_$a1:$a2:$b1:$b2`;
    return $t[-1];
}

sub fisher{
    my ($a1,$a2,$b1,$b2) = @_;

    open AA, ">ftest_$a1:$a2:$b1:$b2" or die $!;
    print AA "d1<-c($a1,$a2)\nd2<-c($b1,$b2)\nfisher.test(rbind(d1,d2))\$p\.value";
    my $result = `Rscript ftest_$a1:$a2:$b1:$b2`;
    my @t  = split /\n/,$result;
        $t[-1] =~ s/^\s+//g;
    $t[-1] =~ s/\[1\] //g;

    `rm -rf ftest_$a1:$a2:$b1:$b2`;
    return $t[-1];
}
sub fisher_great{
    my ($a1,$a2,$b1,$b2) = @_;

    open AA, ">ftest2_$a1:$a2:$b1:$b2" or die $!;
    print AA "d1<-c($a1,$a2)\nd2<-c($b1,$b2)\nfisher.test(rbind(d1,d2),alternative = \"greater\")\$p\.value";
    my $result = `Rscript ftest2_$a1:$a2:$b1:$b2`;
    my @t  = split /\n/,$result;
        $t[-1] =~ s/^\s+//g;
    $t[-1] =~ s/\[1\] //g;

    `rm -rf ftest2_$a1:$a2:$b1:$b2`;
    return $t[-1];
}

sub fisher_less{
    my ($a1,$a2,$b1,$b2) = @_;

    open AA, ">ftest3_$a1:$a2:$b1:$b2" or die $!;
    print AA "d1<-c($a1,$a2)\nd2<-c($b1,$b2)\nfisher.test(rbind(d1,d2),alternative = \"less\")\$p\.value";
    my $result = `Rscript ftest3_$a1:$a2:$b1:$b2`;
    my @t  = split /\n/,$result;
        $t[-1] =~ s/^\s+//g;
    $t[-1] =~ s/\[1\] //g;

    `rm -rf ftest3_$a1:$a2:$b1:$b2`;
    return $t[-1];
}

sub geohyper{
	my ($a1,$a2,$b1,$b2) = @_;
	
	open AA, ">hyper_$a1:$a2:$b1:$b2" or die $!;
    print AA "1-phyper($a1,$a2,$b1,$b2)";
    my $result = `Rscript hyper_$a1:$a2:$b1:$b2`;
    my @t  = split /\n/,$result;
    $t[-1] =~ s/^\s+//g;
    $t[-1] =~ s/\[1\] //g;

    `rm -rf hyper_$a1:$a2:$b1:$b2`;
    return $t[-1];
	
}
