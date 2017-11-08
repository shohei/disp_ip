/* Copyright(C) 2016 Cobac.Net All Rights Reserved. */
/* chapter: ��9��           */
/* project: display         */
/* outline: �\���o�͍쐬 */

module disp_out
  (
    input               PCK,
    input               PRST,
    input               DISPON,
    output  reg         FIFORD,
    input   [15:0]      FIFOOUT,

    input   [9:0]       HCNT,
    input   [9:0]       VCNT,
    output  reg         AXISTART,

    output  reg [3:0]   VGA_R,
    output  reg [3:0]   VGA_G,
    output  reg [3:0]   VGA_B
    );

/* VGA(640�~480)�p�p�����[�^�ǂݍ��� */
`include "vga_param.vh"

/* FIFO�ǂݏo���M�� */
wire [9:0] rdstart = HFRONT + HWIDTH + HBACK - 10'd3;
wire [9:0] rdend   = HPERIOD - 10'd3;

always @( posedge PCK ) begin
    if ( PRST )
        FIFORD <= 1'b0;
    else if ( VCNT < VFRONT + VWIDTH + VBACK )
        FIFORD <= 1'b0;
    else if ( (HCNT==rdstart) & DISPON )
        FIFORD <= 1'b1;
    else if ( HCNT==rdend )
        FIFORD <= 1'b0;
end

/* FIFORD��1�N���b�N�x�点�ĕ\���̍ŏI�C�l�[�u������� */
reg disp_enable;

always @( posedge PCK ) begin
    if ( PRST )
        disp_enable  <= 1'b0;
    else
        disp_enable  <= FIFORD;
end

/* VGA_R�`VGA_B�o�� */
always @( posedge PCK ) begin
    if ( PRST )
        {VGA_R, VGA_G, VGA_B} <= 16'h0;
    else if ( disp_enable )
        {VGA_R, VGA_G, VGA_B} <= FIFOOUT;
    else
        {VGA_R, VGA_G, VGA_B} <= 16'h0;
end

/* VRAM�ǂݏo���J�n */
always @( posedge PCK ) begin
    if ( PRST )
        AXISTART <= 1'b0;
    else
        AXISTART <= (VCNT == VFRONT + VWIDTH + VBACK -10'd1);
end

endmodule
