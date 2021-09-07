module Snooping (clock);

	input clock;
	// Instrucao: [2] Processador -> [1] Op -> [3] Tag -> [3] Dado
	// Processador: P1 -> 00, P2 -> 01, P3 -> 10
	
	// Processadores
	reg  [8:0] instr;
	wire  [8:0] instr_in;
	wire [2:0] outp1, outp2, outp3;
	
	// Writeback
	wire [2:0] e1, d1, e2, d2, e3, d3, e_WB, d_WB;
	wire wb1, wb2, wb3, WB;
	
	// Read
	wire [2:0] em1, em2, em3, enderecoMem, dadoMem;
	wire read1, read2, read3, read;
	
	// Barramento
	wire [1:0] saidaP1, saidaP2, saidaP3;
	wire [1:0] saidaBarramento;
	
	processador p1 (clock, 2'b00, instr, saidaBarramento, saidaP1, e1, d1, wb1, outp1, read1, em1, dadoMem);
	processador p2 (clock, 2'b01, instr, saidaBarramento, saidaP2, e2, d2, wb2, outp2, read2, em2, dadoMem);
	processador p3 (clock, 2'b10, instr, saidaBarramento, saidaP3, e3, d3, wb3, outp3, read3, em3, dadoMem);
	bus barramento (instr, saidaP1, saidaP2, saidaP3, saidaBarramento);
	mux_wb wb (e1, d1, e2, d2, e3, d3, wb1, wb2, wb3, e_WB, d_WB, WB);
	mux_read readm (em1, em2, em3, read1, read2, read3, enderecoMem, read);
	mem memoria (enderecoMem, read, e_WB, d_WB, WB, dadoMem);
	
	
	

endmodule
