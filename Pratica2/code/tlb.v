module tlb (addr, Clock, out);

	input [5:0] addr;
	input Clock;
 	output reg [15:0] out;

	reg [5:0] virtualAddress [0:40];
	reg [15:0] physicalAddres [0:40]; // [15:13] -> Yreg // [12:10] -> Xreg // [9:6] -> I // [5:0] -> Offset
	
	integer hitAddr, hitIndex, i, break, addressSize;
	
	initial begin
		
			virtualAddress[0] = 6'b000000; virtualAddress[1] = 6'b000001; virtualAddress[2] = 6'b000010;  
			virtualAddress[3] = 6'b000011; virtualAddress[4] = 6'b000100; virtualAddress[5] = 6'b000101;
			virtualAddress[6] = 6'b000110; virtualAddress[7] = 6'b000111; virtualAddress[8] = 6'b001000;
			virtualAddress[9] = 6'b001001; virtualAddress[10]= 6'b001010; virtualAddress[11]= 6'b001011;
			virtualAddress[12]= 6'b001100; virtualAddress[13]= 6'b001101; virtualAddress[14]= 6'b001110;
			virtualAddress[15]= 6'b001111; virtualAddress[16]= 6'b010000; virtualAddress[17]= 6'b010001;
			virtualAddress[18]= 6'b010010; virtualAddress[19]= 6'b010011; virtualAddress[20]= 6'b010100;			
			virtualAddress[21]= 6'b010101; virtualAddress[22]= 6'b010110; virtualAddress[23]= 6'b010111;
			virtualAddress[23]= 6'b011000; virtualAddress[24]= 6'b011001; virtualAddress[25]= 6'b011010;
			virtualAddress[26]= 6'b011011; virtualAddress[27]= 6'b011100; virtualAddress[28]= 6'b011101;
			virtualAddress[29]= 6'b011110; virtualAddress[30]= 6'b011111; virtualAddress[31]= 6'b100000;
			virtualAddress[32]= 6'b100001; virtualAddress[33]= 6'b100010; virtualAddress[34]= 6'b100011;
			virtualAddress[35]= 6'b100100; virtualAddress[36]= 6'b100101; virtualAddress[37]= 6'b100110;
			
		/*
		// Loop
			physicalAddres[0] = 16'b0000000001000000;
			physicalAddres[1] = 16'b0000000000000110;
			physicalAddres[2] = 16'b0000100001000000;
			physicalAddres[3] = 16'b0000000000000001;
			physicalAddres[4] = 16'b0000110001000000;
			physicalAddres[5] = 16'b0000000000001010;
			physicalAddres[6] = 16'b0100110111000000;
			physicalAddres[7] = 16'b0001000011000000;	
		*/
		
		// Programa normal
			physicalAddres[0] = 16'b0000000001000000; // MVI R0, #2
			physicalAddres[1] = 16'b0000000000000010; // #2
			physicalAddres[2] = 16'b0000010001000000; // MVI R1, #3
			physicalAddres[3] = 16'b0000000000000011; // #3
			physicalAddres[4] = 16'b0000010110000000; // ADD R1,R0
			physicalAddres[5] = 16'b0000100001000000; // MVI R2, #6
			physicalAddres[6] = 16'b0000000000000110; // #6
			physicalAddres[7] = 16'b0010100111000000; // SUB R2, R1
			physicalAddres[8] = 16'b0100110000000000; // MV R3, R2
			physicalAddres[9] = 16'b0110000110000000; // ADD R0, R3
			physicalAddres[10]= 16'b0000011000000000; // OR R1, R0
			physicalAddres[11]= 16'b0000010111000000; // SUB R1, R0
			physicalAddres[12]= 16'b0110010110000000; // ADD R1, R3
			physicalAddres[13]= 16'b0110011010000000; // SLL R1, R3
			physicalAddres[14]= 16'b0110011011000000; // SRL R1, R3
			physicalAddres[15]= 16'b0000000001000000; // MVI R0, #0
			physicalAddres[16]= 16'b0000000000000000; // #0
			physicalAddres[17]= 16'b0010001001000000; // SLT R0, R1
			physicalAddres[18]= 16'b0010011001000000; // SLT R1, R1
			physicalAddres[19]= 16'b0000110001000000; // MVI R3, #3
			physicalAddres[20]= 16'b0000000000000011; // #3
			physicalAddres[21]= 16'b0000010001000000; // MVI R1, #5
			physicalAddres[22]= 16'b0000000000000101; // #5
			physicalAddres[23]= 16'b0110000110000000; // ADD R0, R3
			physicalAddres[24]= 16'b0000000001000000; // MVI R0, #0
			physicalAddres[25]= 16'b0000000000000000; // #0
			physicalAddres[26]= 16'b0110100100000000; // LD R2, R3
			physicalAddres[27]= 16'b0110100110000000; // ADD R2, R3
			physicalAddres[28]= 16'b0000100101000000; // SD R2, R0
			physicalAddres[29]= 16'b0000000100000000; // LD R0, R0
			physicalAddres[30]= 16'b0110000111000000; // SUB R0, R3
			physicalAddres[31]= 16'b0000000001000000; // MVI R0, #0
			physicalAddres[32]= 16'b0000000000000000; // #0
			physicalAddres[33]= 16'b0000000110000000; // ADD R0, R0
			physicalAddres[34]= 16'b0100000011000000; // MVNZ R0, R2
			physicalAddres[35]= 16'b0110010111000000; // SUB R1, R3
			physicalAddres[36]= 16'b0100000011000000; // MVNZ R0, R2
			physicalAddres[37]= 16'b0010000110000000; // ADD R0, R1
				
	end
	
	always @(*) begin
		addressSize = 40;
		out = 16'b0;
		hitAddr = 0; hitIndex = 0; i = 0; break = 0;
		
		for (i=0;i<addressSize;i=i+1) begin
			if (break == 0) begin
				if (addr == virtualAddress[i]) begin
					break = 1;
					hitAddr = 1;
					hitIndex = i;
				end
				else begin
					hitAddr = 0;
				end
			end
		end
		
		if (hitAddr == 1) begin
			out = physicalAddres[hitIndex];
		end
		else begin
			out = 16'b0;
		end
				
	end

endmodule
