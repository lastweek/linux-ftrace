#define _GNU_SOURCE

#include "includeme.h"
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>

static void getcpu(int *cpu, int *node)
{
	int ret;

	ret = syscall(SYS_getcpu, cpu, node, NULL);
}

static int pin_cpu(int cpu_id)
{
	int ret;

	cpu_set_t cpu_set;
	CPU_ZERO(&cpu_set);
	CPU_SET(cpu_id, &cpu_set);

	ret = sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
	return ret;
}

int main(int argc, char **argv)
{
	int cpu, node;
	int fd;
	void *foo;
	long nr_size, i;
	struct timeval ts, te, result;
	struct stat st;
	size_t file_size, mmap_size;
	int NR_PAGES;

	if (argc != 2)
		die("Usage: ./a.out file_to_open");

	pin_cpu(23);
	getcpu(&cpu, &node);
	printf("Runs on cpu: %d, node: %d\n", cpu, node);

	/* Open and get file size */
	fd = open(argv[1], O_RDONLY);
	if (fd < 0)
		die("Fail to open file: %s", argv[1]);
	fstat(fd, &st);
	file_size = st.st_size;
	NR_PAGES = file_size / PAGE_SIZE;
	mmap_size = NR_PAGES * PAGE_SIZE;
	printf("Using file: %s file_size: %zu B, nr_pages: %d\n", argv[1], file_size, NR_PAGES);

	foo = mmap(NULL, mmap_size, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
	if (foo == MAP_FAILED) {
		perror("Fail to mmap");
		exit(-1);
	}

	gettimeofday(&ts, NULL);
	for (i = 0; i < NR_PAGES; i++) {
		int *bar, cut;

		bar = foo + PAGE_SIZE * i;
		*bar = 100;
		//printf("%10d %#lx\n", i, bar);
	}
	gettimeofday(&te, NULL);
	timeval_sub(&result, &te, &ts);

	printf(" Runtime: %ld.%06ld s\n",
		result.tv_sec, result.tv_usec);
	printf(" NR_PAGES: %d\n", NR_PAGES);
	printf(" per_page_ns: %lu\n",
		(result.tv_sec * 1000000000 + result.tv_usec * 1000) / NR_PAGES);

	return 0;
}
