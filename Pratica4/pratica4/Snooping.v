module Snooping (clock);

	input clock;
	// Instrucao: [2] Processador -> [1] Op -> [3] Tag -> [3] Dado
	// Processador: P1 -> 00, P2 -> 01, P3 -> 10
	
	// Processadores
	reg  [8:0] instr;
	wire  [8:0] instr_in;
	wire [2:0] outp1, outp2, outp3;
	
	// Memoria
	wire [2:0] enderecoWB, dadoWB;
	wire WB;
	
	// Barramento
	wire [1:0] saidaP1, saidaP2, saidaP3;
	wire [1:0] saidaBarramento;
	
	processador p1 (clock, 2'b00, instr_in, saidaBarramento, saidaP1, enderecoWB, dadoWB, WB, outp1);
	processador p2 (clock, 2'b01, instr_in, saidaBarramento, saidaP2, enderecoWB, dadoWB, WB, outp2);
	processador p3 (clock, 2'b10, instr_in, saidaBarramento, saidaP3, enderecoWB, dadoWB, WB, outp3);
	bus barramento (instr, saidaP1, saidaP2, saidaP3, saidaBarramento);
	mem memoria (instr, enderecoWB, dadoWB, WB, instr_in);
	
	

endmodule
