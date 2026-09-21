# ==============================================================================
# VCS + UVM Makefile for Structured Directory (src/design & src/tb)
# ==============================================================================

VCS      = vcs
SIMV     = ./simv
URG      = urg

# Include directories for compiler
INCDIRS = \
	+incdir+src/tb/include \
	+incdir+src/tb/agent \
	+incdir+src/tb/sequences \
	+incdir+src/tb/env \
	+incdir+src/tb/tests \
	+incdir+src/tb/top \
	+incdir+src/design

# Primary source compile order
SRC = \
	src/tb/include/define.svh \
	src/tb/include/axi_interface.sv \
	src/design/axi_design.sv \
	src/tb/top/axi_package.sv \
	src/tb/top/axi_top.sv

# Default test and seed
TEST ?= axi_sanity_test
SEED ?= 1

# Regression Test List
TEST_LIST = \
	axi_sanity_test \
	axi_b2b_write_test \
	axi_slv_err_test \
	axi_dec_err_test \
	axi_unaligned_test \
	axi_wstrb_test \
	axi_corner_data_test \
	axi_negative_test

SEEDS ?= 1 2

CMP_OPTS = -full64 -sverilog +v2k -ntb_opts uvm \
           -timescale=1ns/1ns \
           $(INCDIRS) \
           -debug_access+all \
           -cm line+cond+fsm+tgl+branch \
           -cm_hier cov_hier.cfg

# ----------------------------------------
# Compile
# Usage: make c
# ----------------------------------------
c:
	$(VCS) $(CMP_OPTS) $(SRC) -l compile.log

# ----------------------------------------
# Simulate Single Test
# Usage: make r TEST=axi_sanity_test SEED=10
# ----------------------------------------
r:
	@mkdir -p sim_logs
	$(SIMV) +UVM_TESTNAME=$(TEST) +ntb_random_seed=$(SEED) \
	        -cm line+cond+fsm+tgl+branch \
	        -cm_name $(TEST)_seed_$(SEED) \
	        -cm_dir simv.vdb \
	        -l sim_logs/$(TEST)_seed_$(SEED).log

# ----------------------------------------
# Compile + Run Single Test
# Usage: make cr TEST=axi_sanity_test
# ----------------------------------------
cr: c r

# ----------------------------------------
# Run Full Regression
# Usage: make reg
# ----------------------------------------
reg: c
	@echo "========================================================================================"
	@echo "                   STARTING FULL UVM REGRESSION & COVERAGE RUN                          "
	@echo "========================================================================================"
	@mkdir -p regression_logs
	@rm -rf regression_summary.rpt
	@echo "========================================================================================" >> regression_summary.rpt
	@echo "                               REGRESSION SUMMARY REPORT                                " >> regression_summary.rpt
	@echo "========================================================================================" >> regression_summary.rpt
	@printf "%-22s %-6s %-8s %-12s %-12s %-25s\n" "TEST NAME" "SEED" "STATUS" "WR COV" "RD COV" "LOG FILE" | tee -a regression_summary.rpt
	@echo "----------------------------------------------------------------------------------------" | tee -a regression_summary.rpt
	@for t in $(TEST_LIST); do \
		for s in $(SEEDS); do \
			$(SIMV) +UVM_TESTNAME=$$t +ntb_random_seed=$$s \
			        -cm line+cond+fsm+tgl+branch \
			        -cm_name $${t}_seed_$${s} \
			        -cm_dir simv.vdb \
			        -l regression_logs/$${t}_seed_$${s}.log > /dev/null 2>&1; \
			if grep -q "\*\*\* TEST PASSED \*\*\*" regression_logs/$${t}_seed_$${s}.log && \
			   ! grep -q "UVM_ERROR : *[1-9]" regression_logs/$${t}_seed_$${s}.log && \
			   ! grep -q "UVM_FATAL : *[1-9]" regression_logs/$${t}_seed_$${s}.log; then \
				STATUS="PASSED"; \
			else \
				STATUS="FAILED"; \
			fi; \
			WR_COV=$$(grep "Write Coverage" regression_logs/$${t}_seed_$${s}.log | tail -1 | awk '{print $$NF}'); \
			RD_COV=$$(grep "Read  Coverage" regression_logs/$${t}_seed_$${s}.log | tail -1 | awk '{print $$NF}'); \
			if [ -z "$$WR_COV" ]; then WR_COV="N/A"; fi; \
			if [ -z "$$RD_COV" ]; then RD_COV="N/A"; fi; \
			printf "%-22s %-6s %-8s %-12s %-12s %-25s\n" "$$t" "$$s" "$$STATUS" "$$WR_COV" "$$RD_COV" "regression_logs/$${t}_seed_$${s}.log" | tee -a regression_summary.rpt; \
		done; \
	done
	@echo "========================================================================================" | tee -a regression_summary.rpt
	@$(MAKE) cov

# ----------------------------------------
# Coverage Report
# Usage: make cov
# ----------------------------------------
cov:
	$(URG) -dir simv.vdb -report cov_report -format both

# ----------------------------------------
# View Coverage Dashboard
# Usage: make view
# ----------------------------------------
view:
	firefox cov_report/dashboard.html &

# ----------------------------------------
# Clean
# Usage: make clean
# ----------------------------------------
clean:
	rm -rf csrc simv simv.daidir \
	       ucli.key *.vdb cov_report \
	       *.log sim_logs regression_logs \
	       regression_summary.rpt DVEfiles novas* \
	       verdiLog inter.fsdb

# ----------------------------------------
# Help
# Usage: make help
# ----------------------------------------
help:
	@echo "make c               -> Compile design & testbench"
	@echo "make r TEST=<name>   -> Run single test"
	@echo "make reg             -> Run all tests in regression + auto-generate coverage"
	@echo "make cov             -> Generate URG coverage report"
	@echo "make view            -> Open Coverage HTML Dashboard"
	@echo "make clean           -> Clean all generated files"
