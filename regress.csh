#!/bin/sh

#while read -r line
#do
#	echo -e $line
#	echo -e starting test
#	run_cmd_var=`make run_npn SIM_OPTS="+UVM_TESTNAME=$line "`
#	#make run_npn SIM_OPTS="+UVM_TESTNAME=$line " 
#	echo -e $run_cmd_var
#done < spi_regress.tl


while read -r line
do
	echo -e $line >> temp_regress_file
done < spi_regress.tl


awk '{print $1}' temp_regress_file > temp_test_name
awk '{for i=2; i<NF; i++} print $i ""; print $NF}' temp_regress_file > temp_sim_opts

i=0
test_name=()
while read -r tc_name 
do 
	test_name+=("$tc_name")
	((i++))
done < temp_test_name

i=0
sim_opts=()
while read -r tc_sim_opts
do 
	sim_opts+=("tc_sim_opts")
	((i++))
done < temp_sim_opts


 
