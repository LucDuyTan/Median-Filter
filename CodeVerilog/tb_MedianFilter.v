`timescale 1ns / 1ps

module tb_MedianFilter();

    reg clock;
    reg reset;
    reg start;

    wire done;
    wire out_valid;
    wire [7:0] pixel_out;

    integer f;
    integer count;

    MedianFilter uut (
        .clock(clock),
        .reset(reset),
        .start(start),
        .done(done),
        .out_valid(out_valid),
        .pixel_out(pixel_out)
    );

    always #5 clock = ~clock;
    initial begin
        $readmemh("D:/HK2-2025/HDL/LAB2/baitap1_nhieu.hex", uut.img_ram);
    end

    initial begin
        f = $fopen("D:/HK2-2025/HDL/LAB2/output_hex.hex", "w");
        if (!f) begin
            $display("ERROR: Khong mo duoc file!");
            $finish;
        end

        clock = 0;
        reset = 0;
        start = 0;
        count = 0;

        #20 reset = 1;

        #20 start = 1;
        #10 start = 0;
        wait(done);
        #50;

        $fclose(f);

        $display("Pixels written: %0d", count);

        $finish;
    end

    always @(posedge clock) begin
        if (out_valid) begin
            $fwrite(f, "%02h\n", pixel_out);
            count = count + 1;
        end
    end

endmodule