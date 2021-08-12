module instrQ (Clock, Rs_AddSub_Full, Rs_MulDiv_Full, out);

	input Clock;
	input Rs_AddSub_Full, Rs_MulDiv_Full;
	
	output reg [11:0] out;
	
	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	parameter MUL = 3'b010;
	parameter DIV = 3'b011;
	
	reg [11:0] Memory [6:0];	
	reg PcEn;
	wire [8:0] PC;
	
	initial begin
		Memory[0] = 12'b000010000001; // ADD R3, R1, R2 
		Memory[1] = 12'b001100010000; // SUB R5, R3, R1
		Memory[2] = 12'b000100011101; // ADD R5, R4, R6
		Memory[3] = 12'b010101100011; // MUL R6, R5,R4
		Memory[4] = 12'b010001100010; // MUL R2, R5, R3
		Memory[5] = 12'b001101100011; // SUB R6, R5, R4
		Memory[6] = 12'b000101100100;	// ADD R6, R5, R5
	end
	
	
	always@(negedge Clock) begin
		PcEn = 0;
		if(PC!=7) begin
			// Se houver espaco na RS, solta a instrucao
			if ((!Rs_AddSub_Full) && (Memory[PC][11:9] == ADD || Memory[PC][11:9] == SUB)) begin
				PcEn = 1'b1;
				#10 out = Memory[PC];			
			end
			else if ((!Rs_MulDiv_Full) && (Memory[PC][11:9] == MUL || Memory[PC][11:9] == DIV)) begin
				PcEn = 1'b1;
				#10 out = Memory[PC];		
			end	
			// Se nao houver, ocorre stall
		end	
		
	end // -- Fim do Always --
	
	PCcounter pccounter (Clock, PcEn, PC);

endmodule
