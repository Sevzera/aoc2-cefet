	module processador (clock, id_processador, instr, entradaMaquina, saidaMaquina, enderecoWB, dadoWB, WB, out);

	input clock;
	
	// Input e Output
	input [1:0] id_processador;
	input [8:0] instr;
	input [1:0] entradaMaquina;
	output [1:0] saidaMaquina;
	output reg WB;
	output reg [2:0] out, enderecoWB, dadoWB;
	
	// Cache -> L1 com 1 posicao
	reg [1:0] Estado[1:0];
	reg [2:0] Tag[1:0];
	reg [2:0] Dado[1:0];
	
	// Estados
	parameter invalido = 2'b00;
	parameter modificado = 2'b01;
	parameter compartilhado = 2'b10;
	
	// Maquina de estados
		reg maquina; // Define se proc e' emissor ou receptor
		reg [1:0] m_op, m_estadoCache, m_entradaMaquina; // Sinais de envio emissor
		wire[1:0] m_novoEstado, m_saidaMaquina;  // m_saidaMaquina representa a mensagem de envio aos outros processadores
		wire writeBack, abortAccessMemory;
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
		integer i, cacheSize, breakLom_op, cachePos, Hit;
	
	assign saidaMaquina = m_saidaMaquina;
	
	initial begin
		Estado[0] = 2'b00; Tag[0] = 3'b111; Dado[0] = 3'b111;
		Estado[1] = 2'b00; Tag[1] = 3'b111; Dado[1] = 3'b111;		
	end
	
	
	always @ (posedge clock) begin
		out = 3'b0;
	
		cacheSize = 2;
		breakLom_op = 0;
		cachePos = 0;
		Hit = 0;	
		
		if (instr[8:7] == id_processador) begin // Processador e' emissor
			maquina = 0; // Emissor
			// m_operacao de read
			if (instr[6] == 0) begin
				// Realiza for para percorrer e encontrar a tag
				for (i=0; i<cacheSize; i=i+1) begin
					if (!breakLom_op) begin
						// Hit (encontro da tag na cache), se nao ocorrer, bloco nao esta presente na cache
						if (Tag[i] == instr[5:3]) begin
							Hit = 1;
							cachePos = i;
							breakLom_op = 1;
						end
					end
				end
				
				// Read hit e bloco nao esta invalido
				if ( Hit && (Estado[cachePos] != invalido) ) begin
					m_op = m_opReadHit;
					m_estadoCache = Estado[cachePos];
					#10;
					out = Dado[cachePos];
				end
				// Read miss
				else begin
					m_op = m_opReadMiss;
					m_estadoCache = Estado[cachePos];
					#10;
					
					if (writeBack) begin
						WB = writeBack;
						enderecoWB = Tag[cachePos];
						dadoWB = Dado[cachePos];
						#10 WB = 1'b0;
					end
					
					Tag[cachePos] = instr[5:3];
					Dado[cachePos] = instr[2:0];
					Estado[cachePos] = m_novoEstado;
				end				
			end
			
			// m_operacao de write
			else begin
				// Realiza for para percorrer e encontrar a tag
				for (i=0; i<cacheSize; i=i+1) begin
					if (!breakLom_op) begin
						// Hit (encontro da tag na cache), se nao ocorrer, bloco nao esta presente na cache
						if (Tag[i] == instr[5:3]) begin
							Hit = 1;
							cachePos = i;
							breakLom_op = 1;
						end
					end
				end
				
				// Write hit e bloco nao esta invalido
				if ( Hit && (Estado[cachePos] != invalido) ) begin
					m_op = m_opWriteHit;
					m_estadoCache = Estado[cachePos];
					#10;
					Dado[cachePos] = instr[2:0];
					Estado[cachePos] = m_novoEstado;
				end
				// Write miss 
				else begin
					m_op = m_opWriteMiss;
					m_estadoCache = Estado[cachePos];
					#10;
					
					if (writeBack) begin
						WB = writeBack;
						enderecoWB = Tag[cachePos];
						dadoWB = Dado[cachePos];
						#10 WB = 1'b0;
					end
					
					Tag[cachePos] = instr[5:3];
					Dado[cachePos] = instr[2:0];
					Estado[cachePos] = m_novoEstado;									
				end
			end
		end
		
		else begin // Processador e' receptor
			maquina = 1;
			m_entradaMaquina = entradaMaquina;
			#10;
			
			// Encontramos o block que sera modificado
			for (i=0; i<cacheSize; i=i+1) begin
				if (!breakLom_op) begin
					// Hit (encontro da tag na cache), se nao ocorrer, bloco nao esta presente na cache
					if (Tag[i] == instr[5:3]) begin
						Hit = 1;
						cachePos = i;
						breakLom_op = 1;
					end
				end			
			end
			
			// Se encontrar a posicao
			if  (Hit) begin
				// Se houver writeback
				if (writeBack) begin
					WB = writeBack;
					enderecoWB = Tag[cachePos];
					dadoWB = Dado[cachePos];
					#10 WB = 1'b0;
				end
			
				Estado[cachePos] = m_novoEstado;
				
			end
			
		end
	
	end // FIM DO ALWAYS
	
	maquinaSnooping m (maquina, m_op, m_estadoCache, m_entradaMaquina, m_novoEstado, m_saidaMaquina, writeBack, abortAccessMemory);

endmodule

