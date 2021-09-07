module mux_read (e1, e2, e3, read1, read2, read3, outE, outRead);

	input [2:0] e1, e2, e3;
	input read1, read2, read3;
	output reg outRead;
	output reg [2:0] outE;
	
	always @ (*) begin
		outRead = 0;
		if(read1) begin outE = e1; outRead = 1'b1; end
		else if(read2) begin outE = e2; outRead = 1'b1; end
		else if(read3) begin outE = e3; outRead = 1'b1; end			
	
	end
	


endmodule
