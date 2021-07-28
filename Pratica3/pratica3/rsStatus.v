module rsStatus (Clock, reserveStationIndexIn, reserveStationStatusIn, regIndexIn, reserveStationStatus, Busy);

	input Clock;
	input [5:0] reserveStationIndexIn;
	input [4:0] regIndexIn;
	input reserveStationStatusIn;
	
	reg [5:0] reserveStationIndex [4:0]; // Indicar de qual operacao este registrador esta vindo
	output reg [4:0] reserveStationStatus ; // Indicar de qual operacao este registrador esta vindo ( 1=executando, 0=finalizado )
	output reg [4:0] Busy ; // Mandar sinal falando se esse registrador ja esta sendo usado ou nao
	
	initial begin
		reserveStationIndex[0]=6'b0; reserveStationIndex[1]=6'b0; reserveStationIndex[2]=6'b0;
		reserveStationIndex[3]=6'b0; reserveStationIndex[4]=6'b0;
		reserveStationStatus[4:0] = 5'b0;
		Busy[4:0]=5'b0;
	end
	
	always @(posedge Clock) begin
	
		if ( Busy[regIndexIn] == 0 ) begin // Setando pela primeira vez o registrador
			reserveStationIndex[regIndexIn] = reserveStationIndexIn;
			reserveStationStatus[regIndexIn] = 1;
			Busy[regIndexIn] = 1;
		end
		else begin // Verificar se ja terminou a execucao
			if ( reserveStationStatus == 1 ) begin
				reserveStationIndex[regIndexIn] = 6'b1; // Valor padrao de vazio
				reserveStationStatus[regIndexIn] = 0;
				Busy[regIndexIn] = 0;
			end
		end
	end

endmodule
