srctree := ../
objtree := ../
SRCARCH := x86

CFLAGS := -static

SRCS := $(wildcard *.c posix/*.c)
OBJS := $(SRCS:.c=.o)

all: $(OBJS)

clean:
	rm -f *.o

%.o: %.c includeme.h
	gcc -ggdb -o $@ $< -lm -pthread
