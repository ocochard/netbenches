# Withdrawn: IPv4 and IPv6 arms used different flow counts

This set is not a valid IPv4-against-IPv6 comparison and is kept only as the
raw record.

`equilibrium` hardcoded a different flow count per address family:

| family | source x destination | flows |
|---|---|---|
| IPv4 | `198.18.10.1-.71` x `198.19.10.1-.70` | 71 x 70 = 4970 |
| IPv6 | `[2001:2:0:10::1]-::14` x `[2001:2:0:8010::1]-::64` | 20 x 100 = 2000 |

So every IPv4 bench here ran ~4970 flows and every IPv6 bench 2000. Flow count
drives the RSS queue spread on the DUT, so the two families were not measuring
the same thing. That is a candidate explanation for the IPv6/IPv4 packet-rate
ratio reported in this set's README, which the hwpmc profiles could not
account for: the profiles found the same per-packet cost in both families.

`equilibrium` now defaults to 2000 flows in both families. The replacement set
re-runs all five cyphers with matched flow counts.

The null cypher figure in this set (2062 Mb/s IPv4, against 3702 on
FreeBSD 13-r365873) is **not** a search artifact: the search offered 2500 Mb/s
and the DUT returned 2044, with no "forwarding rate too low" clamp in any of
the five iterations. Whether it survives the flow-count correction is what the
replacement set answers.
