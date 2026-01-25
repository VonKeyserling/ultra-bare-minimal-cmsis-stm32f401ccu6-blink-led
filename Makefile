include_dir = include
source_dir = src
build_dir = build

CFLAGS = -mcpu=cortex-m4 -nostdlib -std=gnu11 -mthumb -DSTM32F401xC -I${include_dir} -g -Wall
LDFLAGS = --specs=nosys.specs -T linker.ld -Wl,-Map=$(build_dir)/memory.map

CC = arm-none-eabi-gcc

SRCS = $(wildcard $(source_dir)/*.c)
OBJS = $(patsubst $(source_dir)/%.c, $(build_dir)/%.o, $(SRCS))

all: $(build_dir)/firmware.elf $(build_dir)/firmware.bin

$(build_dir)/firmware.bin: $(build_dir)/firmware.elf
	arm-none-eabi-objcopy -O binary $< $@

$(build_dir)/firmware.elf: $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) $(LDFLAGS) -o $@

$(build_dir)/%.o: $(source_dir)/%.c
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	@rm -rf $(build_dir) && mkdir $(build_dir)

flash: $(build_dir)/firmware.bin
	@st-flash write $(build_dir)/firmware.bin 0x8000000
