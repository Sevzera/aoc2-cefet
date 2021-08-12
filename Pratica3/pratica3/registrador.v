/**** GUARDA DADOS DENTRO DO REG ****/

module registrador (clk, InputData, DataControl, InputLabel, LabelControl, OutputLabel, OutputData, start);
	
	input clk, DataControl, LabelControl, start;
	input [11:0] InputData;
	input [1:0] InputLabel;	
	
	output reg [11:0] OutputData;
	output reg [1:0] OutputLabel;
	
	initial begin
		OutputLabel = 2'b11;
	end
	
	always@(clk, DataControl, start)begin
		if(DataControl) begin
			OutputData <= InputData;
		end
	end
	always@(clk, LabelControl)begin
		if(LabelControl) begin
			OutputLabel <= InputLabel;
		end
	end
	
endmodule
