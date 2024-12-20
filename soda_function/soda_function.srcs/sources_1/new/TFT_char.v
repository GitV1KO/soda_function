`timescale  1ns/1ns

module  TFT_char
(
    input   wire            sys_clk     ,   // 输入工作时钟, 默认50MHz
    input   wire            sys_rst_n   ,   // 输入复位信号, 低电平有效
    input   wire    [23:0]  data1   ,
    input   wire    [23:0]  data2   ,
    input   wire    [23:0]  data3   ,
    output  wire    [15:0]  rgb_tft     ,   // 输出显示像素数据
    output  wire            hsync       ,   // 输出行同步信号
    output  wire            vsync       ,   // 输出场同步信号
    output  wire            tft_clk     ,   // 输出TFT时钟信号
    output  wire            tft_de      ,   // 输出TFT数据有效信号
    output  wire            tft_bl          // 输出背光信号

);


//wire  define
wire            tft_clk_33m ;   // TFT工作时钟, 频率33MHz
wire            locked      ;   // PLL锁定信号
wire            rst_n       ;   // TFT模块复位信号
wire    [10:0]   pix_x      ;   // TFT显示位置X轴像素坐标
wire    [10:0]   pix_y      ;   // TFT显示位置Y轴像素坐标
wire    [15:0]  pix_data    ;   // TFT显示像素数据
wire            clk_reg     ;

// rst_n: TFT模块复位信号
assign  rst_n = (sys_rst_n & locked);


//------------- clk_gen_inst -------------
pll pll
(
    .reset      (~sys_rst_n ),  // 输入复位信号，低电平有效
    .clk_in1    (sys_clk    ),  // 输入50MHz系统时钟
    .clk_out1   (tft_clk_33m ),  // 输出TFT工作时钟，频率33MHz
     
    .locked     (locked     )   // PLL锁定信号
);

//------------- tft_ctrl_inst -------------
tft_ctrl    tft_ctrl_inst
(
    .tft_clk_33m (tft_clk_33m),   // 输入时钟，频率33MHz
    .sys_rst_n   (rst_n      ),   // 输入复位信号，低电平有效
    .pix_data    (pix_data   ),   // 显示像素数据

    .pix_x       (pix_x      ),   // 输出TFT显示位置X轴坐标
    .pix_y       (pix_y      ),   // 输出TFT显示位置Y轴坐标
    .rgb_tft     (rgb_tft    ),   // 输出TFT显示数据
    .hsync       (hsync      ),   // 输出行同步信号
    .vsync       (vsync      ),   // 输出场同步信号
    .tft_clk     (tft_clk    ),   // 输出TFT时钟信号
    .tft_de      (tft_de     ),   // 输出TFT数据有效信号
    .tft_bl      (tft_bl     )    // 输出背光信号

);

//------------- tft_pic_inst -------------

tft_pic tft_pic_inst
(
    .tft_clk_33m (tft_clk_33m),   // 输入时钟，频率33MHz
    .sys_rst_n   (rst_n      ),   // 输入复位信号，低电平有效
    .pix_x       (pix_x      ),   // 输入TFT显示位置X轴坐标
    .pix_y       (pix_y      ),   // 输入TFT显示位置Y轴坐标
    .data1   (data1 ),
    .data2   (data2),
    .data3   (data3),
	
    .pix_data    (pix_data   )    // 输入TFT显示位置Y轴坐标

);

endmodule