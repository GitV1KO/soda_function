module key_filter
#(
    parameter CNT_20MS =20'd999_999//999999���»���ÿ3��һ�֣����Ÿ�����
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
        cnt_20ms <=20'd0;   //ȷ���ڰ�������ʱ�����������¿�ʼ����
    else if(cnt_20ms==CNT_20MS)
        cnt_20ms <=CNT_20MS;
    else
         cnt_20ms <= cnt_20ms +20'd1;   //��һ�°�����������������ʱ������һֱ��һ��ȷ��û�ж��� 

always@(posedge sys_clk or negedge sys_rst_n)  
    if(sys_rst_n==1'b0)
        key_flag <=1'b0;
     else if(cnt_20ms==(CNT_20MS-20'd1))
        key_flag <=1'b1;    //�������ӽ����ֵ999999�������ɹ�
     else
        key_flag <=1'b0;
endmodule