module instrQ (Clock, Clear);

	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	parameter MUL = 3'b010;
	parameter DIV = 3'b011;
		
	input Clock, Clear;
	
	wire [5:0] PC;
	reg stall, pcIn;
	reg MClock, PClock;	
	
	wire [2:0] opCode, rd, rs;
	wire [8:0] instr;
	wire [8:0] Bus;
	wire RS_addSubFull,RS_mulDivFull;
	

	reg incr_pc;
	
	always @(posedge Clock) begin // Controla o despacho
		stall = 0;
		if ( (RS_addSubFull) && (opCode == ADD || opCode == SUB)) begin // Caso a RS de add/sub esteja cheia, nao despacha (se I for add/sub)
			stall = 1'b1;
		end
		if ( (RS_mulDivFull) && (opCode == MUL || opCode == DIV)) begin // Caso a RS de mul/div esteja cheia, nao despacha (se I for mul/div)
			stall = 1'b1;
		end
		
		if (stall == 0) begin // Se ocorrer despacho, busca instrucao da rom e aumenta pc
			MClock = 1;			
			#10 MClock = 0;		
			incr_pc = 1; PClock = 1;
			#10 incr_pc = 0; PClock = 0;
		end		
		
	end // Fim always
	
	// Instanciando modulos
	lpmcounter count (1'b1, PClock, incr_pc, Bus[5:0], Clear, pcIn, PC);
	lpmrom instrMem (PC, MClock, instr);
	instrDecoder decoder (instr, opCode, rd, rs);
	reserveStation rStation (Clock, instr, RS_addSubFull, Rs_mulDivFull);

endmodule
