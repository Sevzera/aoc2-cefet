module mem (instr, enderecoWB, dadoWB, WB, out);

	input [8:0] instr;
	input [2:0] enderecoWB, dadoWB;
	input WB;
	
	output reg [8:0] out;
	
	// Memoria
	reg [2:0] Tag[2:0];
	reg [2:0] Dado[2:0];
	
	// Variaveis aux
	integer i, memorySize, memoryPos, breakLoop = 1;
	
	initial begin
		Tag[0] = 3'b001; Dado[0] = 3'b001;
		Tag[1] = 3'b010; Dado[1] = 3'b010;
		Tag[2] = 3'b011; Dado[2] = 3'b100;
	end
	
	always @ (instr) begin		
		if (instr[6] == 0) begin
			breakLoop = 0;
			memorySize = 3;
			memoryPos = 0;
		
			for (i=0; i<memorySize; i=i+1) begin
				if (!breakLoop) begin
					if ( instr[5:3] == Tag[i] ) begin
						memoryPos = i;
						breakLoop = 1;
					end
				end
			end
		
			out = {instr[8:3], Dado[memoryPos]};
		end
		else out = instr;
	end
	
	always @ (posedge WB) begin
		breakLoop = 0;
		memorySize = 3;
		memoryPos = 0;
	
		for (i=0; i<memorySize; i=i+1) begin
			if (breakLoop) begin
				if ( enderecoWB == Tag[i] ) begin
					memoryPos = i;
					breakLoop = 1;
				end
			end
		end
		
		Dado[memoryPos] = dadoWB;
	end

endmodule
