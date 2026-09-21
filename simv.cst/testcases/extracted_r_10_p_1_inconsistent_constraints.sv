class c_10_1;
    integer addr = 9;
    rand bit[31:0] AWADDR; // rand_mode = ON 

    constraint dec_err_address_this    // (constraint_mode = ON) (src/tb/agent/axi_trans.sv:74)
    {
       (AWADDR >= (16 * 4));
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (src/tb/sequences/axi_corner_data_seq.sv:31)
    {
       (AWADDR == (addr * 4));
    }
endclass

program p_10_1;
    c_10_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zx0z0000zz1x1x0zz00xx0xz10zz01z0xxxzzzxzxzzxzxxxzzzzzxzxzxzxxxzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
