module multiplex (din, r0, r1, r2, r3, r4, r5, r6, r7, g, mem, control, out);

input [9:0]  control;
input [15:0] din, r0, r1, r2, r3, r4, r5, r6, r7, g, mem;

output reg [15:0] out; //Bus

always@(*) 
	begin
		case (control)
			11'b00000000001: out = din;
			11'b00000000010: out = r0;
			11'b00000000100: out = r1;
			11'b00000001000: out = r2;
			11'b00000010000: out = r3;
			11'b00000100000: out = r4;
			11'b00001000000: out = r5;
			11'b00010000000: out = r6;
			11'b00100000000: out = r7;
			11'b01000000000: out = g;
			11'b10000000000: out = mem;
			
		endcase
	end

endmodule
