module reserveStation (Clock, instrIn, RS_addSubFull, RS_mulDivFull);

	// Operacoes
	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	parameter MUL = 3'b010;
	parameter DIV = 3'b011;

	// Input e output
	input Clock;
	input [8:0] instrIn;
	output RS_addSubFull, RS_mulDivFull;
	
	// output de modulos
	wire [2:0] opCode, rd, rs; // Instruction decoder
	
	// RS status	
	reg  [4:0] regIndexIn;
	wire [4:0] regsBusy;	
	wire [4:0] reserveStatus;
	
	// RS variaveis
	reg [4:0] Vk [5:0], Vj [5:0], Qk [5:0], Qj [5:0];
	reg [5:0] Busy, Exec, Wresult;
	reg [2:0] Op [5:0];
		
	// Controle de registradores
	wire [4:0] Xreg, Yreg;
		
	// Auxiliares
	reg [5:0] rsIndex;
	integer i, addsubSize, muldivSize, break, rsIndex_aux;
	
	dec3to5 decRd (rd, 1'b1, Xreg);
	dec3to5 decRs (rs, 1'b1, Yreg);
	
	assign RS_addSubFull = Busy[0] & Busy[1] & Busy[2];
	assign RS_mulDivFull = Busy[3] & Busy[4] & Busy[5];
	
	initial begin
		rsIndex[5:0] = 6'b0; 
		regIndexIn[4:0] = 5'b0;
		
		Busy[5:0] = 6'b0; Exec[5:0] = 6'b0; Wresult[5:0] =  6'b0; 		
		Op[0]=3'b0; Op[1]=3'b0; Op[2]=3'b0; Op[3]=3'b0; Op[4]=3'b0; Op[5]=3'b0;
		Vk[0]=5'b0; Vk[1]=5'b0; Vk[2]=5'b0; Vk[3]=5'b0; Vk[4]=5'b0; Vk[5]=5'b0;
		Vj[0]=5'b0; Vj[1]=5'b0; Vj[2]=5'b0; Vj[3]=5'b0; Vj[4]=5'b0; Vj[5]=5'b0;
		Qk[0]=5'b0; Qk[1]=5'b0; Qk[2]=5'b0; Qk[3]=5'b0; Qk[4]=5'b0; Qk[5]=5'b0;
		Qj[0]=5'b0; Qj[1]=5'b0; Qj[2]=5'b0; Qj[3]=5'b0; Qj[4]=5'b0; Qj[5]=5'b0;
	end
	
	always @( posedge Clock ) begin 
	
		// Reseta as principais variaveis
		i = 0; break = 0;
		addsubSize = 3; muldivSize = 6; // addsubSize -> i=0 // muldivSize -> i=3
		
		// Toda vez que acontecer um despacho ele salva a instrucao			
		
		// AddSub RS
		if ( (opCode == ADD || opCode == SUB) && (!RS_addSubFull) ) begin
			for ( i=0; i<addsubSize; i=i+1 ) begin
				if (!break) begin
					if (!Busy[i]) begin // Se o espaco nao estiver ocupado
						Op[i] = opCode;
						if (!regsBusy[Xreg]) begin // Se o reg nao estiver ocupado 
							Vk[i] = Xreg;
							Qk[i] = 3'b1; // Valor padrao
							regIndexIn = Xreg; // Seta o valor no reserve status
						end else begin
							Vk[i] = 3'b1; // Valor padrao
							Qk[i] = reserveStatus[Xreg]; // Resgata a tag do reserve status							
						end
						if (!regsBusy[Yreg]) begin // Se o reg nao estiver ocupado 
							Vj[i] = Yreg;
							Qj[i] = 3'b1;
						end else begin
							Vj[i] = 3'b1;
							Qj[i] = reserveStatus[Yreg]; // Resgata a tag do reserve status
						end
						Busy = 1'b1;
						Exec = 1'b0;
						Wresult = 1'b0;
						rsIndex[i] = 1'b1;
						rsIndex_aux = i;
						break = 1;
					end
				end
			end
		end
		
		//MulDiv RS
		if ( (opCode == MUL || opCode == DIV) && (!RS_mulDivFull) ) begin
			for ( i=3; i<muldivSize; i=i+1 ) begin
				if (!break) begin
					if (!Busy[i]) begin // Se o espaco nao estiver ocupado
						Op[i] = opCode;
						if (!regsBusy[Xreg]) begin // Se o reg nao estiver ocupado 
							Vk[i] = Xreg;
							Qk[i] = 3'b1; // Valor padrao
							regIndexIn = Xreg; // Seta o valor no reserve status
						end else begin
							Vk[i] = 3'b1; // Valor padrao
							Qk[i] = reserveStatus[Xreg]; // Resgata a tag do reserve status							
						end
						if (!regsBusy[Yreg]) begin // Se o reg nao estiver ocupado 
							Vj[i] = Yreg;
							Qj[i] = 3'b1;
							regIndexIn = Yreg; // Seta o valor no reserve status
						end else begin
							Vj[i] = 3'b1;
							Qj[i] = reserveStatus[Yreg]; // Resgata a tag do reserve status
						end
						Busy = 1'b1;
						Exec = 1'b0;
						Wresult = 1'b0;
						rsIndex[i] = 1'b1;
						rsIndex_aux = i;
						break = 1;
					end
				end
			end
		end
		
		
	end // Fim always

	// Instancia todos modulos
	instrDecoder instrDcdr (instrIn, opCode, rd, rs);
	rsStatus rsSts (Clock, rsIndex, Wresult[rsIndex_aux], regIndexIn, reserveStatus, regsBusy);
	
endmodule 
