# IPsec bench lab configuration

Configuration of the lab nodes that `bench-lab.sh` does **not** drive.

The harness uploads and reboots only the DUT (`configs/<set>/dut/`) and the
reference endpoint (`configs/<set>/refendpoint/`). The packet generator is set
up once by hand, so its configuration is archived here.

## Nodes

| Role | Host | Mgmt IP | Hardware |
|---|---|---|---|
| Packet generator and receiver | sm1 | 192.168.100.4 | Supermicro, Intel i350 (igb) |
| Device under test | apu2-3 | 192.168.100.43 | PC Engines APU2, AMD GX-412TC 4 cores, Intel i210AT |
| IPsec reference endpoint | sm2 | 192.168.100.46 | Supermicro, Intel Atom C2758 8 cores |

`bench-lab-3nodes.config` in the parent directory holds the full diagram, the
MAC addresses and the pkt-gen command lines.

## Traffic path

    sm1 igb1 ==> apu2-3 igb1 [DUT, encrypts] igb2 ==> sm2 igb1 [peer, decrypts]
     ^                                                            |
     +---------------- sm1 igb2 <=== sm2 igb2 <-------------------+

The ESP tunnel runs between 198.18.1.205 (DUT) and 198.18.1.203 (peer). Only
the DUT's encryption rate is under measurement; the generator and the peer must
never be the bottleneck.

## Things that silently break this bench

- **Routing must point at the DUT, not at the peer.** Both 198.18.0.0/16 and
  198.19.0.0/16 (and their IPv6 equivalents) are routed through 198.18.0.205 on
  igb1. Pointing the return prefix at the peer's own address makes the packets
  leave directly on igb2, skip the tunnel, and measure nothing.
- **sm1's 10G link to sm2 must stay down.** cxl0/cxl1 normally carry
  198.18.0.4/24 and 198.19.0.4/24, the same subnets as the bench ports. With
  both up the kernel prefers the 10G path and the DUT is never traversed. The
  cxl lines are commented out in `generator/etc/rc.conf`; the machine's original
  file is kept on the node as `/etc/rc.conf.pre-ipsec-bench`.
- **pf must be disabled on every node.** We bench IPsec, nothing else.
- **The peer needs `net.inet.ipsec.async_crypto=1`** (set in
  `configs/*/refendpoint/etc/sysctl.conf`). Without it the decryption runs
  inline on the netisr thread and the ESP queue overflows: 203520 dropped for
  204218 received, measured on this Atom C2758. Do **not** set it on the DUT,
  it is a bench variable there (see `configs.vti.async_crypto/`).
- **The `null` cipher needs a non-empty key** since FreeBSD 15
  (`sys/netipsec/key.c` commit 04207850a9b9 rejects `sadb_key_bits == 0` with no
  `SADB_EALG_NULL` exemption). Note `setkey -f` exits 0 even when a line fails,
  so a broken SA produces wrong numbers rather than an error.

## QAT

sm1 and sm2 both carry an `Atom processor C2000 QAT` device, but BSDRP images
built before the `qat_c2xxxfw` module was added to `MODULES_OVERRIDE` lack its
firmware, and the driver fails with `could not load firmware image, error 2`.
The peer keeps up on AES-NI alone with `async_crypto=1`, so QAT is not required
for this bench.
