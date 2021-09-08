module mem (endereco, read, enderecoWB, dadoWB, WB, out);

	input [2:0] endereco;
	input [2:0] enderecoWB, dadoWB;
	input WB, read;
	
	output reg [2:0] out;
	
	// Memoria
	reg [2:0] Tag[6:0];
	reg [2:0] Dado[6:0];
	
	// Variaveis aux
	integer i, memorySize, memoryPos, breakLoop = 1;
	
	initial begin
		Tag[0] = 3'b001; Dado[0] = 3'b001;
		Tag[1] = 3'b001; Dado[1] = 3'b000;
		Tag[2] = 3'b010; Dado[2] = 3'b001;
		Tag[3] = 3'b011; Dado[3] = 3'b010;
		Tag[4] = 3'b100; Dado[4] = 3'b011;
		Tag[5] = 3'b101; Dado[5] = 3'b011;
		Tag[6] = 3'b110; Dado[6] = 3'b100;
	end
	
	always @ (posedge read) begin		
		breakLoop = 0;
		memorySize = 6;
		memoryPos = 0;
	
		for (i=0; i<memorySize; i=i+1) begin
			if (!breakLoop) begin
				if ( endereco == Tag[i] ) begin
					memoryPos = i;
					breakLoop = 1;
				end
			end
		end
		
		out = Dado[memoryPos];
	end
	
	always @ (posedge WB) begin
		breakLoop = 0;
		memorySize = 6;
		memoryPos = 0;
	
		for (i=0; i<memorySize; i=i+1) begin
			if (!breakLoop) begin
				if ( enderecoWB == Tag[i] ) begin
					memoryPos = i;
					breakLoop = 1;
				end
			end
		end
		
		Dado[memoryPos] = dadoWB;
	end

endmodule
