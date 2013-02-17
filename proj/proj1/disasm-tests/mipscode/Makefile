SOURCES := sim.c processor.c load_program.c disassemble.c
HEADERS := elf.h load_program.h processor.h disassemble.h

ASM_TESTS := simple insts dt1 dt4 dt5 dt6 dt7 dt8 dt9 dt10 dt11


all: mips-sim $(addprefix mipscode/, $(ASM_TESTS))

.PHONY: disasmtest runtest dt1test dt2test dt3test

mipscode/%.o: mipscode/%.s
	mips-gcc -c -o $@ $<

mipscode/%.o: mipscode/%.c
	mips-gcc -O2 -o $@ -c $<

$(addprefix mipscode/, $(ASM_TESTS)): %: %.s mipscode/mips.ld
	mips-gcc -o $(patsubst %.s, %.o, $<) -c $<
	mips-ld -o $@ $(patsubst %.s, %.o, $<) -T mipscode/mips.ld

mips-sim: $(SOURCES) $(HEADERS)
	gcc -O2 -o $@ $(SOURCES)

disasmtest: mips-sim mipscode/insts
	./mips-sim -d mipscode/insts > insts.dump
	diff insts.dump mipscode/insts.dump

dt1test: mips-sim mipscode/dt1
	./mips-sim -d mipscode/dt1 > dt1.dump
	diff dt1.dump mipscode/dt1.dump

dt4test: mips-sim mipscode/dt4
	./mips-sim -d mipscode/dt4 > dt4.dump
	diff dt4.dump mipscode/dt4.dump

dt5test: mips-sim mipscode/dt5
	./mips-sim -d mipscode/dt5 > dt5.dump
	diff dt5.dump mipscode/dt5.dump

dt6test: mips-sim mipscode/dt6
	./mips-sim -d mipscode/dt6 > dt6.dump
	diff dt6.dump mipscode/dt6.dump

dt7test: mips-sim mipscode/dt7
	./mips-sim -d mipscode/dt7 > dt7.dump
	diff dt7.dump mipscode/dt7.dump

dt8test: mips-sim mipscode/dt8
	./mips-sim -d mipscode/dt8 > dt8.dump
	diff dt8.dump mipscode/dt8.dump

dt9test: mips-sim mipscode/dt9
	./mips-sim -d mipscode/dt9 > dt9.dump
	diff dt9.dump mipscode/dt9.dump

dt10test: mips-sim mipscode/dt10
	./mips-sim -d mipscode/dt10 > dt10.dump
	diff dt10.dump mipscode/dt10.dump

dt11test: mips-sim mipscode/dt11
	./mips-sim -d mipscode/dt11 > dt11.dump
	diff dt11.dump mipscode/dt11.dump

runtest: mips-sim mipscode/insts
	./mips-sim -r mipscode/insts > insts.trace
	@diff insts.trace mipscode/insts.trace && echo "RUN TEST PASSED!" || echo "RUN TEST FAILED!"

clean:
	rm -f mips-sim $(addprefix mipscode/, $(ASM_TESTS)) $(addsuffix .o, $(addprefix mipscode/, $(ASM_TESTS))) *.dump *.trace
