module MedianFilter ( 
    input clock, input reset, input start, 
    output reg done, output reg out_valid, 
    output reg [7:0] pixel_out 
);
    parameter WIDTH  = 430;
    parameter HEIGHT = 554;
    parameter BORDER = 6; 

    localparam X_START = BORDER;
    localparam X_END   = WIDTH - BORDER - 1;
    localparam Y_START = BORDER;
    localparam Y_END   = HEIGHT - BORDER - 1;

    reg [7:0] img_ram [0:WIDTH*HEIGHT-1];
    initial $readmemh("D:/HK2-2025/HDL/LAB2/baitap1_nhieu.hex", img_ram);

    reg [9:0] x, y; 
    reg [3:0] cnt;  
    reg [7:0] win [0:8];
    reg [2:0] state;

    localparam IDLE=0, CHECK=1, FETCH=2, PROCESS=3, NEXT=4, FINISH=5;

    wire [7:0] median_val;
    sort9_cas u_sort (
        .p0(win[0]), .p1(win[1]), .p2(win[2]), .p3(win[3]), .p4(win[4]), 
        .p5(win[5]), .p6(win[6]), .p7(win[7]), .p8(win[8]), 
        .median(median_val)
    );

    integer signed nx, ny; 
    reg [9:0] safe_nx, safe_ny;
    reg [18:0] addr;

    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            state <= IDLE;
            x <= 0; y <= 0;
            done <= 0; out_valid <= 0; cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0; out_valid <= 0; x <= 0; y <= 0;
                    if (start) state <= CHECK;
                end
                CHECK: begin
                    if (x < X_START || x > X_END || y < Y_START || y > Y_END)
                        state <= PROCESS; 
                    else begin
                        cnt <= 0;
                        state <= FETCH;   
                    end
                end

                FETCH: begin
                    case (cnt)
                        0: begin ny = y-1; nx = x-1; end
                        1: begin ny = y-1; nx = x;   end
                        2: begin ny = y-1; nx = x+1; end
                        3: begin ny = y;   nx = x-1; end
                        4: begin ny = y;   nx = x;   end
                        5: begin ny = y;   nx = x+1; end
                        6: begin ny = y+1; nx = x-1; end
                        7: begin ny = y+1; nx = x;   end
                        8: begin ny = y+1; nx = x+1; end
                    endcase

                    if (nx < X_START) safe_nx = X_START;
                    else if (nx > X_END) safe_nx = X_END;
                    else safe_nx = nx;

                    if (ny < Y_START) safe_ny = Y_START;
                    else if (ny > Y_END) safe_ny = Y_END;
                    else safe_ny = ny;

                    addr = safe_ny * WIDTH + safe_nx;
                    win[cnt] <= img_ram[addr];

                    if (cnt == 8) state <= PROCESS;
                    else cnt <= cnt + 1;
                end

                PROCESS: begin
                    out_valid <= 1;
                    if (x < X_START || x > X_END || y < Y_START || y > Y_END)
                        pixel_out <= 8'hFF;    
                    else
                        pixel_out <= median_val; 
                    state <= NEXT;
                end

                NEXT: begin
                    out_valid <= 0;
                    if (x < WIDTH - 1) begin
                        x <= x + 1;
                        state <= CHECK;
                    end else if (y < HEIGHT - 1) begin
                        x <= 0;
                        y <= y + 1;
                        state <= CHECK;
                    end else begin
                        state <= FINISH;
                    end
                end

                FINISH: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule