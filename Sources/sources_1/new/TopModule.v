`timescale 1ns / 1ps

module TopModule(
    input clkin,
    input btnR,
    input btnL,
    input btnU,
    input btnC,
    input btnD, // global reset button
    output [3:0] an,
    output dp,
    output [6:0] seg,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output [3:0] led,
    output Hsync,
    output Vsync
    );
    
    wire clk, digsel, qsec;
    
    wire [3:0] ringCounterOut;
    wire [3:0] selectorOut;
    wire [6:0] hex7segOut;
    wire [7:0] signChangerOut; 
    
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnD), .clk(clk), .digsel(digsel)); 
    
    // Instantiate RingCounter
    RingCounter ringCounter (.clk(clk), .Advance(digsel), .Qout(ringCounterOut));
    
    // Instantiate Selector    
    Selector selector (.N({8'b00000000, signChangerOut}), .sel(ringCounterOut), .H(selectorOut));    
    
    // Instantiate hex7seg
    wire negative;
    wire [7:0] ScoreCount;
    hex7seg hexDisplay (.n(selectorOut), .negative(ringCounterOut[2] & ScoreCount[7]), .seg(hex7segOut));


    // display hsync and vsync
    wire [15:0] Vrow, Hcolumn;
    wire [15:0] V_out, H_out;
    wire V_outsync, H_outsync;
    wire ActiveRegion;
    wire Water, LeftBorder, RightBorder, TopBorder, BottomBorder, Podium, Slug;
    wire [15:0] SlugHori, SlugVert;
    wire FlashSlug, FlashingIcicle;
    wire [3:0] time_counter, time_counter1, time_counter2, time_counter3, time_counter4, time_counter5, time_counter6, time_counter7, time_counter8, time_counter9;
    wire [9:0] waitload, waitDTC;
    wire [3:0] waitcount, waitcount1, waitcount2, waitcount3, waitcount4, waitcount5, waitcount6, waitcount7, waitcount8, waitcount9;
    
    wire [15:0] twosec, two5sec, threesec, three5sec, foursec, randomtime;
    
    // Icicle state machine
    wire [3:0] State, State1, State2, State3, State4, State5, State6, State7, State8, State9;
    wire [9:0] T2, IncScore, DecScore, PickColor, ResetIcicle, RTimer;
    wire MaxColor, HitSlug, HitWater, waitTimeDone;
    Pixel_Address pixeladdress (.clk(clk), .reset(1'b0), .Din(16'd0), .Hout(H_out), .Vout(V_out), .UTC(), .DTC());
    DisplaySync sync (.clk(clk), .row(V_out), .column(H_out), .Hsync(H_outsync), .Vsync(V_outsync));
    
    FDRE #(.INIT(1'b1)) hsync (.C(clk), .R(1'b0), .CE(1'b1), .D(H_outsync), .Q(Hsync));
    FDRE #(.INIT(1'b1)) vsync (.C(clk), .R(1'b0), .CE(1'b1), .D(V_outsync), .Q(Vsync));
    
    assign ActiveRegion = ((16'd0 <= H_out) & (H_out <= 16'd639)) & ((16'd0 <= V_out) & (V_out <= 16'd479));
    assign LeftBorder = (16'd0 <= H_out) & (H_out <= 16'd9);
    assign RightBorder = (16'd630 <= H_out) & (H_out <= 16'd639);
    assign TopBorder = (16'd0 <= V_out) & (V_out <= 16'd7);
    assign BottomBorder = (16'd472 <= V_out) & (V_out <= 16'd479);
    assign Podium = ((16'd284 <= H_out) & (H_out <= 16'd351)) & ((16'd279 <= V_out) & (V_out <= 16'd471));
    assign Water = ((16'd360 <= V_out) & (V_out <= 16'd472)) & ((16'd8 <= H_out) & (H_out <= 16'd630));
    assign Slug = (SlugVert >= V_out) & (SlugVert <= (V_out+16'd16)) & (SlugHori >= H_out) & (SlugHori <= (H_out+16'd16)) & (SlugVert < 16'd471 | FlashSlug);
    
    wire [9:0] cyan, magenta;
    wire [9:0] activeicicle;
    wire [15:0] icicleVert, icicleVert1, icicleVert2, icicleVert3, icicleVert4, icicleVert5, icicleVert6, icicleVert7, icicleVert8, icicleVert9;
    wire [3:0] FadeIn, FadeIn1, FadeIn2, FadeIn3, FadeIn4, FadeIn5, FadeIn6, FadeIn7, FadeIn8, FadeIn9;
    wire [9:0] hit;

    assign activeicicle[0] = (H_out >= 16'd30) & (H_out <= 16'd36) & (icicleVert >= V_out) & (icicleVert <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[0] | FlashingIcicle);
    assign activeicicle[1] = (H_out >= 16'd94) & (H_out <= 16'd100) & (icicleVert1 >= V_out) & (icicleVert1 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[1] | FlashingIcicle);
    assign activeicicle[2] = (H_out >= 16'd158) & (H_out <= 16'd164) & (icicleVert2 >= V_out) & (icicleVert2 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[2] | FlashingIcicle);
    assign activeicicle[3] = (H_out >= 16'd222) & (H_out <= 16'd228) & (icicleVert3 >= V_out) & (icicleVert3 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[3] | FlashingIcicle);
    assign activeicicle[4] = (H_out >= 16'd286) & (H_out <= 16'd292) & (icicleVert4 >= V_out) & (icicleVert4 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[4] | FlashingIcicle);
    assign activeicicle[5] = (H_out >= 16'd350) & (H_out <= 16'd356) & (icicleVert5 >= V_out) & (icicleVert5 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[5] | FlashingIcicle);
    assign activeicicle[6] = (H_out >= 16'd414) & (H_out <= 16'd420) & (icicleVert6 >= V_out) & (icicleVert6 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[6] | FlashingIcicle);
    assign activeicicle[7] = (H_out >= 16'd478) & (H_out <= 16'd484) & (icicleVert7 >= V_out) & (icicleVert7 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[7] | FlashingIcicle);
    assign activeicicle[8] = (H_out >= 16'd542) & (H_out <= 16'd548) & (icicleVert8 >= V_out) & (icicleVert8 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[8] | FlashingIcicle);
    assign activeicicle[9] = (H_out >= 16'd606) & (H_out <= 16'd612) & (icicleVert9 >= V_out) & (icicleVert9 <= (V_out+16'd40)) & ~Water & ~Podium & (~hit[9] | FlashingIcicle);
    
    assign vgaRed = {4{ActiveRegion}} & {{4{LeftBorder}} | {4{RightBorder}} | {4{TopBorder}} | {4{BottomBorder}} | {2{Podium}} | {4{Slug}} | {
    {{4{activeicicle[0] & ~cyan[0]}} & FadeIn} | 
    {{4{activeicicle[1] & ~cyan[1]}} & FadeIn1} |
    {{4{activeicicle[2] & ~cyan[2]}} & FadeIn2} |
    {{4{activeicicle[3] & ~cyan[3]}} & FadeIn3} |
    {{4{activeicicle[4] & ~cyan[4]}} & FadeIn4} |
    {{4{activeicicle[5] & ~cyan[5]}} & FadeIn5} |
    {{4{activeicicle[6] & ~cyan[6]}} & FadeIn6} |
    {{4{activeicicle[7] & ~cyan[7]}} & FadeIn7} |
    {{4{activeicicle[8] & ~cyan[8]}} & FadeIn8} |
    {{4{activeicicle[9] & ~cyan[9]}} & FadeIn9}}
     & ~{4{Water}}};
    assign vgaGreen = {4{ActiveRegion}} & {4{Podium}} | {4{Slug}} | {
    {{4{activeicicle[0] & cyan[0]}} & FadeIn} | 
    {{4{activeicicle[1] & cyan[1]}} & FadeIn1} |
    {{4{activeicicle[2] & cyan[2]}} & FadeIn2} |
    {{4{activeicicle[3] & cyan[3]}} & FadeIn3} |
    {{4{activeicicle[4] & cyan[4]}} & FadeIn4} |
    {{4{activeicicle[5] & cyan[5]}} & FadeIn5} |
    {{4{activeicicle[6] & cyan[6]}} & FadeIn6} |
    {{4{activeicicle[7] & cyan[7]}} & FadeIn7} |
    {{4{activeicicle[8] & cyan[8]}} & FadeIn8} |
    {{4{activeicicle[9] & cyan[9]}} & FadeIn9}}
     & ~{4{Water}};    
    assign vgaBlue = {4{ActiveRegion}} & {4{Water & ~Slug}} | {
    {{4{activeicicle[0]}} & FadeIn} | 
    {{4{activeicicle[1]}} & FadeIn1} | 
    {{4{activeicicle[2]}} & FadeIn2} | 
    {{4{activeicicle[3]}} & FadeIn3} | 
    {{4{activeicicle[4]}} & FadeIn4} | 
    {{4{activeicicle[5]}} & FadeIn5} | 
    {{4{activeicicle[6]}} & FadeIn6} | 
    {{4{activeicicle[7]}} & FadeIn7} | 
    {{4{activeicicle[8]}} & FadeIn8} | 
    {{4{activeicicle[9]}} & FadeIn9}}  
     & ~{4{Water}};
    
// --------------------------------------------------------------------------------------------------------------------------------------------------------
    
    //slug and movement
    // To make the slug move, make two 16-but counters, one for the horizontal and one for vertical movement
    wire syncclk1, syncclk2, syncclk3;
    EdgeDetector oneframe (.clk(clk), .enter(Vsync), .Edge(syncclk1));
    EdgeDetector twoframe (.clk(clk), .enter(Vsync | Hsync), .Edge(syncclk2));
    assign syncclk3 = (H_out >= 16'd637 & H_out <= 16'd639) & (V_out == 16'd479);
    
    
    //assign SlugMove
    wire qslug;
   
    wire dontMoveLeft, dontMoveRight, dontMoveUp, dontMoveDown, inWater;
    // add a condition to the dontmoves to include not moving when in water 
    //stop left less than
    assign dontMoveLeft = (SlugHori == 16'd26) | ((SlugVert >= 16'd279) & (SlugHori == 16'd367)) | (SlugVert >= 16'd360);
    // stop right greater than (then for the podium: sulgvert greater than, and slughori is less than)
    assign dontMoveRight = (SlugHori == 16'd630) | ((SlugVert >= 16'd279) & (SlugHori == 16'd283)) | (SlugVert >= 16'd360);
    // stop up less than
    assign dontMoveUp = (SlugVert == 16'd23) | (SlugVert >= 16'd360);
    // stop down greater than
    assign dontMoveDown = (SlugVert == 16'd471) | ((16'd284 <= SlugHori) & (SlugHori <= 16'd367) & (SlugVert == 16'd279));
    assign inWater = (SlugVert >= 16'd360);
    
    // resets the board at the beginning. (setting reset to 1 and then sets it to 0)
    FDRE #(.INIT(1'b1)) slugspawn (.C(clk), .R(1'b0), .CE(1'b1), .D(1'b0), .Q(qslug));
    
    countUD16L horizontal (.clk(clk), .UD(~btnL | btnR), .CE((syncclk1 & btnL & ~dontMoveLeft & ~(hit[0] | hit[1] | hit[2] | hit[3] | hit[4] | hit[5] | hit[6] | hit[7] | hit[8] | hit[9])) | 
    (syncclk1 & btnR & ~dontMoveRight & ~(hit[0] | hit[1] | hit[2] | hit[3] | hit[4] | hit[5] | hit[6] | hit[7] | hit[8] | hit[9]))), .LD(qslug), .Din(16'd326), .Qout(SlugHori));
    countUD16L vertical (.clk(clk), .UD(~btnU | inWater), .CE((syncclk2 & btnU & ~dontMoveUp & ~inWater & ~(hit[0] | hit[1] | hit[2] | hit[3] | hit[4] | hit[5] | hit[6] | hit[7] | hit[8] | hit[9])) | 
    (syncclk1 & ~btnU & ~dontMoveDown & ~inWater & ~(hit[0] | hit[1] | hit[2] | hit[3] | hit[4] | hit[5] | hit[6] | hit[7] | hit[8] | hit[9])) | 
    (syncclk1 & ~dontMoveDown & inWater)), .LD(qslug), .Din(16'd276), .Qout(SlugVert));
    
    // flashing slug
     wire flashout, flashoutice;
     countUD4L flash (.clk(clk), .UD(1'b1), .CE(syncclk1), .LD(1'b0), .Din(), .Qout(), .UTC(flashout), .DTC());
    
     FDRE #(.INIT(1'b0)) flashes (.C(clk), .R(1'b0), .CE(qsec), .D(~FlashSlug), .Q(FlashSlug));
     EdgeDetector flashslug (.clk(clk), .enter(flashout), .Edge(qsec));
    
// ------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    IcicleStateMachine icicle (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[0]), .Color(cyan[0]), .MaxColor(FadeIn == 4'b1111), .T2(T2[0]), .PickColor(PickColor[0]), .HitSlug(hit[0]), .HitWater(icicleVert >= 16'd430),
                              .ResetIcicle(ResetIcicle[0]), .RTimer(RTimer[0]), .IncScore(IncScore[0]), .DecScore(DecScore[0]), .States(State));
    IcicleStateMachine icicle1 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[1]), .Color(cyan[1]), .MaxColor(FadeIn1 == 4'b1111), .T2(T2[1]), .PickColor(PickColor[1]), .HitSlug(hit[1]), .HitWater(icicleVert1 >= 16'd430),
                             .ResetIcicle(ResetIcicle[1]), .RTimer(RTimer[1]), .IncScore(IncScore[1]), .DecScore(DecScore[1]), .States(State1));
    IcicleStateMachine icicle2 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[2]), .Color(cyan[2]), .MaxColor(FadeIn2 == 4'b1111), .T2(T2[2]), .PickColor(PickColor[2]), .HitSlug(hit[2]), .HitWater(icicleVert2 >= 16'd430),
                             .ResetIcicle(ResetIcicle[2]), .RTimer(RTimer[2]), .IncScore(IncScore[2]), .DecScore(DecScore[2]), .States(State2));
    IcicleStateMachine icicle3 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[3]), .Color(cyan[3]), .MaxColor(FadeIn3 == 4'b1111), .T2(T2[3]), .PickColor(PickColor[3]), .HitSlug(hit[3]), .HitWater(icicleVert3 >= 16'd430),
                             .ResetIcicle(ResetIcicle[3]), .RTimer(RTimer[3]), .IncScore(IncScore[3]), .DecScore(DecScore[3]), .States(State3));
    IcicleStateMachine icicle4 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[4]), .Color(cyan[4]), .MaxColor(FadeIn4 == 4'b1111), .T2(T2[4]), .PickColor(PickColor[4]), .HitSlug(hit[4]), .HitWater(icicleVert4 >= 16'd430),
                             .ResetIcicle(ResetIcicle[4]), .RTimer(RTimer[4]), .IncScore(IncScore[4]), .DecScore(DecScore[4]), .States(State4));
    IcicleStateMachine icicle5 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[5]), .Color(cyan[5]), .MaxColor(FadeIn5 == 4'b1111), .T2(T2[5]), .PickColor(PickColor[5]), .HitSlug(hit[5]), .HitWater(icicleVert5 >= 16'd430),
                             .ResetIcicle(ResetIcicle[5]), .RTimer(RTimer[5]), .IncScore(IncScore[5]), .DecScore(DecScore[5]), .States(State5));
    IcicleStateMachine icicle6 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[6]), .Color(cyan[6]), .MaxColor(FadeIn6 == 4'b1111), .T2(T2[6]), .PickColor(PickColor[6]), .HitSlug(hit[6]), .HitWater(icicleVert6 >= 16'd430),
                             .ResetIcicle(ResetIcicle[6]), .RTimer(RTimer[6]), .IncScore(IncScore[6]), .DecScore(DecScore[6]), .States(State6));
    IcicleStateMachine icicle7 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[7]), .Color(cyan[7]), .MaxColor(FadeIn7 == 4'b1111), .T2(T2[7]), .PickColor(PickColor[7]), .HitSlug(hit[7]), .HitWater(icicleVert7 >= 16'd430),
                             .ResetIcicle(ResetIcicle[7]), .RTimer(RTimer[7]), .IncScore(IncScore[7]), .DecScore(DecScore[7]), .States(State7));
    IcicleStateMachine icicle8 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[8]), .Color(cyan[8]), .MaxColor(FadeIn8 == 4'b1111), .T2(T2[8]), .PickColor(PickColor[8]), .HitSlug(hit[8]), .HitWater(icicleVert8 >= 16'd430),
                             .ResetIcicle(ResetIcicle[8]), .RTimer(RTimer[8]), .IncScore(IncScore[8]), .DecScore(DecScore[8]), .States(State8));
    IcicleStateMachine icicle9 (.clk(clk), .Go(btnC), .waitTimeDone(waitDTC[9]), .Color(cyan[9]), .MaxColor(FadeIn9 == 4'b1111), .T2(T2[9]), .PickColor(PickColor[9]), .HitSlug(hit[9]), .HitWater(icicleVert9 >= 16'd430),
                             .ResetIcicle(ResetIcicle[9]), .RTimer(RTimer[9]), .IncScore(IncScore[9]), .DecScore(DecScore[9]), .States(State9));                                                                                                                                                                              
    
    // 16 bit counter to control the dropping of icicle
    countUD16L icicleDrop (.clk(clk), .UD(1'b1), .CE(syncclk3 & State[3] & (FadeIn == 4'b1111) & ~hit[0]), .LD(ResetIcicle[0]), .Din(16'd48), .Qout(icicleVert));
    countUD16L icicleDrop1 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State1[3] & (FadeIn1 == 4'b1111) & ~hit[1]), .LD(ResetIcicle[1]), .Din(16'd48), .Qout(icicleVert1));
    countUD16L icicleDrop2 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State2[3] & (FadeIn2 == 4'b1111) & ~hit[2]), .LD(ResetIcicle[2]), .Din(16'd48), .Qout(icicleVert2));
    countUD16L icicleDrop3 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State3[3] & (FadeIn3 == 4'b1111) & ~hit[3]), .LD(ResetIcicle[3]), .Din(16'd48), .Qout(icicleVert3));
    countUD16L icicleDrop4 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State4[3] & (FadeIn4 == 4'b1111) & ~hit[4]), .LD(ResetIcicle[4]), .Din(16'd48), .Qout(icicleVert4));
    countUD16L icicleDrop5 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State5[3] & (FadeIn5 == 4'b1111) & ~hit[5]), .LD(ResetIcicle[5]), .Din(16'd48), .Qout(icicleVert5));
    countUD16L icicleDrop6 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State6[3] & (FadeIn6 == 4'b1111) & ~hit[6]), .LD(ResetIcicle[6]), .Din(16'd48), .Qout(icicleVert6));
    countUD16L icicleDrop7 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State7[3] & (FadeIn7 == 4'b1111) & ~hit[7]), .LD(ResetIcicle[7]), .Din(16'd48), .Qout(icicleVert7));
    countUD16L icicleDrop8 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State8[3] & (FadeIn8 == 4'b1111) & ~hit[8]), .LD(ResetIcicle[8]), .Din(16'd48), .Qout(icicleVert8));
    countUD16L icicleDrop9 (.clk(clk), .UD(1'b1), .CE(syncclk3 & State9[3] & (FadeIn9 == 4'b1111) & ~hit[9]), .LD(ResetIcicle[9]), .Din(16'd48), .Qout(icicleVert9));
  
    
    // picking random time from T2-3.5
    wire [7:0] RndTime;
    LSFR randomTimeGen (.clk(clk), .RndN(RndTime));
    
    // still need counters for the randomtime counter and random color
    wire [7:0] Color, Color1, Color2, Color3, Color4, Color5, Color6, Color7, Color8, Color9;
    LSFR randomNumGen (.clk(clk), .RndN(Color));
    FDRE #(.INIT(1'b0)) cyanpick (.C(clk), .R(1'b0), .CE(PickColor[0]), .D(Color[1]), .Q(cyan[0]));
    FDRE #(.INIT(1'b0)) cyanpick1 (.C(clk), .R(1'b0), .CE(PickColor[1]), .D(Color[5]), .Q(cyan[1]));
    FDRE #(.INIT(1'b0)) cyanpick2 (.C(clk), .R(1'b0), .CE(PickColor[2]), .D(Color[3]), .Q(cyan[2]));
    FDRE #(.INIT(1'b0)) cyanpick3 (.C(clk), .R(1'b0), .CE(PickColor[3]), .D(Color[7]), .Q(cyan[3]));
    FDRE #(.INIT(1'b0)) cyanpick4 (.C(clk), .R(1'b0), .CE(PickColor[4]), .D(Color[1]), .Q(cyan[4]));
    FDRE #(.INIT(1'b0)) cyanpick5 (.C(clk), .R(1'b0), .CE(PickColor[5]), .D(Color[0]), .Q(cyan[5]));
    FDRE #(.INIT(1'b0)) cyanpick6 (.C(clk), .R(1'b0), .CE(PickColor[6]), .D(Color[2]), .Q(cyan[6]));
    FDRE #(.INIT(1'b0)) cyanpick7 (.C(clk), .R(1'b0), .CE(PickColor[7]), .D(Color[6]), .Q(cyan[7]));
    FDRE #(.INIT(1'b0)) cyanpick8 (.C(clk), .R(1'b0), .CE(PickColor[8]), .D(Color[5]), .Q(cyan[8]));
    FDRE #(.INIT(1'b0)) cyanpick9 (.C(clk), .R(1'b0), .CE(PickColor[9]), .D(Color[4]), .Q(cyan[9]));

   // wait counter
    countUD4L waiting (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[0]), .Din({1'b1, RndTime[5:4], 1'b0}), .Qout(waitcount), .DTC(waitDTC[0]));
    countUD4L waiting1 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[1]), .Din({1'b1, RndTime[3:2], 1'b0}), .Qout(waitcount1), .DTC(waitDTC[1]));
    countUD4L waiting2 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[2]), .Din({1'b1, RndTime[1:0], 1'b0}), .Qout(waitcount2), .DTC(waitDTC[2]));
    countUD4L waiting3 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[3]), .Din({1'b1, RndTime[7:6], 1'b0}), .Qout(waitcount3), .DTC(waitDTC[3]));
    countUD4L waiting4 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[4]), .Din({1'b1, RndTime[3:2], 1'b0}), .Qout(waitcount4), .DTC(waitDTC[4]));
    countUD4L waiting5 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[5]), .Din({1'b1, RndTime[5:4], 1'b0}), .Qout(waitcount5), .DTC(waitDTC[5]));
    countUD4L waiting6 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[6]), .Din({1'b1, RndTime[6:5], 1'b0}), .Qout(waitcount6), .DTC(waitDTC[6]));
    countUD4L waiting7 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[7]), .Din({1'b1, RndTime[2:1], 1'b0}), .Qout(waitcount7), .DTC(waitDTC[7]));
    countUD4L waiting8 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[8]), .Din({1'b1, RndTime[7:6], 1'b0}), .Qout(waitcount8), .DTC(waitDTC[8]));
    countUD4L waiting9 (.clk(clk), .UD(1'b0), .CE(qsec), .LD(RTimer[9]), .Din({1'b1, RndTime[1:0], 1'b0}), .Qout(waitcount9), .DTC(waitDTC[9]));
    
    countUD4L fading (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn == 4'b1111) & State[2]), .LD(ResetIcicle[0]), .Din(4'b0000), .Qout(FadeIn));
    countUD4L fading1 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn1 == 4'b1111) & State1[2]), .LD(ResetIcicle[1]), .Din(4'b0000), .Qout(FadeIn1));
    countUD4L fading2 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn2 == 4'b1111) & State2[2]), .LD(ResetIcicle[2]), .Din(4'b0000), .Qout(FadeIn2));
    countUD4L fading3 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn3 == 4'b1111) & State3[2]), .LD(ResetIcicle[3]), .Din(4'b0000), .Qout(FadeIn3));
    countUD4L fading4 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn4 == 4'b1111) & State4[2]), .LD(ResetIcicle[4]), .Din(4'b0000), .Qout(FadeIn4));
    countUD4L fading5 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn5 == 4'b1111) & State5[2]), .LD(ResetIcicle[5]), .Din(4'b0000), .Qout(FadeIn5));
    countUD4L fading6 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn6 == 4'b1111) & State6[2]), .LD(ResetIcicle[6]), .Din(4'b0000), .Qout(FadeIn6));
    countUD4L fading7 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn7 == 4'b1111) & State7[2]), .LD(ResetIcicle[7]), .Din(4'b0000), .Qout(FadeIn7));
    countUD4L fading8 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn8 == 4'b1111) & State8[2]), .LD(ResetIcicle[8]), .Din(4'b0000), .Qout(FadeIn8));
    countUD4L fading9 (.clk(clk), .UD(1'b1), .CE(qsec & ~(FadeIn9 == 4'b1111) & State9[2]), .LD(ResetIcicle[9]), .Din(4'b0000), .Qout(FadeIn9));

    
    
    // icicle collision with slug
 
     assign hit[0] = icicleVert >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert) & (SlugVert >= icicleVert) & ((SlugHori >= 16'd30 - 16'd16) & (SlugHori <= 16'd36 + 16'd16)));
     assign hit[1] = icicleVert1 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert1) & (SlugVert >= icicleVert1) & ((SlugHori >= 16'd94 - 16'd16) & (SlugHori <= 16'd100 + 16'd16)));
     assign hit[2] = icicleVert2 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert2) & (SlugVert >= icicleVert2) & ((SlugHori >= 16'd158 - 16'd16) & (SlugHori <= 16'd164 + 16'd16)));
     assign hit[3] = icicleVert3 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert3) & (SlugVert >= icicleVert3) & ((SlugHori >= 16'd222 - 16'd16) & (SlugHori <= 16'd228 + 16'd16)));
     assign hit[4] = icicleVert4 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert4) & (SlugVert >= icicleVert4) & ((SlugHori >= 16'd286 - 16'd16) & (SlugHori <= 16'd292 + 16'd16)));
     assign hit[5] = icicleVert5 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert5) & (SlugVert >= icicleVert5) & ((SlugHori >= 16'd350 - 16'd16) & (SlugHori <= 16'd356 + 16'd16)));
     assign hit[6] = icicleVert6 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert6) & (SlugVert >= icicleVert6) & ((SlugHori >= 16'd414 - 16'd16) & (SlugHori <= 16'd420 + 16'd16)));
     assign hit[7] = icicleVert7 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert7) & (SlugVert >= icicleVert7) & ((SlugHori >= 16'd478 - 16'd16) & (SlugHori <= 16'd484 + 16'd16)));
     assign hit[8] = icicleVert8 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert8) & (SlugVert >= icicleVert8) & ((SlugHori >= 16'd542 - 16'd16) & (SlugHori <= 16'd548 + 16'd16)));
     assign hit[9] = icicleVert9 >= 16'd49 & ((SlugVert - 16'd16 <= icicleVert9) & (SlugVert >= icicleVert9) & ((SlugHori >= 16'd606 - 16'd16) & (SlugHori <= 16'd612 + 16'd16)));
   
    // flashing icicle
     countUD4L flashicicle (.clk(clk), .UD(1'b1), .CE(syncclk1), .LD(1'b0), .Din(), .Qout(), .UTC(flashoutice), .DTC());
     wire qsecice;
     FDRE #(.INIT(1'b0)) flashesice (.C(clk), .R(1'b0), .CE(qsecice), .D(~FlashingIcicle), .Q(FlashingIcicle));
     EdgeDetector flashice (.clk(clk), .enter(flashoutice), .Edge(qsecice));
    
    
    // score counter
    countUD8L scorecounter (.clk(clk), .UD((IncScore[0] | IncScore[1] | IncScore[2] | IncScore[3] | IncScore[4] | IncScore[5] | IncScore[6] | IncScore[7] | IncScore[8] | IncScore[9]) | 
    ~(DecScore[0] | DecScore[1] | DecScore[2] | DecScore[3] | DecScore[4] | DecScore[5] | DecScore[6] | DecScore[7] | DecScore[8] | DecScore[9])), 
    .CE((IncScore[0] | IncScore[1] | IncScore[2] | IncScore[3] | IncScore[4] | IncScore[5] | IncScore[6] | IncScore[7] | IncScore[8] | IncScore[9]) | 
    (DecScore[0] | DecScore[1] | DecScore[2] | DecScore[3] | DecScore[4] | DecScore[5] | DecScore[6] | DecScore[7] | DecScore[8] | DecScore[9])), .LD(), .Din(), .Qout(ScoreCount), .UTC(), .DTC());
    SignChanger SignChanger(.a(ScoreCount), .sign(ScoreCount[7]), .d(signChangerOut));
    
    // T2 counter (the timer counter needs CE and LD)
    assign T2[0] = ~|(time_counter ^ 4'b1000);
    //assign
    assign T2[1] = ~|(time_counter1 ^ 4'b1000);
    assign T2[2] = ~|(time_counter2 ^ 4'b1000);
    assign T2[3] = ~|(time_counter3 ^ 4'b1000);
    assign T2[4] = ~|(time_counter4 ^ 4'b1000);
    assign T2[5] = ~|(time_counter5 ^ 4'b1000);
    assign T2[6] = ~|(time_counter6 ^ 4'b1000);
    assign T2[7] = ~|(time_counter7 ^ 4'b1000);
    assign T2[8] = ~|(time_counter8 ^ 4'b1000);
    assign T2[9] = ~|(time_counter9 ^ 4'b1000);
    countUD4L timer (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[0]), .Din(4'b0000), .Qout(time_counter));
    countUD4L timer1 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[1]), .Din(4'b0000), .Qout(time_counter1));
    countUD4L timer2 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[2]), .Din(4'b0000), .Qout(time_counter2));
    countUD4L timer3 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[3]), .Din(4'b0000), .Qout(time_counter3));
    countUD4L timer4 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[4]), .Din(4'b0000), .Qout(time_counter4));
    countUD4L timer5 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[5]), .Din(4'b0000), .Qout(time_counter5));
    countUD4L timer6 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[6]), .Din(4'b0000), .Qout(time_counter6));
    countUD4L timer7 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[7]), .Din(4'b0000), .Qout(time_counter7));
    countUD4L timer8 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[8]), .Din(4'b0000), .Qout(time_counter8));
    countUD4L timer9 (.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer[9]), .Din(4'b0000), .Qout(time_counter9));
    
    assign seg = hex7segOut;
    assign dp = 1'b1;
    assign an[3] = 1'b1;
    assign an[2] = ~(ringCounterOut[2] & ScoreCount[7]);
    assign an[1] = ~(ringCounterOut[1]);
    assign an[0] = ~(ringCounterOut[0]);

endmodule
