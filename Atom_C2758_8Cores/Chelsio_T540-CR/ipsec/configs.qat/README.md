# configs.qat: the QAT arm's DUT configuration

One directory per cypher, each holding only the `dut/` half. The
`refendpoint/` halves are shared with `../configs/<cypher>/refendpoint/`
unchanged: enabling QAT on the DUT does not change what the peer must run.

There is no `null` set here. With no cypher there is nothing for a crypto
accelerator to do, so the comparison would be meaningless.

## Loading the driver

`etc/rc.conf` carries:

```sh
kld_list="qat_c2xxxfw qat_c2xxx"
```

Order matters: the firmware module must be resident before the PF driver
attaches. Do **not** move this to `boot/loader.conf.local` as `qat_c2xxx(4)`
suggests: `qat_c2xxx_load="YES"` there panics the boot with `panic: timed
sleep before timers are working`.

`qat_c2xxxfw.ko` cannot be unloaded once loaded (`Device busy`), so an A/B
against AES-NI needs a fresh boot per arm. Never load and unload within one
boot.

`etc/rc.local` dumps `dev.qat_c2xxx.0.stats` so each iteration records
whether QAT actually carried the traffic. Those counters are what the result
set's `ring_full` analysis rests on.

## Running it: the reference endpoint must not be rebooted

`bench-lab.sh` uploads to and **reboots** `REF_ADMIN` whenever a
configuration set contains both a `dut/` and a `refendpoint/` directory (the
test at `scripts/bench-lab.sh:265`, the reboot at `:269`). The reference
endpoint of this bench is bigone, which is not nanobsd (no `/cfg`, no `config
save`, so an uploaded file would not persist) and is the lab's workstation: it
must not be rebooted between configuration sets.

So do not pass this tree to `-c` directly. Copy it to a scratch tree with the
`dut/` level stripped, which makes the harness take the single-node branch,
and point `-c` at that:

```sh
for c in aes-gcm-128 aes-gcm-256 aes-cbc-128-hmac-sha1 aes-cbc-256-hmac-sha2-256; do
    mkdir -p /tmp/configs.qat.run/$c
    cp -r configs.qat/$c/dut/* /tmp/configs.qat.run/$c/
done
```

bigone is configured once by hand from `../configs/<cypher>/refendpoint/`,
which is the versioned record of what it must contain.
