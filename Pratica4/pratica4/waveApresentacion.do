onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Snooping/clock
add wave -noupdate /Snooping/instr
add wave -noupdate -divider Barramento
add wave -noupdate -color Goldenrod /Snooping/saidaBarramento
add wave -noupdate -divider Memoria
add wave -noupdate /Snooping/read
add wave -noupdate -color White -radix unsigned /Snooping/enderecoMem
add wave -noupdate -color White -radix unsigned /Snooping/dadoMem
add wave -noupdate /Snooping/WB
add wave -noupdate -color Khaki -radix unsigned /Snooping/e_WB
add wave -noupdate -color Khaki -radix unsigned /Snooping/d_WB
add wave -noupdate -divider P1
add wave -noupdate /Snooping/p1/setarValores
add wave -noupdate -color {Medium Aquamarine} -radix unsigned /Snooping/p1/Hit
add wave -noupdate -color {Steel Blue} -radix unsigned /Snooping/p1/Estado
add wave -noupdate -color {Steel Blue} -radix unsigned /Snooping/p1/Tag
add wave -noupdate -color {Steel Blue} -radix unsigned /Snooping/p1/Dado
add wave -noupdate -divider P2
add wave -noupdate -color {Medium Aquamarine} -radix unsigned /Snooping/p2/Hit
add wave -noupdate -color Maroon -radix unsigned /Snooping/p2/Estado
add wave -noupdate -color Maroon -radix unsigned /Snooping/p2/Tag
add wave -noupdate -color Maroon -radix unsigned /Snooping/p2/Dado
add wave -noupdate -divider P3
add wave -noupdate -color {Medium Aquamarine} -radix unsigned /Snooping/p3/Hit
add wave -noupdate -color {Dark Orchid} -radix unsigned /Snooping/p3/Estado
add wave -noupdate -color {Dark Orchid} -radix unsigned /Snooping/p3/Tag
add wave -noupdate -color {Dark Orchid} -radix unsigned /Snooping/p3/Dado
add wave -noupdate -divider {Saidas processadores}
add wave -noupdate -color Gray75 -radix unsigned /Snooping/outp1
add wave -noupdate -color Gray75 -radix unsigned /Snooping/outp2
add wave -noupdate -color Gray75 -radix unsigned /Snooping/outp3
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 2} {80 ps} 0}
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
WaveRestoreZoom {0 ps} {2008 ps}
