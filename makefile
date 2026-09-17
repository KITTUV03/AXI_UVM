
# ==================================================
# VCS + UVM Makefile
# ==================================================

VCS      = vcs
SIMV     = ./simv
URG      = urg

SRC = \
	axi_package.sv \
	axi_interface.sv \
	axi_design.sv \
	axi_top.sv

CMP_OPTS = -full64 -sverilog +v2k -ntb_opts uvm \
           -debug_access+all \
           -cm line+cond+fsm+tgl+branch

# ----------------------------------------
# Compile
# Usage: make c
# ----------------------------------------
c:
	$(VCS) $(CMP_OPTS) $(SRC) -l compile.log

# ----------------------------------------
# Simulate
# Usage: make r
# ----------------------------------------
r:
	$(SIMV) -cm line+cond+fsm+tgl+branch -l sim.log

# ----------------------------------------
# Compile + Run
# Usage: make cr
# ----------------------------------------
cr: c r

# ----------------------------------------
# Coverage Report
# Usage: make cov
# ----------------------------------------
cov:
	$(URG) -dir simv.vdb -report cov_report

# ----------------------------------------
# Open Coverage Report
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
	       *.log DVEfiles novas* \
	       verdiLog inter.fsdb

# ----------------------------------------
# Help
# Usage: make help
# ----------------------------------------
help:
	@echo "make c     -> Compile"
	@echo "make r     -> Run Simulation"
	@echo "make cr    -> Compile + Run"
	@echo "make cov   -> Generate Coverage Report"
	@echo "make view  -> Open Coverage Report"
	@echo "make clean -> Clean Generated Files"
