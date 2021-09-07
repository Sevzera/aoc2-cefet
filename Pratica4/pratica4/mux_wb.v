module mux_wb (e1, d1, e2, d2, e3, d3, wb1, wb2, wb3, outE, outD, outWb);

	input [2:0] e1, d1, e2, d2, e3, d3;
	input wb1, wb2, wb3;
	output reg outWb;
	output reg [2:0] outE, outD;
	
	always @ (*) begin			
		outWb = 1'b0;
		if(wb1) begin outE = e1; outD = d1; outWb = 1'b1; end
		else if(wb2) begin outE = e2; outD = d2; outWb = 1'b1; end
		else if(wb3) begin outE = e3; outD = d3; outWb = 1'b1; end
	end
	


endmodule
