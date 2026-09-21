class c_84_1;
    integer i = 13;
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

program p_84_1;
    c_84_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zx01zzx11001zxzx011zzxx111xzx000xxxzzxzzxzxzzzzzzxzxzxxzzzzxzzxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
