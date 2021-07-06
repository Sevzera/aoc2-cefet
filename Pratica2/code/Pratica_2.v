module Pratica_2 (MClock, PClock, Resetn, Run);
	input MClock, PClock, Resetn, Run;
	
	wire [15:0]Bus;
	wire Done, Run, W;
	wire [15:0] ADDRrom;
	wire [15:0] ADDR, DOUT, memoryRamOut;
	
	/* Parte 1 e 2
	upcount_5 count(Resetn, MClock, n);
	memoryROM memROM (n, MClock, memoryOut);
	*/
	
	/* Parte 3 */
	
	iFetch iF (ADDRrom, MClock, DIN);
	proc proc (DIN, memoryRamOutOut, Resetn, PClock, Run, Done, Bus, ADDR, DOUT, W, ADDRrom);
	memoryRAM memRAM (ADDR, MClock, DOUT, W, memoryRamOut);
	
endmodule
