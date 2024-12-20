module key_filter
#(
    parameter CNT_20MS =20'd999_999//999999，下划线每3个一分，看着更清晰
)
(
    input wire sys_clk   ,
    input wire sys_rst_n ,
    input wire key_in    ,
    
    output reg key_flag
);

reg [19:0] cnt_20ms;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n==1'b0)
        cnt_20ms <=20'd0;
    else if(key_in==1'd1)
        cnt_20ms <=20'd0;   //确保在按键按下时，计数器重新开始计数
    else if(cnt_20ms==CNT_20MS)
        cnt_20ms <=CNT_20MS;
    else
         cnt_20ms <= cnt_20ms +20'd1;   //按一下按键，按键弹上来这时计数器一直加一，确保没有抖动 

always@(posedge sys_clk or negedge sys_rst_n)  
    if(sys_rst_n==1'b0)
        key_flag <=1'b0;
     else if(cnt_20ms==(CNT_20MS-20'd1))
        key_flag <=1'b1;    //计数器接近最大值999999，消抖成功
     else
        key_flag <=1'b0;
endmodule