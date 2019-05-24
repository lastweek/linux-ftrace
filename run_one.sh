#
# Setup ftrace
# Clear pgcache
# Run test program
#

./set_ftrace_filter.sh
sleep 1

sync ; echo 3 > /proc/sys/vm/drop_caches
sleep 1

/usr/bin/time ./src/file.o ./src/5
#./src/file.o ./src/5
