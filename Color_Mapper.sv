//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module color_mapper ( input [9:0] BallX, BallY, DrawX, DrawY, GoomX, GoomY,
								input clk, blank, VGA_CLK, current_jumping, last_direction, mushroom_on, superMario, gameover, startScreen, win,
								input [1:0] which_mario,
								input logic goomba_alive, which_goomba,
								output logic [39:0] grid [30], 
								output logic [39:0] peach_grid [30],
								output logic [39:0] mushroom_grid[30],
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, goom_on;
	 logic blockDrawing;
	 logic prev_state;
	 
	 logic [9:0] mario_addy, goom_addy; 
	 logic [9:0] superMario_addy;
	 logic [9:0] block_addy, floor_addy;
	 logic [9:0] cloud_addy, mushroom_addy;
	 logic [11:0] go_addy;
	 logic [8:0] princess_addy;
	 logic [14:0] logo_addy;
	 logic [13:0] enter_addy, ty_addy;
	 
	 logic [23:0] rgb_standing; // current mario pixel color
	 logic [23:0] rgb_running1, rgb_running2, rgb_running3, rgb_jumping;
	 logic [23:0] rgb_super_standing, rgb_super_running1, rgb_super_running2, rgb_super_running3, rgb_super_jumping;

	 logic [23:0] block_rgb, floor_rgb, princess_rgb; 
	 logic [23:0] cloud_rgb, mushroom_rgb, go_rgb;
	 logic [23:0] goomba_rgb, goomba_rgb1, goomba_rgb2, enter_rgb, logo_rgb, ty_rgb;
	 
	 logic [7:0] BlockX, BlockY, MushroomX, MushroomY, goX, goY;
	 logic [9:0] CloudX, CloudY, PrinX, PrinY, LogoX, LogoY, EnterX, EnterY, TyX, TyY;
	 
	 logic [23:0] background_color, brickcolor;
	 logic [23:0] skycolor;
	 logic [9:0] DrawXMod, DrawYMod; 
	 
	 assign skycolor = 24'h3cbcfc;
	 	
	 assign logo_addy = (DrawX - LogoX) + (DrawY - LogoY) * 205; 
	 assign enter_addy = (DrawX - EnterX) + (DrawY - EnterY) * 175; // 175 x 66
	 assign ty_addy = (DrawX - TyX) + (DrawY - TyY) * 304;

	 assign LogoX = 217;
	 assign LogoY = 120;
	 assign TyX = 168; 
	 assign TyY = 32; 
	 
	 always_comb
	 begin
	 
		for (int i = 0; i < 30; i++)
		begin
			
			for (int j = 0; j < 40; j++)
			
			begin
				if ((i == 15 && j == 39) || (i == 14 && j == 39))
					peach_grid[i][j] = 1;
				else
					peach_grid[i][j] = 0;
			
			end
		
		end
	 
	 end
	 
	 /* GAME WIN SCREEN */ 
	 thankyouROM ty(.read_address(ty_addy), .we(0), .Clk(clk), .data_Out(ty_rgb));
	 
	 /* TITLE SCREEN */
	 logoROM lg(.read_address(logo_addy), .we(0), .Clk(clk), .data_Out(logo_rgb));
	 enterROM er(.read_address(enter_addy), .we(0), .Clk(clk), .data_Out(enter_rgb));
	 
	 gameOverRAM too_bad(.read_address(go_addy), .we(0), .Clk(clk), .data_Out(go_rgb));
	 
	 /* MARIO */ 
	 
	 marioStandingRAM Mario(.read_address(mario_addy), .we(0), .Clk(clk), .data_Out(rgb_standing));
	 
	 marioRunning1RAM MarioRunning1(.read_address(mario_addy), .we(0), .Clk(clk), .data_Out(rgb_running1));
	 
	 marioRunning2RAM MarioRunning2(.read_address(mario_addy), .we(0), .Clk(clk), .data_Out(rgb_running2));
	 
	 marioRunning3RAM MarioRunning3(.read_address(mario_addy), .we(0), .Clk(clk), .data_Out(rgb_running3));
	 
	 marioJumpingRAM MarioJump(.read_address(mario_addy), .we(0), .Clk(clk), .data_Out(rgb_jumping));
	 
	 /** superMario BEGIN **/
	 
	 SuperMarioStandingRAM superMarioStanding(.read_address(superMario_addy), .we(0), .Clk(clk), .data_Out(rgb_super_standing));
	 
	 SuperMarioRunning1RAM superMarioRunning1(.read_address(superMario_addy), .we(0), .Clk(clk), .data_Out(rgb_super_running1));
	 
	 SuperMarioRunning2RAM superMarioRunning2(.read_address(superMario_addy), .we(0), .Clk(clk), .data_Out(rgb_super_running2));
	 
	 SuperMarioRunning3RAM superMarioRunning3(.read_address(superMario_addy), .we(0), .Clk(clk), .data_Out(rgb_super_running3));
	 
	 SuperMarioJumpingRAM superMarioJump(.read_address(superMario_addy), .we(0), .Clk(clk), .data_Out(rgb_super_jumping));
	 
	 /** superMario END **/
	 
	 blockRAM block(.read_address(block_addy), .we(0), .Clk(clk), .data_Out(block_rgb)); // block Mario can jump on
	 
	 floorRAM floor_block(.read_address(floor_addy), .we(0), .Clk(clk), .data_Out(floor_rgb));
	 
	 cloudRAM cloud(.read_address(cloud_addy), .we(0), .Clk(clk), .data_Out(cloud_rgb));
	 
	 mushroomRAM mushroom(.read_address(mushroom_addy), .we(0), .Clk(clk), .data_Out(mushroom_rgb));
	 
	 /** Goomba and Princess **/
	 
	 goomba1RAM goomba(.read_address(goom_addy), .we(0), .Clk(clk), .data_Out(goomba_rgb1));
	 goomba2RAM goomba2(.read_address(goom_addy), .we(0), .Clk(clk), .data_Out(goomba_rgb2));
	 princessRAM prin(.read_address(princess_addy), .we(0), .Clk(clk), .data_Out(princess_rgb));
	 
	 /** Goomba and Princess END **/
	 assign go_addy = (DrawX - goX) + (DrawY - goY) * 168;
	 assign floor_addy = (DrawX % 16) + (DrawY % 16) * 16;
	 assign block_addy = (DrawX - BlockX) + (DrawY - BlockY) * 16;
	 assign cloud_addy = (DrawX - CloudX) + (DrawY - CloudY) * 32; // 32 by 24
	 assign mushroom_addy = (DrawX - MushroomX) + (DrawY - MushroomY) * 16;
	 
	 assign princess_addy = (DrawX - PrinX) + (DrawY - PrinY) * 16; // 32 by 24
    assign goom_addy = (DrawX - GoomX) + (DrawY - GoomY) * 16;
	 
	 assign DrawXMod = DrawX / 16; 
	 assign DrawYMod = DrawY / 16; 
	 
	 always_comb
    begin: goomba_mux
	 
		if (~which_goomba)
        goomba_rgb = goomba_rgb1; 
		else 
        goomba_rgb = goomba_rgb2;
		  
    end
	 
	 always_comb 
	 begin 
	 if ((DrawX >= GoomX) && (DrawX < GoomX + 16) && (DrawY >= GoomY) && (DrawY < GoomY + 16))
		goom_on = 1'b1;
		
    else
		goom_on = 1'b0;
	 end 
	 
	 always_comb begin
	
			BlockX = DrawX;
			BlockY = DrawY;
			
			CloudX = DrawX;
			CloudY = DrawY;
	 
	 /** BLOCKS **/
	 
//	 if (DrawY < 368 && DrawY > 351 && DrawX > 31 && DrawX < 48)
//		begin
//			BlockX = 32;
//			BlockY = 352;
//
//		end
		
	 /* STAIR */
	 if (DrawY < 448 && DrawY > 431 && DrawX > 79 && DrawX < 96)
		begin			
			BlockX = 80;
			BlockY = 432;
			
		end
		
	 if (DrawY < 448 && DrawY > 431 && DrawX > 95 && DrawX < 112)
		begin			
			BlockX = 96;
			BlockY = 432;	
			
		end
		
	 if (DrawY < 432 && DrawY > 415 && DrawX > 95 && DrawX < 112)
		begin			
			BlockX = 96;
			BlockY = 416;	
			
		end
		
	 /* STAIR */
		
	 if (DrawY < 400 && DrawY > 383 && DrawX > 143 && DrawX < 160)
		begin			
			BlockX = 144;
			BlockY = 384;	

		end
		
	 if (DrawY < 400 && DrawY > 383 && DrawX > 159 && DrawX < 176)
		begin			
			BlockX = 160;
			BlockY = 384;	

		end
				
	 if (DrawY < 400 && DrawY > 383 && DrawX > 175 && DrawX < 192)
		begin
			BlockX = 176;
			BlockY = 384;

		end
	
	 /* GROUP */
	 if (DrawY < 368 && DrawY > 351 && DrawX > 223 && DrawX < 240)
		begin
			BlockX = 224;
			BlockY = 352;

		end
		
	 if (DrawY < 368 && DrawY > 351 && DrawX > 239 && DrawX < 256)
		begin
			BlockX = 240;
			BlockY = 352;

		end
				
	 if (DrawY < 368 && DrawY > 351 && DrawX > 255 && DrawX < 272)
		begin
			BlockX = 256;
			BlockY = 352;

		end
	 /* GROUP */
	 
	 /* GROUP2 */
	 if (DrawY < 352 && DrawY > 335 && DrawX > 303 && DrawX < 320)
		begin
			BlockX = 304;
			BlockY = 336;

		end
		
	 if (DrawY < 352 && DrawY > 335 && DrawX > 319 && DrawX < 336)
		begin
			BlockX = 320;
			BlockY = 336;

		end
				
	 if (DrawY < 352 && DrawY > 335 && DrawX > 335 && DrawX < 352)
		begin
			BlockX = 336;
			BlockY = 336;

		end
	 /* GROUP2 */
	 
	 /* GROUP3 */
	 if (DrawY < 320 && DrawY > 303 && DrawX > 383 && DrawX < 400)
		begin
			BlockX = 384;
			BlockY = 304;

		end
		
	 if (DrawY < 320 && DrawY > 303 && DrawX > 399 && DrawX < 416)
		begin
			BlockX = 400;
			BlockY = 304;

		end
				
	 /* GROUP3 */
	 
	 /* GROUP4 */
	 if (DrawY < 336 && DrawY > 319 && DrawX > 463 && DrawX < 480)
		begin
			BlockX = 464;
			BlockY = 320;

		end
	 /* GROUP4 */
	 
	 /* PYRAMID */
	 
	 /* Layer 1 */
	 if (DrawY < 320 && DrawY > 303 && DrawX > 511 && DrawX < 528)
		begin
			BlockX = 512;
			BlockY = 304;

		end
		
	 if (DrawY < 320 && DrawY > 303 && DrawX > 527 && DrawX < 544)
		begin
			BlockX = 528;
			BlockY = 304;

		end
				
	 if (DrawY < 320 && DrawY > 303 && DrawX > 543 && DrawX < 560)
		begin
			BlockX = 544;
			BlockY = 304;

		end
		
	 if (DrawY < 320 && DrawY > 303 && DrawX > 559 && DrawX < 576)
		begin
			BlockX = 560;
			BlockY = 304;
		end
		
	 if (DrawY < 320 && DrawY > 303 && DrawX > 575 && DrawX < 592)
		begin
			BlockX = 576;
			BlockY = 304;
		end
	 
	 /* Layer 2 */
		
	 if (DrawY < 304 && DrawY > 287 && DrawX > 527 && DrawX < 544)
		begin
			BlockX = 528;
			BlockY = 288;

		end
				
	 if (DrawY < 304 && DrawY > 287 && DrawX > 543 && DrawX < 560)
		begin
			BlockX = 544;
			BlockY = 288;

		end
		
	 if (DrawY < 304 && DrawY > 287 && DrawX > 559 && DrawX < 576)
		begin
			BlockX = 560;
			BlockY = 288;

		end
		
	 /* Layer 3 */
	 
	 if (DrawY < 288 && DrawY > 271 && DrawX > 543 && DrawX < 560)
		begin
			BlockX = 544;
			BlockY = 272;

		end
	 
	 
	 /* PYRAMID */

	 
	 /* PEACH */
	 if (DrawY < 272 && DrawY > 255 && DrawX > 607 && DrawX < 624)
		begin
			BlockX = 608;
			BlockY = 256;
		end
		
	 if (DrawY < 272 && DrawY > 255 && DrawX > 623 && DrawX < 640)
		begin
			BlockX = 624;
			BlockY = 256;
		end
		
	 /* PEACH */
	 
		
	 if (DrawY <= 447 && DrawY >= 432 && DrawX >= 384 && DrawX <= 399)
		begin
			BlockX = 384;
			BlockY = 432;
		end
		
	 if (DrawY < 448 && DrawY > 431 && DrawX > 479 && DrawX < 496)
		begin				
			BlockX = 480;
			BlockY = 432;
		end
	 
	 
	 
	  /** CLOUDS AND OTHER **/
	 
	 
	 if (DrawY < 120 && DrawY > 95 && DrawX > 387 && DrawX < 420)
		begin
			CloudX = 388;
			CloudY = 96;
			
		end
				
	 if (DrawY < 152 && DrawY > 127 && DrawX > 511 && DrawX < 544)
		begin
			CloudX = 512;
			CloudY = 128;
			
		end
		
	 if (DrawY < 152 && DrawY > 127 && DrawX > 239 && DrawX < 272)
		begin
			CloudX = 240;
			CloudY = 128;
			
		end
		
	 if (DrawY < 120 && DrawY > 95 && DrawX > 111 && DrawX < 144)
		begin
			CloudX = 112;
			CloudY = 96;
			
		end
	 
	 end
	 
    always_comb
    begin:Mario_on_proc
		 mario_addy = 0;
		 superMario_addy = 0;
	 
		 if (superMario == 0)
			 begin
				
				if (last_direction)
				
				begin
					mario_addy = (DrawX - BallX) + (DrawY - BallY) * 16;
					
					if ((DrawX >= BallX) && (DrawX < BallX + 16) && (DrawY >= BallY) && (DrawY < BallY + 16))
						ball_on = 1'b1;
				
					else 
						ball_on = 1'b0;
				end
					
				else
				
				begin
					mario_addy = (15 - (DrawX - BallX)) + (DrawY - BallY) * 16;
					
					if ((DrawX >= BallX) && (DrawX < BallX + 16) && (DrawY >= BallY) && (DrawY < BallY + 16))
						ball_on = 1'b1;
				
					else 
						ball_on = 1'b0;
				end
				
			 end
			 
		 else /** if mario is big **/
			 begin
				if (last_direction)
					
					begin
					
						superMario_addy = (DrawX - BallX) + (DrawY - BallY) * 16;
						
						if (prev_state != superMario)
						begin
							
							if ((DrawX >= BallX) && (DrawX < BallX + 16) && (DrawY >= (BallY - 16)) && (DrawY < (BallY - 16) + 32))
								ball_on = 1'b1;
					
							else 
								ball_on = 1'b0;
							
						end
						else
						begin
						
							if ((DrawX >= BallX) && (DrawX < BallX + 16) && (DrawY >= BallY) && (DrawY < BallY + 32))
								ball_on = 1'b1;
						
							else 
								ball_on = 1'b0;
						end
						
					end
						
					else
					begin
						superMario_addy = (15 - (DrawX - BallX)) + (DrawY - BallY) * 16;
						
						if (prev_state != superMario)
						begin
							
							if ((DrawX >= BallX) && (DrawX < BallX + 16) && (DrawY >= (BallY - 16)) && (DrawY < (BallY - 16) + 32))
								ball_on = 1'b1;
					
							else 
								ball_on = 1'b0;
							
						end
						else 
						begin
						
							if ((DrawX >= BallX) && (DrawX < BallX + 16) && (DrawY >= BallY) && (DrawY < BallY + 32))
								ball_on = 1'b1;
						
							else 
								ball_on = 1'b0;
							
						end
						
					end
					
			 end
end 
	  
	  
always_ff @(posedge VGA_CLK) begin

prev_state <= superMario;

if (blank == 1'b1)
begin

	if (startScreen)
	begin
		
	
		if (DrawY < 240 && DrawY >= 120 && DrawX >= 217 && DrawX < 217 + 205)
			begin
				  Red = logo_rgb[23:16];
				  Green = logo_rgb[15:8];
				  Blue = logo_rgb[7:0];
			end
      else if (DrawY < 366 && DrawY >= 300 && DrawX >= 232 && DrawX < 232 + 175)
			begin
			
				 if (enter_rgb == 24'hffffff)
				 begin
					 Red = skycolor[23:16]; 
					 Green = skycolor[15:8];
					 Blue = skycolor[7:0];
				 end
				 
				 else 
				 begin
					  EnterX = 232;
					  EnterY = 300;
					  Red = enter_rgb[23:16];
					  Green = enter_rgb[15:8];
					  Blue = enter_rgb[7:0];
				 end
			end
		else 
			begin
				Red = skycolor[23:16]; 
				Green = skycolor[15:8];
				Blue = skycolor[7:0];
			end
		
	end
	

	else if (gameover)
	begin
		Red = 8'h0;
		Green = 8'h0;
		Blue = 8'h0;
		
		if (DrawY < 250 && DrawY > 229 && DrawX > 235 && DrawX < 404)
		begin
			goX = 236;
			goY = 230;
			Red = go_rgb[23:16];
			Green = go_rgb[15:8];
			Blue = go_rgb[7:0];
		end
	end
	else begin
	
	if ((ball_on == 1'b1)) 
	begin 
		if (superMario == 0) begin
			if (rgb_standing == 24'hffffff && current_jumping == 0 && which_mario == 0)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else if (rgb_running1 == 24'hffffff && current_jumping == 0 && which_mario == 1)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else if (rgb_running2 == 24'hffffff && current_jumping == 0 && which_mario == 2)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
			
			else if (rgb_running3 == 24'hffffff && current_jumping == 0 && which_mario == 3)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else if (rgb_jumping == 24'hffffff && current_jumping == 1)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else
			
				begin
				
					if (current_jumping)
					begin
						Red = rgb_jumping[23:16]; 
						Green = rgb_jumping[15:8]; 
						Blue = rgb_jumping[7:0];
					end
					
					else
					begin
						if (which_mario == 0)
						begin
							Red = rgb_standing[23:16]; 
							Green = rgb_standing[15:8]; 
							Blue = rgb_standing[7:0];
						end
						
						else if (which_mario == 1)
						begin
							Red = rgb_running1[23:16]; 
							Green = rgb_running1[15:8]; 
							Blue = rgb_running1[7:0];
						end
						
						else if (which_mario == 2)
						begin
							Red = rgb_running2[23:16]; 
							Green = rgb_running2[15:8]; 
							Blue = rgb_running2[7:0];
						end
						
						else if (which_mario == 3)
						begin
							Red = rgb_running3[23:16]; 
							Green = rgb_running3[15:8]; 
							Blue = rgb_running3[7:0];
						end
						
					end
					
				end
				
			end
	
		if (superMario == 1) begin
			if (rgb_super_standing == 24'hffffff && current_jumping == 0 && which_mario == 0)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else if (rgb_super_running1 == 24'hffffff && current_jumping == 0 && which_mario == 1)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else if (rgb_super_running2 == 24'hffffff && current_jumping == 0 && which_mario == 2)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
			
			else if (rgb_super_running3 == 24'hffffff && current_jumping == 0 && which_mario == 3)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else if (rgb_super_jumping == 24'hffffff && current_jumping == 1)
				begin					
					Red = 8'h3c; 
					Green = 8'hbc;
					Blue = 8'hfc;
				end
				
			else
			
				begin
				
					if (current_jumping)
					begin
						Red = rgb_super_jumping[23:16]; 
						Green = rgb_super_jumping[15:8]; 
						Blue = rgb_super_jumping[7:0];
					end
					
					else
					begin
						if (which_mario == 0)
						begin
							Red = rgb_super_standing[23:16]; 
							Green = rgb_super_standing[15:8]; 
							Blue = rgb_super_standing[7:0];
						end
						
						else if (which_mario == 1)
						begin
							Red = rgb_super_running1[23:16]; 
							Green = rgb_super_running1[15:8]; 
							Blue = rgb_super_running1[7:0];
						end
						
						else if (which_mario == 2)
						begin
							Red = rgb_super_running2[23:16]; 
							Green = rgb_super_running2[15:8]; 
							Blue = rgb_super_running2[7:0];
						end
						
						else if (which_mario == 3)
						begin
							Red = rgb_super_running3[23:16]; 
							Green = rgb_super_running3[15:8]; 
							Blue = rgb_super_running3[7:0];
						end
						
					end
					
				end
				
		end
		
	end
	
	else 
	begin
	
		if (DrawY > 447) 
			begin
				if ((DrawX >= 0 && DrawX < 112) || (DrawX > 143))
					begin
						Red = floor_rgb[23:16]; 
						Green = floor_rgb[15:8];
						Blue = floor_rgb[7:0];
						
						grid[DrawYMod][DrawXMod] = 0;
					end
				else 
					begin
						Red = skycolor[23:16]; 
						Green = skycolor[15:8];
						Blue = skycolor[7:0];
						grid[DrawYMod][DrawXMod] = 0;
					end
				
			end
		
		else 
			begin
			
				blockDrawing = 0;
				
//				if (DrawY < 368 && DrawY > 351 && DrawX > 31 && DrawX < 48)
//				begin
//					blockDrawing = 1;
//					Red = block_rgb[23:16];
//					Green = block_rgb[15:8];
//					Blue = block_rgb[7:0];
//					grid[DrawYMod][DrawXMod] = 1;	
//				end
				
				if (DrawY < 448 && DrawY > 431 && DrawX > 79 && DrawX < 96)
				begin			
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;	
				end
					
				if (DrawY < 448 && DrawY > 431 && DrawX > 95 && DrawX < 112)
				begin			
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
					
				if (DrawY < 432 && DrawY > 415 && DrawX > 95 && DrawX < 112)
				begin			
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				if (DrawY < 400 && DrawY > 383 && DrawX > 143 && DrawX < 160)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				if (DrawY < 400 && DrawY > 383 && DrawX > 159 && DrawX < 176)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				if (DrawY < 400 && DrawY > 383 && DrawX > 175 && DrawX < 192)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				/** GROUP **/
				if (DrawY < 368 && DrawY > 351 && DrawX > 223 && DrawX < 240)
				begin
				   blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
		
				if (DrawY < 368 && DrawY > 351 && DrawX > 239 && DrawX < 256)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				if (DrawY < 368 && DrawY > 351 && DrawX > 255 && DrawX < 272)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				/** GROUP **/
				
				/* GROUP2 */
				if (DrawY < 352 && DrawY > 335 && DrawX > 303 && DrawX < 320)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				if (DrawY < 352 && DrawY > 335 && DrawX > 319 && DrawX < 336)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
						
				if (DrawY < 352 && DrawY > 335 && DrawX > 335 && DrawX < 352)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				/* GROUP2 */
				
				
				/* GROUP3 */
				if (DrawY < 320 && DrawY > 303 && DrawX > 383 && DrawX < 400)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				if (DrawY < 320 && DrawY > 303 && DrawX > 399 && DrawX < 416)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				/* GROUP3 */
				
				/* GROUP4 */
				if (DrawY < 336 && DrawY > 319 && DrawX > 463 && DrawX < 480)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				/* GROUP4 */
				
				
				/* PYRAMID */
	 
			 /* Layer 1 */
			 if (DrawY < 320 && DrawY > 303 && DrawX > 511 && DrawX < 528)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
			 if (DrawY < 320 && DrawY > 303 && DrawX > 527 && DrawX < 544)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
						
			 if (DrawY < 320 && DrawY > 303 && DrawX > 543 && DrawX < 560)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
			 if (DrawY < 320 && DrawY > 303 && DrawX > 559 && DrawX < 576)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
			 if (DrawY < 320 && DrawY > 303 && DrawX > 575 && DrawX < 592)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
			 
			 /* Layer 2 */
				
			 if (DrawY < 304 && DrawY > 287 && DrawX > 527 && DrawX < 544)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;

				end
						
			 if (DrawY < 304 && DrawY > 287 && DrawX > 543 && DrawX < 560)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;

				end
				
			 if (DrawY < 304 && DrawY > 287 && DrawX > 559 && DrawX < 576)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;

				end
				
			 /* Layer 3 */
			 
			 if (DrawY < 288 && DrawY > 271 && DrawX > 543 && DrawX < 560)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
			 
			 
			 /* PYRAMID */		
		
			 /* PEACH */
			 if (DrawY < 272 && DrawY > 255 && DrawX > 607 && DrawX < 624)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
			 if (DrawY < 272 && DrawY > 255 && DrawX > 623 && DrawX < 640)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
			 /* PEACH */
				
				
				if (DrawY < 448 && DrawY > 431 && DrawX > 479 && DrawX < 496)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				
				if (DrawY <= 447 && DrawY >= 432 && DrawX >= 384 && DrawX <= 399)
				begin
					blockDrawing = 1;
					Red = block_rgb[23:16];
					Green = block_rgb[15:8];
					Blue = block_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 1;
				end
				
				
				// mushroom
				if ((DrawY < 448 && DrawY > 431 && DrawX > 159 && DrawX < 176) && mushroom_on)
				begin
					blockDrawing = 1;
									
					MushroomX = 160;
					MushroomY = 432;
					
					if (mushroom_rgb == 24'hffffff)
					begin
						Red = skycolor[23:16]; 
						Green = skycolor[15:8];
						Blue = skycolor[7:0];
					end
					else
					begin
						Red = mushroom_rgb[23:16];
						Green = mushroom_rgb[15:8];
						Blue = mushroom_rgb[7:0];
					end
		
					mushroom_grid[DrawYMod][DrawXMod] = 1;
					
				end
				
				if ((DrawY < 448 && DrawY > 431 && DrawX > 159 && DrawX < 176) && mushroom_on == 0)
				begin
					mushroom_grid[DrawYMod][DrawXMod] = 0;
				end
				
				/** PRINCESS on the right TO-DOOOOO **/
				if (DrawX >= 624 && DrawX < 640 && DrawY >= 232 && DrawY < 256)
                begin
						blockDrawing = 1; 
						PrinX = 624; 
						PrinY = 232; 
						
						  if (princess_rgb == 24'hffffff)
							  begin
								Red = skycolor[23:16]; 
								Green = skycolor[15:8];
								Blue = skycolor[7:0];
							  end
						  else 
							  begin
								  Red = princess_rgb[23:16];
								  Green = princess_rgb[15:8];
								  Blue = princess_rgb[7:0];
							  end
					  
            end
				
				/** PRINCESS on the right TO-DOOOOO **/
				
				/** GOOMBA LOGIC **/
				if (goom_on && goomba_alive)
                begin
                    blockDrawing = 1;
                    
                    if (goomba_rgb == 24'hffffff)
                    begin
                        Red = skycolor[23:16]; 
                        Green = skycolor[15:8];
                        Blue = skycolor[7:0];
                    end
                    else
                    begin
                        Red = goomba_rgb[23:16];
                        Green = goomba_rgb[15:8];
                        Blue = goomba_rgb[7:0];
                    end
                    
                end
				
				/** GOOMBA LOGIC **/

				
				if (DrawY < 120 && DrawY > 95 && DrawX > 387 && DrawX < 420)
				begin
					blockDrawing = 1;
					Red = cloud_rgb[23:16];
					Green = cloud_rgb[15:8];
					Blue = cloud_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 0;
				end
				
				if (DrawY < 152 && DrawY > 127 && DrawX > 511 && DrawX < 544)
				begin
					blockDrawing = 1;
					Red = cloud_rgb[23:16];
					Green = cloud_rgb[15:8];
					Blue = cloud_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 0;
				end
				
				if (DrawY < 152 && DrawY > 127 && DrawX > 239 && DrawX < 272)
				begin
					blockDrawing = 1;
					Red = cloud_rgb[23:16];
					Green = cloud_rgb[15:8];
					Blue = cloud_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 0;
				end
					
				if (DrawY < 120 && DrawY > 95 && DrawX > 111 && DrawX < 144)
				begin
					blockDrawing = 1;
					Red = cloud_rgb[23:16];
					Green = cloud_rgb[15:8];
					Blue = cloud_rgb[7:0];
					grid[DrawYMod][DrawXMod] = 0;
				end
				
				if (blockDrawing == 0)
				begin
					Red = skycolor[23:16]; 
					Green = skycolor[15:8];
					Blue = skycolor[7:0];
					grid[DrawYMod][DrawXMod] = 0;
					
					if (win)
					begin
						if (DrawY < 32 + 38 && DrawY >= 32 && DrawX >= 168 && DrawX < 168 + 304)
							begin
				
							if (ty_rgb == 24'h000000)
								begin
								 Red = skycolor[23:16]; 
								 Green = skycolor[15:8];
								 Blue = skycolor[7:0];
							end
							else 
								begin
									Red = ty_rgb[23:16];
									Green = ty_rgb[15:8];
									Blue = ty_rgb[7:0];
								end
						end
					end
					
				end
				
			end
	end
	
	end
		
end
  
else // blanking region
	begin
		Red = 0;
		Green = 0;
		Blue = 0;
	end
end
    
endmodule
