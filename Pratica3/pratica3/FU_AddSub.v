module count_AddSub (Clock, en, out);

	input Clock, en;
	
	output reg out;
	
	always@(posedge Clock) begin
		
		if(en) begin
			if(out == 1) out = 0;
			else out = 1;
		end
		else out = 0;
		
	end

endmodule


module FU_AddSub (Clock, en, Rx, Ry, Op, out, Done, Label, LabelOut);

	input Clock, en;
	input [11:0] Rx, Ry;
	input [2:0] Op;
	input [1:0] Label;
	
	output reg Done;
	output reg [11:0] out;	
	output [1:0] LabelOut;
	
	wire contador;
	
	assign LabelOut = Label;
	
	initial begin Done = 0; end
	
	always@(negedge Clock) begin
		
		Done = 0;
		
		//if (en && contador) begin
		if (en) begin	
			case(Op)
				2'b000: begin out = Rx + Ry; Done = 1; end
				2'b001: begin out = Rx - Ry; Done = 1; end				
			endcase
		end
		
	end

	count_AddSub count (Clock, en, contador);
	
endmodule
