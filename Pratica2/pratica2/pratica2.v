module pratica2 (MClock, PClock, Resetn, Run);
	
	input MClock, PClock, Resetn, Run;
	
	
	wire [15:0] DIN, BusWires;
	wire [5:0] addrCount;
	wire Resetn, Run, Done;
	
	wire [5:0] addrM;
	wire [15:0] addr, dout;
	wire w;
	wire [15:0] memOut;
	
	assign addrM = addr[4:0];
	
	ifetch ifetch (addrCount, MClock, DIN);
	ramlpm memory (addrM, MClock, dout, w, memOut);
	proc proc (DIN, memOut, Resetn, PClock, Run, Done, BusWires, addrCount, addr, dout, w);
	
	
endmodule