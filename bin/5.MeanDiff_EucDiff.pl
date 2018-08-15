#!usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;


my %lunp;
open UNLUNG_LIST, "<Ref.list" or die $!;
while(<UNLUNG_LIST>){
    chomp;
    my ($id,$path) = split /\t/;
    my @tt = split /[_:]/,$id;
    my $enst = $tt[0];
    my $ensg = $tt[1];

    $lunp{$enst} = $path;

}
#print Dumper(\%lunp);

my $dir = shift;
opendir(IN,$dir);
while(readdir(IN)){
	chomp;
	next if (/^\./);
	next unless (/lunp$/);
	my $id = $_;
	my ($enst,$pos,$ref,$alt) = split /[:_]/, $id;

	#get all the upro of ref seq
    my @array;
    next unless (defined $lunp{$enst});
    my $path = $lunp{$enst};
    open ORI, "<$path" or die $!;
    while(<ORI>) {
        chomp;
        next if (/#/);
        my @t = split /\t/;
        push @array,$t[1];
    }
	my @array1;
	my @array2;
	#get all the upro of mutated seq
	open IN2, "<$dir/$id" or die $1;
	while(<IN2>){
		chomp;
		next if (/#/);
		my @t = split /\t/;
		next if (abs($t[0]-$pos)>=200);
		push @array1, $array[$t[0]-1];
		push @array2, $t[1];
			
	}

	if (scalar(@array1) != scalar(@array2)){
		print "ERROR$enst\t$pos\t$ref\t$alt\tscalar(@array1)\tscalar(@array2)\n";	
	}
	else{
		my $stru = strucDiff(\@array1, \@array2);
		my $euc = Euclidean(\@array1, \@array2);
		print "$enst\t$pos\t$ref\t$alt\t".($stru)."\t".($euc)."\n";	
	}
	
}

sub strucDiff{
        my ($a, $b) = @_;
    my @d1 = @$a;
    my @d2 = @$b;
    my $j;
    for(my $i=0; $i<scalar(@d1); $i++){
        $j += abs($d1[$i] - $d2[$i]);
	}
    my $k = $j/scalar(@d1);  
    return $k;
}

sub Euclidean{

        my ($a, $b) = @_;
        my @d1 = @$a;
        my @d2 = @$b;

        my $j;
        for(my $i=0; $i<@d1; $i++){
                $j += ($d1[$i] - $d2[$i])**2;
        }
        my $k = sqrt($j);

        return $k;

}


