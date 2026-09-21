class c_82_1;
    integer i = 11;
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

program p_82_1;
    c_82_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xz1zx0xx00xxx01zxz110z0x0xz0zz1zzzzxzxzxxzxzxzxxzxzzzzzzzxzxxxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
