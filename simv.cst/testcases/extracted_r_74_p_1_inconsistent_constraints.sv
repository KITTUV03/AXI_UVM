class c_74_1;
    integer i = 3;
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

program p_74_1;
    c_74_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xzzxx1z1111x0x1z1x1zxz000x000zz1xxxzxzxzzzzxzzzxzzzxxzzxxxxxzxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
