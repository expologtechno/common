######################################################################
#  	(c) Copyright 2021 EXPOLOG TECHNOLOGIES LLP
#  		    ALL RIGHTS RESERVED
#  	     EXPOLOG TECHNOLOGIES CONFIDENTIAL
#=====================================================================
#  File 	: makefile
#  Author 	: Praveen N
#  
######################################################################

DUMP_OPTS=DUMP_ON

#TB_DIR=$(VRF_DIR)/tb
#AGENT_DIR=$(VRF_DIR)/agent
#SEQ_DIR=$(VRF_DIR)/seqs
#TEST_DIR=$(VRF_DIR)/test

#DUT_FILE=$(RTL_DIR)/cmsdk_ahb_ram.v
#TOP_FILE=$(TB_DIR)/top.sv

TEST_NAME=""
SIM_OPTS=""
LOG_NAME=""

#INC_DIR=+incdir+$(RTL_DIR) +incdir+$(AGENT_DIR) +incdir+$(AGENT_DIR)/ahb_agent +incdir+$(TEST_DIR) +incdir+$(SEQ_DIR)  +incdir+$(TB_DIR) +incdir+$(LOG_DIR) +incdir+$(SIM_DIR)

logo_print: 
	cat $(CMN_DIR)/EXPOLOG_logo.txt

comp:
	vlog -coveropt 3 +cover -L $(QUESTA_HOME)/uvm-1.2 +define+$(DUMP_OPTS) $(INC_DIR) $(DUT_FILE) $(TOP_FILE) -l $(TEST_NAME).vlog

comp_regress:
	vlog -coveropt 3 +cover -L $(QUESTA_HOME)/uvm-1.2 +define+$(DUMP_OPTS) $(INC_DIR) $(DUT_FILE) $(TOP_FILE) -l $(LOG_NAME).vlog

vsim_example:
	rm -rf $(LOG_DIR)/$(TEST_NAME)_$(SEED)
	rm -rf $(TEST_NAME)_$(SEED).ucdb
	mkdir $(LOG_DIR)/$(TEST_NAME)_$(SEED)
	vsim -c -debugDB -sv_seed $(SEED) -cvgperinstance -voptargs=+acc -coverage -voptargs="+cover=all" +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=$(TEST_NAME) -l $(LOG_DIR)/$(TEST_NAME)_$(SEED)/$(TEST_NAME)_$(SEED).log -do "coverage save -onexit $(LOG_DIR)/$(TEST_NAME)_$(SEED)/$(TEST_NAME)_$(SEED).ucdb;do $(SIM_DIR)/wave.do; run -all; exit" work.top

run_example:	comp sim

sim: 
	vsim -c -debugDB +UVM_TESTNAME=$(TEST_NAME) $(SIM_OPTS) -l $(TEST_NAME).log -assertdebug -cvgperinstance -voptargs=+acc -coverage -voptargs="+cover=all" -do "coverage save -onexit $(TEST_NAME).ucdb; do $(CMN_DIR)/wave.do; run -all; exit" work.tb_top
	tr -d '\r' < $(CMN_DIR)/EXPOLOG_logo.txt > temp_file
	tr -d '\r' < $(TEST_NAME).log > temp_file_1
	cat temp_file temp_file_1 > temp_log && mv temp_log $(TEST_NAME).log 
	rm temp_file*

sim_regress:
	vsim -c -debugDB $(SIM_OPTS) -l $(LOG_NAME).log -assertdebug -cvgperinstance -voptargs=+acc -coverage -voptargs="+cover=all" -do "coverage save -onexit $(LOG_NAME).ucdb;run -all; exit"   work.tb_top
	tr -d '\r' < $(CMN_DIR)/EXPOLOG_logo.txt > temp_file
	tr -d '\r' < $(LOG_NAME).log > temp_file_1
	cat temp_file temp_file_1 > temp_log && mv temp_log $(LOG_NAME).log
	rm temp_file*

run: logo_print comp sim


run_regress: logo_print comp_regress sim_regress


regress: 
	./$(CMN_DIR)/regress.csh $(TL_FILE).tl 


wave: 
	vsim -view $(SIM_DIR)/vsim.wlf &


vsim_gui: 
	vsim -debugDB +UVM_TESTNAME=$(TEST_NAME) $(SIM_OPTS) -do "do $(CMN_DIR)/wave.do; run -all; exit" work.tb_top

run_gui: logo_print comp vsim_gui

cov_merge:
	vcover merge merge.ucdb $(TL_FILE)_*/*/*.ucdb	
	#vcover report -html -output covhtmlreport -annotate -details -assert -directive -cvg -code bcefst -threshL 50 -threshH 90 merge.ucdb
	vcover report -html -source -details -assert -directive -cvg -code bcefst -threshL 50 -threshH 90 merge.ucdb

clean:
	rm -rf work &
	rm *.log &
	rm *.vlog &
	rm *.ucdb &
	rm vsim.* 

clean_regress:
	rm -rf covhtmlreport &
	rm merge.ucdb &
	rm -rf $(TL_FILE)_*

#run_reg: comp lsb_fst_data_test msb_fst_data_test Rx_raising_Tx_falling_test Rx_falling_Tx_raising_test

#merge:
#	vcover merge -64 merge_ucdb.ucdb *.ucdb
#wave:
#	vsim -view vsim.wlf


