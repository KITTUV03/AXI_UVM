class c_37_1;
    integer addr = 6;
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

program p_37_1;
    c_37_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "x0xz1xx0z0z1x0z00x110z0xz0z1xzz1xzzxzzxzxzzzxzzxzxzzzxxzxxxzzzzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
