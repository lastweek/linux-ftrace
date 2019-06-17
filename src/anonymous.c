#define _GNU_SOURCE

#include "includeme.h"
#include <sched.h>

void getcpu(int *cpu, int *node)
{
	int ret;

	ret = syscall(SYS_getcpu, cpu, node, NULL);
}

#define NR_PAGES 1000000ULL

int oneg(void)
{
	void *foo;
	long nr_size, i;
	struct timeval ts, te, result;

	nr_size = NR_PAGES * PAGE_SIZE;
	//posix_memalign(&foo, PAGE_SIZE, nr_size);
	foo = mmap(NULL, nr_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	if (!foo)
		die("fail to malloc");
	printf("Range: [%#lx - %#lx]\n", foo, foo + NR_PAGES * PAGE_SIZE);

	gettimeofday(&ts, NULL);
	for (i = 0; i < NR_PAGES; i++) {
		int *bar, cut;

		bar = foo + PAGE_SIZE * i;
		*bar = 100;
		//printf("%10d %#lx\n", i, bar);
	}
#if 0
	for (i = 0; i < NR_PAGES; i++) {
		int *bar, cut;

		bar = foo + PAGE_SIZE * i;
		cut = *bar;
		//printf("%10d %#lx\n", i, bar);
	}
#endif
	gettimeofday(&te, NULL);
	timeval_sub(&result, &te, &ts);

	printf(" Runtime: %ld.%06ld s\n",
		result.tv_sec, result.tv_usec);
	printf(" NR_PAGES: %d\n", NR_PAGES);
	printf(" per_page_ns: %lu\n",
		(result.tv_sec * 1000000000 + result.tv_usec * 1000) / NR_PAGES);
	return 0;
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

int main(void)
{
	int cpu, node;

	pin_cpu(23);

	getcpu(&cpu, &node);
	printf("cpu: %d, node: %d, nr_pages: %lu\n", cpu, node, NR_PAGES);

	oneg();
}
