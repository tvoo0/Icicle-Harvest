`timescale 1ns / 1ps
/*
icicle state machine will have three states:
1. Idle state: In this state, this is before Go is on meaning the game has not started so nothing should be happening
2. Color State: In this state, Go is on signaling the state of the game. Color is randomly chosen and then waits randomly chosen time between 2-3.5 seconds
3. Fade State: In this state, after a time between 2-3.5 seconds has passed, icicle fades in by increasing intensity. Once color is at max, go to next state
4. Drop State: In this state, When color components are max, icicle drops at 3 pixels per frame until hit by player or disappears into water. If it goes into water, transition back to color state.
5. Hit state: In this state, if icicle is hit by player, icicle stops and flashes for 2 seconds. Once two seconds are up, transition back to start state.
*/


module IcicleStateMachine(
    input clk,
    input Go,
    input Color,
    input MaxColor,
    input T2,
    input HitSlug,
    input HitWater,
    output PickColor,
    input waitTimeDone,
    output IncScore,
    output DecScore,
    output RTimer,
    output ResetIcicle,
    output [4:0] States
    );

    wire [4:0] stateOut, Q;
    
    assign stateOut[0] = (Q[0] & ~Go); // Idle
    assign stateOut[1] = (Q[0] & Go) | (Q[1] & ~waitTimeDone) | (Q[3] & HitWater) | (Q[4] & T2); // wait
    assign stateOut[2] = (Q[2] & ~MaxColor) | (Q[1] & waitTimeDone); // Color and fade
    assign stateOut[3] = (Q[2] & MaxColor) | (Q[3] & ~HitWater) | (Q[3] & ~HitSlug); // Drop
    assign stateOut[4] = (Q[3] & HitSlug) | (Q[4] & ~T2); // Hit
    
    // outputs
    assign PickColor = (Q[1] & waitTimeDone);
    assign IncScore = (Q[3] & HitSlug & T2) & Color;
    assign DecScore = (Q[3] & HitSlug & T2) & ~Color;
    assign ResetIcicle = (Q[0] & Go) | (Q[4] & T2) | (Q[3] & HitWater);
    assign RTimer = (Q[0] & Go) | (Q[3] & HitWater) | (Q[4] & T2);
    assign States = stateOut[4:0];

    FDRE #(.INIT(1'b1)) stateQ0FF (.C(clk), .R(1'b0), .CE(1'b1), .D(stateOut[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) stateQ1234FF[4:1] (.C({4{clk}}), .R(4'b0), .CE({4{1'b1}}), .D(stateOut[4:1]), .Q(Q[4:1]));
    
endmodule