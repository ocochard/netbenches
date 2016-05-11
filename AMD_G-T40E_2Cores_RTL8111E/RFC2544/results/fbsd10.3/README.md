Testing performance regarding multiple frame size
  - PC Engines APU (dual core AMD G-T40E Processor 1 GHz)
  - 3 Realtek RTL8111E Gigabit Ethernet ports
  - FreeBSD 10.3
  - 2000 flows of variable size UDP packets
  - 2 static routes

Frame Size | pps Measured: Median | pps measured: min | pps measured: max | Max theoricall  
-----------|----------------------|-------------------|-------------------|----------------
64         |152694                |152690.5           |152715             | 1488095     
128        |152707.5              |152706             |152741             |  844594
256        |152723                |152721             |152740             |  452898
512        |152722                |152719             |152740             |  234962
1024       |119730                |119730             |119730             |  119732
1280       |96152                 |96152              |96152              |   96153
1518       |81273                 |81273              |81273              |   81274

