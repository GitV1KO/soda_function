`timescale 1ns / 1ps
module one_second_timer (
    input  wire clk,       // 50MHz 时钟输入
    input  wire rst,       // 复位信号，低电平有效
    input  wire start,     // 启动定时器信号
    output reg  done       // 完成信号，定时器计时结束时有效
);

    // 定义目标计数值（50MHz时钟下，计数50,000,000次即为1秒）
    localparam TARGET_COUNT = 50_000_000- 1;// 50_000_000次时钟周期，即1秒

    reg [25:0] count_reg;   // 用于计数的寄存器，26位足够表示最大50,000,000
    reg        running;     // 标志位，表示定时器是否正在运行

    // 复位或者计时更新
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count_reg <= 26'd0;
            done      <= 1'b0;
            running   <= 1'b0;
        end else begin
            // 默认情况下，完成信号为0
            done <= 1'b0; 
            
            // 如果接收到启动信号并且定时器没有运行，开始计时
            if (start && !running) begin
                running   <= 1'b1;      // 启动定时器
                count_reg <= 26'd0;     // 清零计数器
            end else if (running) begin    //这里的running是防止给完一个start不到1s(也就是还没计完数)又来一个start
                // 如果定时器正在运行，进行计数
                if (count_reg == TARGET_COUNT) begin
                     // 如果达到目标计数值，表示1秒到达
                    done      <= 1'b1;      // 发出完成信号
                    running   <= 1'b0;      // 停止计时
                end else begin
                    count_reg <= count_reg + 1'b1;
                end
            end
        end
    end

endmodule

