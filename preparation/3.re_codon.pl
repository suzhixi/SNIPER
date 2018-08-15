#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;


my %start;
my %end;
my %id;
open IN,"<$ARGV[0]" or die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $anno = $t[10];	
	my $strand = $t[4];

	if($anno =~ /start_codon/){
		foreach my $k(@t){
            print "\t$k";
        }
        print "\n";
	
		my $line1 = <IN>;
		my $line2 = <IN>;
		chomp $line1;
		chomp $line2;
		my @t1 = split /\t/,$line1;
		my @t2 = split /\t/,$line2;
		if($t1[9] eq $t[9]){	
			for(my $i=0;$i<10;$i++){
				print "\t$t1[$i]";		
			}					
			print "\tstart_codon:2";	
			for(my $i=11;$i<@t1;$i++){
                print "\t$t1[$i]";
            }
			print "\n";
		}
		else{
			foreach my $i(@t1){
        	    print "\t$i";
	        }
    	    print "\n";		
		}
		if($t2[9] eq $t[9]){
			for(my $i=0;$i<10;$i++){
                print "\t$t2[$i]";
            }
            print "\tstart_codon:3";
            for(my $i=11;$i<@t2;$i++){
                print "\t$t2[$i]";
            }
            print "\n";
		}
		else{
			foreach my $i(@t2){
                print "\t$i";
            }
            print "\n";
		}
	}	
	elsif($anno =~ /stop_codon/){
		foreach my $k(@t){
            print "\t$k";
        }
        print "\n";

		my $line1 = <IN>;
        my $line2 = <IN>;
        chomp $line1;
        chomp $line2;
        my @t1 = split /\t/,$line1;
        my @t2 = split /\t/,$line2;
		if($t1[9] eq $t[9]){
            for(my $i=0;$i<10;$i++){
                print "\t$t1[$i]";
            }
            print "\tstop_codon:2";
            for(my $i=11;$i<@t1;$i++){
                print "\t$t1[$i]";
            }
            print "\n";
		}
		else{
            foreach my $i(@t1){
                print "\t$i";
            }
            print "\n";
        }
		if($t2[9] eq $t[9]){
            for(my $i=0;$i<10;$i++){
                print "\t$t2[$i]";
            }
            print "\tstop_codon:3";
            for(my $i=11;$i<@t2;$i++){
                print "\t$t2[$i]";
            }
            print "\n";
		}
		else{
			foreach my $i(@t2){
                print "\t$i";
            }
            print "\n";
		}			
	}
	else{
		foreach my $i(@t){
        	print "\t$i";
		}
	    print "\n";			
	}
}
