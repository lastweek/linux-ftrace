set -x
set -e

DIR=/sys/kernel/debug/tracing

# Disable tracing and clear trace
echo 0 > $DIR/tracing_on
echo > $DIR/trace

# Setup tracer type
echo function_graph > $DIR/current_tracer
#echo irqsoff > $DIR/current_tracer

# Setup cpumask if any
echo 800000 > $DIR/tracing_cpumask

# pgfault functions

echo __do_page_fault >> $DIR/set_ftrace_filter
echo  hugetlb_fault >> $DIR/set_ftrace_filter
echo  __handle_mm_fault >> $DIR/set_ftrace_filter
echo    do_anonymous_page >> $DIR/set_ftrace_filter
echo      alloc_pages_vma >> $DIR/set_ftrace_filter
echo      __anon_vma_prepare >> $DIR/set_ftrace_filter
echo      page_add_new_anon_rmap >> $DIR/set_ftrace_filter
echo      mem_cgroup_* >> $DIR/set_ftrace_filter
echo      lru_cache_add_active_or_unevictable >> $DIR/set_ftrace_filter

echo    __do_fault >> $DIR/set_ftrace_filter
echo    do_swap_page >> $DIR/set_ftrace_filter
echo    do_wp_page >> $DIR/set_ftrace_filter

echo 1 > $DIR/tracing_on
