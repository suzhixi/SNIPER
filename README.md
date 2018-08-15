# SNIDER
**Requirement:**
1. ViennaRNA RNAplfold
2. Perl package:</br>
Data::Dumper</br>
Statistics::R</br>
3.bedtools</br>
4.human reference genome (.fa)</br>
5.gene annotation (.gtf)</br>
**Preparation**</br>
>cd preparation</br>
>sh run.sh</br>




**Pipeline**</br>
>cd test
>perl ../bin/1.snv_filter.pl test.snv.list </br>
>perl ../bin/2.snv_summary.pl snv.txt > snv_summary.txt </br>
>perl ../bin/3.add_ref.pl Ref.list snv_summary.txt > snv_summary.add.txt </br>
>perl ../bin/4.cal_alt.pl snv_summary.add.txt </br> 
>perl ../bin/5.MeanDiff_EucDiff.pl RNAplfold > dis.txt </br>
>perl ../bin/6.add_alt.pl snv_summary.add.txt > snv_summary.add.diff.txt</br>
>perl ../bin/7.ribo_enriched_lnc.pl snv_summary.add.diff.txt lnc.txt</br>
>perl ../bin/7.ribo_enriched_lnc.pl snv_summary.add.diff.txt 3utr.txt 3UTR</br>
>perl ../bin/7.ribo_enriched_lnc.pl snv_summary.add.diff.txt 5utr.txt 5UTR</br>

