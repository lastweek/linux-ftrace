# Linux ftrace Scripts

This repo has some ftrace scripts to interact with the linux ftrace subsystem.
Instead of using this scripts, you can also directly interact with it using those sys files.
The scripts is just a wrapper.

## Usage

Enable tracing:
- `set_ftrace_filter.sh`: enable classical ftrace on selected functons
- `set_graph_function.sh`: enable to dump function call graph on selected functons

Dump trace (after you have enabled one of the above modes):
- `cat_trace_file.sh`

Disable tracing:
- `disable.sh`

For both tracing modes,
select the functions by selectively enabling `echo XXX >> $DIR/set_ftrace_filter`.

All these script files are very simple and takes no argument to run.
If you wish to change anything, modify the scripts directly.

## Tips for tracing pgfaults

Originally, I wrote these scripts to trace pgfaults.


- Some caveats
	- Pay close attention to _hugepage_ usage if you are measuing pgfault latency in userspace with a high version kernel.
		- `echo never > /sys/kernel/mm/transparent_hugepage/enabled`
		- `cat /proc/meminfo`
	- Drop page cache if needed
		- `echo 3 > /proc/sys/vm/drop_caches`

- Misc
	- Trace major/minor pgfaults in an easy way:
		- e.g., `/usr/bin/time ls`
	- Easy way to verify if any hugepage func is called within kernel
		- `echo __do_page_fault >> set_graph_function`, then search huge within `trace`.
	- Create file with certain size
		- `dd if="/dev/zero" of=output.txt bs=4096 count=10`
