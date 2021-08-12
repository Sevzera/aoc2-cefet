module count_MulDiv (Clock, en, out);

	input Clock, en;
	
	output reg [1:0] out;
	
	initial begin out = 0; end
	
	always@(posedge Clock) begin
		
		if(en) begin
			if(out == 1) out = 0;
			else out = out + 1;
		end
		else out = 0;
	
	end

endmodule


module FU_MulDiv (Clock, en, Rx, Ry, Op, out, Done, Label, LabelOut);

	input Clock, en;
	input [11:0] Rx, Ry;
	input [2:0] Op;
	input [1:0] Label;
	
	output reg Done;
	output reg [11:0] out;	
	output [1:0] LabelOut;
	
	wire [1:0] contador;
	
	assign LabelOut = Label;
	
	initial begin Done = 0; end
	
	always@(negedge Clock) begin
		
		Done = 0;
		
		//if (en && (contador == 2'b10)) begin
		if (en && contador) begin
			case(Op)
				2'b010: begin out = Rx * Ry; Done = 1; end
				2'b011: begin out = Rx / Ry; Done = 1; end				
			endcase
		end
		
	end

	count_MulDiv count (Clock, en, contador);
	
endmodule