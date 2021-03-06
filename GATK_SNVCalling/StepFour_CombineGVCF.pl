#!/usr/bin/perl -w
sub usage (){
    die qq(
#===========================================================================
#        USAGE:print.pl  -h
#        DESCRIPTION: -h : Display this help
#        Original resource from WES2018 Pipeline: FMD/SNVCalling/pipeline/StepOne.bwa.pl
#        Author: Wang Yu
#        Mail: yulywang\@umich.edu
#        Created Time:  Wed 18 Apr 2018 10:35:15 PM EDT
#===========================================================================
)
}
use strict;
use warnings;
use Getopt::Std;
$ARGV[0] || &usage();
our ($opt_h);
getopts("h");

my $i = 30; # because previous all samples end at 29.vcf.gz
print "gatk4.0.5 CombineGVCFs -R /home/yulywang/db/human/hs37d5.fa -O ../CombineGVCF/30samples/$i.vcf.gz ";
$i++; 

my $j = 1; # for indexing
while(my $input = <>){
	chomp $input;
	my @F = split/\//,$input;
	my $prefix = $F[$#F]; # not full path prefix
	$prefix =~ s/.bam$//;

	#my $header = "\@RG\\tID:$prefix\\tPL:Illumina\\tLB:$prefix\\tDS:pe::0\\tDT:2020-01-01\\tSM:$prefix\\tCN:University_of_Michigan_Ganesh_Lab_YuWang";

	$prefix = $input; # full path
	$prefix =~ s/.bam$//;

	#print "samtools sort -m 1600M --threads 4 -n -O BAM -o $prefix.sortid.bam $input;";
	#print " samtools fastq $prefix.sortid.bam | bwa7.17 mem -R \"$header\" -t 4 -k 20 -w 105 -d 105 -r 1.3 -c 12000 -A 1 -B 4 -O 6 -E 1 -L 6 -U 18 -p /home/yulywang/db/human/hs37d5 - | gzip -3 > $prefix.sam.gz;";
	#print "gzip -dc $prefix.sam.gz | samtools view --threads 4 -b1ht /home/yulywang/db/human/hs37d5.fa.fai - > $prefix.unsort.bam;";
	#print "samtools sort -m 1600M --threads 4 -O BAM -o $prefix.sort.bam $prefix.unsort.bam;"; 
	#print "samtools index $prefix.sort.bam;";
	#print "rm $prefix.sortid.bam; rm $prefix.sam.gz; rm $prefix.unsort.bam; ";
	#print "gatk4.0.5 MarkDuplicates --INPUT $prefix.sort.bam --OUTPUT $prefix.dup.bam --METRICS_FILE $prefix.matrix --ASSUME_SORTED true --CREATE_INDEX true -R ~/db/human/hs37d5.fa --TAGGING_POLICY All --MAX_RECORDS_IN_RAM 350000;";
	#print "gatk4.0.5 BaseRecalibrator -R ~/db/human/hs37d5.fa -I $prefix.dup.bam --known-sites  ~/db/dbsnp/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --known-sites ~/db/dbsnp/1000G_phase1.indels.hg19.sites.vcf.gz --known-sites ~/db/dbsnp/dbsnp_138.hg19.excluding_sites_after_129.vcf.gz -O $prefix.recal_data.table; ";
	#print "gatk4.0.5 ApplyBQSR -R ~/db/human/hs37d5.fa -I $prefix.dup.bam -bqsr $prefix.recal_data.table -O $prefix.dup.bq.bam;";
	#print "gatk4.0.5 HaplotypeCaller -R ~/db/human/hs37d5.fa -I $prefix.dup.bq.bam -O $prefix.g.vcf.gz --emit-ref-confidence GVCF --max-reads-per-alignment-start 100;";
	print "-V $prefix.g.vcf.gz ";
	if($j % 30 == 0 ){ # this will merge N samples as one command line
			print "\n";
			print "gatk4.0.5 CombineGVCFs -R /home/yulywang/db/human/hs37d5.fa -O ../CombineGVCF/30samples/$i.vcf.gz ";
			$i++;
	}
	$j++;
}
print "\n";
