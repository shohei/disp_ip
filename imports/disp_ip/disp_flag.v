/* Copyright(C) 2016 Cobac.Net All Rights Reserved. */
/* chapter: ��9��      */
/* project: display    */
/* outline: VBLANK�쐬 */

module disp_flag
  (
    input               ACLK,
    input               ARST,
    input               VGA_VS,
    input               CLRVBLNK,
    output  reg         VBLANK
    );

/* VBLANK�Z�b�g�M���E�E�EVGA_VS��ACLK�œ����� */
reg [2:0]   vblank_ff;

always @( posedge ACLK ) begin
    if ( ARST )
        vblank_ff <= 3'b111;
    else begin
        vblank_ff[0] <= VGA_VS;
        vblank_ff[1] <= vblank_ff[0];
        vblank_ff[2] <= vblank_ff[1];
    end
end

assign set_vblank = (vblank_ff[2:1] == 2'b10);

/* VBLANK�t���O */
always @( posedge ACLK ) begin
    if ( ARST )
        VBLANK <= 1'b0;
    else if ( CLRVBLNK )
        VBLANK <= 1'b0;
    else if ( set_vblank )
        VBLANK <= 1'b1;
end

endmodule
