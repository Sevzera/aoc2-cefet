// Modulo para contar os estagios

module upcount (Clear, Clock, Q);
	input Clear, Clock;
	output reg [2:0] Q;
	
	always@(posedge Clock) begin
		if(Clear) Q <= 3'b0;
		else Q <= Q + 1'b1;
	end
	
endmodule

/* Counter parte 1 e 2
module upcount_5(Clear, Clock, Q);
	input Clear, Clock;
	output reg [4:0] Q;
	
	always @(posedge Clock)
		if (Clear) Q <= 5'b0;
		else Q <= Q + 1'b1;
endmodule
*/


