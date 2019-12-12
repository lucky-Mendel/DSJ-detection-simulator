#!/usr/bin/perl -w
use strict;
srand;
open TRID,"<","/hwfssz5/ST_PRECISION/TOMCAT/F16ZQSB1SY2825/zhoubiaofeng_temp/version14/00.basic_infor/dice_order_four_col";
open SIM_OUT_A,">",$ARGV[0]."A";
open SIM_OUT_B,">",$ARGV[0]."B";
print SIM_OUT_A "txid\trpk\n";
print SIM_OUT_B "txid\trpk\n";
my ($rpk_total,$first_A,$second_A,$first_B,$second_B,$fold)=(0,0,0,0,0,0);
my $line=1;
my $count=1;
$rpk_total=$ARGV[1];
srand();
open LENGTH,"<","/hwfssz5/ST_PRECISION/TOMCAT/F16ZQSB1SY2825/zhoubiaofeng_temp/version14/00.basic_infor/400_transcript_infoV1.txt";
my %gene_length=();
my %transcript_length=();
my %gene_transcript=();
while(<LENGTH>){
	chomp;
	my @items=split;
	$gene_length{$items[2]}=$items[3];
	$transcript_length{$items[0]}=$items[1];
	$gene_transcript{$items[0]}=$items[2];
	}
open PAIR,"<","/hwfssz5/ST_PRECISION/TOMCAT/F16ZQSB1SY2825/zhoubiaofeng_temp/version14/00.basic_infor/pair_transcripts.txt";
my %transcript_pair=();
while(<PAIR>){
	chomp;
	my @s=split;
	$transcript_pair{$s[0]}=$s[1];
	$transcript_pair{$s[1]}=$s[0];
	}
while(<TRID>){
	chomp;
	next if /^tran_id/;
	my @rec=split;
	if ($count<=100){
	$fold=rand($ARGV[2]/2)+$ARGV[2]/2;
	$first_A=$rpk_total*$gene_length{$gene_transcript{$rec[0]}}/($fold*$transcript_length{$rec[0]}+$transcript_length{$transcript_pair{$rec[0]}});
	$second_A=$fold*$first_A;
	print SIM_OUT_A "$rec[0]\t","$second_A\n","$transcript_pair{$rec[0]}\t","$first_A\n";
	$first_B=$rpk_total*$gene_length{$gene_transcript{$rec[0]}}/($transcript_length{$rec[0]}+$fold*$transcript_length{$transcript_pair{$rec[0]}});
	$second_B=$fold*$first_B;
	print SIM_OUT_B "$rec[0]\t","$first_B\n","$transcript_pair{$rec[0]}\t","$second_B\n";
	}
	else{
	$first_A=rand(1)*($rpk_total*$gene_length{$gene_transcript{$rec[0]}}/$transcript_length{$rec[0]});
	$second_A=($rpk_total*$gene_length{$gene_transcript{$rec[0]}}-$first_A*$transcript_length{$rec[0]})/$transcript_length{$transcript_pair{$rec[0]}};
	#print "$first_A\t$second_A\n";
	print SIM_OUT_A "$rec[0]\t","$first_A\n","$transcript_pair{$rec[0]}\t","$second_A\n";
	$first_B=rand(1)*($rpk_total*$gene_length{$gene_transcript{$rec[0]}}/$transcript_length{$rec[0]});
	$second_B=($rpk_total*$gene_length{$gene_transcript{$rec[0]}}-$first_B*$transcript_length{$rec[0]})/$transcript_length{$transcript_pair{$rec[0]}};
	print SIM_OUT_B "$rec[0]\t","$first_B\n","$transcript_pair{$rec[0]}\t","$second_B\n";			
		}
	my $skip=<TRID>;
	$count=$count+1;
}		
close TRID;
close SIM_OUT_A;
close SIM_OUT_B;
close LENGTH;
close PAIR;
