#
# Some general ftrace setup
#

set -e
set -x

DIR=/sys/kernel/debug/tracing

# In this test case, we are using cpu23
# and adjust its buffer size only.
echo 800000 > $DIR/tracing_cpumask
echo 80000 > $DIR/per_cpu/cpu23/buffer_size_kb
