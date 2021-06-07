view wave 
wave clipboard store
wave create -driver freeze -pattern counter -startvalue 00000000 -endvalue 11111111 -type Range -direction Up -period 50ps -step 1 -repeat forever -range 7 0 -starttime 0ps -endtime 1000ps sim:/MemoriaRAM/address 
WaveExpandAll -1
wave modify -driver freeze -pattern counter -startvalue 00000000 -endvalue 11111111 -type Range -direction Up -period 100ps -step 1 -repeat forever -range 7 0 -starttime 0ps -endtime 1000ps Edit:/MemoriaRAM/address 
WaveCollapseAll -1
wave clipboard restore
