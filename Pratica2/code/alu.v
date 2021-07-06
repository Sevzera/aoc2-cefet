module alu (aluSignal, A,  BusWires, G);
	input [3:0] aluSignal;
	input [15:0] A, BusWires;
	output reg [15:0] G;
	
	/*
	0010 = add
	0011 = sub
	*/
	
	always@(*)begin
		case(aluSignal)
			// Add
			4'b0000: G = A + BusWires;  
			// Sub
			4'b0001: G = A - BusWires;
			// Or
			4'b0010: G = A || BusWires;
			// Slt
			4'b0011: G = (A < BusWires) ? 1:0;
			// Sll
			4'b0100: G = A << BusWires;
			// Srl
			4'b0101: G = A >> BusWires;
		endcase
	end
	
endmodule
