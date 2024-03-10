DUMP_OPTS=DUMP_ON

DUT_FILE=$(RTL_DIR)/spi_top.v
TB_DIR=$(VRF_DIR)/tb
AGENT_DIR=$(VRF_DIR)/agents
SEQ_DIR=$(VRF_DIR)/Seqs
TOP_FILE=$(TB_DIR)/tb_top.sv
TEST_DIR=$(VRF_DIR)/tests

TEST_NAME=""
SIM_OPTS=""
LOG_NAME=""

INC_DIR=+incdir+$(RTL_DIR) +incdir+$(AGENT_DIR) +incdir+$(AGENT_DIR)/wb_agent +incdir+$(AGENT_DIR)/spi_slave_agent +incdir+$(AGENT_DIR)/reset_agent +incdir+$(TEST_DIR) +incdir+$(SEQ_DIR)  +incdir+$(TB_DIR) +incdir+$(LOG_DIR) +incdir+$(SIM_DIR)

logo_print: 
	cat EXPOLOG_logo.txt

comp:
	vlog -coveropt 3 +cover -L $(QUESTA_HOME)/uvm-1.2 +define+$(DUMP_OPTS) $(INC_DIR) $(DUT_FILE) $(TOP_FILE)

vsim_example:
	rm -rf $(LOG_DIR)/$(TEST_NAME)_$(SEED)
	rm -rf $(TEST_NAME)_$(SEED).ucdb
	mkdir $(LOG_DIR)/$(TEST_NAME)_$(SEED)
	vsim -c -debugDB -sv_seed $(SEED) -cvgperinstance -voptargs=+acc -coverage -voptargs="+cover=all" +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=$(TEST_NAME) -l $(LOG_DIR)/$(TEST_NAME)_$(SEED)/$(TEST_NAME)_$(SEED).log -do "coverage save -onexit $(LOG_DIR)/$(TEST_NAME)_$(SEED)/$(TEST_NAME)_$(SEED).ucdb;do $(SIM_DIR)/wave.do; run -all; exit" work.top

run_example:	comp sim

sim: 
	vsim -c -debugDB +UVM_TESTNAME=$(TEST_NAME) $(SIM_OPTS) -l $(TEST_NAME).log -cvgperinstance -voptargs=+acc -coverage -voptargs="+cover=all" -do "coverage save -onexit $(TEST_NAME).ucdb; do $(SIM_DIR)/wave.do; run -all; exit" work.tb_top
	#mv $(TEST_NAME).* $(LOG_DIR)/ 
	cat $(TEST_NAME).log > temp_log 
	cat EXPOLOG_logo.txt > $(TEST_NAME).log
	cat temp_log >> $(TEST_NAME).log
	rm temp_log

sim_regress:
	vsim -c -debugDB +UVM_TESTNAME=$(TEST_NAME) $(SIM_OPTS) -l $(LOG_NAME).log -cvgperinstance -voptargs=+acc -coverage -voptargs="+cover=all" -do "coverage save -onexit $(LOG_NAME).ucdb;run -all; exit"   work.tb_top
	cat $(LOG_NAME).log > temp_log 
	cat EXPOLOG_logo.txt > $(LOG_NAME).log
	cat temp_log >> $(LOG_NAME).log
	rm temp_log


run: logo_print comp sim


run_regress: logo_print comp sim_regress

wave: 
	vsim -view $(SIM_DIR)/vsim.wlf &


vsim_gui: 
	vsim -debugDB +UVM_TESTNAME=$(TEST_NAME) $(SIM_OPTS) -do "do $(SIM_DIR)/wave.do; run -all; exit" work.tb_top

run_gui: logo_print comp vsim_gui

clean:
	rm -rf work
	rm vsim.*
	rm *.log
	rm *.ucdb

clean_regress:
	rm -rf spi_regress_*

#run_reg: comp lsb_fst_data_test msb_fst_data_test Rx_raising_Tx_falling_test Rx_falling_Tx_raising_test

#merge:
#	vcover merge -64 merge_ucdb.ucdb *.ucdb
#wave:
#	vsim -view vsim.wlf


