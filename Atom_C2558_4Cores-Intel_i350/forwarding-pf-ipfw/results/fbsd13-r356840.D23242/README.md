https://reviews.freebsd.org/D23242
Enter network epoch for network interrupts
```
x 356840.pps
+ 356840D23242.pps
+--------------------------------------------------------------------------+
|x                                    +     +       ++     xx +            |
|                     |_________________________A__________M______________||
|                                        |________A_M______|               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        869221     1100033.5     1098232.5     1052611.2     102532.93
+   5     1013783.5       1106626       1069075     1059918.3     35163.677
No difference proven at 95.0% confidence
```