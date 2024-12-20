`timescale 1ns / 1ps
module one_second_timer (
    input  wire clk,       // 50MHz ʱ������
    input  wire rst,       // ��λ�źţ��͵�ƽ��Ч
    input  wire start,     // ������ʱ���ź�
    output reg  done       // ����źţ���ʱ����ʱ����ʱ��Ч
);

    // ����Ŀ�����ֵ��50MHzʱ���£�����50,000,000�μ�Ϊ1�룩
    localparam TARGET_COUNT = 50_000_000- 1;// 50_000_000��ʱ�����ڣ���1��

    reg [25:0] count_reg;   // ���ڼ����ļĴ�����26λ�㹻��ʾ���50,000,000
    reg        running;     // ��־λ����ʾ��ʱ���Ƿ���������

    // ��λ���߼�ʱ����
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count_reg <= 26'd0;
            done      <= 1'b0;
            running   <= 1'b0;
        end else begin
            // Ĭ������£�����ź�Ϊ0
            done <= 1'b0; 
            
            // ������յ������źŲ��Ҷ�ʱ��û�����У���ʼ��ʱ
            if (start && !running) begin
                running   <= 1'b1;      // ������ʱ��
                count_reg <= 26'd0;     // ���������
            end else if (running) begin    //�����running�Ƿ�ֹ����һ��start����1s(Ҳ���ǻ�û������)����һ��start
                // �����ʱ���������У����м���
                if (count_reg == TARGET_COUNT) begin
                     // ����ﵽĿ�����ֵ����ʾ1�뵽��
                    done      <= 1'b1;      // ��������ź�
                    running   <= 1'b0;      // ֹͣ��ʱ
                end else begin
                    count_reg <= count_reg + 1'b1;
                end
            end
        end
    end

endmodule

