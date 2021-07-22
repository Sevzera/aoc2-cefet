module proc (DIN, mem, Resetn, Clock, Run, Done, BusWires, pc, addrM, doutM, wM);
	input [15:0] DIN; // [15:13] -> Yreg // [12:10] -> Xreg // [9:6] -> I // [5:0] -> Offset
	input [15:0] mem;
	input Resetn, Clock, Run;
	
	output reg Done;
	output [15:0] BusWires;
	output [5:0] pc;
	
	output [15:0] addrM, doutM;
	output wM;
	
	//... declare variables
		wire Clear = Done | Resetn;		
		// regs
			wire [0:4] Xreg, Yreg;
			wire [15:0] R0, R1, R2, R3;	
			wire [15:0] A, G;	
			wire [15:0] aluOut;
		// instructions
			wire [9:0] IR;
			wire [3:0] I;	
		// time steps
			wire [2:0] TstepQ;		
		// signals
			reg dinOut, gOut, memOut, incr_pc, aIn, gIn, irIn, addrIn, doutIn, wIn;
			reg [0:4] regOut, regIn;
			reg [2:0] aluSignal;
		
	assign I = IR[3:0];
	dec3to5 decX (IR[6:4], 1'b1, Xreg);
	dec3to5 decY (IR[9:7], 1'b1, Yreg);	
	upcount tstep (Clear, Clock, TstepQ);
	
	always @(TstepQ or I or Xreg or Yreg) begin
		
		//... specify initial values		
		regOut[0:4] = 5'b00000;
		regIn [0:4] = 5'b00000;	
		dinOut = 1'b0;			
		gOut = 1'b0;	
		memOut = 1'b0;
		incr_pc = 1'b0;
		aIn = 1'b0;
		gIn = 1'b0;
		irIn = 1'b0;
		addrIn = 1'b0;
		doutIn = 1'b0;
		wIn = 1'b0;
		aluSignal = 3'b000;
		Done = 1'b0;
		
		if (Run) begin
			case (TstepQ)
				3'b000: // load instruction time step 0
					begin
						regOut = 5'b00001;
						irIn = 1'b1;
						incr_pc = 1; // pula para proxima instrucao ou imediato
					end	
					
				3'b001: //define signals in time step 1
					case (I)				
						// mv -> copy a data to another reg
						4'b0000: begin	
							regOut = Yreg;
							regIn = Xreg;
							Done = 1'b1;							
						end
						// mvi -> move the DIN to an reg
						4'b0001: begin							
							// Stall
						end
						// mvnz -> (move if not zero) allows a mv operation to be executed only under a certain condition
						4'b0011: begin							
							if (G != 0) begin
							  regOut = Yreg;
							  regIn = Xreg;
							end
							Done = 1;
						end
						// load -> load data from memory
						4'b0100: begin							
							regOut = Yreg;
							addrIn = 1;
						end
						// store -> write on memory
						4'b0101: begin							
							regOut = Xreg;
							doutIn = 1;
						end
						// add -> add the data of two regs
						4'b0110: begin							
							regOut = Xreg;
							aIn = 1;
						end
						// sub -> subtract the data of two regs
						4'b0111: begin							
							regOut = Xreg;
							aIn = 1;
						end
						// Or
						4'b1000: begin
							regOut = Xreg;
							aIn = 1;
						end
						// Slt
						4'b1001: begin
							regOut = Xreg;
							aIn = 1;
						end
						// Sll
						4'b1010: begin
							regOut = Xreg;
							aIn = 1;
						end
						// Srl
						4'b1011: begin
							regOut = Xreg;
							aIn = 1;
						end
					endcase
					
					
				3'b010: //define signals in time step 2
					case (I)				
						// mvi -> move the DIN to an reg
						4'b0001: begin
							regIn = Xreg;
							dinOut = 1'b1;
							Done = 1'b1;
							#20 regOut = 5'b00001;
							incr_pc = 1;	// aumente novamente o pc, pois salva o valor de um imediato de 15 bits
						end
						// load -> load data from memory
						4'b0100: begin							
							// stall
						end
						// store -> write on memory
						4'b0101: begin							
							regOut = Yreg;
							addrIn = 1;
							wIn = 1;
							Done = 1;
						end
						// add -> add the data of two regs
						4'b0110: begin							
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b0000;
						end
						// sub -> subtract the data of two regs
						4'b0111: begin							
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b0001;
						end
						// Or
						4'b1000: begin
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b0010;
						end
						// Slt
						4'b1001: begin
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b0011;
						end
						// Sll
						4'b1010: begin
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b0100;
						end
						// Srl
						4'b1011: begin
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b0101;
						end
					endcase
					
					
				3'b011: //define signals in time step 3
					case (I)		
						// load
						4'b0100: begin							
							regIn = Xreg;
							memOut = 1;
							Done = 1;
						end
						// add -> add the data of two regs
						4'b0110: begin							
							regIn = Xreg;
							gOut = 1;
							Done = 1;
						end
						// sub -> subtract the data of two regs
						4'b0111: begin							
							regIn = Xreg;
							gOut = 1;
							Done = 1;
						end
						// Or
						4'b1000: begin
							regIn = Xreg;
							gOut = 1;
							Done = 1;
						end
						// Slt
						4'b1001: begin
							regIn = Xreg;
							gOut = 1;
							Done = 1;
						end
						// Sll
						4'b1010: begin
							regIn = Xreg;
							gOut = 1;
							Done = 1;
						end
						// Srl
						4'b1011: begin
							regIn = Xreg;
							gOut = 1;
							Done = 1;
						end					
					endcase					
			endcase
		end
		
	end
		
	//... instantiate other registers and the adder/subtracter unit
		// Standart registers
			regn reg_0 (BusWires, regIn[0], Clock, R0, Resetn);
			regn reg_1 (BusWires, regIn[1], Clock, R1, Resetn);
			regn reg_2 (BusWires, regIn[2], Clock, R2, Resetn);
			regn reg_3 (BusWires, regIn[3], Clock, R3, Resetn);
			
		//Counter
		counterlpm count (1'b1, Clock, incr_pc, BusWires[5:0], Resetn, regIn[4], pc);
			
		//Alu
		alu alu (aluSignal, A, BusWires, aluOut);
			
		// Aux reg for multi-cycle
			regn reg_A(BusWires, aIn, Clock, A, Resetn);
			regn reg_G(aluOut, gIn, Clock, G, Resetn);			
			
		// Instruction register
			regn reg_IR(DIN[15:6], irIn, Clock, IR, Resetn);	
			defparam reg_IR.n = 10; 
			
		// Memory register
			regn reg_Addr(BusWires, addrIn, Clock, addrM, Resetn);
			regn reg_Dout(BusWires, doutIn, Clock, doutM, Resetn);		
			regn reg_W(wIn, 1'b1, Clock, wM, Resetn);	
			defparam reg_W.n = 1;	
						
	//... define the bus
		multiplex multiplex (1'b1, DIN, R0, R1, R2, R3, pc, G, mem, {dinOut, regOut, gOut, memOut}, BusWires);
	
	

endmodule
