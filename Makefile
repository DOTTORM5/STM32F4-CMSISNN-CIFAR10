
#---------------------------------------------------------------Directories
ROOT_DIR 	:= $(abspath .)
BUILD_DIR 	:= $(ROOT_DIR)/build
SRC_DIR		:= $(ROOT_DIR)/src
INCLUDE_DIR	:= $(ROOT_DIR)/include
DEP_DIR 	:= $(BUILD_DIR)/dep
CMSIS_DIR	:= $(ROOT_DIR)/lib/CMSIS
DEVICE_DIR	:= $(ROOT_DIR)/lib/Device/ST/STM32F4xx
DRIVER_DIR	:= $(ROOT_DIR)/lib/Driver/STM32F4xx_HAL_Driver
BSP_DIR		:= $(ROOT_DIR)/lib/Driver/BSP/STM32F4xx-Nucleo


#---------------------------------------------------------------Board
BOARD		:= stm32f446xx
BOARD_GEN	:= stm32f4xx
TARGET 		:= $(BUILD_DIR)/main.elf 
TARGET_BIN	:= $(BUILD_DIR)/main.bin
MAIN_SRC	:= arm_nnexamples_cifar10.c
Q			:= @

#---------------------------------------------------------------Compiler
PREFIX		:= arm-none-eabi
CC 			:= $(PREFIX)-gcc
CFLAGS     	+= 	-mcpu=cortex-m4 \
				-mfloat-abi=hard -mfpu=fpv4-sp-d16 \
				-mthumb \
				-g3 \
				-nostdlib \
				-ffunction-sections -fdata-sections \
				-Os
LDFLAGS    	+= 	-T$(SRC_DIR)/STM32F446RETx_FLASH.ld \
				--specs=rdimon.specs -lrdimon --specs=nano.specs -lc
LDFLAGS 	+=  -Wl,--gc-sections,-Map,$(BUILD_DIR)/$(BOARD).map

DEP_CFLAGS 	= 	-MT $@ -MMD -MP -MF $(DEP_DIR)/$(*F).d

INCLUDE_PATH +=	-I$(CMSIS_DIR)/Core/Include \
				-I$(INCLUDE_DIR) \
				-I$(CMSIS_DIR)/NN/Include \
				-I$(CMSIS_DIR)/DSP/Include \
				-I$(DEVICE_DIR)/Include \
				-I$(DRIVER_DIR)/Inc \
				-I$(BSP_DIR)/

#---------------------------------------------------------------Sources
CMSIS_SRC	=	$(shell find $(CMSIS_DIR)/NN/Source -name '*.c')

ST_SRC		+= 	$(DRIVER_DIR)/Src/$(BOARD_GEN)_hal_uart.c \
				$(DRIVER_DIR)/Src/$(BOARD_GEN)_hal_usart.c \
				$(DRIVER_DIR)/Src/$(BOARD_GEN)_hal.c \
				$(DRIVER_DIR)/Src/$(BOARD_GEN)_hal_rcc.c \
				$(DRIVER_DIR)/Src/$(BOARD_GEN)_hal_gpio.c \
				$(DRIVER_DIR)/Src/$(BOARD_GEN)_hal_cortex.c \
				$(BSP_DIR)/$(BOARD_GEN)_nucleo.c

SRC			+= 	$(SRC_DIR)/$(MAIN_SRC)\
				$(SRC_DIR)/startup_$(BOARD).s  \
				$(SRC_DIR)/config.c \
				$(DEVICE_DIR)/Source/Templates/system_stm32f4xx.c \



#--------------------------------------------------------------Objects
OBJ_C		= 	$(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRC))
OBJ			= 	$(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.o, $(OBJ_C))



#--------------------------------------------------------------Rules
all: $(TARGET)
	$(Q) echo "[Done]"

-include $(wildcard $(DEP_DIR)/*.d)

clean:
	$(Q) echo "[Cleaning] Build"
	$(Q) rm -rf $(BUILD_DIR)

$(TARGET): $(OBJ)
	$(Q) echo "[Linking] $@"
	$(Q) $(CC) $(CFLAGS) $(INCLUDE_PATH) $^ $(CMSIS_SRC) $(ST_SRC) -o $@ $(LDFLAGS) 

$(OBJ): $(SRC) Makefile

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(BUILD_DIR) $(DEP_DIR)
	$(Q) echo "[Building] $@"
	$(Q) mkdir -p $(dir $@)
	$(Q) $(CC) $(CFLAGS) $(INCLUDE_PATH) $(DEP_CFLAGS) -o $@ -c $<

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s $(BUILD_DIR) $(DEP_DIR)
	$(Q) echo "[Building] $@"
	$(Q) mkdir -p $(dir $@)
	$(Q) $(CC) $(CFLAGS) $(INCLUDE_PATH) -o $@ -c $<


$(BUILD_DIR):
	$(Q) echo "[Creating Directory] Build"
	$(Q) mkdir -p $@
$(DEP_DIR):
	$(Q) echo "[Creating Directory] Build/dep"
	$(Q) mkdir -p $@

$(TARGET_BIN):
	$(PREFIX)-objcopy -O binary $(TARGET) $@ 

flash: $(TARGET_BIN)
	openocd -f src/st_nucleo_f4.cfg -c "program build/main.bin reset exit"
