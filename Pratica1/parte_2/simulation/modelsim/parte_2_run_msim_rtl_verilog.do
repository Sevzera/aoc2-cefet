transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Victor/Desktop/Pratica_1/parte_2 {C:/Users/Victor/Desktop/Pratica_1/parte_2/MemoriaRAM.v}
