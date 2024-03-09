#!/bin/sh

#while read -r line
#do
#	echo -e $line
#	echo -e starting test
#	run_cmd_var=`make run_npn SIM_OPTS="+UVM_TESTNAME=$line "`
#	#make run_npn SIM_OPTS="+UVM_TESTNAME=$line " 
#	echo -e $run_cmd_var
#done < spi_regress.tl

tput clear 
cat EXPOLOG_logo.txt
echo "Starting Regression..."

#REGRESS_TL=${@:$OPTIND:1}
REGRESS_TL=$1;

#store testname and iteration number
while read -r line
do
	echo -e $line >> temp_regress_file
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

	#run_cmd_var=`make run SIM_OPTS="${sim_opts[$i]} -sv_seed $SEED_VALUE -l ${test_name[$i]}_$SEED_VALUE.log +UVM_TIMEOUT=100000000 +UVM_MAX_QUIT_COUNT=100"`
	#echo -e $run_cmd_var

	#test_dir="$regress_dir/${test_name[$i]}_$SEED_VALUE"
	#mkdir $test_dir
	mkdir $regress_dir/${test_name[$i]}_$SEED_VALUE

	echo "Running test: ${test_name[$i]} with seed value:$SEED_VALUE"
	
	echo "make run SIM_OPTS="${sim_opts[$i]} -sv_seed $SEED_VALUE -l ${test_name[$i]}_$SEED_VALUE.log +UVM_TIMEOUT=100000000 +UVM_MAX_QUIT_COUNT=100"" > $regress_dir/${test_name[$i]}_$SEED_VALUE/run_cmd
	
	read -r line < $regress_dir/${test_name[$i]}_$SEED_VALUE/run_cmd
	echo -e "Run command: $line"

	make run SIM_OPTS="${sim_opts[$i]} -sv_seed $SEED_VALUE -l ${test_name[$i]}_$SEED_VALUE.log +UVM_TIMEOUT=100000000 +UVM_MAX_QUIT_COUNT=100" >/dev/null

	
	#echo $run_cmd_var > $regress_dir/${test_name[$i]}_$SEED_VALUE/run_cmd

	mv ${test_name[$i]}_$SEED_VALUE.* $regress_dir/${test_name[$i]}_$SEED_VALUE/
	#TODO: post regression script
  	#python3 $PRJ_SCRIPTS_DIR/regression_post_process.py $sim_area/
	((j++))
   done
   #TODO: echo regression summary 
   ((i++))
done



