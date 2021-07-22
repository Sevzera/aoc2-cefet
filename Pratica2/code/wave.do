onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pratica2/MClock
add wave -noupdate /pratica2/PClock
add wave -noupdate /pratica2/Resetn
add wave -noupdate /pratica2/Run
add wave -noupdate -color Cyan /pratica2/DIN
add wave -noupdate /pratica2/Done
add wave -noupdate -divider Processador
add wave -noupdate /pratica2/proc/mem
add wave -noupdate /pratica2/proc/pc
add wave -noupdate /pratica2/proc/doutM
add wave -noupdate /pratica2/proc/addrM
add wave -noupdate /pratica2/proc/wM
add wave -noupdate /pratica2/proc/BusWires
add wave -noupdate /pratica2/proc/Clear
add wave -noupdate /pratica2/proc/Xreg
add wave -noupdate /pratica2/proc/Yreg
add wave -noupdate -color {Cornflower Blue} -radix unsigned /pratica2/proc/R0
add wave -noupdate -color {Cornflower Blue} -radix unsigned /pratica2/proc/R1
add wave -noupdate -color {Cornflower Blue} -radix unsigned /pratica2/proc/R2
add wave -noupdate -color {Cornflower Blue} -radix unsigned /pratica2/proc/R3
add wave -noupdate -color {Medium Orchid} -radix unsigned /pratica2/proc/A
add wave -noupdate -color {Medium Orchid} -radix unsigned /pratica2/proc/G
add wave -noupdate -color Gold -radix unsigned /pratica2/proc/aluOut
add wave -noupdate /pratica2/proc/IR
add wave -noupdate /pratica2/proc/I
add wave -noupdate -divider {Sinais processador}
add wave -noupdate -color Red /pratica2/proc/TstepQ
add wave -noupdate -radix unsigned /pratica2/proc/aIn
add wave -noupdate -radix unsigned /pratica2/proc/gIn
add wave -noupdate -radix unsigned /pratica2/proc/gOut
add wave -noupdate -radix unsigned /pratica2/proc/dinOut
add wave -noupdate -radix unsigned /pratica2/proc/irIn
add wave -noupdate -radix unsigned /pratica2/proc/incr_pc
add wave -noupdate /pratica2/proc/regOut
add wave -noupdate /pratica2/proc/regIn
add wave -noupdate /pratica2/proc/aluSignal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {380 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {45 ps} {545 ps}
