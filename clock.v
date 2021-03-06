module clock(    // The top-level module must match the name
rst,
hold,
load,
CLOCK_50,         // of the project file
seg1,
seg2,
seg3,
seg4,
plus,
det
);
input det;
input plus;
input rst;
input CLOCK_50;
input hold;
input load;
output [0:7]seg1;
output [0:7]seg2;
output [0:7]seg3;
output [0:7]seg4;
reg [3:0]count1;
reg [3:0]count2;
reg [3:0]count3;
reg [3:0]count4;
reg   [25:0]count;     
reg   clk2;
initial count1 = 4'b0000;
initial count2 = 4'b0000;
initial count3 = 4'b0000;
initial count4 = 4'b0000;
// clock divider 50MHz to 1Hz
always@(posedge CLOCK_50)
    begin
        if(count==26'd25_000_000)    // counts 25M clk cycles and
            begin                    // toggles clk2 hi or lo
             count<=0;               
             clk2 <= ~clk2;         
            end
        else
            begin
             count<=count+1;
            end
    end    


always @(posedge clk2)
begin
if(load == 1)
begin
if(det == 0)
begin
if(plus == 1)
begin
if(count3+1 == 10)
begin
if(count4 != 5)
begin
count4 <= (count4+1);
count3 <= 0;
end
else
begin
count4 <= 0;
count3 <= 0;
end
end
else
begin
count3 <= (count3+1);
end
end
end
else
begin
if(plus == 0)
begin
if(count3 != 0)
begin 
count3 <= (count3-1);
end
else
begin
if(count4 != 0)
begin
count4 <= (count4-1);
count3 <= 9;
end
else
begin
count4 <= 5;
count3 <= 9;
end
end
end
else
count3 <= count3;
end
end
if(rst == 1)
begin
count1 <= 4'b0000;
count2 <= 4'b0000;
count3 <= 4'b0000;
count4 <= 4'b0000;
end	
else
if(hold == 0)
begin
if(count1+1 == 10)
begin
if(count2 != 5)
begin
count2 <= (count2+1);
count1 <= 0;
end
else
begin
if(count3 != 9)
begin
count3 <= (count3+1);
count2 <= 4'b0000;
count1 <= 4'b0000;
end
else
begin
if(count4 != 5)
begin
count4 <= (count4+1);
count3 <= 4'b0000;
count2 <= 4'b0000;
count1 <= 4'b0000;
end
else
begin
count4 <= 0;
count3 <= 0;
count2 <= 0;
count1 <= 0;
end
end
end
end
else
count1 <= (count1+1);
end
end
Seg7 A(count1,seg1);
Seg7 B(count2,seg2);
Seg7 C(count3,seg3);
Seg7 D(count4,seg4);

endmodule

module Seg7(input [3:0] num, output [0:7] seg);
		reg [7:0] nseg;
    always @(num) 
    begin
        case (num)
            4'b0000: nseg = 8'b11111100; // 0
            4'b0001: nseg = 8'b01100000; // 1
            4'b0010: nseg = 8'b11011010; // 2
            4'b0011: nseg = 8'b11110010; // 3
            4'b0100: nseg = 8'b01100110; // 4
            4'b0101: nseg = 8'b10110110; // 5
            4'b0110: nseg = 8'b10111110; // 6
            4'b0111: nseg = 8'b11100100; // 7
            4'b1000: nseg = 8'b11111110; // 8
            4'b1001: nseg = 8'b11110110; // 9
            default: nseg = 8'b00000000; //  
        endcase
    end
	assign seg = ~nseg;
endmodule 