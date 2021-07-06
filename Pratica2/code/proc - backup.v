module proc (DIN, Resetn, Clock, Run, Done, BusWires);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output reg Done;
	output [15:0] BusWires;
	//output [15:0] ADDR, DOUT;
	//output W;
	
	//... declare variables
		wire Clear = Done | ~Resetn;		
		// regs
			wire [0:7] Xreg, Yreg;
			wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;	
			wire [15:0] A, G;		
		// instructions
			wire [9:0] IR;
			wire [3:0] I;
			wire IRin;		
		// time steps
			wire [2:0] TStep_Q;		
		// signals
			reg aIn, gIn, gOut, dinOut, irIn;
			reg [0:7] regOut, regIn;			
			reg [2:0] aluSignal;
	
	
	upcount Tstep (Clear, Clock, Tstep_Q);
	assign I = IR[3:0];
	dec3to8 decX (IR[6:4], 1'b1, Xreg);
	dec3to8 decY (IR[9:7], 1'b1, Yreg);	
	
	always @(Tstep_Q or I or Xreg or Yreg) begin
		//... specify initial values
		if (Run) begin
			case (Tstep_Q)
				3'b000: // store DIN in IR in time step 0
					begin
						irIn = 1;
					end
				3'b001: //define signals in time step 1
					case (I)				
						// mv -> copy a data to another reg
						4'b000: begin	
							regOut = Yreg;
							regIn = Xreg;
							Done = 1'b1;
						end
						// mvi -> move the DIN to an reg
						4'b001: begin							
							regIn = Xreg;
							dinOut = 1'b1;
							Done = 1'b1;
						end
						// add -> add the data of two regs
						4'b010: begin							
							regOut = Xreg;
							aIn = 1;
						end
						// sub -> subtract the data of two regs
						4'b011: begin							
							regOut = Xreg;
							aIn = 1;
						end
					endcase
					
				3'b010: //define signals in time step 2
					case (I)
						// add -> add the data of two regs
						4'b010: begin							
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b010;
						end
						// sub -> subtract the data of two regs
						4'b011: begin							
							regOut = Yreg;
							gIn = 1;
							aluSignal = 4'b011;
						end
					endcase
					
				3'b011: //define signals in time step 3
					case (I)
						// add -> add the data of two regs
						4'b010: begin							
							regIn = Xreg;
							gOut = 1;
							aluSignal = 4'b010;
							Done = 1;
						end
						// sub -> subtract the data of two regs
						4'b011: begin							
							regIn = Xreg;
							gOut = 1;
							aluSignal = 4'b011;
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
			regn reg_4 (BusWires, regIn[4], Clock, R4, Resetn);
			regn reg_5 (BusWires, regIn[5], Clock, R5, Resetn);
			regn reg_6 (BusWires, regIn[6], Clock, R6, Resetn);
			regn reg_7 (BusWires, regIn[7], Clock, R7, Resetn); // Instructions		
		// Aux reg for multi-cycle
			regn reg_A(BusWires, aIn, Clock, A, Resetn);
			regn reg_G(saidaULA, gIn, Clock, G, Resetn);	
		// Instruction register
			regn_9 reg_IR(DIN[15:7], irIn, Clock, IR, Resetn);	
	//... define alu
		alu alu (aluSignal, A, BusWires, aluOut);
	//... define the bus
		multiplex multiplex (DIN, R0, R1, R2, R3, R4, R5, R6, R7, G, {dinOut, regOut, gOut}, BusWires);
	
	

endmodule
