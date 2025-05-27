#
# 8ms Makefile
#
TOPDIR := ${shell pwd}
LVGL_DIR_NAME := lvgl
LVGL_DIR := ${shell pwd}

include SSD20X/config.mk

CFLAGS += -I$(LVGL_DIR)/
CFLAGS += -DLV_CONF_INCLUDE_SIMPLE -DLV_EX_CONF_INCLUDE_SIMPLE
CFLAGS += -I$(TOPDIR)/include/ -I$(TOPDIR)/include/lvgl/
CFLAGS += -I$(TOPDIR)/extra/include/ -I$(TOPDIR)/extra/include/freetype2
CFLAGS += -I$(TOPDIR)/lvgl/src/ui/

MSRCS += $(shell find . -maxdepth 1 -name \*.c)

# Thêm các file .c trong lvgl/src/ui vào danh sách source
UI_SRCS := $(shell find $(TOPDIR)/lvgl/src/ui -name '*.c')
MSRCS += $(UI_SRCS)

include $(LVGL_DIR)/main/8ms.mk
include $(LVGL_DIR)/control/control.mk
include $(LVGL_DIR)/tty/tty.mk
include $(LVGL_DIR)/blockly/blockly.mk

OBJEXT ?= .o
MOBJS = $(patsubst %.c,build/%.o,$(MSRCS))

DLIBS := -llvgl -lubus -lubox -lblobmsg_json -ljson-c -lcrypto -lwtinfo -lcJSON -lm -lbz2 -lz -lpng -lfreetype -lm
all: clean prepare demo

prepare:
	@mkdir -p build bin

build/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c -o $@ $^
	@echo "CC $^"

demo: $(MOBJS)
	$(CC) -o bin/$@ $(MOBJS) -L./lib -L$(TOPDIR)/extra/lib/ $(DLIBS)
	cp bin/$@ bin/$@_debug
	$(STRIP) --strip-all bin/$@

clean:
	@rm -rf build bin

