# ftrace
ftrace scripts

## Trace pgfaults

- Some caveats
	- Pay close attention to _hugepage_ usage if you are measuing pgfault latency in userspace with a high version kernel.
		- `echo never > /sys/kernel/mm/transparent_hugepage/enabled`
		- `cat /proc/meminfo`

- Misc
	- Trace major/minor pgfaults in an easy way:
		- e.g., `/usr/bin/time ls`
	- Easy way to verify if any hugepage func is called within kernel
		- `echo __do_page_fault >> set_graph_function`, then search huge within `trace`.
