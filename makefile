
#MODULE_PATH=/cygdrive/c/cygwin64/home/ashig/Documents/SPI
MODULE_PATH=../../../SPI

SEED=10
DUMP_OPTS=DUMP_ON

DUT_DIR=$(MODULE_PATH)/Project_area/rtl
DUT_FILE=$(DUT_DIR)/spi_top.v

TB_DIR=$(MODULE_PATH)/Project_area/vrf/tb
#TOP_DIR=$(TB_DIR)/tb/
ENV_DIR=$(MODULE_PATH)/Project_area/vrf/tb/spi_env
AGENT_DIR=$(MODULE_PATH)/Project_area/vrf/agents
SEQ_DIR=$(MODULE_PATH)/Project_area/vrf/Seqs

TOP_FILE=$(TB_DIR)/tb_top.sv

TEST_DIR=$(MODULE_PATH)/Project_area/vrf/tests

LOG_DIR=$(MODULE_PATH)/Scratch_area/log
SIM_DIR=$(MODULE_PATH)/Scratch_area/sim
SIM_OPTS=""

INC_DIR=+incdir+$(DUT_DIR) +incdir+$(AGENT_DIR) +incdir+$(AGENT_DIR)/wb_agent +incdir+$(AGENT_DIR)/spi_slave_agent +incdir+$(AGENT_DIR)/reset_agent +incdir+$(TEST_DIR) +incdir+$(SEQ_DIR)  +incdir+$(ENV_DIR)  +incdir+$(TB_DIR) +incdir+$(LOG_DIR) +incdir+$(SIM_DIR)

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
	vsim -c -debugDB $(SIM_OPTS) -do "do $(SIM_DIR)/wave.do; run -all; exit" work.tb_top

vsim_gui: 
	vsim -debugDB $(SIM_OPTS) -do "do $(SIM_DIR)/wave.do; run -all; exit" work.tb_top

run: logo_print comp sim

run_gui: logo_print comp vsim_gui

wave: 
	vsim -view $(SIM_DIR)/vsim.wlf &

#run_reg: comp lsb_fst_data_test msb_fst_data_test Rx_raising_Tx_falling_test Rx_falling_Tx_raising_test

#merge:
#	vcover merge -64 merge_ucdb.ucdb *.ucdb
#wave:
#	vsim -view vsim.wlf


