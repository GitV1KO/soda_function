`timescale  1ns/1ns

module  tft_ctrl
(
    input   wire            tft_clk_33m  ,   // 输入时钟, 频率33MHz
    input   wire            sys_rst_n   ,   // 系统复位信号, 低电平有效
    input   wire    [15:0]  pix_data    ,   // 输入像素数据

    output  wire    [10:0]   pix_x       ,   // 输出TFT显示位置X轴像素坐标
    output  wire    [10:0]   pix_y       ,   // 输出TFT显示位置Y轴像素坐标
    output  wire    [15:0]   rgb_tft     ,   // 输出TFT显示数据
    output  wire             hsync       ,   // 输出行同步信号?
    output  wire             vsync       ,   // 输出场同步信号
    output  wire             tft_clk     ,   // 输出TFT时钟信号
    output  wire             tft_de      ,   // 输出TFT数据有效信号
    output  wire             tft_bl          // 输出TFT背光信号
);


//parameter define
parameter H_SYNC    =   11'd1    ,   // 行同步宽度
          H_BACK    =   11'd46   ,   // 行后廊
          H_VALID   =   11'd800  ,   // 行有效区域
          H_FRONT   =   11'd210  ,   // 行前廊
          H_TOTAL   =   11'd1057 ;   // 行总宽度

parameter V_SYNC    =   11'd1    ,   // 场同步宽度
          V_BACK    =   11'd23   ,   // 场后廊
          V_VALID   =   11'd480  ,   // 场有效区域
          V_FRONT   =   11'd22   ,   // 场前廊
          V_TOTAL   =   11'd526  ;   // 场总高度

//wire  define
wire            rgb_valid       ;   // VGA显示区域有效标志
wire            pix_data_req    ;   // 像素数据请求信号

//reg   define
reg     [10:0]   cnt_h   ;   // 行计数器
reg     [10:0]   cnt_v   ;   // 场计数器


// tft_clk, tft_de, tft_bl: 输出TFT时钟信号、数据有效信号和背光信号
assign  tft_clk = tft_clk_33m    ;
assign  tft_de  = rgb_valid     ;
assign  tft_bl  = sys_rst_n     ;

// cnt_h: 行同步信号产生
always@(posedge tft_clk_33m or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_h   <=  11'd0   ;
    else    if(cnt_h == H_TOTAL - 1'd1)
        cnt_h   <=  11'd0   ;
    else
        cnt_h   <=  cnt_h + 1'd1   ;

// hsync: 行同步信号?
assign  hsync = (cnt_h  <=  H_SYNC - 1'd1) ? 1'b1 : 1'b0  ;

// cnt_v: 场同步信号产生
always@(posedge tft_clk_33m or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_v   <=  11'd0 ;
    else    if((cnt_v == V_TOTAL - 1'd1) &&  (cnt_h == H_TOTAL-1'd1))
        cnt_v   <=  11'd0 ;
    else    if(cnt_h == H_TOTAL - 1'd1)
        cnt_v   <=  cnt_v + 1'd1 ;
    else
        cnt_v   <=  cnt_v ;

// vsync: 场同步信号
assign  vsync = (cnt_v  <=  V_SYNC - 1'd1) ? 1'b1 : 1'b0  ;

// rgb_valid: VGA显示区域有效标志
assign  rgb_valid = (((cnt_h >= H_SYNC + H_BACK)
                    && (cnt_h < H_SYNC + H_BACK + H_VALID))
                    &&((cnt_v >= V_SYNC + V_BACK)
                    && (cnt_v < V_SYNC + V_BACK + V_VALID)))
                    ? 1'b1 : 1'b0;

// pix_data_req: 像素数据请求信号，表示rgb_valid有效时的数据区域
assign  pix_data_req = (((cnt_h >= H_SYNC + H_BACK - 1'b1)
                    && (cnt_h < H_SYNC + H_BACK + H_VALID - 1'b1))
                    &&((cnt_v >= V_SYNC + V_BACK)
                    && (cnt_v < V_SYNC + V_BACK + V_VALID)))
                    ? 1'b1 : 1'b0;

// pix_x, pix_y: 输出TFT显示位置的X轴和Y轴像素坐标
assign  pix_x = (pix_data_req == 1'b1)
                ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 11'h3ff;
assign  pix_y = (pix_data_req == 1'b1)
                ? (cnt_v - (V_SYNC + V_BACK )) : 11'h3ff;

// rgb_tft: 输出TFT显示的像素数据
assign  rgb_tft = (rgb_valid == 1'b1) ? pix_data : 16'b0 ;

endmodule 
