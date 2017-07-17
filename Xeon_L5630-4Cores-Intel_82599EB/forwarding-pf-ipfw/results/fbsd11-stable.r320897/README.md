impact of r320897 (Intel drivers update) on forwarding performance:
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD 11-stable
  - 2000 flows of smallest UDP packets
  - harvest.mask=351
  - Traffic load at 14.48Mpps (10Gigabit line-rate)

inet4 forwarding:
````
x r320896 inet4 forwarding performance in Packets-per-second
+ r320897 inet4 forwarding performance in Packets-per-second
+--------------------------------------------------------------------------+
|        +       x                                                         |
|        + +    xxx                                               + +     x|
|  |_____________M__________A_________________________|                    |
||_________M_____________________A______________________________|          |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2391158       2827046       2400271     2485689.6     190946.03
+   5       2340001       2784777       2354638       2518375     235724.04
No difference proven at 95.0% confidence
```

inet6 forwarding
```
x 320896 inet6 forwarding performance in Packets-per-second
+ 320897 inet6 forwarding performance in Packets-per-second
+--------------------------------------------------------------------------+
|++             xxx                              +++                      x|
|       |_________M_____________________A______________________________|   |
|   |__________________________A_________________M_______|                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2192929       2612661       2209081     2365128.4     225052.37
+   5       2088639       2444865       2436635     2301707.2     191577.83
No difference proven at 95.0% confidence
```

