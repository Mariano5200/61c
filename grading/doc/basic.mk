basic : code.scm 
	-stk -no-tk -file ~cs61a/grading/testing/mk/basic/basic.scm > /dev/null
	if diff output /home/ff/cs61a/grading/testing/mk/basic/basic.ref;\
	then \
	exit 0;\
	else \
	exit 1; \
	fi 

OK :
	@echo "It worked!!!"
	@echo " "
	@echo "Your submission was sucsesfully loaded and passed our sanity check."
	@echo "Your reader will examin your project soon and will email comments to you."

NOT-OK : 
	@echo "SUBMISSION FAILED!"
	@echo " "
	@echo "Your submission did not load, or did not pass one of our sanity checks."
	@echo " "
	@echo "Please try the following:"
	@echo " "
	@echo " * Make sure that your code.scm file loads sucessfully from a fresh launch of STk."
	@echo " * Make sure that all of your soultions can be run from this fresh load."
	@echo " * Test your solutions to make sure that they work for many different types of input. Think about typical cases as well as boundry cases."













