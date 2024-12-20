`timescale 1ns / 1ps

module tb_Top( );

reg sys_clk;
reg  key_in1 ; //����1����
reg  key_in2;//����2����,
reg key_in3;

initial begin
	sys_clk =0;
	key_in1=0;
	key_in2=0;
	key_in3=0;
	#500
	key_in1=1;
	#500
	key_in1=0;
	
	#500
     key_in2=1;
    #100
     key_in2=0;
     #500
     
     #500
     key_in1=1;
     #500
     key_in1=0;
     
     #500
     key_in2=1;
     #100
     key_in2=0;
     #500
     
     
     key_in3=1;
     #100
     key_in3=0;
     
	end

always #10 sys_clk =~sys_clk;   //20nsһ�����ڣ�������ʵ��ʱ��ͳһ

Top Top_inst
(
	.sys_clk     (sys_clk    ),
	.key_in1    (key_in1 ),
	 .key_in2   (key_in2),
    .key_in3   (key_in3)
    
);

endmodule

