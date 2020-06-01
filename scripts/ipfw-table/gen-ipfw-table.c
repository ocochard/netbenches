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
#include <stdbool.h> /* bool */
#include <malloc_np.h> /* malloc */
#include <sys/socket.h>	/* AF_INET */
#include <arpa/inet.h>

#define ELEMENTS	7

static void
usage(void)
{

	fprintf(stderr, "gen-ipfw-table [number-of-entries]\n");
	fprintf(stderr, "example:\n");
	fprintf(stderr, "gen-ipfw-table 1000000\n");
	exit(-1);
}

bool
exist_in_table(uint value, uint32_t *table,  uint32_t size)
{
	int i;
	for (i=0; i < size; i++)
	{
		if (value == table[i])
			return true;
		if (value == 0)
			break;
	}
	return false;
}

/* Generate IPFW configuration file */
/* With "number" of entries to be blacklisted*/
int
main(int argc, char *argv[])
{
    struct in_addr ip_addr;
	int i=0;
	uint32_t *table, *excludedtable;
	char buf[INET_ADDRSTRLEN];
	char tobeexcluded[ELEMENTS][INET_ADDRSTRLEN] = {
		"1.0.0.0",
		"198.18.0.0",
		"198.19.255.255",
		"172.16.16.0",
		"172.16.17.255",
		"223.255.255.255",
		"0.0.0.1"
	};

	/* check number of argument */
	if (argc != 2)
	{
		printf("ERROR: Missing argument\n");
		usage();
	}
	if (atoi(argv[1]) == 0)
	{
		printf("ERROR: argument need to be a number\n");
		usage();
	}
	table = calloc( atoi(argv[1]) , sizeof(uint32_t) );

	/* Convert ASCII address into int */
	/*
	excludedtable = calloc( ELEMENTS, sizeof(uint32_t) );
	for(i = 0; i < ELEMENTS; i++)
    {
		if (inet_pton(AF_INET, tobeexcluded[i] , &ip_addr) == 1) {
			excludedtable[i] = htonl(ip_addr.s_addr);
			printf("inet_pton(AF_INET, %s, ip_addr.s_addr) => %u\n", tobeexcluded[i], excludedtable[i]);
		} else {
			printf("Error for id %u (%s)\n", i, tobeexcluded[i]);
		}
			if (inet_ntop(AF_INET, &ip_addr, buf, sizeof(buf)) != NULL) {
			printf("inet_ntop(AF_INET, %u, ...) => %s\n", htonl(ip_addr.s_addr), buf);
		} else {
			printf("Error\n");
		}
	}
	*/

	/* Now generate random table */
	for(i = 0; i < atoi(argv[1]); i++)
	{
		while (table[i]==0)
		{
			ip_addr.s_addr = arc4random();
			/* Need to be between 16777216 (1.0.0.0) and 3758096383 (223.255.255.255) */
			if ( htonl(ip_addr.s_addr) < 16777216 || htonl(ip_addr.s_addr) > 3758096383 ) {
				continue;
			}

			/* Exclude IP between 198.18.0.0 (3323068416) and "198.19.255.255 (3323199487) */
			if ( htonl(ip_addr.s_addr) < 3323199487 && htonl(ip_addr.s_addr) > 3323068416 ) {
				continue;
			}

			/* Exclude IP between 172.16.16.0 (2886733824) and 172.16.17.255 (2886734335) */
			if ( htonl(ip_addr.s_addr) < 2886734335 && htonl(ip_addr.s_addr) > 2886733824 ) {
				continue;
			}

			/* check if not already in the table */
			if (exist_in_table(ip_addr.s_addr, table, atoi(argv[1])) == true) {
				continue;
			}

			/* if (inet_ntop(AF_INET, &ip_addr, buf, sizeof(buf)) != NULL) {
				printf("random: %u (%s)\n", ip_addr.s_addr, buf);
			} */
			table[i]=ip_addr.s_addr;
		}
	}

	printf("-f flush\n");
	printf("table 1 create type addr\n");
	for (i=0; i < atoi(argv[1]); i++)
	{
		ip_addr.s_addr = table[i];
		if (inet_ntop(AF_INET, &ip_addr, buf, sizeof(buf)) != NULL) {
			printf("table 1 add %s/32\n", buf);
		} else {
			printf("ERROR calling inet_ntop with value %u\n", table[i]);
		}
	}
	printf("add deny ip from table(1) to any\n");
	printf("add allow ip from any to any\n");
	free(table);
	/* free(excludedtable); */
	return (0);
}
