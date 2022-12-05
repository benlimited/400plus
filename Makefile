ADDRESS := 0x7E0000
DEPDIR := .deps
DEPFLAGS = -Wp,-MT,$@ -Wp,-MMD,$(patsubst %.o,$(DEPDIR)/%.d,$(@))

ifndef CROSS_COMPILE
	CROSS_COMPILE := arm-none-eabi-
endif

ifdef RELEASE
	VERSION := VER-$(RELEASE)
	RELNAME := 400plus-$(RELEASE)
	D_FLAGS := -DRELEASE
else
	VERSION := REV-$(shell git rev-parse --short HEAD)
	D_FLAGS :=
endif

USE_FONTS := -DUSE_FONT_SMALL

COMMON_FLAGS := \
	$(USE_FONTS)                      \
	-DVERSION='"$(VERSION)"'          \
	-Wall                             \
	-mcpu=arm946e-s                   \
	-march=armv5te                    \
	-fno-builtin                      \
	-nostdlib                         \
	-fomit-frame-pointer              \
	-fno-strict-aliasing              \
	-mfloat-abi=soft                  \
	-msoft-float                      \

CC     := $(CROSS_COMPILE)gcc
CFLAGS += $(COMMON_FLAGS)              \
	$(D_FLAGS)                         \
	$(DEPFLAGS)                        \
	-Os                                \
	-nostdinc                          \
	-Ivxworks                          \
	-Werror                            \
	-Wstrict-prototypes                \
	-Wmissing-prototypes               \
	-Wno-char-subscripts               \
	-fdata-sections                    \
	-ffunction-sections                \

AS      := $(CROSS_COMPILE)as
ASFLAGS := $(COMMON_FLAGS)

LD      := $(CROSS_COMPILE)ld
LDFLAGS := -Wl,-Ttext,$(ADDRESS) -Wl,-T,link.script -Wl,-Map,autoexec.map -Wl,--gc-sections -e _start -lm -lgcc -lc

OBJCOPY := $(CROSS_COMPILE)objcopy

S_SRCS := $(wildcard *.S) $(wildcard vxworks/*.S) $(wildcard firmware/*.S)
C_SRCS := $(wildcard *.c) $(wildcard vxworks/*.c) $(wildcard firmware/*.c)

S_OBJS := $(S_SRCS:.S=.o)
C_OBJS := $(C_SRCS:.c=.o)

OBJS  := $(S_OBJS) $(C_OBJS)
DEPFILES := $(C_SRCS:%.c=$(DEPDIR)/%.d)

install: all
ifdef INSTALL_HOST
	@echo [UPLOAD]:AUTOEXEC.BIN
	@curl -s http://$(INSTALL_HOST)/upload.cgi?UPDIR=/                                | fgrep -io SUCCESS
	@curl -s -F file=@AUTOEXEC.BIN -F submit=submit http://$(INSTALL_HOST)/upload.cgi | fgrep -io SUCCESS
	
	@echo [UPLOAD]:languages.ini
	@curl -s http://$(INSTALL_HOST)/upload.cgi?UPDIR=/400PLUS                          | fgrep -io SUCCESS
	@curl -s -F file=@languages.ini -F submit=submit http://$(INSTALL_HOST)/upload.cgi | fgrep -io SUCCESS
endif
ifdef INSTALL_PATH
	@install    AUTOEXEC.BIN  $(INSTALL_PATH)/
	@install -D languages.ini $(INSTALL_PATH)/400PLUS
	@umount $(INSTALL_PATH)
endif

all: AUTOEXEC.BIN languages.ini languages/new_lang.ini
	@echo [ALL]
	@ls -l AUTOEXEC.BIN

release: clean
	@echo [RELEASE]
	@git checkout-index -a --prefix $(RELNAME)/src/
	@zip -9 -r $(RELNAME).src.zip $(RELNAME)

	@mkdir $(RELNAME)/bin
	@cd $(RELNAME)/src && CFLAGS="" make
	@cp $(RELNAME)/src/AUTOEXEC.BIN $(RELNAME)/src/languages.ini $(RELNAME)/bin/
	@zip -9 -r $(RELNAME).bin.zip $(RELNAME)/bin/

	@echo [ZIP]
	@rm -rf $(RELNAME)
	@ls -l $(RELNAME).src.zip $(RELNAME).bin.zip

AUTOEXEC.BIN: AUTOEXEC.arm.elf
	@echo [OBJCOPY]: $@
	$(OBJCOPY) -O binary AUTOEXEC.arm.elf AUTOEXEC.BIN

AUTOEXEC.arm.elf: $(OBJS) link.script
	@echo [LINK]: $@
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)

%.o: %.c $(DEPDIR)/%.d | $(DEPDIR)
	@echo [C]: $<
	@$(CC) $(CFLAGS) -c $<

%.o: %.S
	@echo [ASM]: $<
	@$(CC) $(ASFLAGS) -c -o $@ $<

clean:
	@echo [CLEAN]
	rm -f $(OBJS) $(DEPFILES)
	rm -f AUTOEXEC.arm.elf AUTOEXEC.BIN autoexec.map

languages.ini: languages.h languages/*.ini
	@echo [I18N]: $@
	@./languages/lang_tool.pl -q -f languages -l languages.h -o languages.ini

languages/new_lang.ini: languages.h
	@echo [I18N]: $@
	@./languages/lang_tool.pl -q -f languages -l languages.h -g

$(DEPDIR): ; @mkdir -p $@

$(DEPFILES): 

include $(wildcard $(DEPFILES))
