set -x
set -e

DIR=/sys/kernel/debug/tracing

# Clear trace
echo > $DIR/trace

# Disable tracing
echo 0 > $DIR/tracing_on

# Setup tracer type
echo function_graph > $DIR/current_tracer

echo > $DIR/set_ftrace_filter
echo __do_page_fault >> $DIR/set_graph_function

echo 1 > $DIR/tracing_on
