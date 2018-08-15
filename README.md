# SNIPER
SNIPER is a framework to detect riboSNitch-enriched elements (5'UTR, 3'UTR and lncRNAs) in cancer genome.

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
>ln -s ../preparation/All.NR.filter.fasta .</br>
>ln -s ../preparation/Chrpos_RNApos.txt .</br>
>ln -s ../preparation/Ref.list .</br>
>sh run.sh</br>

