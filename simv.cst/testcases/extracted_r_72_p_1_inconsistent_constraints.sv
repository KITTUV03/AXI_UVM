class c_72_1;
    integer i = 1;
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

program p_72_1;
    c_72_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "00xz01111x01zxz1x01xxzz0z0xz0x10xzxxxzzxzxxzzzzxxxxxzzzxxxzxxzzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
