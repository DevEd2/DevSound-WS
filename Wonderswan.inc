; Wonderswan hardware definitions by DevEd

%ifndef WS_INCLUDE
    %define WS_INCLUDE

CPU 186 ; CPU is actually NEC V30, which supports 186 instructions but the extra NEC instructrions aren't supported by NASM

; Cartridge footer constants

ORIENTATION_HORIZONTAL  equ 0b00000000
ORIENTATION_VERTICAL    equ 0b00000001
ROMBUS_16BIT            equ 0b00000000
ROMBUS_8BIT             equ 0b00000010
ROMSPEED_3CYCLES        equ 0b00000000
ROMSPEED_1CYCLE         equ 0b00000100

; Hardware registers

REG_DISP_CTRL           equ 0x00
REG_BACK_COLOR          equ 0x01
REG_LINE_CUR            equ 0x02
REG_LINE_CMP            equ 0x03
REG_SPR_BASE            equ 0x04
REG_SPR_FIRST           equ 0x05
REG_SPR_COUNT           equ 0x06
REG_MAP_BASE            equ 0x07
REG_SCR2_WIN_X0         equ 0x08
REG_SCR2_WIN_Y0         equ 0x09
REG_SCR2_WIN_X1         equ 0x0A
REG_SCR2_WIN_Y1         equ 0x0B
REG_SPR_WIN_X0          equ 0x0C
REG_SPR_WIN_Y0          equ 0x0D
REG_SPR_WIN_X1          equ 0x0E
REG_SPR_WIN_Y1          equ 0x0F
REG_SCR1_X              equ 0x10
REG_SCR1_Y              equ 0x11
REG_SCR2_X              equ 0x12
REG_SCR2_Y              equ 0x13
REG_LCD_CTRL            equ 0x14
REG_LCD_ICON            equ 0x15
REG_LCD_VTOTAL          equ 0x16
REG_LCD_VSYNC           equ 0x17
REG_PALMONO_POOL_0      equ 0x1C
REG_PALMONO_POOL_1      equ 0x1D
REG_PALMONO_POOL_2      equ 0x1E
REG_PALMONO_POOL_3      equ 0x1F
REG_PALMONO_0           equ 0x20
REG_PALMONO_1           equ 0x22
REG_PALMONO_2           equ 0x24
REG_PALMONO_3           equ 0x26
REG_PALMONO_4           equ 0x28
REG_PALMONO_5           equ 0x2A
REG_PALMONO_6           equ 0x2C
REG_PALMONO_7           equ 0x2E
REG_PALMONO_8           equ 0x30
REG_PALMONO_9           equ 0x32
REG_PALMONO_A           equ 0x34
REG_PALMONO_B           equ 0x36
REG_PALMONO_C           equ 0x38
REG_PALMONO_D           equ 0x3A
REG_PALMONO_E           equ 0x3C
REG_PALMONO_F           equ 0x3E
  
REG_DMA_SRC             equ 0x40
REG_DMA_SRC_HI          equ 0x42
REG_DMA_DST             equ 0x44
REG_DMA_LEN             equ 0x46
REG_DMA_CTRL            equ 0x48
REG_SDMA_SRC            equ 0x4A
REG_SDMA_SRC_HI         equ 0x4C
REG_SDMA_LEN            equ 0x4E
REG_SDMA_CTRL           equ 0x52

REG_DISP_MODE           equ 0x60

REG_HYPER_CTRL          equ 0x6A
REG_HYPER_CHAN_CTRL     equ 0x6B  
REG_SND_CH1_PITCH       equ 0x80
REG_SND_CH2_PITCH       equ 0x82
REG_SND_CH3_PITCH       equ 0x84
REG_SND_CH4_PITCH       equ 0x86
REG_SND_CH1_VOL         equ 0x88
REG_SND_CH2_VOL         equ 0x89
REG_SND_CH3_VOL         equ 0x8A
REG_SND_CH4_VOL         equ 0x8B
REG_SND_SWEEP_VALUE     equ 0x8C
REG_SND_SWEEP_TIME      equ 0x8D
REG_SND_NOISE           equ 0x8E
REG_SND_WAVE_BASE       equ 0x8F
REG_SND_CTRL            equ 0x90
REG_SND_OUTPUT          equ 0x91
REG_SND_RANDOM          equ 0x92
REG_SND_VOICE_CTRL      equ 0x94
REG_SND_HYPERVOICE      equ 0x95
REG_SND_9697            equ 0x96
REG_SND_9899            equ 0x98
REG_SND_9A              equ 0x9A
REG_SND_9B              equ 0x9B
REG_SND_9C              equ 0x9C
REG_SND_9D              equ 0x9D
REG_SND_9E              equ 0x9E

REG_WSC_SYSTEM          equ 0x62
REG_HW_FLAGS            equ 0xA0

REG_TMR_CTRL            equ 0xA2
REG_HTMR_FREQ           equ 0xA4
REG_VTMR_FREQ           equ 0xA6
REG_HTMR_CTR            equ 0xA8
REG_VTMR_CTR            equ 0xAA

REG_INT_BASE            equ 0xB0
REG_SER_DATA            equ 0xB1
REG_INT_ENABLE          equ 0xB2
REG_SER_STATUS          equ 0xB3
REG_INT_STATUS          equ 0xB4
REG_KEYPAD              equ 0xB5
REG_INT_ACK             equ 0xB6

REG_IEEP_DATA           equ 0xBA
REG_IEEP_ADDR           equ 0xBC
REG_IEEP_STATUS         equ 0xBE
REG_IEEP_CMD            equ 0xBE

REG_BANK_ROM2           equ 0xC0
REG_BANK_SRAM           equ 0xC1
REG_BANK_ROM0           equ 0xC2
REG_BANK_ROM1           equ 0xC3
REG_EEP_DATA            equ 0xC4
REG_EEP_ADDR            equ 0xC6
REG_EEP_STATUS          equ 0xC8
REG_EEP_CMD             equ 0xC8
REG_RTC_STATUS          equ 0xCA
REG_RTC_CMD             equ 0xCA
REG_RTC_DATA            equ 0xCB
REG_GPO_EN              equ 0xCC
REG_GPO_DATA            equ 0xCD
REG_WW_FLASH_CE         equ 0xCE

; REG_DISP_CTRL constants
DispCtrl_SCR2WindowOn   equ 0b00100000
DispCtrl_SCR2WindowOver equ 0b00010000
DispCtrl_SPRWindowOn    equ 0b00001000
DispCtrl_SPROn          equ 0b00000100
DispCtrl_SCR2On         equ 0b00000010
DispCtrl_SCR1On         equ 0b00000001

; REG_LCD_ICON flags
LCDIcon_BigCircle       equ 0b00100000
LCDIcon_MedCircle       equ 0b00010000
LCDIcon_SmallCircle     equ 0b00001000
LCDIcon_Horizontal      equ 0b00000100
LCDIcon_Vertical        equ 0b00000010
LCDIcon_SleepMode       equ 0b00000001

; Sound constants

; REG_SND_NOISE constants
Noise_Enable            equ 0b00010000
Noise_Reset             equ 0b00001000
Noise_Tap14             equ 0
Noise_Tap10             equ 1
Noise_Tap13             equ 2
Noise_Tap04             equ 3
Noise_Tap08             equ 4
Noise_Tap06             equ 5
Noise_Tap09             equ 6
Noise_Tap11             equ 7

; REG_SND_CTRL constants
SndCtrl_CH4_Noise       equ 0b10000000
SndCtrl_CH4_Wave        equ 0b00000000
SndCtrl_CH3_Sweep       equ 0b01000000
SndCtrl_CH3_NoSweep     equ 0b00000000
SndCtrl_CH2_Voice       equ 0b00100000
SndCtrl_CH2_Wave        equ 0b00000000
SndCtrl_EnableCH4       equ 0b00001000
SndCtrl_EnableCH3       equ 0b00000100
SndCtrl_EnableCH2       equ 0b00000010
SndCtrl_EnableCH1       equ 0b00000001

; REG_SND_OUTPUT constants
SndOut_Headphones       equ 0b10000000
SndOut_NoHeadphones     equ 0b00000000
SndOut_EnableHeadphones equ 0b00001000
SndOut_EnableSpeakers   equ 0b00000001

; REG_SND_VOICE_CTRL constants
Voice_LeftHalfVolume    equ 0b00001000
Voice_LeftFullVolume    equ 0b00000100
Voice_RightHalfVolume   equ 0b00000010
Voice_RightFullVolume   equ 0b00000001

; REG_KEYPAD constants
Keypad_EnableButtons    equ 0b01000000
Keypad_EnablePadX       equ 0b00100000
Keypad_EnablePadY       equ 0b00010000
btnB                    equ 0b00001000
btnX4                   equ 0b00001000
btnY4                   equ 0b00001000
btnA                    equ 0b00000100
btnX3                   equ 0b00000100
btnY3                   equ 0b00000100
btnStart                equ 0b00000010
btnX2                   equ 0b00000010
btnY2                   equ 0b00000010
btnX1                   equ 0b00000001
btnY1                   equ 0b00000001

; REG_DISP_MODE constants
DispMode_2BPP           equ 0b00000000
DispMode_4BPP           equ 0b10000000
DispMode_PlanarFormat   equ 0b00000000
DispMode_PackedFormat   equ 0b00100000

; REG_WSC_SYSTEM constants
System_SwanCrystal      equ 0b10000000
System_PowerOff         equ 0b00000001

; REG_HW_FLAGS constants
System_Mono             equ 0b00000000
System_Color            equ 0b00000010

; REG_INT_ENABLE constants
HWINT_SER_TX            equ 0b00000001
HWINT_KEY               equ 0b00000010
HWINT_CART              equ 0b00000100
HWINT_SER_RX            equ 0b00001000
HWINT_LINE              equ 0b00010000
HWINT_VBLANK_TMR        equ 0b00100000
HWINT_VBLANK            equ 0b01000000
HWINT_HBLANK_TMR        equ 0b10000000

BIT_HWINT_SER_TX        equ 0
BIT_HWINT_KEY           equ 1
BIT_HWINT_CART          equ 2
BIT_HWINT_SER_RX        equ 3
BIT_HWINT_LINE          equ 4
BIT_HWINT_VBLANK_TMR    equ 5
BIT_HWINT_VBLANK        equ 6
BIT_HWINT_HBLANK_TMR    equ 7

%endif