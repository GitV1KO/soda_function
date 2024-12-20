`timescale 1ns / 1ps


module Top
(
    input wire sys_clk,
    input wire key_in1,
    input wire key_in2,
    input wire key_in3,
    output  wire    [15:0]  rgb_tft     ,   // 输出TFT显示的RGB数据
    output  wire            hsync       ,   // 输出行同步信号
    output  wire            vsync       ,   // 输出场同步信号
    output  wire            tft_clk     ,   // 输出TFT时钟信号
    output  wire            tft_de      ,   // 输出TFT数据使能信号
    output  wire            tft_bl          // 输出TFT背光信号 
 
 );
 
wire sys_rst_n;
 
 reg [6:0] rst_cnt;
 
initial begin
      rst_cnt=0;
end
always@(posedge  sys_clk)
   if( rst_cnt==15)
       rst_cnt<=15;
   else
       rst_cnt<= rst_cnt+1;
          
 assign sys_rst_n=(rst_cnt>=10)?1:0;    //初始上电时，系统先用10个脉冲复位一下
 
 wire key_flag1;
 wire key_flag2;
 wire key_flag3;
 
 
 
 key_filter
 #(
     .CNT_20MS (20'd9)//999999
 )U1
 (
     .sys_clk  ( sys_clk  )  ,
     .sys_rst_n( sys_rst_n)  ,
     .key_in   ( key_in1   )  ,
           
     .key_flag ( key_flag1 )  
 );
 key_filter
 #(
     .CNT_20MS (20'd9)
 )U2
 (
     .sys_clk  ( sys_clk  )  ,
     .sys_rst_n( sys_rst_n)  ,
     .key_in   ( key_in2   )  ,
           
     .key_flag ( key_flag2 )  
 );
 key_filter
 #(
     .CNT_20MS (20'd9)
 )U3
 (
     .sys_clk  ( sys_clk  )  ,
     .sys_rst_n( sys_rst_n)  ,
     .key_in   ( key_in3   )  ,
           
     .key_flag ( key_flag3 )  
 );     //按键去抖实例化
  
 
reg [23:0] dollars_in ;
reg [23:0] dollars_out1 ;
reg [23:0] dollars_out2 ;

 always@(posedge sys_clk or negedge sys_rst_n)
      if(!sys_rst_n)begin
          dollars_in <=0;
          dollars_out1<=0;
          dollars_out2<=0;
      end else if(key_flag1)
         dollars_in <=  dollars_in+5;
     else if(key_flag2)
          dollars_in <=  dollars_in+10;
     else if(key_flag3) begin
            if(dollars_in>=25)
                dollars_out2<= dollars_in-25;    
            else
                 dollars_out1<=dollars_in;  
     end else  if(miao_cnt>=5)begin
         dollars_in <=0;
         dollars_out1<=0;
         dollars_out2<=0;    
     end
 
reg start; 
wire done;     
reg [3:0] miao_cnt; 
 
 always@(posedge sys_clk or negedge sys_rst_n)
      if(!sys_rst_n)
        start<=0;
      else if(miao_cnt>=5)
        start<=0;
      else if(key_flag3)
         start<=1;      //key3消抖后start才赋值1
         
 always@(posedge sys_clk or negedge sys_rst_n)
     if(!sys_rst_n)  
         miao_cnt<=0;
     else if(miao_cnt>=5) 
          miao_cnt<=0;    
     else if(start&&done) //从下面的定时器实例化得到done //start和done都得1才行(说明计时器计了1秒)
         miao_cnt<= miao_cnt+1; 
         
         
one_second_timer one_second_timer_U1
(
         .clk  (sys_clk  ) ,       // 50MHz时钟输入
         .rst  (~sys_rst_n ) ,       // 复位信号，低电平有效
         .start(start) ,            // 启动定时器信号
         .done (done )              // 定时器完成信号
);            //通过定时器实例化得到done   
 TFT_char TFT_char_U1
(
    .sys_clk   (sys_clk   ),   //输入工作时钟,频率50MHz
    .sys_rst_n (sys_rst_n ),   //输入复位信号,低电平有效
	.data1   (dollars_in ),
    .data2   (dollars_out1),
    .data3   (dollars_out2),
	
	
    .rgb_tft   (rgb_tft   ),   //输出像素信息
    .hsync     (hsync     ),   //输出行同步信号
    .vsync     (vsync     ),   //输出场同步信号
    .tft_clk   (tft_clk   ),   //输出TFT时钟信号
    .tft_de    (tft_de    ),   //输出TFT使能信号
    .tft_bl    (tft_bl    )    //输出背光信号
);


endmodule
