echo "setting project environments"
#export PROJ_ROOT=C:/home/$USER/Documents/WB_SPI_master
#export PROJ_ROOT=$PWD
export PROJ_ROOT=../../../WB_SPI_master
export PROJ_AREA=$PROJ_ROOT/project_area
export SCRATCH_AREA=$PROJ_ROOT/scratch_area
export SIM_DIR=$SCRATCH_AREA/sim
export RTL_DIR=$PROJ_AREA/rtl
export VRF_DIR=$PROJ_AREA/vrf
#export LOG_DIR=/home/$USER/Documents/sim_logs
export LOG_DIR=$PROJ_ROOT/../sim_logs

echo "PROJ_ROOT	   =	$PROJ_ROOT	"	
echo "PROJ_AREA	   =	$PROJ_AREA	"	
echo "SCRATCH_AREA =	$SCRATCH_AREA	"	
echo "SIM_DIR	   =	$SIM_DIR	"	
echo "RTL_DIR	   =	$RTL_DIR	"		
echo "VRF_DIR	   =	$VRF_DIR	"		
