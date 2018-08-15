# SNIDER
**Requirement:**
1. ViennaRNA RNAplfold
2. Perl package:</br>
Data::Dumper</br>
Statistics::R</br>

**pipeline**
perl ../bin/1.snv_filter.pl test.snv.list
perl ../bin/2.snv_summary.pl snv.txt > snv_summary.txt #30 minutes
perl ../bin/3.add_ref.pl Ref.list snv_summary.txt > snv_summary.add.txt
perl ../bin/4.cal_alt.pl snv_summary.add.txt
perl ../bin/5.MeanDiff_EucDiff.pl RNAplfold > dis.txt
perl ../bin/6.add_alt.pl snv_summary.add.txt > snv_summary.add.diff.txt
perl ../bin/7.ribo_enriched_lnc.pl snv_summary.add.diff.txt lnc.txt
perl ../bin/7.ribo_enriched_lnc.pl snv_summary.add.diff.txt 3utr.txt 3UTR
perl ../bin/7.ribo_enriched_lnc.pl snv_summary.add.diff.txt 5utr.txt 5UTR

