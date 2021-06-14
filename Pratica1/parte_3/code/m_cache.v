module m_cache (clock, test_tag, test_data, test_wren);

// Declarando inputs
input clock, test_wren;
input [7:0] test_tag, test_data;

// Memoria principal
reg mp_clock, mp_wren; 				// Clock controlado para tornar mais facil a leitura da memoria principal
reg [7:0]  mp_address, mp_data;
wire [7:0] mp_out;

// Memoria cache
reg mc_wren;
reg [7:0] mc_address [0:3][0:1];
reg valido [0:3], dirty [0:3];
reg [1:0] lru [0:3];
reg [7:0] mc_out;

// Intermediarias
integer i, lastLRU, oldLRU, hitIndex, hit, break;


// Valores iniciais da memoria cache definidos a partir do codigo teste
initial begin
	mc_address[0][0] = 8'b00000000; mc_address[0][1] = 8'b00000101;
	mc_address[1][0] = 8'b00000010; mc_address[1][1] = 8'b00000001;
	mc_address[2][0] = 8'b00000101; mc_address[2][1] = 8'b00000101;
	mc_address[3][0] = 8'b00000001; mc_address[3][1] = 8'b00000011;
	
	valido[0] = 1'b1; valido[1] = 1'b1; valido[2] = 1'b0; valido[3] = 1'b1;
	dirty[0] = 1'b0; dirty[1] = 1'b0; dirty[2] = 1'b0; dirty[3] = 1'b0;
	lru[0] = 0; lru[1] = 1;	lru[2] = 3; lru[3] = 2;
	
	mp_clock = 0;
end


always@(test_tag) begin
	i=0; lastLRU=0; oldLRU=0; hitIndex=0; hit=0; break=0;
	mc_wren = test_wren;
	
	// Verificar se houve hit
	for (i=0; i<4; i=i+1) begin
		if(break == 0) begin
			if(test_tag == mc_address[i][0] && valido[i] == 1) begin // Hit
				hitIndex = i;
				hit = 1;
				break = 1;
			end
			else if(test_tag == mc_address[i][0] && valido[i] == 0) begin // Miss
				hitIndex = i;
				hit = 0;
				break = 1;
			end
			else begin // Miss
				hit = 0;
			end
		end
	end
	
	
	// Procurar LRU mais antigo
	for (i=0; i<4; i=i+1) begin
		if(oldLRU < lru[i]) begin
			oldLRU = lru[i];
			lastLRU = i;
		end
	end
	
end

always@(posedge clock) begin
	// Write back
	if (hit == 1) begin
		if (dirty[hitIndex] == 1) begin
			mp_address = mc_address[hitIndex][0];
			mp_data = mc_address[hitIndex][1];
			mp_wren = 1;
			mp_clock = 1;
			#2
			#10 mp_clock = 0; mp_wren = 0;
		end
	end
	else begin
		if (dirty[lastLRU] == 1) begin
			mp_address = mc_address[lastLRU][0];
			mp_data = mc_address[lastLRU][1];
			mp_clock = 1;
			#2
			#10 mp_clock = 0; mp_wren = 0;
		end
	end
	
	
	// Operacao de read
	if (mc_wren == 0) begin
		if (hit == 1) begin
			mc_out = mc_address[hitIndex][1];
			dirty[hitIndex] = 0;
		end
		else begin
			if (valido[hitIndex] == 0) begin
				mp_address = test_tag;
				mp_clock = 1;
				mp_wren = 0;
				#2
				#10 mp_clock = 0; mp_wren = 0;
				mc_address[hitIndex][0] = mp_address;
				mc_address[hitIndex][1] = mp_out;
				dirty[hitIndex] = 0;
				valido[hitIndex] = 1;
			end
			else begin
				mp_address = test_tag;
				mp_clock = 1;
				mp_wren = 0;
				#2
				#10 mp_clock = 0; mp_wren = 0;
				mc_address[lastLRU][0] = mp_address;
				mc_address[lastLRU][1] = mp_out;
				dirty[hitIndex] = 0;
			end
		end
	end
	
	
	// Operacao de write
	else begin
		if (hit == 1) begin
			mc_address[hitIndex][1] = test_data;
			dirty[hitIndex] = 1;
		end
		else begin
			mc_address[lastLRU][0] = test_tag;
			mc_address[lastLRU][1] = test_data;
			dirty[lastLRU] = 1;
		end
	end
	
	
	// Alteracoes do LRU
	if (hit == 1) begin
		if (lru[hitIndex] == 2) begin // Retirado = 2
			for (i=0; i<4; i=i+1) begin
				if (i != hitIndex && lru[hitIndex] != 3) lru[i] = lru[i] + 1;
				else lru[hitIndex] = 0;					
			end
		end
		else if (lru[hitIndex] == 1) begin // Retirado = 1
			for (i=0; i<4; i=i+1) begin
				if (i != hitIndex && lru[i] < 2) lru[i] = lru[i] + 1;					
				else lru[hitIndex] = 0;	
			end
		end
	end
	else // Retirado mais velho = 3
		for (i=0; i<4; i=i+1) begin
			if (i != hitIndex) lru[i] = lru[i] + 1;
			else lru[hitIndex] = 0;					
		end
end

m_principal m_principal(mp_address, mp_clock, mp_data, mp_wren, mp_out);

endmodule
