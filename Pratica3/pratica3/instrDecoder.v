module instrDecoder (instrIn, opCode, Xreg, Yreg);

	input [8:0] instrIn;
	output reg [2:0] opCode, Xreg, Yreg;

	always @(*) begin
		opCode <= instrIn[8:6];
		Xreg <= instrIn[5:3];
		Yreg <= instrIn[2:0];
	end
	
endmodule

