#!/bin/bash

file="log_cose_throughput"
plain_data=(10 20 50)

names=""
for k in {0..2}
do
	for i in {0..50} 
	do
		echo "ns uwcbr.tcl ${plain_data[k]} 6 $i 2 >> ${file}_${plain_data[k]}B.txt 2>/dev/null"
		ns uwcbr.tcl ${plain_data[k]} 6 $i 2 >> ${file}_${plain_data[k]}B.txt 2>/dev/null
	done
	 
	LC_NUMERIC=C awk -F ":" '/Mean Throughput/ {printf("%.5f\n",$2)}' ${file}_${plain_data[k]}B.txt > mean_throughput_cose${plain_data[k]}B.csv
	
	names="${names} mean_throughput_cose${plain_data[k]}B.csv"
done

period_string=${period[*]}
echo "${period_string//${IFS:0:1}/;}" > mean_throughput_period.csv
paste -d ";" ${names} >> mean_throughput_by_plain_size.csv

