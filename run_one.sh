#
# Setup ftrace
# Clear pgcache
# Run test program
#


##
# Step I: Setup ftrace
#
./set_ftrace_filter.sh
#./set_graph_function.sh
sleep 1

##
# Step II: Drop pgcache if needed
#
sync ; echo 3 > /proc/sys/vm/drop_caches
sleep 1

##
# Step III: Run test program
#
#/usr/bin/time ./src/file.o ./src/tmpfs/5
#./src/file.o ./src/5
lxc-execute -n test -s lxc.cgroup.memory.limit_in_bytes=1G ./src/anonymous.o
