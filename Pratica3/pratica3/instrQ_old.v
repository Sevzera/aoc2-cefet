module instrQ (Clock, Clear, instrIn, instrOut, add, remove, full, empty, RS_AddSubFull, RS_MulDivFull);

	input Clock, Clear, add, remove, RS_AddSubFull, RS_MulDivFull;
	input [8:0] instrIn;
	output full, empty;
	output reg [8:0] instrOut;
	
	reg [8:0] instructions [7:0];
	reg [7:0] valid ;

	reg [8:0] auxInstr;
	wire [2:0] opCode, rd, rs;
	integer instrQ_size, i, break, stall;
	
	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	parameter MUL = 3'b010;
	parameter DIV = 3'b011;
	
	assign full = valid[0] & valid[1] & valid[2] & valid[3] & valid[4] & valid[5] & valid[6] & valid[7];
	assign empty = ~valid[0] & ~valid[1] & ~valid[2] & ~valid[3] & ~valid[4] & ~valid[5] & ~valid[6] & ~valid[7];
	
	initial begin
		instructions[0] = 9'b111111111; instructions[1] = 9'b111111111; instructions[2] = 9'b111111111; instructions[3] = 9'b111111111; 
		instructions[4] = 9'b111111111; instructions[5] = 9'b111111111; instructions[6] = 9'b111111111; instructions[7] = 9'b111111111; 
		
		valid = 8'b0;
	end	
	
	always @(posedge Clock) begin		
		instrQ_size = 8;
		break = 0;
		stall = 0;
		auxInstr[8:0] = 9'b0;				
		
		if (Clear) begin			
			valid[7:0] = 8'b0;
		end 			
		
		else begin
		
			if (add && ~full) begin // Para adicionar uma instrucao na lista, a fila nao pode estar cheia
				for (i=0 ; i<instrQ_size ; i=i+1) begin // Procura pela primeira posicao vazia
					if (break == 0) begin
						if (~valid[i]) begin // Primeira posicao vazia
							valid[i] = 1'b1;
							instructions[i] = instrIn;							
							break = 1;
							#10;
						end
					end
				end
			end
			
			if (remove && ~empty) begin // Para remover uma instrucao, a fila nao pode estar vazia										
				instrOut = instructions[0]; // Pega a primeira instrucao
				
				// Verifica qual opCode da proxima isntrucao e se sua estacao de reserva esta cheia
				if ( (opCode == MUL || opCode == DIV) && (RS_MulDivFull) ) begin
					stall = 1;
				end
				if ( (opCode == ADD || opCode == SUB) && (RS_AddSubFull) ) begin
					stall = 1;
				end
				
				
				if (stall == 0) begin // Se RS estiver com espaco (dependendo da prox instrucao), acontece o despacho
					for (i=1 ; i<instrQ_size ; i=i+1) begin // Refaz ordenacao para atualizar fila de instrucao
						if (break == 0) begin
							if (valid[i]) begin // Enquanto houver posicao valida, move ela para frente
								valid[i] = 1'b0;
								auxInstr = instructions[i];
								instructions[i-1] = auxInstr;								
								#10;
							end
							else begin
								break = 1;								
								if (i == 1) begin
									valid[0] = 1'b0;
									instructions[0] = 9'b111111111;									
								end
								else
									instructions[i] = 9'b111111111;
							end
						end
					end
				end 
				else begin // Caso ocorra stall
					instrOut[8:0] = 9'b111111111; // Valor padrao para instrucao invalida
				end
				
			end
			
		end		
		
	end // Fim always

	// Declarar modulos necessarios
	instrDecoder decoder (instrOut, opCode, rd, rs);
		
endmodule
