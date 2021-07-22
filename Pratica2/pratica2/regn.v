module regn(R, Rin, Clock, Q, set_0);
	parameter n = 16;
	input [n-1:0] R;
	input Rin, Clock, set_0;
	output reg [n-1:0] Q;
	
	initial begin
		Q<=16'b0;
	end
	
	always @(posedge Clock) 
		if (set_0) Q = 16'b0;
		else if (Rin) Q = R;
endmodule