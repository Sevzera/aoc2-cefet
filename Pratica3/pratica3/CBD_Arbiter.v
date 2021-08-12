module CDB_Arbiter (ResultAddSub, ResultMulDiv, CDB, control);

	input [1:0] control;
	input [11:0] ResultAddSub, ResultMulDiv;
	
	output reg [11:0] CDB;
	
	always@(*) begin
		case(control)
			2'b01: CDB = ResultAddSub;
			2'b10: CDB = ResultMulDiv;
			default: CDB = 0;
		endcase
	
	end


endmodule
