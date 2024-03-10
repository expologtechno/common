Steps to execute: 
	1. Copy the files from common repo to your project sim area
	2. Edits the path in PROJECT.bashrc if required 
		you can check if the variables are set properly or not by using following command
		echo $PROJ_ROOT   <--- this will print the variable value
	3. Edit the DUT_FILE name in make file for your project

Guidelines to be followed: 
	1. TB TOP file module name should be tb_top and file name can be tb_top.sv
	2. Everyone should follow the Directory stucture - other wise makefile will not work (you may need to update again)
	3. Test result should be printed propery using UVM_INFO
		pass pattern : !!! TEST PASSED !!!
		fail pattern : !!! TEST FAILED !!! 
	4. all the directory names should be in lower case
		proper names: 	project_area/  scratch_area/
		improper names:	Project_Area/  Scractch_area/  
	5. Don't Push the simulation logs and regression logs to git repository 
		

project_regress.tl file format:
test_name 	interation_no		+plusargs +defines

To run the regression:
	chmod +x project_regress.tl   (<--- only first time)
	./regress.csh project_regress.tl

To run single test:
	make run TEST_NAME="your_test_name" SIM_OPTS="your_plusargs_or_defines"

To Open the waves:
	make waves

To clean sim area : (delete indivisual logs and other vsim files)
	make clean

To clean regression folders:
	make clean_regress


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


 

