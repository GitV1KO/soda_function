`timescale 1ns / 1ps


module Top
(
    input wire sys_clk,
    input wire key_in1,
    input wire key_in2,
    input wire key_in3,
    output  wire    [15:0]  rgb_tft     ,   // ���TFT��ʾ��RGB����
    output  wire            hsync       ,   // �����ͬ���ź�
    output  wire            vsync       ,   // �����ͬ���ź�
    output  wire            tft_clk     ,   // ���TFTʱ���ź�
    output  wire            tft_de      ,   // ���TFT����ʹ���ź�
    output  wire            tft_bl          // ���TFT�����ź� 
 
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
          
 assign sys_rst_n=(rst_cnt>=10)?1:0;    //��ʼ�ϵ�ʱ��ϵͳ����10�����帴λһ��
 
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
 );     //����ȥ��ʵ����
  
 
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
         start<=1;      //key3������start�Ÿ�ֵ1
         
 always@(posedge sys_clk or negedge sys_rst_n)
     if(!sys_rst_n)  
         miao_cnt<=0;
     else if(miao_cnt>=5) 
          miao_cnt<=0;    
     else if(start&&done) //������Ķ�ʱ��ʵ�����õ�done //start��done����1����(˵����ʱ������1��)
         miao_cnt<= miao_cnt+1; 
         
         
one_second_timer one_second_timer_U1
(
         .clk  (sys_clk  ) ,       // 50MHzʱ������
         .rst  (~sys_rst_n ) ,       // ��λ�źţ��͵�ƽ��Ч
         .start(start) ,            // ������ʱ���ź�
         .done (done )              // ��ʱ������ź�
);            //ͨ����ʱ��ʵ�����õ�done   
 TFT_char TFT_char_U1
(
    .sys_clk   (sys_clk   ),   //���빤��ʱ��,Ƶ��50MHz
    .sys_rst_n (sys_rst_n ),   //���븴λ�ź�,�͵�ƽ��Ч
	.data1   (dollars_in ),
    .data2   (dollars_out1),
    .data3   (dollars_out2),
	
	
    .rgb_tft   (rgb_tft   ),   //���������Ϣ
    .hsync     (hsync     ),   //�����ͬ���ź�
    .vsync     (vsync     ),   //�����ͬ���ź�
    .tft_clk   (tft_clk   ),   //���TFTʱ���ź�
    .tft_de    (tft_de    ),   //���TFTʹ���ź�
    .tft_bl    (tft_bl    )    //��������ź�
);


endmodule
