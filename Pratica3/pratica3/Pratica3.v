module Pratica3 (Clock);

	input Clock;
	
	// Clock, Clear, Bus, instr, RS_addSubFull, RS_mulDivFull
	instrQ instructionQ (Clock, Clear);
	
endmodule
