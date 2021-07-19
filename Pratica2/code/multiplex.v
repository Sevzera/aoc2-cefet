module multiplex (en, din, r0, r1, r2, r3, pc, g, mem, control, out);

input en;
input [0:7]  control;
input [15:0] din, r0, r1, r2, r3, g, mem;
input [5:0] pc;

output reg [15:0] out; //Bus

always@(en, control) 
	begin
		if (en)
			case (control)
				8'b10000000: out = din;
				8'b01000000: out = r0;
				8'b00100000: out = r1;
				8'b00010000: out = r2;
				8'b00001000: out = r3;
				8'b00000100: out = {11'b0, pc};
				8'b00000010: out = g;			
				8'b00000001: out = mem;										
			endcase
		else out = 16'b0;
	end

endmodule
