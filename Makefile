all: compile-compiler

COMPILER_SOURCES = $(shell find compiler/ -type f -name '*.S' -print)
COMPILER_HEADERS = $(shell find compiler/ -type f -name '*.h' -print)

COMPILER_OBJECTS = $(COMPILER_SOURCES:.S=.o)

compiler/*.o:

compile-compiler: $(COMPILER_OBJECTS)
	ld $(COMPILER_OBJECTS) -o armadillo

clean:
	rm -f armadillo $(COMPILER_OBJECTS)

