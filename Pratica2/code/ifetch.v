module ifetch(addr, MClock, DIN);

	input [5:0] addr;
	input MClock;
	output [15:0] DIN;
	
	wire [5:0] memOut;
		
	romlpm addrs (addr, MClock, memOut);  	// Gera uma pagina virtual, tera que passar uma TLB	
	tlb tableTLB (memOut, MClock, DIN);	// Endereco pagina fisica = tlbOut
	
endmodule



