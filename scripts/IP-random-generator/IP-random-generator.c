/*-
 * Copyright (c) 2020 Olivier Cochard-Labbé (olivier@cochard.me)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdlib.h>
#include <limits.h> /* needed by strtol */
#include <errno.h>
#include <string.h> /* strcmp */
#include <stdbool.h> /* bool */
#include <malloc_np.h> /* malloc */
#include <sys/socket.h>	/* AF_INET */
#include <arpa/inet.h>
#include <sys/types.h>
#include <netinet/in.h>

#define ELEMENTS	7

//https://www.programmersought.com/article/1863337235/

/* Globals variables */
struct in_addr *table4;
struct in6_addr *table6;
uint32_t table_size;
uint8_t family;

static void
usage(void)
{

	fprintf(stderr, "IP-random-generator type family number\n");
	fprintf(stderr, "type can be::\n");
	fprintf(stderr, " -bird: Generate host bird 2 static routes configuration file:\n");
	fprintf(stderr, " -ipfw: Generate host IPFW black-list table configuration file:\n");
	fprintf(stderr, "family can be: inet, inet6, 4 or 6\n");
	fprintf(stderr, "example:\n");
	fprintf(stderr, "gen-ipfw-table ipfw inet6 1000000\n");
	exit(-1);
}

bool
exist_in_table4(struct in_addr value)
{
	for ( uint32_t i=0; i < table_size; i++)
	{
		if (memcmp(&value, &table4[i], sizeof(struct in_addr)) == 0)
			return true;
		else
			break;
	}
	return false;
}

bool
exist_in_table6(struct in6_addr value)
{
	for ( uint32_t i=0; i < table_size; i++)
	{
		if (memcmp(&value, &table6[i], sizeof(struct in6_addr)) == 0)
			return true;
		else
			break;
	}
	return false;
}

bool
is_inet6_smaller_than(struct in6_addr value, struct in6_addr ref)
{
	int result;
	/*
	struct in6_addr ip6_addr;
	char buf1[INET6_ADDRSTRLEN];
	char buf2[INET6_ADDRSTRLEN];
	inet_ntop(AF_INET6, &value, buf1, sizeof(buf1));
	inet_ntop(AF_INET6, &ref, buf2, sizeof(buf2));
	printf("Is %s smaller than %s ?\n", buf1, buf2);
	*/
	result = memcmp(&value, &ref, sizeof(struct in6_addr));
	if (result < 0) {
		return true;
	} else {
		return false;
	}
}

bool
is_inet6_bigger_than(struct in6_addr value, struct in6_addr ref)
{
	int result;
	/* debug
	struct in6_addr ip6_addr;
	char buf1[INET6_ADDRSTRLEN];
	char buf2[INET6_ADDRSTRLEN];
	inet_ntop(AF_INET6, &value, buf1, sizeof(buf1));
	inet_ntop(AF_INET6, &ref, buf2, sizeof(buf2));
	printf("Is %s bigger than %s ?\n", buf1, buf2);
	*/
	result = memcmp(&value, &ref, sizeof(struct in6_addr));
	if (result > 0) {
		return true;
	} else {
		return false;
	}
}

void
random4_addr (void)
{
    struct in_addr ip_addr, low_ip, high_ip;
	char low[INET_ADDRSTRLEN];
	char high[INET_ADDRSTRLEN];

	for( uint32_t i = 0; i < table_size; i++)
	{
		while (table4[i].s_addr==0)
		{
			ip_addr.s_addr = arc4random();
			/* Keep only range 1.0.0.0 - 223.255.255.255 */
			strlcpy(low, "1.0.0.0", sizeof(low));
			strlcpy(high, "223.255.255.255", sizeof(high));
			inet_pton(AF_INET, low, &low_ip);
			inet_pton(AF_INET, high, &high_ip);
			if ( ntohl(ip_addr.s_addr) < ntohl(low_ip.s_addr) || ntohl(ip_addr.s_addr) > ntohl(high_ip.s_addr) ) {
				continue;
			}
			/* netmap pkt-gen, using source range 192.18.10/24
			   and destination range 198.19.10.0/24
			   but interfaces are into range 198.18.0.0/24 and 198.19.0.0/24
			/* Exclude range 198.18.0.0-198.19.255.255 */
			strlcpy(low, "198.18.0.0", sizeof(low));
			strlcpy(high, "198.19.255.255", sizeof(high));
			inet_pton(AF_INET, low, &low_ip);
			inet_pton(AF_INET, high, &high_ip);
			if (htonl(ip_addr.s_addr) > ntohl(low_ip.s_addr) && ntohl(ip_addr.s_addr) < ntohl(high_ip.s_addr)) {
				continue;
			}

			/* Exclude addresses between 172.16.16.0 (2886733824) and 172.16.17.255 (2886734335) */
			strlcpy(low, "172.16.16.0", sizeof(low));
			strlcpy(high, "172.16.17.255", sizeof(high));
			inet_pton(AF_INET, low, &low_ip);
			inet_pton(AF_INET, high, &high_ip);
			//printf("%u need to exclude range %u -  %u\n", ntohl(ip_addr.s_addr), ntohl(low_ip.s_addr), ntohl(high_ip.s_addr));
			if ( htonl(ip_addr.s_addr) > ntohl(low_ip.s_addr) && htonl(ip_addr.s_addr) < ntohl(high_ip.s_addr)) {
				continue;
			}

			/* check if not already in the table */
			if (exist_in_table4(ip_addr) == true) {
			continue;
			}

		table4[i].s_addr=ip_addr.s_addr;
		}
	}
}

int randrange(int min, int max)
{
	return min + rand() / (RAND_MAX / (max - min + 1) + 1);
}

void
random6_addr (void)
{
    struct in6_addr ip_addr, low_ip, high_ip;
	char low[INET6_ADDRSTRLEN];
	char high[INET6_ADDRSTRLEN];

	for( uint32_t i = 0; i < table_size; i++)
	{
		while (table6[i].s6_addr[0]==0 && table6[i].s6_addr[1]==0 && table6[i].s6_addr[2]==0 && table6[i].s6_addr[3]==0)
		{
			/* XXXX NEED includes BENCH range into it to correctly stress the lookup algorithm */
			/* Generate random into the global space: between 2001:: and 2001::ffff:ffff:ffff:ffff:ffff:ffff */
			/* splitted into 32bytes words: The first one [0] need to be static
			splitted into 16 bytes words: [3] need to be in range 0-128 maximum */
			ip_addr.__u6_addr.__u6_addr32[0] = 33554720; /* 2001: */
			ip_addr.__u6_addr.__u6_addr32[1] = arc4random();
			ip_addr.__u6_addr.__u6_addr16[3] = randrange(0,128);
			ip_addr.__u6_addr.__u6_addr32[2] = arc4random();
			ip_addr.__u6_addr.__u6_addr32[3] = arc4random();

			/* Exclude addresses between 2001:2:: and 2001:2:0:8000:: */
			/* Never reached because bug just before */
			/* XXX: Performance bug on bench lab :Could the lookup algo avoid
			to easly those full range ? */
			strlcpy(low, "2001:2::", sizeof(low));
			strlcpy(high, "2001:2:0:8000:ffff:ffff:ffff:ffff", sizeof(high));
			inet_pton(AF_INET6, low, &low_ip);
			inet_pton(AF_INET6, high, &high_ip);
			if ( is_inet6_bigger_than(ip_addr, low_ip) && is_inet6_smaller_than(ip_addr, high_ip)) {
				continue;
			}

			/* check if not already in the table */
			if (exist_in_table6(ip_addr) == true) {
				continue;
			}

		table6[i]=ip_addr;
		}
	}
}

void
random_addr (void)
{
	if (family == 4)
		random4_addr();
	else if (family == 6)
		random6_addr();
}

void
ipfw_config(void)
{
	struct in_addr ip_addr;
    struct in6_addr ip6_addr;
	char buf4[INET_ADDRSTRLEN];
	char buf6[INET6_ADDRSTRLEN];

	printf("-f flush\n");
	printf("table 1 create type addr\n");
	for (uint32_t i=0; i < table_size; i++)
	{
		if (family==4) {
			ip_addr.s_addr = table4[i].s_addr;
			if (inet_ntop(AF_INET, &ip_addr, buf4, sizeof(buf4)) != NULL) {
				printf("table 1 add %s/32\n", buf4);
			} else {
				printf("ERROR calling inet_ntop with value %u\n", table4[i].s_addr);
			}
		} else if (family==6) {
			ip6_addr = table6[i];

		if (inet_ntop(AF_INET6, &ip6_addr, buf6, sizeof(buf6)) != NULL) {
				printf("table 1 add %s/128\n", buf6);
			} else {
				printf("ERROR calling inet_ntop with value %llx\n", (unsigned long long)table6[i].s6_addr);
			}
		}
	}
	printf("add deny ip from table(1) to any\n");
	printf("add allow ip from any to any\n");
}

void
bird_config(void)
{
	printf("NOT IMPLEMENTED\n");
}

/* Generate IPFW configuration file */
/* With "number" of entries to be blacklisted*/
int
main(int argc, char *argv[])
{
    struct in_addr ip_addr;
    struct in6_addr ip6_addr;
	int i=0;
	//uint32_t *excludedtable;
	char *endptr;
	char ifamily[8];
	char type[8];
	/*
	char tobeexcluded[ELEMENTS][INET_ADDRSTRLEN] = {
		"1.0.0.0",
		"198.18.0.0",
		"198.19.255.255",
		"172.16.16.0",
		"172.16.17.255",
		"223.255.255.255",
		"0.0.0.1"
	}; */

	/* check number of argument */
	if (argc != 4)
	{
		printf("ERROR: Missing argument\n");
		usage();
	}

	strlcpy(type, argv[1], sizeof(type));
	strlcpy(ifamily, argv[2], sizeof(ifamily));

	errno = 0;
	table_size = strtoul(argv[3], &endptr, 10);

    if (errno == ERANGE || errno == EINVAL || (errno != 0 && table_size == 0)) {
        perror("strtol");
        exit(EXIT_FAILURE);
    }

	if (strcmp(ifamily, "inet") == 0 || strcmp(ifamily, "4") == 0) {
		family=4;
	}
	else if (strcmp(ifamily, "inet6") == 0 || strcmp(ifamily, "6") == 0) {
		family=6;
	}

	if (family==4) {
		table4 = calloc( table_size , sizeof(ip_addr) );
	} else if (family==6){
		table6 = calloc( table_size , sizeof(ip6_addr) );
	} else {
		usage();
	}

	/* Now generate random table */
	random_addr();

	if (strcmp(type, "ipfw") == 0) {
		ipfw_config();
	} else if (strcmp(type, "bird") == 0) {
		bird_config();
	}


	if (family==4) {
		free(table4);
	} else if (family==6) {
		free(table6);
	}
	/* free(excludedtable); */
	return (0);
}
