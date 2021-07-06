module iFetch (addr, MClock, DIN);

	input [4:0] addr;
	input MClock;
	output [15:0] DIN;
	
	wire [15:0] memOut;
	
	memoryROM (addr, MClock, memOut); // Gera uma pagina virtual, tera que passar uma TLB
	tlb tlb (memOut, DIN);

endmodule
