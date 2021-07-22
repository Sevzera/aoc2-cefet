transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/ifetch.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/tlb.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/pratica2.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/dec3to5.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/proc.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/upcount.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/regn.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/multiplex.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/alu.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/ramlpm.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/romlpm.v}
vlog -vlog01compat -work work +incdir+E:/Pessoais/Victor/CEFET/2021.1/AOC\ 2/_Laoc/Pratica_II/code_2 {E:/Pessoais/Victor/CEFET/2021.1/AOC 2/_Laoc/Pratica_II/code_2/counterlpm.v}

