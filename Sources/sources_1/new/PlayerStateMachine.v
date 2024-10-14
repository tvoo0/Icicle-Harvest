`timescale 1ns / 1ps
/*
player state machine will have three states:
1. Game state: In this state, the player can freely move before and after the game has begun
2. Hit State: In this state, the player will transition to this state when they hit an icicle in which after 2 seconds of the icicle flashing, it goes back to the game state
3. Lose State: In this state, 
*/


module PlayerStateMachine(
    input clk,
    input hit,
    input water,
    input T2,
    output Move,
    output Freeze
    );
       
    wire [2:0] stateOut, Q;
    
    
    assign stateOut[0] = (Q[0] & (~hit & ~water)) | (Q[1] & T2); // Game
    assign stateOut[1] = (Q[0] & hit) | (Q[1] & ~T2); // Hit
    assign stateOut[2] = (Q[0] & water); // Lose

    // outputs 
    assign Move = Q[0];
    assign Freeze = Q[1];
   
    FDRE #(.INIT(1'b1)) stateQ0FF (.C(clk), .R(1'b0), .CE(1'b1), .D(stateOut[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) stateQ12FF[2:1] (.C({2{clk}}), .R(2'b0), .CE({2{1'b1}}), .D(stateOut[2:1]), .Q(Q[2:1]));
endmodule