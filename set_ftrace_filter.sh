set -x
set -e

DIR=/sys/kernel/debug/tracing

# Clear trace
echo > $DIR/trace

# Disable tracing
echo 0 > $DIR/tracing_on

# Setup tracer type
echo function_graph > $DIR/current_tracer

# pgfault functions

echo __do_page_fault >> $DIR/set_ftrace_filter
echo  hugetlb_fault >> $DIR/set_ftrace_filter
echo  __handle_mm_fault >> $DIR/set_ftrace_filter
echo    do_anonymous_page >> $DIR/set_ftrace_filter
echo    __do_fault >> $DIR/set_ftrace_filter
echo    do_swap_page >> $DIR/set_ftrace_filter
echo    do_wp_page >> $DIR/set_ftrace_filter

echo 1 > $DIR/tracing_on
