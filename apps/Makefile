
# Include commons make file to get platform and tool chain specific variables.

VPATH := $(PWD)
OPENAMP_ROOT     := $(PWD)/..
BUILD            ?= $(OPENAMP_ROOT)/.build/apps
OS               ?= baremetal
PLAT             ?= zc702evk
ROLE             ?= remote

include ../porting/os/$(OS)/platforms/$(PLAT)/Makefile.platform

ifeq ($(OS),baremetal)
ifeq ($(ROLE),master)
CFLAGS+=-D"MASTER=1"
else
CFLAGS+=-D"MASTER=0"
endif
endif

LDFLAGS += -L$(OPENAMP_ROOT)/.build
LIBS := -lopen_amp

INCLUDE := -I$(OPENAMP_ROOT)/include -I$(OPENAMP_ROOT)/include/porting/os/$(OS)/platforms/$(PLAT) -Isamples/common -Isamples/common/$(PLAT)

include Makefile.objs

$(foreach o,$(obj-y),$(if $($o-objs),$(eval $(BUILD)/$o-objs := $(addprefix $(BUILD)/,$($o-objs)))))

all: $(addprefix $(BUILD)/,$(filter %firmware,$(obj-y)))

$(BUILD)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(ABC) $(CFLAGS) $(ARCH_CFLAGS) $(INCLUDE) $($(patsubst %.c,%.o,$<)-cflags) $($(dir $<)firmware-cflags) -c $< -o $@

$(BUILD)/%.o: %.S
	mkdir -p $(dir $@)
	$(AS) $(ARCH_ASFLAGS) $(INCLUDE) $< -o $@

clean:
	rm -rf $(BUILD)

.SECONDEXPANSION:
$(BUILD)/%firmware: $$($$@-objs) $(addprefix $(BUILD)/,$(common-obj-y))
	echo "$@: $^" 
	$(LD) -Wl,-Map=$(dir $@)/firmware.map -Wl,--gc-sections $(LDFLAGS) $($(patsubst $(BUILD)/,,$@)-ldflags) -o $@ -Wl,--start-group $^ $(LIBS) $($(patsubst $(BUILD)/,,$@)-libs) -Wl,--end-group
