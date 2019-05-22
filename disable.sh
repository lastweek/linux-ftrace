#
# Disable tracing
#

DIR=/sys/kernel/debug/tracing
echo 0 > $DIR/tracing_on
