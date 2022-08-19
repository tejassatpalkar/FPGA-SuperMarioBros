//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, prev_last_direction, superMario, startScreen,
					input [7:0] keycode, keycode2,
					input logic [39:0] grid [30], 
					input logic [39:0] mushroom_grid[30], 
					input logic [39:0] peach_grid[30], 
					input logic [9:0] GoomX, GoomY,
					output current_jump, eighth_frame_clk, last_direction, collision, initGameOver, killGoomba, peach,
               output [9:0] BallX, BallY);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size, width, height, new_velocity, grid_X, grid_Y;
	 logic [9:0] grid_X_right, grid_Y_right;
	 logic prev_state;
	 
	 logic [9:0] bottom, right; 
    assign bottom = Ball_Y_Pos + height; 
    assign right = Ball_X_Pos + width;
	 
    parameter [9:0] Ball_X_Center=3;  // Center position on the X axis
    logic [9:0] Ball_Y_Center;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=3;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max= 479 - 32 + 1;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

	 jump mario_jump(.Clk(frame_clk), .Reset(Reset), .keycode(keycode), .keycode2(keycode2), .current_jumping(current_jumping), .Ball_Y_Pos(Ball_Y_Pos), .Y_Velocity(new_velocity));

	 // Mario!
	 always_comb
	 begin
	 		
		if (superMario == 1)
		begin
			width = 16;
			height = 32;
		end
		
		else
		begin
			width = 16;
			height = 16;
		end
		
		Ball_Y_Center = 479 - 32 - height + 1;

	 end
	 
	 logic current_jumping;
	 logic on_block, on_peach;
	 logic half_frame_clk, quarter_frame_clk;
	 
	 always_ff @ (posedge frame_clk or posedge Reset )
    begin 
        if (Reset) 
            half_frame_clk <= 1'b0;
        else 
            half_frame_clk <= ~ (half_frame_clk);
    end
	 
	 always_ff @ (posedge half_frame_clk or posedge Reset )
    begin 
        if (Reset) 
            quarter_frame_clk <= 1'b0;
        else 
            quarter_frame_clk <= ~ (quarter_frame_clk);
    end
	 
	 always_ff @ (posedge quarter_frame_clk or posedge Reset )
    begin 
        if (Reset) 
            eighth_frame_clk <= 1'b0;
        else 
            eighth_frame_clk <= ~ (eighth_frame_clk);
    end
	 	 
always_comb begin
	collision = 0;
	on_block = 0;
	initGameOver = 0;
	killGoomba = 0;
	peach = 0;
	on_peach = 0;
	
	if (Ball_Y_Pos >= 479)
			initGameOver = 1;
	
	last_direction = prev_last_direction;

	Ball_X_Motion = 0;
	Ball_Y_Motion = 0;
	grid_X = Ball_X_Pos / 16; 
	grid_Y = Ball_Y_Pos / 16; 
	grid_X_right = (Ball_X_Pos + width) / 16;
	grid_Y_right = (Ball_Y_Pos + height) / 16;
	
	if (((Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos + width >= 0 && Ball_X_Pos + width < 112) || (Ball_X_Pos + width > 143))) || (grid[grid_Y_right][grid_X]) || (grid[grid_Y_right][grid_X_right]))
		current_jumping = 0;
	else if (((Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos >= 0 && Ball_X_Pos < 112) || Ball_X_Pos > 143)) || (grid[grid_Y_right][grid_X]) || (grid[grid_Y_right][grid_X_right]))
		current_jumping = 0;
	else
		current_jumping = 1;

//	if ((Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos + width >= 0 && Ball_X_Pos + width < 112) || (Ball_X_Pos + width > 143)))
//		current_jumping = 0;
//	else if (((Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos >= 0 && Ball_X_Pos < 112) || Ball_X_Pos > 143)))
//		current_jumping = 0;
//	else
//		current_jumping = 1;
		
	 
	if (current_jumping)
		begin
			Ball_Y_Motion = new_velocity;
			
			if ((Ball_Y_Motion + Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos + width >= 0 && Ball_X_Pos + width < 112) || (Ball_X_Pos + width > 143 && Ball_X_Pos + width < 192) || (Ball_X_Pos + width > 223)))
				 Ball_Y_Motion = Ball_Y_Max - Ball_Y_Pos - height;
			
			if ((Ball_Y_Motion + Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos >= 0 && Ball_X_Pos < 112) || (Ball_X_Pos > 143 && Ball_X_Pos < 192) || (Ball_X_Pos > 223)))
				 Ball_Y_Motion = Ball_Y_Max - Ball_Y_Pos - height;
			 
			
			if (keycode == 8'h04 || keycode2 == 8'h04)
			begin
				if ($signed(Ball_Y_Pos) <= $signed(Ball_Y_Min))
					begin
						Ball_Y_Motion = 0;
					end
				if ($signed(Ball_X_Pos) <= (Ball_X_Min))
					begin
						Ball_X_Motion = 0;
					end
				else 
					begin
					Ball_X_Motion = -1;
					end
			end
				
			if (keycode == 8'h07 || keycode2 == 8'h07)
				begin
				if ($signed(Ball_Y_Pos) <= $signed(Ball_Y_Min)) // TODO: split these statements across all of em? 
					begin
						Ball_Y_Motion = 0;
					end
				if ((Ball_X_Pos + width) >= Ball_X_Max)
					begin
						Ball_X_Motion = 0;
					end
				else
					begin
						Ball_X_Motion = 1;
					end
			end

			grid_X = (Ball_X_Pos + Ball_X_Motion) / 16; 
			grid_Y = (Ball_Y_Pos + Ball_Y_Motion) / 16;
			
			grid_X_right = (Ball_X_Pos + width + Ball_X_Motion) / 16; // check the right of mario
			grid_Y_right = (Ball_Y_Pos + height + Ball_Y_Motion) / 16; // check the bottom of mario
			
			if (grid[grid_Y][grid_X]) // there is a collision on the bottom of the block
				begin
					// Now check the case type
					Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
				end
			if (grid[grid_Y_right][grid_X]) // collision on top of the block
				begin
					Ball_Y_Motion = ((grid_Y_right) * 16) - (Ball_Y_Pos + height);
				end
				
			if (grid[grid_Y][grid_X_right]) // there is a collision on the bottom of the blcok
				begin
					Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
				end
			if (grid[grid_Y_right][grid_X_right]) // collision on top of the block
				begin
					Ball_Y_Motion = (grid_Y_right * 16) - (Ball_Y_Pos + height);
				end
				
				
//			if (grid[grid_Y][grid_X_right]) // collision on left of block
//				begin
//					Ball_X_Motion = ((grid_X_right) * 16) - (Ball_X_Pos + width);
//				end
//				
//			if (grid[grid_Y][grid_X]) // collision on right of block
//				begin
//					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
//				end


        /****** GOOMBA*****/
        if (Ball_X_Pos + Ball_X_Motion >= GoomX && Ball_X_Pos + Ball_X_Motion < GoomX + width && bottom < GoomY && bottom + Ball_Y_Motion >= GoomY ) 
            begin
					killGoomba = 1; 
            end

        
        if (right + Ball_X_Motion >= GoomX && right + Ball_X_Motion < GoomX + width && bottom < GoomY && bottom + Ball_Y_Motion >= GoomY) 
            begin
					killGoomba = 1; 
            end
		  /****** GOOMBA*****/
		  
		  if (peach_grid[grid_Y][grid_X]) // there is a collision on the bottom of the block
				begin
					// Now check the case type
					Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
				end
			if (peach_grid[grid_Y_right][grid_X]) // collision on top of the block
				begin
					Ball_Y_Motion = ((grid_Y_right) * 16) - (Ball_Y_Pos + height);
				end
				
			if (peach_grid[grid_Y][grid_X_right]) // there is a collision on the bottom of the blcok
				begin
					Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
				end
			if (peach_grid[grid_Y_right][grid_X_right]) // collision on top of the block
				begin
					Ball_Y_Motion = (grid_Y_right * 16) - (Ball_Y_Pos + height);
				end

	end

	else
		begin
			
			if ( (Ball_Y_Pos + height) >= Ball_Y_Max )  
				begin
					Ball_Y_Motion = 0;  
					Ball_X_Motion = 0;
				end
					  
					  
			else if ( Ball_Y_Pos <= Ball_Y_Min )  
				begin
					Ball_Y_Motion = 0;
					Ball_X_Motion = 0;
				end
					  
			else if ( (Ball_X_Pos + width) >= Ball_X_Max )  
				begin
					Ball_X_Motion = 0;  
					Ball_Y_Motion = 0;
				end
					  
			else if ( Ball_X_Pos <= Ball_X_Min )  
				begin
					Ball_X_Motion = 0;
					Ball_Y_Motion = 0;
				end
				 
			case (keycode) // this is the most recent key press. The array itself is a queue. 
				 
					/* left */
				8'h04 : begin
							case(keycode2)
							8'h07 : begin // A and D have been pressed
									Ball_Y_Motion = 0;
									Ball_X_Motion = 0;
									end
							8'h1A : begin // A and W have been pressed
																	
										if ($signed(Ball_Y_Pos) <= $signed(Ball_Y_Min))
											begin
												Ball_Y_Motion = 0;
											end
										if ((Ball_X_Pos) <= (Ball_X_Min))
											begin
												Ball_X_Motion = 0;
											end
												
										else
											begin
												Ball_Y_Motion = -10;
												Ball_X_Motion = -1;
											end
									end
							default : begin
										if ((Ball_X_Pos) <= (Ball_X_Min))
											begin
												Ball_Y_Motion = 0;
												Ball_X_Motion = 0;
											end
										else
											begin
												Ball_X_Motion = -1;//A
												Ball_Y_Motion = 0;
											end
									end
							endcase

							
						end
								
					/* right */
				8'h07 : begin
							case(keycode2)
							8'h04 : begin // D and A have been pressed
									Ball_Y_Motion = 0;
									Ball_X_Motion = 0;
									end
							8'h1A : begin // D and W have been pressed
										
										if ($signed(Ball_Y_Pos) <= $signed(Ball_Y_Min)) // TODO: split these statements across all of em? 
											begin
												Ball_Y_Motion = 0;
											end
										if ((Ball_X_Pos + width) >= Ball_X_Max)
											begin
												Ball_X_Motion = 0;
											end
												
										else
											begin
												Ball_Y_Motion = -10;
												Ball_X_Motion = 1;
											end
									end
							default: begin
									if ((Ball_X_Pos + width) >= Ball_X_Max)
										begin
											Ball_Y_Motion = 0;
											Ball_X_Motion = 0;
										end
									else
										begin
											Ball_X_Motion = 1;//D
											Ball_Y_Motion = 0;
										end
									end
							endcase

						end
							  
					/* down */
				8'h16 : begin	//TODO: handle the other key presses 
							if ((Ball_Y_Pos + height) >= Ball_Y_Max )
								begin
									Ball_Y_Motion = 0;
									Ball_X_Motion = 0;
								end
							else
								begin
									Ball_Y_Motion = 0;//S
									Ball_X_Motion = 0;
								end

						end
								
					/* up */
				8'h1A : begin
												
							case(keycode2)
							8'h04 : begin // W and A have been pressed
										if ($signed(Ball_Y_Pos) <= $signed(Ball_Y_Min))
											begin
												Ball_Y_Motion = 0;
											end
										if ((Ball_X_Pos) <= (Ball_X_Min))
											begin
												Ball_X_Motion = 0;
											end
												
										else
											begin
												Ball_Y_Motion = -10;
												Ball_X_Motion = -1;
											end
									end
							8'h07 : begin // W and D have been pressed
										if ($signed(Ball_Y_Pos) <= $signed(Ball_Y_Min)) // TODO: split these statements across all of em? 
											begin
												Ball_Y_Motion = 0;
											end
										if ((Ball_X_Pos + width) >= Ball_X_Max)
											begin
												Ball_X_Motion = 0;
											end
												
										else
											begin
												Ball_Y_Motion = -10;
												Ball_X_Motion = 1;
											end
									end
							default : begin // Just the W key has been pressed
										if ($signed(Ball_Y_Pos) <= $signed(Ball_Y_Min))
											begin
												Ball_Y_Motion = 0;
												Ball_X_Motion = 0;
											end	  
										else
											begin
												Ball_Y_Motion = -10;
												Ball_X_Motion = 0;
											end	
									end
							endcase
							
						end
			endcase
			
		grid_X = (Ball_X_Pos + Ball_X_Motion) / 16; 
		grid_Y = (Ball_Y_Pos + Ball_Y_Motion) / 16;
			
		grid_X_right = (Ball_X_Pos + width + Ball_X_Motion) / 16; // check the right of mario
		grid_Y_right = (Ball_Y_Pos + height + Ball_Y_Motion) / 16;		

		if (grid[grid_Y][grid_X]) // there is a collision on the bottom of the block
			begin
				Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
			end
		else if (grid[grid_Y_right][grid_X]) // collision on top of the block
			begin
				Ball_Y_Motion = (grid_Y_right * 16) - (Ball_Y_Pos + height);
				on_block = 1;
			end
			
		else if (grid[grid_Y][grid_X_right]) // there is a collision on the bottom of the block
			begin
				Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
			end
		else if (grid[grid_Y_right][grid_X_right]) // collision on top of the block
			begin
				Ball_Y_Motion = ((grid_Y_right) * 16) - (Ball_Y_Pos + height);
				on_block = 1;
			end
							
		if (on_block == 0) 
		begin
		
			if (grid[grid_Y][grid_X_right]) // collision on left of block
				begin
					Ball_X_Motion = ((grid_X_right) * 16) - (Ball_X_Pos + width);
					Ball_Y_Motion = 0;
				end
				
			if (grid[grid_Y][grid_X]) // collision on right of block
				begin
					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
					Ball_Y_Motion = 0;
				end
				
			if (grid[grid_Y_right][grid_X_right]) // collision on left of block
				begin
					Ball_X_Motion = ((grid_X_right) * 16) - (Ball_X_Pos + width);
					Ball_Y_Motion = 0;
				end
				
			if (grid[grid_Y_right][grid_X]) // collision on right of block
				begin
					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
					Ball_Y_Motion = 0;
				end
		end
		else
		begin
			if (grid[grid_Y][grid_X_right])
				begin
					Ball_X_Motion = ((grid_X_right * 16) - (Ball_X_Pos + width));
				end
				
		end
		
		/* mushroom collision */
		
		if (mushroom_grid[grid_Y][grid_X]) // there is a collision on the bottom of the block
			begin
				collision = 1;
			end
		if (mushroom_grid[grid_Y_right][grid_X]) // collision on top of the block
			begin
				collision = 1;
			end
			
		if (mushroom_grid[grid_Y][grid_X_right]) // there is a collision on the bottom of the block
			begin
				collision = 1;
			end
		if (mushroom_grid[grid_Y_right][grid_X_right]) // collision on top of the block
			begin
				collision = 1;
			end
		
		if (mushroom_grid[grid_Y][grid_X_right]) // collision on left of block
			begin
				collision = 1;
			end
			
		if (mushroom_grid[grid_Y][grid_X]) // collision on right of block
			begin
				collision = 1;
			end
			
		if (mushroom_grid[grid_Y_right][grid_X_right]) // collision on left of block
			begin
				collision = 1;
			end
			
		if (mushroom_grid[grid_Y_right][grid_X]) // collision on right of block
			begin
				collision = 1;
			end
			
		/* END of mushroom collision */
		
		
		/* peach collision */
		
		if (peach_grid[grid_Y][grid_X]) // there is a collision on the bottom of the block
			begin
				peach = 1;
				Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
			end
		else if (peach_grid[grid_Y_right][grid_X]) // collision on top of the block
			begin
				Ball_Y_Motion = (grid_Y_right * 16) - (Ball_Y_Pos + height);
				on_peach = 1;
				peach = 1;

			end
			
		else if (peach_grid[grid_Y][grid_X_right]) // there is a collision on the bottom of the block
			begin
				Ball_Y_Motion = (grid_Y * 16) + 16 - Ball_Y_Pos; 
				peach = 1;

			end
		else if (peach_grid[grid_Y_right][grid_X_right]) // collision on top of the block
			begin
				Ball_Y_Motion = ((grid_Y_right) * 16) - (Ball_Y_Pos + height);
				on_peach = 1;
				peach = 1;

			end
							
		if (on_peach == 0) 
		begin
		
			if (peach_grid[grid_Y][grid_X_right]) // collision on left of block
				begin
					Ball_X_Motion = ((grid_X_right) * 16) - (Ball_X_Pos + width);
					Ball_Y_Motion = 0;
					peach = 1;

				end
				
			if (peach_grid[grid_Y][grid_X]) // collision on right of block
				begin
					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
					Ball_Y_Motion = 0;
					peach = 1;

				end
				
			if (peach_grid[grid_Y_right][grid_X_right]) // collision on left of block
				begin
					Ball_X_Motion = ((grid_X_right) * 16) - (Ball_X_Pos + width);
					Ball_Y_Motion = 0;
					peach = 1;

				end
				
			if (peach_grid[grid_Y_right][grid_X]) // collision on right of block
				begin
					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
					Ball_Y_Motion = 0;
					peach = 1;

				end
		end
		else
		begin
			if (peach_grid[grid_Y][grid_X_right])
				begin
					Ball_X_Motion = ((grid_X_right * 16) - (Ball_X_Pos + width));
					peach = 1;

				end
				
		end
			
		/* END of peach collision */
		
		/* Take care of case where middle of big mario collides */
		if (superMario && on_block == 0)
		begin
			if (grid[grid_Y + 1][grid_X_right]) // collision on left of block
				begin
					Ball_X_Motion = ((grid_X_right) * 16) - (Ball_X_Pos + width);
					Ball_Y_Motion = 0;
				end
				
			if (grid[grid_Y + 1][grid_X]) // collision on right of block
				begin
					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
					Ball_Y_Motion = 0;
				end
				
			if (grid[grid_Y_right][grid_X_right]) // collision on left of block
				begin
					Ball_X_Motion = ((grid_X_right) * 16) - (Ball_X_Pos + width);
					Ball_Y_Motion = 0;
				end
				
			if (grid[grid_Y_right][grid_X]) // collision on right of block
				begin
					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
					Ball_Y_Motion = 0;
				end
		
		end
		
		if (superMario && on_block == 1)
		begin
			if (grid[grid_Y + 1][grid_X_right])
				begin
					Ball_X_Motion = ((grid_X_right * 16) - (Ball_X_Pos + width));
				end
				
			 if (grid[grid_Y + 1][grid_X]) // collision on right of block
				begin
					Ball_X_Motion = (grid_X * 16) + 16 - (Ball_X_Pos);
				end
		end
				
		
		 /*************************************** Goomba********************************/

    
		if ((Ball_X_Pos + Ball_X_Motion >= GoomX) && (Ball_X_Pos + Ball_X_Motion <= GoomX + width) && (Ball_Y_Pos + 2 + Ball_Y_Motion >= GoomY) && (Ball_Y_Pos + 2 + Ball_Y_Motion <= GoomY + height))
			begin
				initGameOver = 1;
			end
		if ((right + Ball_X_Motion >= GoomX) && (right + Ball_X_Motion <= GoomX + width) && (Ball_Y_Pos + 2 + Ball_Y_Motion >= GoomY) && (Ball_Y_Pos + 2 + Ball_Y_Motion <= GoomY + height))
			begin
				initGameOver = 1; 
			end
            
       /**************************************END GOOMBA******************************/
		
		
	end 
	
	if ($signed(Ball_X_Motion) > 0)
		last_direction = 1;
		
	if ($signed(Ball_X_Motion) < 0)
		last_direction = 0;	
		
	if ((Ball_Y_Motion + Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos + width >= 0 && Ball_X_Pos + width < 112) || (Ball_X_Pos + width > 143)))
		Ball_Y_Motion = Ball_Y_Max - Ball_Y_Pos - height;
		
	if ((Ball_Y_Motion + Ball_Y_Pos + height >= Ball_Y_Max) && ((Ball_X_Pos >= 0 && Ball_X_Pos < 112) || (Ball_X_Pos > 143)))
		Ball_Y_Motion = Ball_Y_Max - Ball_Y_Pos - height;

		
end
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        
		  if (Reset)  // Asynchronous Reset
        begin 
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end 
		  
		  else if (startScreen)
		  begin
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
		  end
		  
		  else 
		  begin
				
				Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
										 
			end
		
	 end
			       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
	 
	 assign current_jump = current_jumping;
	 

endmodule
