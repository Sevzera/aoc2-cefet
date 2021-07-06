module proc (DIN, Mem, Resetn, Clock, Run, Done, BusWires, ADDR, DOUT, W, ADDRrom);
	input [15:0] DIN;
	input [15:0] Mem;
	input Resetn, Clock, Run;
	output reg Done;
	output [15:0] BusWires;
	output [15:0] ADDR, DOUT, ADDRrom;	// Address outside and Data outside
	output W;						// Write/Read mem ram
	
	//... declare variables
		wire Clear = Done | ~Resetn;		
		// regs
			wire [7:0] Xreg, Yreg;
			wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;	
			wire [15:0] A, G;		
		// instructions
			wire [9:0] IR;
			wire [3:0] I;	
		// time steps
			wire [2:0] TStep_Q;		
		// signals
			reg IRin, Ain, Gin, DINout, Gout, MemOut,incr_pc, ADDRin, DOUTin, Wvalue, ADDRromIn;
			reg [7:0] Rout, Rin;			
			reg [2:0] aluSignal;			
	
	
	upcount Tstep (Clear, Clock, Tstep_Q);
	assign I = IR[3:0];
	dec3to8 decX (IR[6:4], 1'b1, Xreg);
	dec3to8 decY (IR[9:7], 1'b1, Yreg);	
	
	always @(Tstep_Q or I or Xreg or Yreg) begin
		//... specify initial values
			IRin = 1'b0;
			Rout[7:0] = 8'b00000000;
			Rin[7:0] = 8'b00000000;
			Ain = 1'b0;
			Gin = 1'b0;
			DINout = 1'b0;			
			Gout = 1'b0;		
			DOUTin = 1'b0;
			ADDRin = 1'b0;
			Wvalue = 1'b0;
			incr_pc = 1'b0;
			aluSignal = 4'b0000;
			Done = 1'b0;
		
		if (Run) begin
			case (Tstep_Q)
				3'b000: // store DIN in IR in time step 0
					begin
						Rout = 8'b10000000;
						IRin = 1;
						ADDRromIn = 1;
						incr_pc = 1;
					end
					
					
				3'b001: //define signals in time step 1
					case (I)				
						// mv -> copy a data to another reg
						4'b0000: begin	
							Rout = Yreg;
							Rin = Xreg;
							Done = 1'b1;							
						end
						// mvi -> move the DIN to an reg
						4'b0001: begin							
							Rin = Xreg;
							DINout = 1'b1;
							Done = 1'b1;
							incr_pc = 1;
						end
						// mvnz -> (move if not zero) allows a mv operation to be executed only under a certain condition
						4'b0011: begin							
							if (G != 0) begin
							  Rout = Yreg;
							  Rin = Xreg;
							end
							Done = 1;
						end
						// load -> load data from memory
						4'b0100: begin							
							Rout = Yreg;
							ADDRin = 1;
						end
						// store -> write on memory
						4'b0101: begin							
							Rout = Xreg;
							DOUTin = 1;
						end
						// add -> add the data of two regs
						4'b0110: begin							
							Rout = Xreg;
							Ain = 1;
						end
						// sub -> subtract the data of two regs
						4'b0111: begin							
							Rout = Xreg;
							Ain = 1;
						end
						// Or
						4'b1000: begin
							Rout = Xreg;
							Ain = 1;
						end
						// Slt
						4'b1001: begin
							Rout = Xreg;
							Ain = 1;
						end
						// Sll
						4'b1010: begin
							Rout = Xreg;
							Ain = 1;
						end
						// Srl
						4'b1011: begin
							Rout = Xreg;
							Ain = 1;
						end
					endcase
					
					
				3'b010: //define signals in time step 2
					case (I)
						// load -> load data from memory
						4'b0100: begin							
							Rin = Xreg;
							MemOut = 1;
							Done = 1;
						end
						// store -> write on memory
						4'b0101: begin							
							Rout = Yreg;
							ADDRin = 1;
							Wvalue = 1;
							Done = 1;
						end
						// add -> add the data of two regs
						4'b0110: begin							
							Rout = Yreg;
							Gin = 1;
							aluSignal = 4'b0000;
						end
						// sub -> subtract the data of two regs
						4'b0111: begin							
							Rout = Yreg;
							Gin = 1;
							aluSignal = 4'b0001;
						end
						// Or
						4'b1000: begin
							Rout = Yreg;
							Gin = 1;
							aluSignal = 4'b0010;
						end
						// Slt
						4'b1001: begin
							Rout = Yreg;
							Gin = 1;
							aluSignal = 4'b0011;
						end
						// Sll
						4'b1010: begin
							Rout = Yreg;
							Gin = 1;
							aluSignal = 4'b0100;
						end
						// Srl
						4'b1001: begin
							Rout = Yreg;
							Gin = 1;
							aluSignal = 4'b0101;
						end
					endcase
					
					
				3'b011: //define signals in time step 3
					case (I)						
						// add -> add the data of two regs
						4'b0110: begin							
							Rin = Xreg;
							Gout = 1;
							Done = 1;
						end
						// sub -> subtract the data of two regs
						4'b0111: begin							
							Rin = Xreg;
							Gout = 1;
							Done = 1;
						end
						// Or
						4'b1000: begin
							Rin = Xreg;
							Gout = 1;
							Done = 1;
						end
						// Slt
						4'b1001: begin
							Rin = Xreg;
							Gout = 1;
							Done = 1;
						end
						// Sll
						4'b1010: begin
							Rin = Xreg;
							Gout = 1;
							Done = 1;
						end
						// Srl
						4'b1011: begin
							Rin = Xreg;
							Gout = 1;
							Done = 1;
						end
					
					endcase
					
			endcase
		end
	end
		
	//... instantiate other registers and the adder/subtracter unit
		// Standart registers
			regn reg_0 (BusWires, Rin[0], Clock, R0, Resetn);
			regn reg_1 (BusWires, Rin[1], Clock, R1, Resetn);
			regn reg_2 (BusWires, Rin[2], Clock, R2, Resetn);
			regn reg_3 (BusWires, Rin[3], Clock, R3, Resetn);
			regn reg_4 (BusWires, Rin[4], Clock, R4, Resetn);
			regn reg_5 (BusWires, Rin[5], Clock, R5, Resetn);
			regn reg_6 (BusWires, Rin[6], Clock, R6, Resetn);
			//regn reg_7 (BusWires, Rin[7], Clock, R7, Resetn); Parte 1 e 2
			
		// Counter
			counter reg_7 (Clock, incr_pc, BusWires, ~Resetn, Rin[7], R7);	// O buswire vai ser R7 nesse momento
			
		// Aux reg for multi-cycle
			regn reg_A(BusWires, AIn, Clock, A, Resetn);
			regn reg_G(aluOut, GIn, Clock, G, Resetn);	
			
		// Instruction register
			regn_9 reg_IR(DIN[15:7], IRin, Clock, IR, Resetn);	
			
		// Parte 3
			regn reg_ADDR (BusWires, ADDRin, Clock, ADDR);
			regn reg_DOUT (BusWires, DOUTin, Clock, DOUT);			
			regn reg_W (W, 1'b1, Clock, W);
			regn reg_ADDRrom (BusWires, ADDRromIn, Clock, ADDRrom);
			
	//... define alu
		alu alu (aluSignal, A, BusWires, aluOut);
		
	//... define the bus
		multiplex multiplex (DIN, R0, R1, R2, R3, R4, R5, R6, R7, G, Mem,{DINout, Rout, Gout, MemOut}, BusWires);
	
	

endmodule
