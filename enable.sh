#
# Enable Tracing after setup
#

DIR=/sys/kernel/debug/tracing
echo 1 > $DIR/tracing_on
