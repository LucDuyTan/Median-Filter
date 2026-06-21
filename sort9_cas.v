module sort9_cas ( p0, p1, p2, p3, p4, p5, p6, p7, p8, median );
    input [7:0] p0, p1, p2, p3, p4, p5, p6, p7, p8;
    output reg [7:0] median;
    function [15:0] cas(input [7:0] a, b);
        begin
            cas = (a <= b) ? {a, b} : {b, a};
        end
    endfunction
    reg [7:0] r0, r1, r2, r3, r4, r5, r6, r7, r8;
    reg [7:0] max_min, med_med, min_max;
    always @(*) begin
        //Sắp xếp hàng 1: p0, p1, p2 -> r0, r1, r2
        {r0, r1} = cas(p0, p1);
        {r1, r2} = cas(r1, p2);
        {r0, r1} = cas(r0, r1);

        // 2. Sắp xếp hàng 2: p3, p4, p5 -> r3, r4, r5
        {r3, r4} = cas(p3, p4);
        {r4, r5} = cas(r4, p5);
        {r3, r4} = cas(r3, r4);

        // 3. Sắp xếp hàng 3: p6, p7, p8 -> r6, r7, r8
        {r6, r7} = cas(p6, p7);
        {r7, r8} = cas(r7, p8);
        {r6, r7} = cas(r6, r7);

        // 4. Tìm Max của các Min (r0, r3, r6)
        {r0, r3} = cas(r0, r3); 
        {r3, r6} = cas(r3, r6); 
        max_min = r6;
        // 5. Tìm Min của các Max (r2, r5, r8)
        {r2, r5} = cas(r2, r5); 
        {r2, r8} = cas(r2, r8); 
        min_max = r2;
        // 6. Tìm Median của các Median (r1, r4, r7)
        {r1, r4} = cas(r1, r4);
        {r4, r7} = cas(r4, r7);
        {r1, r4} = cas(r1, r4);
        med_med = r4;
        // 7. Median cuối cùng là Median của (max_min, med_med, min_max)
        {max_min, med_med} = cas(max_min, med_med);
        {med_med, min_max} = cas(med_med, min_max);
        {max_min, med_med} = cas(max_min, med_med);        
        median = med_med;
    end
endmodule
