set -x
set -e

DIR=/sys/kernel/debug/tracing

# Presetup if any
./prepare.sh

# Disable tracing and clear trace
echo 0 > $DIR/tracing_on
echo > $DIR/trace
echo > $DIR/set_ftrace_filter
echo > $DIR/set_graph_function

# Setup tracer type
echo function_graph > $DIR/current_tracer
#echo irqsoff > $DIR/current_tracer

##
# Top-level pgfault functions
# - handle_mm_fault() could come from faultin_page()
# - __do_page_fault() could come from copy_from/to_user()
# - That means, not everything comes from userspace as expected.
#
#echo xperf_profile* >> $DIR/set_ftrace_filter
#echo  hugetlb_fault >> $DIR/set_ftrace_filter
echo  __handle_mm_fault >> $DIR/set_ftrace_filter

##
# cgroup-related
echo      mem_cgroup_try_charge_delay >> $DIR/set_ftrace_filter
echo      mem_cgroup_commit_charge >> $DIR/set_ftrace_filter
echo      mem_cgroup_cancel_charge >> $DIR/set_ftrace_filter
#echo      try_to_free_mem_cgroup_pages >> $DIR/set_ftrace_filter
#echo      pageout* >> $DIR/set_ftrace_filter
#echo      try_to_unmap* >> $DIR/set_ftrace_filter
#echo      try_to_unmap_flush >> $DIR/set_ftrace_filter


##
# do_anonymous_page()
#  - First Write on an anonymous page, the one we interested.
#  - First Read will use the zero_page, not interesting.
#
#echo    do_anonymous_page >> $DIR/set_ftrace_filter
#echo      __anon_vma_prepare >> $DIR/set_ftrace_filter
#echo      alloc_pages_vma >> $DIR/set_ftrace_filter
#echo      page_add_new_anon_rmap >> $DIR/set_ftrace_filter
#echo      mem_cgroup_try_charge_delay >> $DIR/set_ftrace_filter
#echo      mem_cgroup_commit_charge >> $DIR/set_ftrace_filter
#echo      lru_cache_add_active_or_unevictable >> $DIR/set_ftrace_filter

##
# Fault on file-mmap
#echo    __do_fault >> $DIR/set_ftrace_filter
#echo        submit_bio >> $DIR/set_ftrace_filter
#echo        ext4_filemap_fault >> $DIR/set_ftrace_filter
#echo        ext4_readpage >> $DIR/set_ftrace_filter
#echo        ext4_readpages >> $DIR/set_ftrace_filter

echo    __mm_populate >> $DIR/set_ftrace_filter
echo    get_user_pages* >> $DIR/set_ftrace_filter

#echo    do_swap_page >> $DIR/set_ftrace_filter
#echo    do_wp_page >> $DIR/set_ftrace_filter

echo 1 > $DIR/tracing_on
