module dec3to5(W, En, Y);
	input [2:0] W;
	input En;
	output reg [0:4] Y;
	
	always @(W or En) begin
		if (En == 1) case (W)
				3'b000: Y = 5'b10000;
				3'b001: Y = 5'b01000;
				3'b010: Y = 5'b00100;
				3'b011: Y = 5'b00010;
				3'b100: Y = 5'b00001;
			endcase
		else Y = 5'b00000;
	end
	
endmodule
