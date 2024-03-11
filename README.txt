######################################################################
#  	(c) Copyright 2021 EXPOLOG TECHNOLOGIES LLP
#  		    ALL RIGHTS RESERVED
#  	     EXPOLOG TECHNOLOGIES CONFIDENTIAL
#=====================================================================
#  File 	: README.txt 
#  Author 	: Praveen N
#  
######################################################################

Steps to execute: 
	1. Clone common repo
	2. Copy PROJECT.bashrc to scratch_area/sim --> rename as per project ex: AHB.bashrc 
	3. Edit the DUT_FILE name and other paths 
	4. Create a tl file for regression in format specified below
	5. source the *.bashrc <-- required whenver changes happens to bashrc file 

Guidelines to be followed: 
	1. TB TOP file module name should be tb_top and file name can be tb_top.sv
	2. Everyone should follow the Directory stucture - other wise makefile will not work (you may need to update again)
	3. Test result should be printed propery using UVM_INFO
		pass pattern : !!!TEST PASSED!!!
		fail pattern : !!!TEST FAILED!!! 
	4. all the directory names should be in lower case
		proper names: 	project_area/  scratch_area/
		improper names:	Project_Area/  Scractch_area/  
	5. Don't Push the simulation logs and regression logs to git repository 
		

project_regress.tl file format:
user_deined_test_name 		interation_no		+UVM_TESTNAME=your_test_name +plusargs +defines

To run the regression:
	make regress

To run single test:
	make run TEST_NAME="your_test_name" SIM_OPTS="your_plusargs_or_defines"

To Open the waves:
	make wave

To clean sim area : (delete indivisual logs and other vsim files)
	make clean

To clean regression folders:
	make clean_regress

To generate coverage report:
	make cov_merge


Git commands:
To clone the repo: 
	git clone repo_url
		--> will create a directory in repository name
	git clone repo_url directory_name
		--> will create a directory in provided directory_name
		
To fetch from repo: (1st time)
	git fetch

To check git status:
	git status
		--> will display new files and modified file if any

To add new files:
	git add file_1 file_2

To commit files:
	git commit -m "commit_message" file_1 file_2 ../file_3  
 
	example:
	git commit -m "updating makefile" makefile 
	git commit -m "inital checkin" 	project_area/vrf/tb/tb_top.sv

To pull updated data base:
	git pull

To push the modified files to repo:
	git push
	>enter your user name
	>enter pass token generated from git hub

Directory structure:
	your_folder
		|		
		|
		| 
		|common

		|Project_root_dir
			docs
			project_area 
				RTL
					design files
				verif
					TB
					seq
					test	
					agent
			scratch_area
				sim
					project_name.bashrc
					project_name.tl
