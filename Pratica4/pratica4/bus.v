module bus (instr, p1, p2, p3, out);

	input [8:0] instr;

	input [1:0] p1, p2, p3;
	output reg [1:0] out;
	
	always@(*) begin
		if (instr[8:7] == 2'b00) out = p1;
		else if (instr[8:7] == 2'b01) out = p2;
		else if (instr[8:7] == 2'b10) out = p3;
	end

endmodule
