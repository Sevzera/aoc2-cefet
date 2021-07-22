module dec3to4(W, En, Y);
	input [2:0] W;
	input En;
	output reg [0:7] Y;
	
	always @(W or En) begin
		if (En == 1) case (W)
				3'b000: Y = 4'b1000;
				3'b001: Y = 4'b0100;
				3'b010: Y = 4'b0010;
				3'b011: Y = 4'b0001;
			endcase
		else Y = 4'b0000;
	end
	
endmodule
