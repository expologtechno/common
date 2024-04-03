#!/bin/sh

######################################################################
#  	(c) Copyright 2021 EXPOLOG TECHNOLOGIES LLP
#  		    ALL RIGHTS RESERVED
#  	     EXPOLOG TECHNOLOGIES CONFIDENTIAL
#=====================================================================
#  File 	: regress.csh
#  Author 	: Praveen N
#  
######################################################################


#while read -r line
#do
#	echo -e $line
#	echo -e starting test
#	run_cmd_var=`make run_npn SIM_OPTS="+UVM_TESTNAME=$line "`
#	#make run_npn SIM_OPTS="+UVM_TESTNAME=$line " 
#	echo -e $run_cmd_var
#done < spi_regress.tl

tput clear 
cat $CMN_DIR/EXPOLOG_logo.txt
echo "Starting Regression..."

#REGRESS_TL=${@:$OPTIND:1}
REGRESS_TL=$1;

#store testname and iteration number
while read -r line
do
	if [[ $line != *"#"* ]]
	then
		if [ "$line" != "" ]
		then
			echo -e $line >> temp_regress_file
		fi
	fi
done < $REGRESS_TL

awk '{print $1}' temp_regress_file > temp_test_name
awk '{for (i=3; i<NF; i++) printf $i " "; print $NF}' temp_regress_file > temp_sim_opts
awk '{print $2}' temp_regress_file > temp_iter_file

#get test names 
i=0
test_name=()
while read -r tc_name 
do 
	test_name+=("$tc_name")
	((i++))
done < temp_test_name

#get sim_opts 
i=0
sim_opts=()
while read -r tc_sim_opts
do 
	sim_opts+=("$tc_sim_opts")
	((i++))
done < temp_sim_opts

#get iteration number
i=0
iter_opts=()
while read -r iter_num
do
	iter_opts+=("$iter_num")
	((i++))
done < temp_iter_file


# Remove the tempory files 
rm -rf temp_*

num_tests=${#test_name[@]}
 
#directory to save the regression logs
export regress_dir="${REGRESS_TL%.*}_$(date +%Y%m%d_%H%M%S)"
#mkdir -p "${REGRESS_TL%.*}_$(date +%Y%m%d_%H%M%S)"
mkdir -p $regress_dir

cp $CMN_DIR/EXPOLOG_logo.txt $regress_dir/regress_summary.txt

total_sims=0
for i in ${iter_opts[@]}
do
    total_sims=`expr $total_sims + $i`
done

rem_sims=$total_sims

echo "Number of tests : $num_tests"
echo "Number of sims  : $total_sims"

PASS_STRING="!!!TEST PASSED!!!"
FAIL_STRING="!!!TEST FAILED!!!"

passed_count=0
failed_count=0
incomplete_cnt=0

curr_pass_cnt=0
curr_fail_cnt=0

#Launch the regression 
tput sc 
i=0
while [ $i -lt $num_tests ]
do
   j=0
   while [ $j -lt ${iter_opts[$i]} ]
   do
   	tput rc
  	SEED_VALUE=$RANDOM;

	mkdir $regress_dir/${test_name[$i]}_$SEED_VALUE

	((rem_sims--))

	echo "Running test: "`expr $i + 1`"  	Iteration: "`expr $j + 1`"	remaining_iterations: "`expr ${iter_opts[$i]} - 1 - $j`"	remaining sims: $rem_sims"
	echo "Running test: ${test_name[$i]} with seed value:$SEED_VALUE"
	
	echo "make run TEST_NAME='"${test_name[$i]}"' SIM_OPTS='"${sim_opts[$i]} -sv_seed $SEED_VALUE -l ${test_name[$i]}_$SEED_VALUE.log +UVM_TIMEOUT=100000000 +UVM_MAX_QUIT_COUNT=100"'" > $regress_dir/${test_name[$i]}_$SEED_VALUE/run_cmd
	
	read -r line < $regress_dir/${test_name[$i]}_$SEED_VALUE/run_cmd
	echo -e "Run command: $line"

	#make run_regress TEST_NAME="${test_name[$i]}" LOG_NAME="${test_name[$i]}_$SEED_VALUE" SIM_OPTS="${sim_opts[$i]} -sv_seed $SEED_VALUE +UVM_TIMEOUT=100000000 +UVM_MAX_QUIT_COUNT=100" >/dev/null
	make run_regress LOG_NAME="${test_name[$i]}_$SEED_VALUE" SIM_OPTS="${sim_opts[$i]} -sv_seed $SEED_VALUE +UVM_TIMEOUT=100000000 +UVM_MAX_QUIT_COUNT=100" >/dev/null

	#echo $run_cmd_var > $regress_dir/${test_name[$i]}_$SEED_VALUE/run_cmd

	mv ${test_name[$i]}_$SEED_VALUE.* $regress_dir/${test_name[$i]}_$SEED_VALUE/

	#regression summary:
	#if grep -q "$PASS_STRING" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log"; then

	# Search for "PASSED" or "FAILED" in the log file
	if [ -f "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log" ]
	then
		curr_pass_cnt=$(grep -c "$PASS_STRING" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log")	
		curr_fail_cnt=$(grep -c "$FAIL_STRING" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log")
	else
		curr_pass_cnt=0
		curr_fail_cnt=0
	fi

	passed_count=`expr $passed_count + $curr_pass_cnt`
	failed_count=`expr $failed_count + $curr_fail_cnt`
	
	if [ "$curr_pass_cnt" -eq 0 ] && [ "$curr_fail_cnt" -eq 0 ]; then
		((incomplete_cnt++))
	fi

	# Print the table
	{
		printf "\n=====================================================================================================\n"	
		#printf "| Log File: %-10s \n" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log"
		#printf "|-----------------------------------------------------------------------------------------------------\n"	
		printf "| %-10s | %-10s | \n" "Result" "Count"  
		printf "| %-10s | %-10s | \n" "PASSED" "$passed_count" 
		printf "| %-10s | %-10s | \n" "FAILED" "$failed_count" 
		printf "| %-10s | %-10s | \n" "INCOMPLETE" "$incomplete_cnt" 
		printf "|-----------------------------------------------------------------------------------------------------\n"	
		printf "| Regress summary : %-10s \n" "$regress_dir/regress_summary.txt"
		printf "=====================================================================================================\n \n"	
	} > temp_regress_summary 

	{
		printf "\n=====================================================================================================\n"	
		#printf "| Log File: %-10s \n" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log"
		printf "| %-20s\t | %-10s | %-30s   \n" "TEST_NAME" "Result" "Logfile"  
		printf "|-----------------------------------------------------------------------------------------------------\n"	
		if [ "$curr_pass_cnt" -eq 0 ] && [ "$curr_fail_cnt" -eq 0 ]; then
			printf "| %-20s | %-10s | %-30s   \n" "${test_name[$i]}_$SEED_VALUE" "INCOMPLETE" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log" 
		elif [ "$curr_pass_cnt" -gt 0 ] && [ "$curr_fail_cnt" -eq 0 ]; then 
			printf "| %-20s | %-10s | %-30s   \n" "${test_name[$i]}_$SEED_VALUE" "PASSED" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log" 
		elif [ "$curr_pass_cnt" -eq 0 ] && [ "$curr_fail_cnt" -gt 0 ]; then 
			printf "| %-20s | %-10s | %-30s   \n" "${test_name[$i]}_$SEED_VALUE" "FAILED" "$regress_dir/${test_name[$i]}_$SEED_VALUE/${test_name[$i]}_$SEED_VALUE.log" 
		fi
		#printf "|-----------------------------------------------------------------------------------------------------\n"	
		#printf "| Regress summary : %-10s \n" "$regress_dir/regress_summary.txt"
		printf "====================================================================================================="	
	} > temp_test_result 

	cat temp_regress_summary
	#cat temp_test_result
	
	cat temp_test_result >> $regress_dir/regress_summary.txt

	#TODO: post regression script
  	#python3 $PRJ_SCRIPTS_DIR/regression_post_process.py $sim_area/
	((j++))
   done
   #TODO: echo regression summary 
   ((i++))
done

	cat temp_regress_summary >> $regress_dir/regress_summary.txt
	rm temp_regress_summary		
	rm temp_test_result

