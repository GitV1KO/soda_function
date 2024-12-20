`timescale  1ns/1ns

module  TFT_char
(
    input   wire            sys_clk     ,   // ���빤��ʱ��, Ĭ��50MHz
    input   wire            sys_rst_n   ,   // ���븴λ�ź�, �͵�ƽ��Ч
    input   wire    [23:0]  data1   ,
    input   wire    [23:0]  data2   ,
    input   wire    [23:0]  data3   ,
    output  wire    [15:0]  rgb_tft     ,   // �����ʾ��������
    output  wire            hsync       ,   // �����ͬ���ź�
    output  wire            vsync       ,   // �����ͬ���ź�
    output  wire            tft_clk     ,   // ���TFTʱ���ź�
    output  wire            tft_de      ,   // ���TFT������Ч�ź�
    output  wire            tft_bl          // ��������ź�

);


//wire  define
wire            tft_clk_33m ;   // TFT����ʱ��, Ƶ��33MHz
wire            locked      ;   // PLL�����ź�
wire            rst_n       ;   // TFTģ�鸴λ�ź�
wire    [10:0]   pix_x      ;   // TFT��ʾλ��X����������
wire    [10:0]   pix_y      ;   // TFT��ʾλ��Y����������
wire    [15:0]  pix_data    ;   // TFT��ʾ��������
wire            clk_reg     ;

// rst_n: TFTģ�鸴λ�ź�
assign  rst_n = (sys_rst_n & locked);


//------------- clk_gen_inst -------------
pll pll
(
    .reset      (~sys_rst_n ),  // ���븴λ�źţ��͵�ƽ��Ч
    .clk_in1    (sys_clk    ),  // ����50MHzϵͳʱ��
    .clk_out1   (tft_clk_33m ),  // ���TFT����ʱ�ӣ�Ƶ��33MHz
     
    .locked     (locked     )   // PLL�����ź�
);

//------------- tft_ctrl_inst -------------
tft_ctrl    tft_ctrl_inst
(
    .tft_clk_33m (tft_clk_33m),   // ����ʱ�ӣ�Ƶ��33MHz
    .sys_rst_n   (rst_n      ),   // ���븴λ�źţ��͵�ƽ��Ч
    .pix_data    (pix_data   ),   // ��ʾ��������

    .pix_x       (pix_x      ),   // ���TFT��ʾλ��X������
    .pix_y       (pix_y      ),   // ���TFT��ʾλ��Y������
    .rgb_tft     (rgb_tft    ),   // ���TFT��ʾ����
    .hsync       (hsync      ),   // �����ͬ���ź�
    .vsync       (vsync      ),   // �����ͬ���ź�
    .tft_clk     (tft_clk    ),   // ���TFTʱ���ź�
    .tft_de      (tft_de     ),   // ���TFT������Ч�ź�
    .tft_bl      (tft_bl     )    // ��������ź�

);

//------------- tft_pic_inst -------------

tft_pic tft_pic_inst
(
    .tft_clk_33m (tft_clk_33m),   // ����ʱ�ӣ�Ƶ��33MHz
    .sys_rst_n   (rst_n      ),   // ���븴λ�źţ��͵�ƽ��Ч
    .pix_x       (pix_x      ),   // ����TFT��ʾλ��X������
    .pix_y       (pix_y      ),   // ����TFT��ʾλ��Y������
    .data1   (data1 ),
    .data2   (data2),
    .data3   (data3),
	
    .pix_data    (pix_data   )    // ����TFT��ʾλ��Y������

);

endmodule