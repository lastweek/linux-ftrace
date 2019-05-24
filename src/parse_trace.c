#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "includeme.h"

/*
 * NOTE: ad-hoc code. The trace file is cooked.
 */

int main(int argc, char **argv)
{
	FILE *fp;
	char *line;
	size_t line_sz;
	long nr;
	double total, max;

	if (argc != 2)
		die("Usage: ./parse_trace.o trace_file_path");

	fp = fopen(argv[1], "r");
	if (!fp)
		die("Fail to open trace file: %s", argv[1]);
	else
		printf("Using trace file: %s\n", argv[1]);

	line_sz = 256;
	line = malloc(line_sz);
	if (!line)
		die("Fail to alloc buffer.");

	nr = 0;
	total = 0;
	max = 0;
	while (getline(&line, &line_sz, fp) != -1) {
		double tmp;
		int nr_matched;

		nr_matched = sscanf(line, "%lf\n", &tmp);
		if (nr_matched > 0) {
			if (tmp > 5)
				continue;

			total += tmp;
			nr++;

			if (tmp > max)
				max = tmp;
		}
	}

	printf("Max: %lf Total: %lf us, nr %d. avg %lf us\n",
		max, total, nr, total/nr);
	return 0;
}
