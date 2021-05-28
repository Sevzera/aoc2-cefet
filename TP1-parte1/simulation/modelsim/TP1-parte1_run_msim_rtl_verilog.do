transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/sev-windowsvm/Desktop/aoc2-cefet/TP1-parte1 {C:/Users/sev-windowsvm/Desktop/aoc2-cefet/TP1-parte1/memoriaRAM.v}

