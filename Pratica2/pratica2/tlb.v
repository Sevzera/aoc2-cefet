module tlb (addr, Clock, out);

	input [5:0] addr;
	input Clock;
 	output reg [15:0] out;

	reg [31:0] virtualAddress [0:40];
	reg [15:0] physicalAddress [0:40]; // [15:13] -> Yreg // [12:10] -> Xreg // [9:6] -> I // [5:0] -> Offset
	
	integer hitAddr, hitIndex, i, break, addressSize;
	
	initial begin
		
			virtualAddress[0] = {26'b0,6'b000000}; virtualAddress[1] = {26'b0,6'b000001}; virtualAddress[2] = {26'b0,6'b000010};  
			virtualAddress[3] = {26'b0,6'b000011}; virtualAddress[4] = {26'b0,6'b000100}; virtualAddress[5] = {26'b0,6'b000101};
			virtualAddress[6] = {26'b0,6'b000110}; virtualAddress[7] = {26'b0,6'b000111}; virtualAddress[8] = {26'b0,6'b001000};
			virtualAddress[9] = {26'b0,6'b001001}; virtualAddress[10]= {26'b0,6'b001010}; virtualAddress[11]= {26'b0,6'b001011};
			virtualAddress[12]= {26'b0,6'b001100}; virtualAddress[13]= {26'b0,6'b001101}; virtualAddress[14]= {26'b0,6'b001110};
			virtualAddress[15]= {26'b0,6'b001111}; virtualAddress[16]= {26'b0,6'b010000}; virtualAddress[17]= {26'b0,6'b010001};
			virtualAddress[18]= {26'b0,6'b010010}; virtualAddress[19]= {26'b0,6'b010011}; virtualAddress[20]= {26'b0,6'b010100};			
			virtualAddress[21]= {26'b0,6'b010101}; virtualAddress[22]= {26'b0,6'b010110}; virtualAddress[23]= {26'b0,6'b010111};
			virtualAddress[23]= {26'b0,6'b011000}; virtualAddress[24]= {26'b0,6'b011001}; virtualAddress[25]= {26'b0,6'b011010};
			virtualAddress[26]= {26'b0,6'b011011}; virtualAddress[27]= {26'b0,6'b011100}; virtualAddress[28]= {26'b0,6'b011101};
			virtualAddress[29]= {26'b0,6'b011110}; virtualAddress[30]= {26'b0,6'b011111}; virtualAddress[31]= {26'b0,6'b100000};
			virtualAddress[32]= {26'b0,6'b100001}; virtualAddress[33]= {26'b0,6'b100010}; virtualAddress[34]= {26'b0,6'b100011};
			virtualAddress[35]= {26'b0,6'b100100}; virtualAddress[36]= {26'b0,6'b100101}; virtualAddress[37]= {26'b0,6'b100110};			
				
				
		// Programa normal
			physicalAddress[0] = 16'b0000000001000000; // MVI R0, #2
			physicalAddress[1] = 16'b0000000000000010; // #2
			physicalAddress[2] = 16'b0000010001000000; // MVI R1, #3
			physicalAddress[3] = 16'b0000000000000011; // #3
			physicalAddress[4] = 16'b0000010110000000; // ADD R1,R0
			physicalAddress[5] = 16'b0000100001000000; // MVI R2, #6
			physicalAddress[6] = 16'b0000000000000110; // #6
			physicalAddress[7] = 16'b0010100111000000; // SUB R2, R1
			physicalAddress[8] = 16'b0100110000000000; // MV R3, R2
			physicalAddress[9] = 16'b0110000110000000; // ADD R0, R3
			physicalAddress[10]= 16'b0000011000000000; // OR R1, R0
			physicalAddress[11]= 16'b0000010111000000; // SUB R1, R0
			physicalAddress[12]= 16'b0110010110000000; // ADD R1, R3
			physicalAddress[13]= 16'b0110011010000000; // SLL R1, R3
			physicalAddress[14]= 16'b0110011011000000; // SRL R1, R3
			physicalAddress[15]= 16'b0000000001000000; // MVI R0, #0
			physicalAddress[16]= 16'b0000000000000000; // #0
			physicalAddress[17]= 16'b0010001001000000; // SLT R0, R1
			physicalAddress[18]= 16'b0010011001000000; // SLT R1, R1
			physicalAddress[19]= 16'b0000110001000000; // MVI R3, #3
			physicalAddress[20]= 16'b0000000000000011; // #3
			physicalAddress[21]= 16'b0000010001000000; // MVI R1, #5
			physicalAddress[22]= 16'b0000000000000101; // #5
			physicalAddress[23]= 16'b0110000110000000; // ADD R0, R3
			physicalAddress[24]= 16'b0000000001000000; // MVI R0, #0
			physicalAddress[25]= 16'b0000000000000000; // #0
			physicalAddress[26]= 16'b0110100100000000; // LD R2, R3
			physicalAddress[27]= 16'b0110100110000000; // ADD R2, R3
			physicalAddress[28]= 16'b0000100101000000; // SD R2, R0
			physicalAddress[29]= 16'b0000000100000000; // LD R0, R0
			physicalAddress[30]= 16'b0110000111000000; // SUB R0, R3
			physicalAddress[31]= 16'b0000000001000000; // MVI R0, #0
			physicalAddress[32]= 16'b0000000000000000; // #0
			physicalAddress[33]= 16'b0000000110000000; // ADD R0, R0
			physicalAddress[34]= 16'b0100000011000000; // MVNZ R0, R2
			physicalAddress[35]= 16'b0110010111000000; // SUB R1, R3
			physicalAddress[36]= 16'b0100000011000000; // MVNZ R0, R2
			physicalAddress[37]= 16'b0010000110000000; // ADD R0, R1
		
		
		/*
		// Loop - R3 = R4, R2 = R2, R0 = R5, pc = R7
			physicalAddress[0] = 16'b0000100001000000;
			physicalAddress[1] = 16'b0000000000000001;
			physicalAddress[2] = 16'b0000110001000000;			
			physicalAddress[3] = 16'b0000000000001010;
			physicalAddress[4] = 16'b1000000000000000;
			physicalAddress[5] = 16'b0100110111000000;
			physicalAddress[6] = 16'b0001000011000000;
		*/
		
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
			out = physicalAddress[hitIndex];
		end
		else begin
			out = 16'b0;
		end
				
	end

endmodule
