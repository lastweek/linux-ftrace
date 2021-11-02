set -e

DIR=/sys/kernel/debug/tracing

# Presetup if any
# ./prepare.sh

# Disable tracing and clear trace
echo 0 > $DIR/tracing_on
echo > $DIR/trace
echo > $DIR/set_ftrace_filter
echo > $DIR/set_graph_function

# Setup tracer type
echo function_graph > $DIR/current_tracer

#echo __do_page_fault >> $DIR/set_graph_function
#echo handle_mm_fault >> $DIR/set_graph_function

# cgroup-related
#echo mem_cgroup_try_charge_delay >> $DIR/set_graph_function
#echo mem_cgroup_commit_charge >> $DIR/set_graph_function

#echo alloc_workqueue >> $DIR/set_graph_function

echo "Enabled graph functions:"
cat $DIR/set_graph_function

echo 1 > $DIR/tracing_on
