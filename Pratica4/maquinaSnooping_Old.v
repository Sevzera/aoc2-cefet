module maquinaSnooping (maquina, op, estadoAtual, entradaMaquina, novoEstado, saidaMaquina, writeBack, abortAccessMemory);

	input maquina;
	input [1:0]op;
	input [1:0]estadoAtual;
	input [1:0]entradaMaquina;
	output reg [1:0] novoEstado;
	output reg [1:0] saidaMaquina;
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
	parameter opReadHit = 2'b00;
	parameter opReadMiss = 2'b01;
	parameter opWriteHit = 2'b10;
	parameter opWriteMiss = 2'b11;
	
	// Sempre que ocorrer uma operacao ou entrada no barramento
	always @ (op, entradaMaquina) begin
	
		// Configuracoes para casos onde nao ocorre mudanca
		novoEstado = estadoAtual;
		saidaMaquina = semMensagem;
		writeBack = 1'b0;
		abortAccessMemory = 1'b0;
		
		// Se for a maquina atuante
		if(maquina == atua) begin
			// e seu estado no momento for
			case(estadoAtual)
				// INVALIDO
				invalido: begin
					// Analisa a operacao e atribui os valores adequados
					case(op)
						opReadHit: begin
						end
						opReadMiss: begin
							novoEstado = compartilhado;
							saidaMaquina = msgReadMiss;
						end						
						opWriteHit: begin
						end		
						opWriteMiss: begin
							novoEstado = modificado;
							saidaMaquina = msgWriteMiss;
						end						
					endcase
				end
				// MODIFICADO
				modificado: begin
					case(op)
						// Analisa a operacao e atribui os valores adequados
						opReadHit: begin
						end
						opReadMiss: begin
							novoEstado = compartilhado;
							saidaMaquina = msgReadMiss;
							writeBack = 1'b1;
						end						
						opWriteHit: begin
						end		
						opWriteMiss: begin
							saidaMaquina = msgWriteMiss;
							writeBack = 1'b1;
						end	
					endcase
				end
				// COMPARTILHADO
				compartilhado: begin
					case(op)
						// Analisa a operacao e atribui os valores adequados
						opReadHit: begin
						end
						opReadMiss: begin
							saidaMaquina = msgReadMiss;
						end						
						opWriteHit: begin
							novoEstado = modificado;
							saidaMaquina = invalidar;
						end		
						opWriteMiss: begin
							novoEstado = modificado;
							saidaMaquina = msgWriteMiss;						
						end
					endcase
				end
			endcase
		end
		
		// Se for a maquina ouvinte		
		else if(maquina == reage) begin
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
							novoEstado = compartilhado;
							writeBack = 1'b1;
							abortAccessMemory = 1'b1;
						end
						msgWriteMiss: begin
							novoEstado = invalido;
							writeBack = 1'b1;
							abortAccessMemory = 1'b1;
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
