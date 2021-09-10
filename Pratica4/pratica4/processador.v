module processador (clock, id_processador, instr, entradaMaquina, saidaMaquina, enderecoWB, dadoWB, WB, out, read, enderecoMem, dadoMem);

	input clock;
	
	// Input e Output
	input [1:0] id_processador;
	input [8:0] instr;
	input [1:0] entradaMaquina;// representa a mensagem recebida
	input [2:0] dadoMem;
	output reg [1:0] saidaMaquina; // saidaMaquina representa a mensagem de envio aos outros processadores
	output reg WB, read;
	output reg [2:0] out, enderecoWB, dadoWB, enderecoMem;
	
	// Cache -> L1 com 1 posicao
	reg [1:0] Estado[3:0];
	reg [2:0] Tag[3:0];
	reg [2:0] Dado[3:0];
	
	// Estados
	parameter invalido = 2'b00;
	parameter modificado = 2'b01;
	parameter compartilhado = 2'b10;
	
	// Maquina de estados
		reg maquina; // Define se proc e' emissor ou receptor
		reg [1:0] m_op, m_estadoCache, m_entradaMaquina;
		wire[1:0] m_novoEstadoEmissor, m_saidaMaquina, m_novoEstadoReceptor;  
		wire writeBackEmissor, writeBackReceptor, abortAccessMemory;
		// Mensagens
		parameter invalidar = 2'b00;
		parameter msgReadMiss = 2'b01;
		parameter msgWriteMiss = 2'b10;
		parameter semMensagem = 2'b11;
		// m_operacoes	
		parameter m_opReadHit = 2'b00;
		parameter m_opReadMiss = 2'b01;
		parameter m_opWriteHit = 2'b10;
		parameter m_opWriteMiss = 2'b11;
	
	// Variaveis auxiliares
		integer i, cacheSize, breakLoop, cachePos, Hit;
		reg setarValores;
	
	initial begin
		setarValores = 1'b1;				
	end
	
	
	always @ (posedge clock) begin
		if(setarValores) begin
			if (id_processador == 2'b00) begin
				Estado[0] = 2'b00; Tag[0] = 3'b000; Dado[0] = 3'b001;
				Estado[1] = 2'b10; Tag[1] = 3'b001; Dado[1] = 3'b000;	
				Estado[2] = 2'b01; Tag[2] = 3'b010; Dado[2] = 3'b100;	
				Estado[3] = 2'b00; Tag[3] = 3'b011; Dado[3] = 3'b001;	
			end
			else if (id_processador == 2'b01) begin
				Estado[0] = 2'b00; Tag[0] = 3'b000; Dado[0] = 3'b001;
				Estado[1] = 2'b01; Tag[1] = 3'b101; Dado[1] = 3'b000;	
				Estado[2] = 2'b00; Tag[2] = 3'b010; Dado[2] = 3'b001;	
				Estado[3] = 2'b10; Tag[3] = 3'b011; Dado[3] = 3'b010;	
			end
			else if (id_processador == 2'b10) begin
				Estado[0] = 2'b10; Tag[0] = 3'b100; Dado[0] = 3'b011;
				Estado[1] = 2'b10; Tag[1] = 3'b001; Dado[1] = 3'b000;	
				Estado[2] = 2'b00; Tag[2] = 3'b010; Dado[2] = 3'b001;	
				Estado[3] = 2'b00; Tag[3] = 3'b011; Dado[3] = 3'b001;	
			end
			setarValores = 1'b0;
		end
			
		out = 3'b0;
	
		cacheSize = 4;
		breakLoop = 0;
		cachePos = 0;
		Hit = 0;	
		
		if (instr[8:7] == id_processador) begin // Processador e' emissor
			maquina = 1'b0; // Emissor
			// m_operacao de read
			if (instr[6] == 1'b0) begin
				// Realiza for para percorrer e encontrar a tag
				for (i=0; i<cacheSize; i=i+1) begin
					if (!breakLoop) begin
						// Hit (encontro da tag na cache), se nao ocorrer, bloco nao esta presente na cache
						if (Tag[i] == instr[5:3]) begin
							Hit = 1;
							cachePos = i;
							breakLoop = 1;
						end
					end
				end
				
				// Read hit e bloco nao esta invalido
				if ( Hit && (Estado[cachePos] != invalido) ) begin
					m_op = m_opReadHit;
					m_estadoCache = Estado[cachePos];
					#5;
					saidaMaquina = m_saidaMaquina;
					
					out = Dado[cachePos];
				end
				// Read miss
				else begin
				
					case(instr[5:3]) 
						3'b000: cachePos = 0;
						3'b001: cachePos = 1;
						3'b010: cachePos = 2;
						3'b011: cachePos = 3;
						3'b100: cachePos = 0;
						3'b101: cachePos = 1;
						3'b110: cachePos = 2;
					endcase
					
					m_op = m_opReadMiss;
					m_estadoCache = Estado[cachePos];
					#5;
					saidaMaquina = m_saidaMaquina;
					
					if (writeBackEmissor) begin
						WB = 1'b1;
						enderecoWB = Tag[cachePos];
						dadoWB = Dado[cachePos];
						#5 WB = 1'b0;
					end
					
					#25;
					// Chamando o valor da memoria
					read = 1'b1;
					enderecoMem = instr[5:3];
					#5 read = 1'b0;
					
					Estado[cachePos] = m_novoEstadoEmissor;
					Tag[cachePos] = instr[5:3];
					Dado[cachePos] = dadoMem;					
				end				
			end
			
			// m_operacao de write
			else begin
				// Realiza for para percorrer e encontrar a tag
				for (i=0; i<cacheSize; i=i+1) begin
					if (!breakLoop) begin
						// Hit (encontro da tag na cache), se nao ocorrer, bloco nao esta presente na cache
						if (Tag[i] == instr[5:3]) begin
							Hit = 1;
							cachePos = i;
							breakLoop = 1;
						end
					end
				end
				
				// Write hit e bloco nao esta invalido
				if ( Hit && (Estado[cachePos] != invalido) ) begin
					m_op = m_opWriteHit;
					m_estadoCache = Estado[cachePos];
					#5;
					saidaMaquina = m_saidaMaquina;
					
					Dado[cachePos] = instr[2:0];
					Estado[cachePos] = m_novoEstadoEmissor;
				end
				// Write miss 
				else begin
				
					case(instr[5:3])
						3'b000: cachePos = 0;
						3'b001: cachePos = 1;
						3'b010: cachePos = 2;
						3'b011: cachePos = 3;
						3'b100: cachePos = 0;
						3'b101: cachePos = 1;
						3'b110: cachePos = 2;
					endcase
				
					m_op = m_opWriteMiss;
					m_estadoCache = Estado[cachePos];
					#5;
					saidaMaquina = m_saidaMaquina;
					
					if (writeBackEmissor) begin
						WB = 1'b1;
						enderecoWB = Tag[cachePos];
						dadoWB = Dado[cachePos];
						#5 WB = 1'b0;
					end
					
					Estado[cachePos] = m_novoEstadoEmissor;
					Tag[cachePos] = instr[5:3];
					Dado[cachePos] = instr[2:0];									
				end
			end
		end
		
		else begin // Processador e' receptor

			// Encontramos o block que sera modificado
			for (i=0; i<cacheSize; i=i+1) begin
				if (!breakLoop) begin
					// Hit (encontro da tag na cache), se nao ocorrer, bloco nao esta presente na cache
					if (Tag[i] == instr[5:3]) begin
						Hit = 1;
						cachePos = i;
						breakLoop = 1;
					end
				end			
			end			
			
			// Se encontrar a posicao
			if (Hit) begin
				#15;
				maquina = 1'b1;
				m_estadoCache = Estado[cachePos];
				m_entradaMaquina = entradaMaquina;
				#5;
			
				// Se houver writeBackReceptor
				if (writeBackReceptor) begin
					WB = 1'b1;
					enderecoWB = Tag[cachePos];
					dadoWB = Dado[cachePos];
					#5 WB = 1'b0;
				end
			
				Estado[cachePos] = m_novoEstadoReceptor;
				
			end
			
		end
	
	end // FIM DO ALWAYS
	
	// maquinaSnooping m (maquina, m_op, m_estadoCache, m_entradaMaquina, m_novoEstado, m_saidaMaquina, writeBack, abortAccessMemory);
	maquinaEmissor  emissor  (maquina, m_op, m_estadoCache, m_novoEstadoEmissor, m_saidaMaquina, writeBackEmissor);
	maquinaReceptor receptor (maquina, m_estadoCache, m_entradaMaquina, m_novoEstadoReceptor, writeBackReceptor, abortAccessMemory);

endmodule

