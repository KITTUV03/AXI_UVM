class c_80_1;
    integer i = 9;
    rand bit[31:0] AWADDR; // rand_mode = ON 

    constraint aligned_address_this    // (constraint_mode = ON) (src/tb/agent/axi_trans.sv:51)
    {
       ((AWADDR[1:0]) == 2'h0);
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (src/tb/sequences/axi_b2b_write.sv:31)
    {
       (AWADDR == i);
    }
endclass

program p_80_1;
    c_80_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "1z00x0z1z0xzzzzz001xz0z01x0x0zxzxzxzxzzxzxzxxzzxxzzxzzxxxzxxxxzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
