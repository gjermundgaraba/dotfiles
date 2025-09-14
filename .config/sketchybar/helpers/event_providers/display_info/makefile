BIN_DIR := bin
BIN := $(BIN_DIR)/display_info

all: $(BIN)

$(BIN): display_info.c | $(BIN_DIR)
	clang -O2 -Wall -framework ApplicationServices -o $(BIN) display_info.c

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BIN_DIR)

