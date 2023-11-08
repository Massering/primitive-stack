// ================== UTILITY ==================

module byte_U_to_0(
    inout[3:0] I
);
    pulldown(I[0]);
    pulldown(I[1]);
    pulldown(I[2]);
    pulldown(I[3]);
endmodule

module X_if_F_else_Z(
    input X,
    input F,
    output Y
);
    not(NF, F);
    nmos(Y, X, F);
    pmos(Y, X, NF);
endmodule

module DATA_if_F_else_ZZZZ(
    inout[3:0] DATA,
    inout[3:0] ODATA,
    input F
);
    X_if_F_else_Z MOS1(ODATA[0], F, DATA[0]);
    X_if_F_else_Z MOS0(ODATA[1], F, DATA[1]);
    X_if_F_else_Z MOS2(ODATA[2], F, DATA[2]);
    X_if_F_else_Z MOS3(ODATA[3], F, DATA[3]);
endmodule

module or4(
    output[3:0] C,
    input[3:0] A,
    input[3:0] B
);
    or Or[3:0](C, A, B);
endmodule

module DDDD_AND_A(
    output wire[3:0] Q,
    input[3:0] D,
    input A
);
    and(Q[0], D[0], A);
    and(Q[1], D[1], A);
    and(Q[2], D[2], A);
    and(Q[3], D[3], A);
endmodule

module decoder_2_to_4(
    output Q0, Q1, Q2, Q3,
    input[1:0] S
);
    wire[1:0] N;
    not NOT[1:0](N, S);

    and(Q0, N[0], N[1]);
    and(Q1, S[0], N[1]);
    and(Q2, N[0], S[1]);
    and(Q3, S[0], S[1]);
endmodule

module DEMUX_3_to_8(
    output i0, i1, i2, i3, i4, i5, i6, i7,
    input D,
    input[3:0] S
);
    wire[3:0] N;
    not Not[3:0](N, S);

    and(i0, D, N[0], N[1], N[2]);
    and(i1, D, S[0], N[1], N[2]);
    and(i2, D, N[0], S[1], N[2]);
    and(i3, D, S[0], S[1], N[2]);
    and(i4, D, N[0], N[1], S[2]);
    and(i5, D, S[0], N[1], S[2]);
    and(i6, D, N[0], S[1], S[2]);
    and(i7, D, S[0], S[1], S[2]);
endmodule


// ================== MEMORY ==================

module RS_trigger(
    output Q, notQ,
    input R, C, S
);
    and(CR, R, C);
    and(CS, S, C);

    nor(Q, CR, notQ);
    nor(notQ, CS, Q);
endmodule

module D_trigger_back(
    output Q,
    input D, C
);
    not(NC, C);
    D_trigger_front D_front(Q, D, NC);
endmodule

module D_trigger_front(
    output Q,
    input D, C
);
    not(notD, D);
    not(notC, C);
    RS_trigger RS1(QR, notQS, D, notC, notD);
    RS_trigger RS2(Q, notQ, QR, C, notQS);
endmodule

module D_trigger(
    output Q,
    input D, C
);
    not(notD, D);
    RS_trigger RS(Q, notQ, notD, C, D);
endmodule

module quad_memory_back(
    output[3:0] ODATA,
    input[3:0] IDATA,
    input CLK
);
    D_trigger_back D0(ODATA[0], IDATA[0], CLK);
    D_trigger_back D1(ODATA[1], IDATA[1], CLK);
    D_trigger_back D2(ODATA[2], IDATA[2], CLK);
    D_trigger_back D3(ODATA[3], IDATA[3], CLK);
endmodule

module quad_memory(
    output[3:0] ODATA,
    input[3:0] IDATA,
    input CLK
);
    D_trigger D0(ODATA[0], IDATA[0], CLK);
    D_trigger D1(ODATA[1], IDATA[1], CLK);
    D_trigger D2(ODATA[2], IDATA[2], CLK);
    D_trigger D3(ODATA[3], IDATA[3], CLK);
endmodule


// ========= ARIPHMETICS =========

module SUM (
    output S, C,
    input X, Y, Z
);

    xor(XxorY, X, Y);
    xor(S, XxorY, Z);

    and(XxorYandZ, XxorY, Z);
    and(XandY, X, Y);
    or(C, XxorYandZ, XandY);
endmodule

module SUM_4_bits (
    output[3:0] S,
    output C,
    input[3:0] X,
    input[3:0] Y
);

    SUM SUM0(S[0], C0, X[0], Y[0], 1'b0);
    SUM SUM1(S[1], C1, X[1], Y[1], C0);
    SUM SUM2(S[2], C2, X[2], Y[2], C1);
    SUM SUM3(S[3], C,  X[3], Y[3], C2);
endmodule

module SUB_4_bits (
    output[3:0] S,
    input[3:0] X, 
    input[3:0] Y
);

    wire[3:0] notY;
    wire[3:0] S_temp;
    not Not[3:0](notY, Y);
    //                      OUT4   OUT1 IN4   IN4
    SUM_4_bits SUM_4_bits0(S_temp,  C0,  X,  notY);
    SUM_4_bits SUM_4_bits1(S,  C1, S_temp, 4'b0001);
endmodule

module mod_5(
    output[3:0] X_mod_5,
    input[3:0] X
);
    wire[3:0] N;
    not Not[3:0](N, X);

    // Извините
    and(n0, N[0], N[1], N[2], N[3]);
    and(n1, X[0], N[1], N[2], N[3]);
    and(n2, N[0], X[1], N[2], N[3]);
    and(n3, X[0], X[1], N[2], N[3]);
    and(n4, N[0], N[1], X[2], N[3]);
    and(n5, X[0], N[1], X[2], N[3]);
    and(n6, N[0], X[1], X[2], N[3]);
    and(n7, X[0], X[1], X[2], N[3]);
    and(n8, N[0], N[1], N[2], X[3]);
    and(n9, X[0], N[1], N[2], X[3]);
    and(na, N[0], X[1], N[2], X[3]);
    and(nb, X[0], X[1], N[2], X[3]);
    and(nc, N[0], N[1], X[2], X[3]);
    and(nd, X[0], N[1], X[2], X[3]);
    and(ne, N[0], X[1], X[2], X[3]);
    and(nf, X[0], X[1], X[2], X[3]);

    wire[3:0] D0;
    wire[3:0] D1;
    wire[3:0] D2;
    wire[3:0] D3;
    wire[3:0] D4;
    wire[3:0] D5;
    wire[3:0] D6;
    wire[3:0] D7;
    wire[3:0] D8;
    wire[3:0] D9;
    wire[3:0] Da;
    wire[3:0] Db;
    wire[3:0] Dc;
    wire[3:0] Dd;
    wire[3:0] De;
    wire[3:0] Df;
    DDDD_AND_A DDDD_AND_A0(D0, 4'd0, n0);
    DDDD_AND_A DDDD_AND_A1(D1, 4'd1, n1);
    DDDD_AND_A DDDD_AND_A2(D2, 4'd2, n2);
    DDDD_AND_A DDDD_AND_A3(D3, 4'd3, n3);
    DDDD_AND_A DDDD_AND_A4(D4, 4'd4, n4);
    DDDD_AND_A DDDD_AND_A5(D5, 4'd0, n5);
    DDDD_AND_A DDDD_AND_A6(D6, 4'd1, n6);
    DDDD_AND_A DDDD_AND_A7(D7, 4'd1, n7);
    DDDD_AND_A DDDD_AND_A8(D8, 4'd2, n8);
    DDDD_AND_A DDDD_AND_A9(D9, 4'd3, n9);
    DDDD_AND_A DDDD_AND_Aa(Da, 4'd4, na);
    DDDD_AND_A DDDD_AND_Ab(Db, 4'd0, nb);
    DDDD_AND_A DDDD_AND_Ac(Dc, 4'd1, nc);
    DDDD_AND_A DDDD_AND_Ad(Dd, 4'd2, nd);
    DDDD_AND_A DDDD_AND_Ae(De, 4'd3, ne);
    DDDD_AND_A DDDD_AND_Af(Df, 4'd4, nf);

    wire[3:0] DD0;
    wire[3:0] DD1;
    wire[3:0] DD2;
    wire[3:0] DD3;
    wire[3:0] DD4;
    wire[3:0] DD5;
    wire[3:0] DD6;
    wire[3:0] DD7;
    or4 OR0(DD0, D0, D1);
    or4 OR1(DD1, D2, D3);
    or4 OR2(DD2, D4, D5);
    or4 OR3(DD3, D6, D7);
    or4 OR4(DD4, D8, D9);
    or4 OR5(DD5, Da, Db);
    or4 OR6(DD6, Dc, Dd);
    or4 OR7(DD7, De, Df);

    wire[3:0] DDD0;
    wire[3:0] DDD1;
    wire[3:0] DDD2;
    wire[3:0] DDD3;
    or4 OROR0(DDD0, DD0, DD1);
    or4 OROR1(DDD1, DD2, DD3);
    or4 OROR2(DDD2, DD4, DD5);
    or4 OROR3(DDD3, DD6, DD7);

    wire[3:0] DDDD0;
    wire[3:0] DDDD1;
    or4 OROROR0(DDDD0, DDD0, DDD1);
    or4 OROROR1(DDDD1, DDD2, DDD3);

    or4 OROROROR(X_mod_5, DDDD0, DDDD1);

endmodule

module SUB_mod_5 (
    output[3:0] S,
    input[3:0] X, 
    input[3:0] Y
);

    wire[3:0] S_temp;
    SUB_4_bits Sub_4_bits(S_temp, X,  Y);
    mod_5 Mod_5(S, S_temp);
endmodule

module decrement (
    output[3:0] ODATA,
    input[3:0] IDATA
);

    SUM_4_bits Sum_4_bits(ODATA, C, IDATA,  4'b1111);
endmodule

module increment (
    output[3:0] ODATA,
    input[3:0] IDATA
);

    SUM_4_bits Sum_4_bits(ODATA, C, IDATA,  4'b1);
endmodule

module decrement_mod_5 (
    output[3:0] ODATA,
    input[3:0] IDATA
);

    wire[3:0] data1;
    decrement dec(data1, IDATA);

    and(cond, data1[0], data1[1], data1[2]);
    not (notCond, cond);

    wire[3:0] odata1;
    wire[3:0] odata2;
    DDDD_AND_A AND0(odata1, data1, notCond);
    DDDD_AND_A AND1(odata2, 4'd4, cond);

    or OR[3:0](ODATA, odata1, odata2);
endmodule

module increment_mod_5 (
        output[3:0] ODATA,
        input[3:0] IDATA
    );

    wire[3:0] data1;
    increment inc(data1, IDATA);

    not (not_data1_1, data1[1]);
    and(cond, data1[0], not_data1_1, data1[2]);
    not (notCond, cond);

    wire[3:0] odata1;
    wire[3:0] odata2;
    DDDD_AND_A AND0(odata1, data1, notCond);
    DDDD_AND_A AND1(odata2, 4'd0, cond);

    or OR[3:0](ODATA, odata1, odata2);
endmodule


// ========= MAIN =========

module MEMORY (
    inout[3:0] IO_DATA,
    input GET,
    input SET,
    input[3:0] INDEX,
    input CLK,
    input RESET
);
    not (NRESET, RESET);

    wire[3:0] idata;
    wire[7:0] in;
    wire[4:0] set;
    wire[4:0] IN;
    DEMUX_3_to_8 DEMUX_IN(in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], SET, INDEX);
    byte_U_to_0 to_0(IO_DATA);
    DDDD_AND_A D_AND_A(idata, IO_DATA, NRESET);
    and (IN[0], in[0], CLK);
    and (IN[1], in[1], CLK);
    and (IN[2], in[2], CLK);
    and (IN[3], in[3], CLK);
    and (IN[4], in[4], CLK);
    or (set[0], IN[0], RESET);
    or (set[1], IN[1], RESET);
    or (set[2], IN[2], RESET);
    or (set[3], IN[3], RESET);
    or (set[4], IN[4], RESET);

    wire[3:0] odata0;
    wire[3:0] odata1;
    wire[3:0] odata2;
    wire[3:0] odata3;
    wire[3:0] odata4;
    quad_memory MEM0(odata0, idata, set[0]);
    quad_memory MEM1(odata1, idata, set[1]);
    quad_memory MEM2(odata2, idata, set[2]);
    quad_memory MEM3(odata3, idata, set[3]);
    quad_memory MEM4(odata4, idata, set[4]);

    wire[3:0] D0;
    wire[3:0] D1;
    wire[3:0] D2;
    wire[3:0] D3;
    wire[3:0] D4;
    wire[3:0] D5;
    wire[3:0] D6;
    wire[3:0] D7;
    wire[3:0] D8;
    wire[3:0] DECR_INDEX;
    decrement_mod_5 decrement(DECR_INDEX, INDEX);
    DEMUX_3_to_8 DEMUX_OUT(out0, out1, out2, out3, out4, out5, out6, out7, GET, DECR_INDEX);
    DDDD_AND_A D_AND_A_O0(D0, odata0, out0);
    DDDD_AND_A D_AND_A_O1(D1, odata1, out1);
    DDDD_AND_A D_AND_A_O2(D2, odata2, out2);
    DDDD_AND_A D_AND_A_O3(D3, odata3, out3);
    DDDD_AND_A D_AND_A_O4(D4, odata4, out4);
    or4 OR5(D5, D0, D1);
    or4 OR6(D6, D2, D3);
    or4 OR7(D7, D4, D5);
    or4 OR8(D8, D6, D7);

    DATA_if_F_else_ZZZZ IF(IO_DATA, D8, GET);
endmodule

module HEAD(
    output[3:0] ODATA,
    input INCR,
    input DECR,
    input CLK,
    input RESET
);
    not (NESET, RESET);
    // increment and decrement
    wire[3:0] INCREMENTED;
    wire[3:0] DECREMENTED;
    wire[3:0] MAKE_INCREMENTED;
    wire[3:0] MAKE_DECREMENTED;
    wire[3:0] MAKE_CREMENTED;
    DDDD_AND_A DDDD_AND_A_INCR(MAKE_INCREMENTED, INCREMENTED, INCR);
    DDDD_AND_A DDDD_AND_A_DECR(MAKE_DECREMENTED, DECREMENTED, DECR);
    or4 OR(MAKE_CREMENTED, MAKE_DECREMENTED, MAKE_INCREMENTED);
    // if RESET
    wire[3:0] IF_NOT_RESET;
    wire[3:0] IF_RESET;
    wire[3:0] IDATA;
    DDDD_AND_A NESET_MAKES_NOTHING(IF_NOT_RESET, MAKE_CREMENTED, NESET);
    DDDD_AND_A RESET_MAKES_4(IF_RESET, 4'b0100, RESET);
    or4 OR1(IDATA, IF_NOT_RESET, IF_RESET);
    // SET
    or(INCRorDECR, INCR, DECR);
    and(CLK_IF, INCRorDECR, CLK);
    or(SET, RESET, CLK_IF);

    quad_memory_back head_memory(ODATA, IDATA, SET);

    increment_mod_5 INCREMENT(INCREMENTED, ODATA);
    decrement_mod_5 DECREMENT(DECREMENTED, ODATA);

endmodule

module stack_structural_normal(
    inout wire[3:0] IO_DATA, 
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX
    );

    wire[3:0] INDEX_4;
    or (INDEX_4[0], INDEX[0]);
    or (INDEX_4[1], INDEX[1]);
    or (INDEX_4[2], INDEX[2]);
    or (INDEX_4[3], 1'b0);

    wire[3:0] Y;
    decoder_2_to_4 OP_decoder(is_nop, is_push, is_pop, is_get, COMMAND);
    DDDD_AND_A DDDD_AND_A_GET(Y, INDEX_4, is_get);
    
    or (get, is_get, is_pop);
    or (set, is_push);

    wire[3:0] HEAD_INDEX;
    HEAD STACK_HEAD(HEAD_INDEX, is_push, is_pop, CLK, RESET);

    wire[3:0] CUR_INDEX;
    SUB_mod_5 SUB(CUR_INDEX, HEAD_INDEX, Y);

    MEMORY STACK_MEMORY(IO_DATA, get, set, CUR_INDEX, CLK, RESET);


endmodule
