/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

/* TITLE SCREEN */
module logoROM 
(
        input [23:0] data_In,
        input [14:0] read_address, write_address,
        input Clk, we,

        output logic [23:0] data_Out
);


logic [23:0] mem [0:24600-1];

initial
begin
     $readmemh("Llogo.txt", mem);
end

always_ff @ (posedge Clk) begin
    if (we)
            mem[write_address] <= data_In;
    data_Out<= mem[read_address];
end
endmodule

module enterROM 
(
        input [23:0] data_In,
        input [13:0] read_address,write_address,
        input Clk, we, 
        output logic [23:0] data_Out
);


logic [23:0] mem [0:11550-1];

initial
begin
     $readmemh("enter.txt", mem);
end


always_ff @ (posedge Clk) begin
    if (we)
            mem[write_address] <= data_In;
    data_Out<= mem[read_address];
end
endmodule 

/* TITLE SCREEN */
 
 
/** GOOMBAS **/
module goomba1RAM
(
        input [23:0] data_In,
        input [7:0] write_address, read_address,
        input we, Clk,

        output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
     $readmemh("Goomba1.txt", mem);
end

always_ff @ (posedge Clk) begin
    if (we)
        mem[write_address] <= data_In;
    data_Out<= mem[read_address];
end
endmodule 

module goomba2RAM
(
        input [23:0] data_In,
        input [7:0] write_address, read_address,
        input we, Clk,

        output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
     $readmemh("Goomba2.txt", mem);
end

always_ff @ (posedge Clk) begin
    if (we)
        mem[write_address] <= data_In;
    data_Out<= mem[read_address];
end

endmodule
/** GOOMBAS **/


/** PRINCESS **/
module princessRAM
(
        input [23:0] data_In,
        input [8:0] write_address, read_address,
        input we, Clk,

        output logic [23:0] data_Out
);

logic [23:0] mem [0:384 -1];
initial
begin
     $readmemh("Princess.txt", mem);
end


always_ff @ (posedge Clk) begin
    if (we)
        mem[write_address] <= data_In;
    data_Out<= mem[read_address];
end
endmodule

/** PRINCESS **/
 
module gameOverRAM
(
        input [23:0] data_In,
        input [11:0] write_address, read_address,
        input we, Clk,

        output logic [23:0] data_Out
);

logic [23:0] mem [0:3360-1];
initial
begin
     $readmemh("gameover.txt", mem);
end


always_ff @ (posedge Clk) begin
    if (we)
        mem[write_address] <= data_In;
    data_Out<= mem[read_address];
end

endmodule

module SuperMarioStandingRAM
(
		input [23:0] data_In,
		input [8:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:511];
initial
begin
	 $readmemh("SuperMarioStanding.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule 

module SuperMarioRunning1RAM
(
		input [23:0] data_In,
		input [8:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:511];
initial
begin
	 $readmemh("SuperMario-1.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule 

module SuperMarioRunning2RAM
(
		input [23:0] data_In,
		input [8:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:511];
initial
begin
	 $readmemh("SuperMario-2.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule 

module SuperMarioRunning3RAM
(
		input [23:0] data_In,
		input [8:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:511];
initial
begin
	 $readmemh("SuperMario-3.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule 

module SuperMarioJumpingRAM
(
		input [23:0] data_In,
		input [8:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:511];
initial
begin
	 $readmemh("SuperMarioJumping.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule 
 
 
 
/*** END OF BIG MARIO ***/
 
 
module marioStandingRAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:255];
initial
begin
	 $readmemh("MarioStanding16x16.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module marioJumpingRAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:255];
initial
begin
	 $readmemh("MarioJumping.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module marioRunning1RAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
	 $readmemh("MarioRun1-16x16.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module marioRunning2RAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
	 $readmemh("MarioRun2-16x16.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module marioRunning3RAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
	 $readmemh("MarioRun3-16x16.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module floorRAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
	 $readmemh("floor_brick.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module blockRAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
	 $readmemh("BrickBlockBrown.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module mushroomRAM
(
		input [23:0] data_In,
		input [7:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:255];
initial
begin
	 $readmemh("mushroom.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

module cloudRAM
(
		input [23:0] data_In,
		input [9:0] write_address, read_address,
		input we, Clk,

		output logic [23:0] data_Out
);


logic [23:0] mem [0:767];
initial
begin
	 $readmemh("cloud.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule


module thankyouROM 
(
        input [23:0] data_In,
        input [13:0] read_address, write_address,
        input Clk,we,

        output logic [23:0] data_Out
);


logic [23:0] mem [0:11552-1];

initial
begin
     $readmemh("thankyou.txt", mem);
end

always_ff @ (posedge Clk) begin
    if (we)
            mem[write_address] <= data_In;
    data_Out<= mem[read_address];
end
endmodule
