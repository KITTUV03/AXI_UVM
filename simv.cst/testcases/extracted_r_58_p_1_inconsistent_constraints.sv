class c_58_1;
    integer addr = 7;
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

program p_58_1;
    c_58_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xx11xx1zzzx1x0x00xx0xxxz101zx010zxxxxzxxzxzxxxzzxxzxxxxxxzzzzxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
