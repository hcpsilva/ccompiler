#	-- ccompiler --
#
#	ccompiler's project Makefile.
#
#	Utilization example:
#		make <TARGET> ["DEBUG=true"]
#
#	@param TARGET
#		Can be any of the following:
#		all - builds the project (DEFAULT TARGET)
#		clean - cleans up all binaries generated during compilation
#		redo - cleans up and then builds
#		help - shows the utilization example
#
#	@param "DEBUG=true"
#		When present, the build will happen in debug mode.
#
#	@author
#		@hcpsilva - Henrique Silva
#		@birromer - Bernardo Hummes
#
#	Make's default action is "all" when no parameters are provided.


################################################################################
#	Definitions:

#	- Project's directories:
INC_DIR := include
OBJ_DIR := bin
OUT_DIR := build
SRC_DIR := src
LIB_DIR := lib

#	- Compilation flags:
#	Compiler and language version
CC := gcc -std=c11
FLX := flex
#	If DEBUG is defined, we'll turn on the debug flag and attach address
#	sanitizer on the executables.
CFLAGS :=\
	-Wall \
	-Wextra \
	-Wpedantic \
	-Wshadow \
	-Wunreachable-code
CFLAGS += $(if $(DEBUG),-g -fsanitize=address -DDEBUG)
CFLAGS += $(if $(VERBOSE), -DVERBOSE)
FLXFLAGS :=\
	--nomain \
	--yylineno
FLXFLAGS += $(if $(DEBUG),-d)
OPT := $(if $(DEBUG),-O0,-O3 -march=native)
LIB := -L$(LIB_DIR)
INC := -I$(INC_DIR)

#	- Release version:
RELEASE := etapa1

################################################################################
#	Files:

#	- Main source files:
#	Presumes that all "main" source files are in the root of SRC_DIR
MAIN := $(notdir $(wildcard $(SRC_DIR)/*.c))

#	- Path to all final binaries:
TARGET := $(MAIN:%.c=$(OUT_DIR)/%)

#	- Lexer files:
LEX := $(shell find $(SRC_DIR) -name '*.l')

#	- Generated lexer sources:
GEN := $(LEX:$(SRC_DIR)/%.l=%.yy.c)

#	- Other source files:
SRC := $(filter-out $(MAIN) $(GEN), $(shell find $(SRC_DIR) -name '*.c' | cut -d'/' -f2-)) $(GEN)

#	- Objects to be created:
OBJ := $(SRC:%.c=$(OBJ_DIR)/%.o)

################################################################################
#	Rules:

#	- Executables:
$(TARGET): $(OUT_DIR)/%: $(SRC_DIR)/%.c $(OBJ)
	$(CC) -o $@ $^ $(INC) $(CFLAGS) $(OPT) $(LIB)

#	- Generated lexer source:
$(GEN): %.yy.c: $(SRC_DIR)/%.l
	$(FLX) $(FLXFLAGS) -o $(SRC_DIR)/$@ $<

#	- Objects:
$(OBJ): $(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(INC) $(CFLAGS) $(OPT)

################################################################################
#	Targets:

.DEFAULT_GOAL = all

all: $(GEN) $(TARGET)
	ln -sf $(shell readlink -f $(TARGET)) $(RELEASE)

clean:
	rm -rf $(OBJ_DIR)/* $(TARGET) $(GEN:%=$(SRC_DIR)/%) $(RELEASE) $(RELEASE).tgz

redo: clean all

tool: clean
	bear make

help:
	@echo "ccompiler's project Makefile."
	@echo
	@echo "Utilization example:"
	@echo " make <TARGET> ['DEBUG=true']"
	@echo
	@echo "@param TARGET"
	@echo " Can be any of the following:"
	@echo " all - builds the project (DEFAULT TARGET)"
	@echo " clean - cleans up all binaries generated during compilation"
	@echo " redo - cleans up and then builds"
	@echo " help - shows the utilization example"
	@echo
	@echo "@param 'DEBUG=true'"
	@echo " When present, the build will happen in debug mode."

################################################################################
#	Debugging and etc.:

#	Debug of the Make variables
print-%:
	@echo $* = $($*)

.PHONY: all clean redo help tool print-%
