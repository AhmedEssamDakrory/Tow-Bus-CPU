add wave -position insertpoint sim:/processor/*
add wave -position insertpoint sim:/alu/*
force -freeze sim:/processor/reset 0 0
force -freeze sim:/processor/MDRin 0 0
force -freeze sim:/processor/DSTin 0 0
force -freeze sim:/processor/SRCin_a 0 0
force -freeze sim:/processor/INC_A 0 0
force -freeze sim:/processor/DEC_A U 0
force -freeze sim:/processor/ADD_AB 0 0
force -freeze sim:/processor/R0out 0 0
force -freeze sim:/processor/R1out 0 0
force -freeze sim:/processor/R2out 0 0
force -freeze sim:/processor/R3out 0 0
force -freeze sim:/processor/R4out 0 0
force -freeze sim:/processor/DEC_A 0 0
force -freeze sim:/processor/R5out 0 0
force -freeze sim:/processor/R6out 0 0
force -freeze sim:/processor/R7out 0 0
force -freeze sim:/processor/WR 0 0
force -freeze sim:/processor/Zin 0 0
force -freeze sim:/processor/IRin 0 0
force -freeze sim:/processor/MARin_B 0 0
force -freeze sim:/processor/SRCin_a_or_b 0 0
force -freeze sim:/processor/MARin_A_or_B 0 0
force -freeze sim:/processor/MDRin_or_RD 0 0
force -freeze sim:/processor/MPC 11111 0
force -freeze sim:/alu/OutFlag 16#0 0
force -freeze sim:/processor/f0 16#0 0
force -freeze sim:/processor/f1 16#0 0
force -freeze sim:/processor/f2 16#0 0
force -freeze sim:/processor/f3 16#0 0
force -freeze sim:/processor/f4 16#0 0
force -freeze sim:/processor/alu1 16#0 0
force -freeze sim:/processor/alu2 16#0 0
force -freeze sim:/processor/MicroI_data 16#0 0
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
run
noforce sim:/processor/busa
noforce sim:/processor/busb
noforce sim:/processor/clk
noforce sim:/processor/reset
noforce sim:/processor/R0
noforce sim:/processor/R1
noforce sim:/processor/R2
noforce sim:/processor/R3
noforce sim:/processor/R4
noforce sim:/processor/R5
noforce sim:/processor/R6
noforce sim:/processor/R7
noforce sim:/processor/MDR
noforce sim:/processor/MAR
noforce sim:/processor/DST
noforce sim:/processor/SRC
noforce sim:/processor/Z
noforce sim:/processor/IR
noforce sim:/processor/flags
noforce sim:/processor/bus_a_or_b1
noforce sim:/processor/bus_a_or_b2
noforce sim:/processor/F
noforce sim:/processor/address_Field_Of_IR
noforce sim:/processor/from_ram
noforce sim:/processor/bus_b_or_ram
noforce sim:/processor/MDRin
noforce sim:/processor/DSTin
noforce sim:/processor/SRCin_a
noforce sim:/processor/INC_A
noforce sim:/processor/DEC_A
noforce sim:/processor/ADD_AB
noforce sim:/processor/R0out
noforce sim:/processor/R1out
noforce sim:/processor/R2out
noforce sim:/processor/R3out
noforce sim:/processor/R4out
noforce sim:/processor/R5out
noforce sim:/processor/R6out
noforce sim:/processor/R7out
noforce sim:/processor/MDRout
noforce sim:/processor/SRCout
noforce sim:/processor/IRout
noforce sim:/processor/Zout
noforce sim:/processor/Zout1
noforce sim:/processor/MARout
noforce sim:/processor/MARin_A
noforce sim:/processor/R0in
noforce sim:/processor/R7in
noforce sim:/processor/R1in
noforce sim:/processor/R2in
noforce sim:/processor/R3in
noforce sim:/processor/R4in
noforce sim:/processor/R5in
noforce sim:/processor/R6in
noforce sim:/processor/SRCin_b
noforce sim:/processor/flag
noforce sim:/processor/RD
noforce sim:/processor/WR
noforce sim:/processor/Zin
noforce sim:/processor/IRin
noforce sim:/processor/MARin_B
noforce sim:/processor/SRCin_a_or_b
noforce sim:/processor/MARin_A_or_B
noforce sim:/processor/MDRin_or_RD
noforce sim:/processor/operation
noforce sim:/processor/f0
noforce sim:/processor/f1
noforce sim:/processor/f2
noforce sim:/processor/f3
noforce sim:/processor/which_Rin
noforce sim:/processor/which_Rout
noforce sim:/processor/f4
noforce sim:/processor/alu1
noforce sim:/processor/alu2
noforce sim:/processor/MicroI_data
noforce sim:/processor/MPC
noforce sim:/processor/tmp
noforce sim:/processor/MPC_ROM
noforce sim:/processor/con1
noforce sim:/processor/con2
noforce sim:/alu/clk
noforce sim:/alu/Operation
noforce sim:/alu/A
noforce sim:/alu/DstOut
noforce sim:/alu/OutSignal
noforce sim:/alu/F
noforce sim:/alu/UpdateFlags
noforce sim:/alu/OutFlag
noforce sim:/alu/LoadFlags
noforce sim:/alu/ClearFlags
noforce sim:/alu/result
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/reset 1 0
run