module tlb (addr, out);

	input [15:0] addr;
 	output reg [15:0] out;

	always @(*) begin
		out = addr;
	end

endmodule
