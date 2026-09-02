#!/bin/bash

file="log_cose"
plain_data=(10 20 50)

mean_throughput_names=""
PDR_names=""
AVG_throughput_efficency_names=""
for k in {0..2}
do
	for i in {0..5} 
	do
		echo "ns uwcbr.tcl ${plain_data[k]} 6 $i 8 >> ${file}_${plain_data[k]}B.txt 2>/dev/null"
		ns uwcbr.tcl ${plain_data[k]} 6 $i 8 >> ${file}_${plain_data[k]}B.txt 2>/dev/null
	done
	 
	LC_NUMERIC=C awk -F ":" '/Mean Throughput/ {printf("%.5f\n",$2)}' ${file}_${plain_data[k]}B.txt > mean_throughput_cose${plain_data[k]}B.csv
	LC_NUMERIC=C awk -F ":" '/Packet Delivery Ratio/ {printf("%.5f\n",$2)}' ${file}_${plain_data[k]}B.txt > PDR_cose${plain_data[k]}B.csv
	LC_NUMERIC=C awk -F ":" '/AVG throughput efficency/ {printf("%.5f\n",$2)}' ${file}_${plain_data[k]}B.txt > AVG_throughput_efficency_cose${plain_data[k]}B.csv
	
	mean_throughput_names="${mean_throughput_names} mean_throughput_cose${plain_data[k]}B.csv"
	PDR_names="${PDR_names} PDR_cose${plain_data[k]}B.csv"
	AVG_throughput_efficency_names="${AVG_throughput_efficency_names} AVG_throughput_efficency_cose${plain_data[k]}B.csv"
done

plain_data_string=${plain_data[*]}

echo "${plain_data_string//${IFS:0:1}/;}" > mean_throughput_by_plain_size.csv
paste -d ";" ${mean_throughput_names} >> mean_throughput_by_plain_size.csv

echo "${plain_data_string//${IFS:0:1}/;}" > PDR_by_plain_size.csv
paste -d ";" ${PDR_names} >> PDR_by_plain_size.csv

echo "${plain_data_string//${IFS:0:1}/;}" > AVG_throughput_efficency_by_plain_size.csv
paste -d ";" ${AVG_throughput_efficency_names} >> AVG_throughput_efficency_by_plain_size.csv

rm ${file}_* mean_throughput*B.csv PDR*B.csv AVG_throughput_efficency*B.csv

