# Make file to create ipc stack library.

OPENAMP_ROOT     := $(PWD)
BUILD            ?= $(OPENAMP_ROOT)/.build
OS               ?= baremetal
PLAT             ?= zc702evk
ROLE             ?= remote

include porting/os/$(OS)/platforms/$(PLAT)/Makefile.platform

ifeq ($(OS),baremetal)
CFLAGS +=-D"ENV=1"
CFLAGS +=-D"OPENAMP_BAREMETAL=1"

ifeq ($(ROLE),master)
CFLAGS+=-D"MASTER=1"
else
CFLAGS+=-D"MASTER=0"
endif
endif

ifeq ($(BENCHMARK),1)
CFLAGS+=-D"OPENAMP_BENCHMARK_ENABLE"
endif

ifeq ($(LINUXREMOTE),1)
CFLAGS+=-D"OPENAMP_REMOTE_LINUX_ENABLE"
endif

INCLUDES := -I"$(OPENAMP_ROOT)/include" -I"$(OPENAMP_ROOT)/include/porting/os/$(OS)/platforms/$(PLAT)"
CFLAGS += $(INCLUDES)


OPENAMP_LIB := $(BUILD)/libopen_amp.a
OPENAMP_RPC_LIB := $(BUILD)/libopen_amp_rpc.a

OPENAMP_C_SRCFILES = \
$(wildcard remoteproc/*.c) \
$(wildcard virtio/*.c) \
$(wildcard rpmsg/*.c) \
$(wildcard common/hil/*.c) \
$(wildcard common/llist/*.c) \
$(wildcard common/shm/*.c) \
$(wildcard common/firmware/*.c) \
$(wildcard porting/os/$(OS)/*.c) \
$(wildcard porting/os/$(OS)/platforms/$(PLAT)/*.c) \
$(wildcard porting/platforms/$(PLAT)/remoteproc/*.c) \
$(wildcard porting/platforms/$(PLAT)/*.c)

OPENAMP_AS_SRCFILES += \
$(wildcard porting/$(PLAT)/*.S)

OPENAMP_OBJFILES := $(patsubst %.c, $(BUILD)/%.o, $(OPENAMP_C_SRCFILES)) $(patsubst %.S, $(BUILD)/%.o, $(OPENAMP_AS_SRCFILES))

OPENAMP_DEPFILES := $(patsubst %.c, $(BUILD)/%.d, $(OPENAMP_C_SRCFILES)) $(patsubst %.S, $(BUILD)/%.d, $(OPENAMP_AS_SRCFILES))

OPENAMP_RPC_C_SRCFILES = \
$(wildcard proxy/remote/rpmsg_retarget/*.c)

OPENAMP_RPC_OBJFILES := $(patsubst %.c, $(BUILD)/%.o, $(OPENAMP_RPC_C_SRCFILES))

OPENAMP_RPC_DEPFILES := $(patsubst %.c, $(BUILD)/%.d, $(OPENAMP_RPC_C_SRCFILES))

all: $(OPENAMP_LIB) $(OPENAMP_RPC_LIB)

$(OPENAMP_LIB): $(OPENAMP_OBJFILES)
	$(AR) -r $@ $(OPENAMP_OBJFILES)

$(OPENAMP_RPC_LIB): $(OPENAMP_RPC_OBJFILES)
	$(AR) -r $@ $(OPENAMP_RPC_OBJFILES)

$(BUILD)/%.o:%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(ARCH_CFLAGS) $(INCLUDE) -c $< -o $@

%.o:%.S
	mkdir -p $(dir $@)
	$(AS) $(ARCH_ASFLAGS) $(INCLUDE) $< -o $@

clean:
	rm -rf $(BUILD)

PHONY: all clean
