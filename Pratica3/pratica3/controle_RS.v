module controle_RS (Clock);

	input Clock;
	
	// Operacoes:
		parameter ADD = 3'b000;
		parameter SUB = 3'b001;
		parameter MUL = 3'b010;
		parameter DIV = 3'b011;
		
	// Variaveis da fila de instrucoes
		wire [11:0] instruction;
		wire [2:0] Op, Rd, Rx, Ry;
		assign Op = instruction [11:9];
		assign Rd = instruction [8:6];
		assign Rx = instruction [5:3];
		assign Ry = instruction [2:0];
	
	// Variaveis das estacoes de reserva
		reg [1:0] ID [3:0]; // Label das RS
		reg [8:0] Time [3:0]; // marca o tempo de entrada da operacao
		reg [11:0] Instrucao [3:0]; // Op - [11:9], Rd - [8:6], Rx - [5:3], Ry - [2:0]
		reg [2:0] RegDestino [3:0];	// Qual registrador o valor da operacao vai
		reg [2:0] OpCode [3:0];			// Marca qual operacao sera executada
		reg [2:0] Vi [3:0], Vj [3:0];	// Registrador que tera o valor "puxado"
		reg [1:0] Qi [3:0], Qj [3:0]; // Tag (ID) da operacao que esta salvando no RegDestino
		reg Busy [3:0], Exec [3:0];
		reg Rs_AddSub_Full, Rs_MulDiv_Full;
		
	// Variaveis registradores
		reg DataControl[5:0];
		reg LabelControl[5:0];
		reg [11:0] InputData;
		reg [1:0]  InputLabel;
		wire [11:0] RegData [5:0];
		wire [1:0]  RegLabel [5:0];
		
	//Variaveis FU AddSub
		reg Run_AddSub;
		reg [1:0] Label_AddSub;
		reg [2:0]  Op_AddSub;
		reg [11:0] Rx_Valor_AddSub, Ry_Valor_AddSub;
		wire Done_AddSub;
		wire [11:0] Result_AddSub;		
		wire [1:0] Label_AddSub_out;
		
	// Variaveis FU MulDiv	
		reg Run_MulDiv;
		reg [1:0] Label_MulDiv;
		reg [2:0]  Op_MulDiv;		
		reg [11:0] Rx_Valor_MulDiv, Ry_Valor_MulDiv;
		wire Done_MulDiv;
		wire [11:0] Result_MulDiv;		
		wire [1:0] Label_MulDiv_out;
		
	// Variaveis CDB Arbiter
		reg  [1:0]  CDB_Control;
		wire [11:0] CDB;
		
	// Variaveis auxiliares
		integer breakLoop, i, j;
		integer Rs_AddSub, Rs_MulDiv;
		reg start;
		reg [8:0] OldTime; integer PosOldInstrucao; // Busca do tempo mais antigo e salva a posicao da RS
		reg [8:0] TimeGlobal;
		
		
	initial begin
	
		ID[0] = 2'b00; ID[1] = 2'b01; ID[2] = 2'b10; ID[3] = 2'b11;
		TimeGlobal = 9'b0; OldTime = 9'b111111111; PosOldInstrucao = 50;
		Rs_AddSub = 0; Rs_MulDiv = 0;
		Rs_AddSub_Full = 1'b0; Rs_MulDiv_Full = 1'b0;
		
		for(i=0;i<4;i=i+1) begin
			Busy[i]=1'b0; 
			Exec[i]=1'b0; 
			RegDestino[i]=3'b111;
			OpCode[i]=3'b111;			
			Vi[i]=3'b111; 
			Vj[i]=3'b111; 
			Qi[i]=2'b11; 
			Qj[i]=2'b11;			 
			Instrucao[i]=12'b111111111111;
		end
		
		Run_AddSub = 0; Run_MulDiv = 0;
		
		

		DataControl[0] = 1; DataControl[1] = 1; DataControl[2] = 1; DataControl[3] = 0; DataControl[4] = 0; DataControl[5] = 1;
		InputData = 1; start = 1; 		
		#5 DataControl[0] = 0; DataControl[1] = 0; DataControl[2] = 0; DataControl[3] = 0; DataControl[4] = 1; DataControl[5] = 0; 
		InputData = 0; start = 0;
		#5 DataControl[0] = 0; DataControl[1] = 0; DataControl[2] = 0; DataControl[3] = 1; DataControl[4] = 0; DataControl[5] = 0;  
		InputData = 2; start = 1;
		
	end
	
	
	always@(posedge Clock) begin
		
		//Resetando variaveis essenciais
			for (i=0;i<6;i=i+1) begin
				DataControl[i] = 0; 
				LabelControl[i] = 0;
			end
			
			OldTime = 9'b111111111; PosOldInstrucao = 50;
			breakLoop = 0;
			CDB_Control = 0;
		
		// Estacoes de reserva:
			if ((!Rs_AddSub_Full) && (Op == ADD || Op == SUB)) begin
				for (i=0;i<2;i=i+1) begin
					if(!breakLoop) begin
						if(Busy[i] == 0) begin							
							Time[i] = TimeGlobal;
							Instrucao[i] = instruction;
							Busy[i] = 1;
							OpCode[i] = Op;
							RegDestino[i] = Rd;				
							if (RegLabel[Rx] == 2'b11) begin // Se nao houver outra operacao salvando no reg
								Vi[i] = Rx;
								Qi[i] = 2'b11;
							end 
							else begin // Se houver, coloca a dependencia
								Vi[i] = 3'b111;
								Qi[i] = RegLabel[Rx];
							end
							if (RegLabel[Ry] == 2'b11) begin // Se nao houver outra operacao salvando no reg
								Vj[i] = Ry;
								Qj[i] = 2'b11;
							end 
							else begin // Se houver, coloca a dependencia
								Vj[i] = 3'b111;
								Qj[i] = RegLabel[Ry];
							end
							// Salvar a dependencia no registrador destino
							InputLabel = i;
							LabelControl[Rd] = 1'b1;
							Rs_AddSub = Rs_AddSub + 1;
							breakLoop = 1;
						end
					end
				end
				breakLoop = 0;
			end
			
			else if ((!Rs_MulDiv_Full) && (Op == MUL || Op == DIV)) begin
				for (i=2;i<4;i=i+1) begin
					if(!breakLoop) begin
						if(Busy[i] == 0) begin
							Time[i] = TimeGlobal;
							Instrucao[i] = instruction;
							Busy[i] = 1;
							OpCode[i] = Op;
							RegDestino[i] = Rd;
							if (RegLabel[Rx] == 2'b11) begin // Se nao houver outra operacao salvando no reg
								Vi[i] = Rx;
								Qi[i] = 2'b11;
							end else begin // Se houver, coloca a dependencia
								Vi[i] = 3'b111;
								Qi[i] = RegLabel[Rx];
							end
							if (RegLabel[Ry] == 2'b11) begin // Se nao houver outra operacao salvando no reg
								Vj[i] = Ry;
								Qj[i] = 2'b11;
							end else begin // Se houver, coloca a dependencia
								Vj[i] = 2'b111;
								Qj[i] = RegLabel[Ry];
							end
							// Salvar a dependencia no registrador destino
							InputLabel = ID[i];
							LabelControl[Rd] = 1'b1;
							Rs_MulDiv = Rs_MulDiv + 1;
							breakLoop = 1;
						end
					end
				end
				breakLoop = 0;
			end		
	
		
	// Procura a proxima instruca a ser executada no FU AddSub
			if ((!Done_AddSub) && (!Run_AddSub) && (Rs_AddSub > 0)) begin				
				// Busca pelo tempo mais antigo sendo este o menor valor
				for (i=0;i<2;i=i+1) begin
					if ((Time[i] < OldTime)) begin
						OldTime = Time[i];
						if ((Vi[i]!=3'b111) && (Vj[i]!=3'b111)) 
							PosOldInstrucao = i;
					end
				end
				
				// Preparar para execucao
					if (PosOldInstrucao != 50) begin
						Exec[PosOldInstrucao] = 1;
						Run_AddSub = 1;
						Op_AddSub = OpCode[PosOldInstrucao];
						Rx_Valor_AddSub = RegData[Vi[PosOldInstrucao]];
						Ry_Valor_AddSub = RegData[Vj[PosOldInstrucao]];
						Label_AddSub = ID[PosOldInstrucao];
					end
				
				OldTime = 9'b111111111;
				PosOldInstrucao = 50;
			end
			
		// Procura a proxima instruca a ser executada no FU MulDiv
			if ((!Done_MulDiv) && (!Run_MulDiv) && (Rs_MulDiv > 0)) begin
				// Busca pelo tempo mais antigo sendo este o menor valor
				for (i=2;i<4;i=i+1) begin
					if ((Time[i] < OldTime)) begin
						OldTime = Time[i];
						if ((Vi[i]!=3'b111) && (Vj[i]!=3'b111)) 
							PosOldInstrucao = i;
					end
				end
				
				// Preparar para execucao
					if (PosOldInstrucao != 50) begin
						Exec[PosOldInstrucao] = 1;
						Run_MulDiv = 1;
						Op_MulDiv = OpCode[PosOldInstrucao];
						Rx_Valor_MulDiv = RegData[Vi[PosOldInstrucao]];
						Ry_Valor_MulDiv = RegData[Vj[PosOldInstrucao]];
						Label_MulDiv = ID[PosOldInstrucao];
					end				
				
				OldTime = 9'b111111111;
				PosOldInstrucao = 50;
			end
		
		
		// Verifica fim da execucao da operacao e se tiver terminado arruma dependencias e valores a partir do CDB
			if (Done_AddSub || Done_MulDiv) begin
				// Caso as duas execucoes acabe ao mesmo tempo
				if (Done_AddSub && Done_MulDiv) begin
					if(Time[Label_AddSub_out] > Time[Label_MulDiv_out]) begin
						Run_AddSub = 0;
						CDB_Control = 2'b01;
						#5 InputData = CDB;
						DataControl[RegDestino[Label_AddSub_out]] = 1;						
									
						if (RegLabel[RegDestino[Label_AddSub_out]] == Label_AddSub_out) begin			
							LabelControl[RegDestino[Label_AddSub_out]] = 1;
							InputLabel = 2'b11;
											
							for (i=0; i<4; i=i+1) begin
								if(Qi[i] == Label_AddSub_out) begin
									Vi[i] = RegDestino[Label_AddSub_out];
									Qi[i] = 2'b11;
								end
								if(Qj[i] == Label_AddSub_out) begin
									Vj[i] = RegDestino[Label_AddSub_out];
									Qj[i] = 2'b11;
								end
							end					

						end
						
						if(Rs_AddSub > 0) Rs_AddSub = Rs_AddSub - 1;

						Time[Label_AddSub_out] = TimeGlobal;
						Busy[Label_AddSub_out]=1'b0; 
						Exec[Label_AddSub_out]=1'b0; 
						RegDestino[Label_AddSub_out]=3'b111;
						OpCode[Label_AddSub_out]=3'b111;			
						Vi[Label_AddSub_out]=3'b111; 
						Vj[Label_AddSub_out]=3'b111; 
						Qi[Label_AddSub_out]=2'b11; 
						Qj[Label_AddSub_out]=2'b11;			 
						Instrucao[Label_AddSub_out]=12'b111111111111;
					end
					else begin						
						Run_MulDiv = 0;						
						CDB_Control = 2'b10;
						#5 InputData = CDB;
						DataControl[RegDestino[Label_MulDiv_out]] = 1;
								
						if (RegLabel[RegDestino[Label_MulDiv_out]] == Label_MulDiv_out) begin						
							LabelControl[RegDestino[Label_MulDiv_out]] = 1;
							InputLabel = 2'b11;
													
							for (i=0; i<4; i=i+1) begin
								if(Qi[i] == Label_MulDiv_out) begin
									Vi[i] = RegDestino[Label_MulDiv_out];
									Qi[i] = 2'b11;
								end
								if(Qj[i] == Label_MulDiv_out) begin
									Vj[i] = RegDestino[Label_MulDiv_out];
									Qj[i] = 2'b11;
								end
							end
						
						end	

						if(Rs_MulDiv > 0) Rs_MulDiv = Rs_MulDiv - 1;

						Time[Label_MulDiv_out] = TimeGlobal;
						Busy[Label_MulDiv_out]=1'b0; 
						Exec[Label_MulDiv_out]=1'b0; 
						RegDestino[Label_MulDiv_out]=3'b111;
						OpCode[Label_MulDiv_out]=3'b111;			
						Vi[Label_MulDiv_out]=3'b111; 
						Vj[Label_MulDiv_out]=3'b111; 
						Qi[Label_MulDiv_out]=2'b11; 
						Qj[Label_MulDiv_out]=2'b11;			 
						Instrucao[Label_MulDiv_out]=12'b111111111111;
					end
					
				end
			
				// Fim da operacao FU AddSub
				if (Done_AddSub) begin
					Run_AddSub = 0;					
					CDB_Control = 2'b01;
					#5 InputData = CDB;
					DataControl[RegDestino[Label_AddSub_out]] = 1;						
											
					if (RegLabel[RegDestino[Label_AddSub_out]] == Label_AddSub_out) begin								
						LabelControl[RegDestino[Label_AddSub_out]] = 1;
						InputLabel = 2'b11;
											
						for (i=0; i<4; i=i+1) begin
							if(Qi[i] == Label_AddSub_out) begin
								Vi[i] = RegDestino[Label_AddSub_out];
								Qi[i] = 2'b11;
							end
							if(Qj[i] == Label_AddSub_out) begin
								Vj[i] = RegDestino[Label_AddSub_out];
								Qj[i] = 2'b11;
							end
						end
					
					end
					
					if(Rs_AddSub > 0) Rs_AddSub = Rs_AddSub - 1;

					Time[Label_AddSub_out] = TimeGlobal;
					Busy[Label_AddSub_out]=1'b0; 
					Exec[Label_AddSub_out]=1'b0; 
					RegDestino[Label_AddSub_out]=3'b111;
					OpCode[Label_AddSub_out]=3'b111;			
					Vi[Label_AddSub_out]=3'b111; 
					Vj[Label_AddSub_out]=3'b111; 
					Qi[Label_AddSub_out]=2'b11; 
					Qj[Label_AddSub_out]=2'b11;			 
					Instrucao[Label_AddSub_out]=12'b111111111111;
					
				end
				
				// Fim da operacao FU MulDiv
				if (Done_MulDiv) begin
					Run_MulDiv = 0;					
					CDB_Control = 2'b10;
					#5 InputData = CDB;
					DataControl[RegDestino[Label_MulDiv_out]] = 1;
											
					if (RegLabel[RegDestino[Label_MulDiv_out]] == Label_MulDiv_out) begin						
						LabelControl[RegDestino[Label_MulDiv_out]] = 1;
						InputLabel = 2'b11;
					
						for (i=0; i<4; i=i+1) begin
							if(Qi[i] == Label_MulDiv_out) begin
								Vi[i] = RegDestino[Label_MulDiv_out];
								Qi[i] = 2'b11;
							end
							if(Qj[i] == Label_MulDiv_out) begin
								Vj[i] = RegDestino[Label_MulDiv_out];
								Qj[i] = 2'b11;
							end
						end
		
					end
					
					if(Rs_MulDiv > 0) Rs_MulDiv = Rs_MulDiv - 1;
					
					Time[Label_MulDiv_out] = TimeGlobal;
					Busy[Label_MulDiv_out]=1'b0; 
					Exec[Label_MulDiv_out]=1'b0; 
					RegDestino[Label_MulDiv_out]=3'b111;
					OpCode[Label_MulDiv_out]=3'b111;			
					Vi[Label_MulDiv_out]=3'b111; 
					Vj[Label_MulDiv_out]=3'b111; 
					Qi[Label_MulDiv_out]=2'b11; 
					Qj[Label_MulDiv_out]=2'b11;			 
					Instrucao[Label_MulDiv_out]=12'b111111111111;
					
				end
				
			end
		
		
		if (Rs_AddSub == 2) Rs_AddSub_Full = 1'b1;
			else Rs_AddSub_Full = 1'b0;
		if (Rs_MulDiv == 2) Rs_MulDiv_Full = 1'b1;
			else Rs_MulDiv_Full = 1'b0;
				
		TimeGlobal = TimeGlobal + 1;
		
	end // -- Fim do Always --

	// Instaciar modulos
		// Fila de instrucoes
			instrQ iq (Clock, Rs_AddSub_Full, Rs_MulDiv_Full, instruction); 
		// Registradores
			registrador r1 (Clock, InputData, DataControl[0], InputLabel, LabelControl[0], RegLabel[0], RegData[0], start); 
			registrador r2 (Clock, InputData, DataControl[1], InputLabel, LabelControl[1], RegLabel[1], RegData[1], start); 
			registrador r3 (Clock, InputData, DataControl[2], InputLabel, LabelControl[2], RegLabel[2], RegData[2], start); 
			registrador r4 (Clock, InputData, DataControl[3], InputLabel, LabelControl[3], RegLabel[3], RegData[3], start); 
			registrador r5 (Clock, InputData, DataControl[4], InputLabel, LabelControl[4], RegLabel[4], RegData[4], start); 
			registrador r6 (Clock, InputData, DataControl[5], InputLabel, LabelControl[5], RegLabel[5], RegData[5], start); 
		// FU AddSub
			FU_AddSub addsub (Clock, Run_AddSub, Rx_Valor_AddSub, Ry_Valor_AddSub, Op_AddSub, Result_AddSub, Done_AddSub, Label_AddSub, Label_AddSub_out);			
		// FU MulDiv
			FU_MulDiv muldiv (Clock, Run_MulDiv, Rx_Valor_MulDiv, Ry_Valor_MulDiv, Op_MulDiv, Result_MulDiv, Done_MulDiv, Label_MulDiv, Label_MulDiv_out);		
		// CDB Arbiter
			CDB_Arbiter cbdArbiter (Result_AddSub, Result_MulDiv, CDB, CDB_Control);
	
endmodule
