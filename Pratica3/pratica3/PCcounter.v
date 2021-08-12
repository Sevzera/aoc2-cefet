module PCcounter (Clock, enable, PC);

	input Clock, enable;
	output reg [8:0] PC;
	
	initial begin
		PC = 9'b0;
	end
	
	always@(negedge Clock) begin
		if (enable) begin
			PC = PC + 1;
		end
	end

endmodule
