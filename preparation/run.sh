bedtools="/mnt/data/hfn/Tools/CGP/BRASS-dev/bin/bedtools"
dir=`pwd`
gtf="/mnt/data/hfn/2.Projects/1.RSS/9.github/gencode.v19.annotation.gtf"
fa="/mnt/data/hfn/Data/hg19/ucsc.hg19.fasta"

echo "#Step one: get referece sequence and predict RNA secondary structure" > $dir/pre.sh
echo "less $gtf |sed '/#/d'|grep  -w 'exon'|awk -F \"\t\" '{print \$1\"\\t\"\$4-1\"\\t\"\$5\"\\t\"\$6\"\\t\"\$7\"\\t\"\$8\"\\t\"\$9\"\\t\"\$10\"\\t\"\$11\"\\t\"\$12}' > NR.bed" >> $dir/pre.sh
echo "$bedtools getfasta -fi $fa -bed NR.bed -tab -fo NR.bed.fasta.txt" >> $dir/pre.sh
echo "perl 0.get.NR.fasta.pl & " >> $dir/pre.sh


echo "#Step two: get coresponding RNA position" >> $dir/pre.sh
echo "perl 1.merge_gtf_reverse_exon.pl& " >> $dir/pre.sh
echo "perl 2.add_anno.pl Chrpos_RNApos_ok.txt > aa" >> $dir/pre.sh
echo "mv aa Chrpos_RNApos.txt" >> $dir/pre.sh
echo "perl 3.re_codon.pl Chrpos_RNApos.txt > aa;cut -f2- aa > Chrpos_RNApos.txt" >> $dir/pre.sh


