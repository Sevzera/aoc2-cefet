module maquinaReceptor (maquina, estadoAtual, entradaMaquina, novoEstado, writeBack, abortAccessMemory);

	input maquina;
	input [1:0]estadoAtual;
	input [1:0]entradaMaquina;
	output reg [1:0] novoEstado;
	output reg writeBack, abortAccessMemory;
	
   // Maquina
	parameter atua = 1'b0;
	parameter reage = 1'b1;
	
	// Estados
	parameter invalido = 2'b00;
	parameter modificado = 2'b01;
	parameter compartilhado = 2'b10;
	
	// Mensagens
	parameter invalidar = 2'b00;
	parameter msgReadMiss = 2'b01;
	parameter msgWriteMiss = 2'b10;
	parameter semMensagem = 2'b11;
	
	// Operacoes	
	parameter opReadHit = 2'b000;
	parameter opReadMiss = 2'b001;
	parameter opWriteHit = 2'b010;
	parameter opWriteMiss = 2'b011;
	
	initial begin
		writeBack = 1'b0;
	end
	
	always @ (entradaMaquina) begin
	
		novoEstado = estadoAtual;
		writeBack = 1'b0;
	
		// Se for a maquina ouvinte		
		if(maquina == reage) begin
			// e seu estado no momento for
			case(estadoAtual)
				// INVALIDO
				invalido: begin
				// Nada acontece, seguem os valores atribuidos no inicio do bloco
				end
				// MODIFICADO
				modificado: begin
					// Analisa a mensagem e atribui os valores adequados
					case(entradaMaquina)
						invalidar: begin
						end
						msgReadMiss: begin							
							writeBack = 1'b1;
							abortAccessMemory = 1'b1;
							novoEstado = compartilhado;
							#20 writeBack = 1'b0; abortAccessMemory = 1'b0;
						end
						msgWriteMiss: begin							
							writeBack = 1'b1;
							abortAccessMemory = 1'b1;
							novoEstado = invalido;
							#20 writeBack = 1'b0; abortAccessMemory = 1'b0;
						end
					endcase
				end
				// COMPARTILHADO
				compartilhado: begin
					// Analisa a mensagem e atribui os valores adequados
					case(entradaMaquina)
						invalidar: begin
							novoEstado = invalido;
						end
						msgReadMiss: begin
						end
						msgWriteMiss: begin
							novoEstado = invalido;
						end
					endcase
				end
			endcase
		end

	end // Fim do always
	
endmodule
