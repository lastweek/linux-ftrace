set -x
set -e

DIR=/sys/kernel/debug/tracing

# Disable tracing and clear trace
echo 0 > $DIR/tracing_on
echo > $DIR/trace
echo > $DIR/set_ftrace_filter

# Setup tracer type
echo function_graph > $DIR/current_tracer

# Setup cpumask if any
echo 800000 > $DIR/tracing_cpumask

# Setup functions
echo __do_page_fault > $DIR/set_graph_function
#echo handle_mm_fault > $DIR/set_graph_function

echo 1 > $DIR/tracing_on
