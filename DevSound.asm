; ================================================================
; Macros
; ================================================================

%macro ds_memcopy 2
    mov     si,%1
    mov     cx,%2
    rep     movsw
%endmacro

; TODO: Find a better way to do this
%macro startmem 1
%assign MemBase %1
%endmacro

%macro defbyte 1
%1: equ MemBase
%assign MemBase MemBase + 1
%endmacro

%macro defword 1
%1 equ MemBase
%assign MemBase MemBase + 2
%endmacro

%macro defbytes 2
%1 equ MemBase
%assign MemBase MemBase + %2
%endmacro

%macro wave 32
    db       %1| %2<<4
    db       %3| %4<<4
    db       %5| %6<<4
    db       %7| %8<<4
    db       %9|%10<<4
    db      %11|%12<<4
    db      %13|%14<<4
    db      %15|%16<<4
    db      %17|%18<<4
    db      %19|%20<<4
    db      %21|%22<<4
    db      %23|%24<<4
    db      %25|%26<<4
    db      %27|%28<<4
    db      %29|%30<<4
    db      %31|%32<<4
%endmacro

; note, octave, length
%macro note 3
    db  ((%2 * 12) + %1) - 7
    db  %3
%endmacro

; ================================================================
; Command definitions
; ================================================================

%macro instrument 1
    db  0xFF
    dw  %1
%endmacro

%macro sound_end 0
    db  0xFF
%endmacro

; ================================================================
; Note definitions
; ================================================================

C_  equ 0
C#  equ 1
D_  equ 2
D#  equ 3
E_  equ 4
F_  equ 5
F#  equ 6
G_  equ 7
G#  equ 8
A_  equ 9
A#  equ 10
B_  equ 12

; ================================================================
; RAM defines
; ================================================================
startmem 0

defbytes DS_WaveBuffer,64

defbyte DS_Playing
defbyte DS_Speed1
defbyte DS_Speed2
defbyte DS_GlobalTick
defbyte DS_TickCount

defbyte DS_CH1Mode
defword DS_CH1Ptr
defword DS_CH1RetPtr
defword DS_CH1VolPtr
defword DS_CH1WavePtr
defword DS_CH1ArpPtr
defbyte DS_CH1LoopCount
defbyte DS_CH1Tick
defbyte DS_CH1VibratoParams
defbyte DS_CH1VibratoPhase

defbyte DS_CH2Mode
defword DS_CH2Ptr
defword DS_CH2RetPtr
defword DS_CH2VolPtr
defword DS_CH2WavePtr
defword DS_CH2ArpPtr
defbyte DS_CH2LoopCount
defbyte DS_CH2Tick
defbyte DS_CH2VibratoParams
defbyte DS_CH2VibratoPhase

defbyte DS_CH3Mode
defword DS_CH3Ptr
defword DS_CH3RetPtr
defword DS_CH3VolPtr
defword DS_CH3WavePtr
defword DS_CH3ArpPtr
defbyte DS_CH3LoopCount
defbyte DS_CH3Tick
defbyte DS_CH3VibratoParams
defbyte DS_CH3VibratoPhase

defbyte DS_CH4Mode
defword DS_CH4Ptr
defword DS_CH4RetPtr
defword DS_CH4VolPtr
defword DS_CH4WavePtr
defword DS_CH4ArpPtr
defbyte DS_CH4LoopCount
defbyte DS_CH4Tick
defbyte DS_CH4VibratoParams
defbyte DS_CH4VibratoPhase

; ================================================================

db  "DevSound-WS by DevEd | deved8@gmail.com"

; Initialize sound playback.
; Call this once during your game's init routine.
DS_Init:
    ; enable all sound channels
    mov     al,SndCtrl_EnableCH1|SndCtrl_EnableCH2|SndCtrl_EnableCH3|SndCtrl_EnableCH4
    out     REG_SND_CTRL,al
    ; enable speakers + headphones (apparently this is actually required on hardware and emulators just assume they're always on)
    mov     al,SndOut_EnableSpeakers|SndOut_EnableHeadphones
    out     REG_SND_OUTPUT,al
    ; set volume of all channels to zero
    xor     al,al
    out     REG_SND_CH1_VOL,al
    out     REG_SND_CH2_VOL,al
    out     REG_SND_CH3_VOL,al
    out     REG_SND_CH4_VOL,al
    ; initialize pointers
    mov     ax,DS_DummySequence
    mov     di,DS_CH1Ptr
    mov     cl,5
    rep     stosw
    mov     di,DS_CH2Ptr
    mov     cl,5
    rep     stosw
    mov     di,DS_CH3Ptr
    mov     cl,5
    rep     stosw
    mov     di,DS_CH4Ptr
    mov     cl,5
    rep     stosw
    ; initialize waveforms
    mov     ax,0xF000
    mov     ds,ax
    mov     di,DS_WaveBuffer
    ds_memcopy DS_DefaultWave,8
    ds_memcopy DS_DefaultWave,8
    ds_memcopy DS_DefaultWave,8
    ds_memcopy DS_DefaultWave,8
    ; reset playing flag
    mov     al,0xFF
    mov     [es:DS_Playing],al
    ret

; ================================================================

; load a song.
; INPUT: si = song pointer
DS_Load:
    ret
 
; ================================================================

; Call this once per frame.
DS_Update:
    pusha
    mov     al,[es:DS_GlobalTick]
    dec     al
    mov     [es:DS_GlobalTick],al
    jne     .done
    mov     al,[es:DS_TickCount]
    inc     al
    mov     [es:DS_TickCount],al
    ror     al,1
    jnc     .eventick
.oddtick:
    mov     al,[es:DS_Speed1]
    jmp     .settick
.eventick:
    mov     al,[es:DS_Speed2]
.settick:
    mov     [es:DS_GlobalTick],al
    ; TODO: sequence reading + parsing
.done:
    call    DS_UpdateRegisters
    popa
    ret
 
; ================================================================

DS_UpdateRegisters:
    ret

; ================================================================

DS_DefaultWave:
    wave    08,10,12,13,14,14,15,15,15,15,14,14,13,12,11,09,07,05,03,02,01,01,00,00,00,00,01,01,02,03,04,06 

DS_FreqTable:
;            C-x   C#x   D-x   D#x   E-x   F-x   F#x   G-x   G#x   A-x   A#x   B-x
    dw                                                 0x58, 0xc6,0x12e,0x190,0x1ec ; 1
    dw      0x244,0x296,0x2e4,0x32d,0x373,0x3b4,0x3f2,0x42c,0x463,0x497,0x4c8,0x4f6 ; 2
    dw      0x522,0x54b,0x572,0x596,0x5b9,0x5da,0x5f9,0x616,0x631,0x64b,0x664,0x67b ; 3
    dw      0x691,0x6a5,0x6b9,0x6cb,0x6dc,0x6ed,0x6fc,0x70b,0x718,0x725,0x732,0x73d ; 4
    dw      0x748,0x752,0x75c,0x765,0x76e,0x776,0x77e,0x785,0x78c,0x792,0x799,0x79e ; 5
    dw      0x7a4,0x7a9,0x7ae,0x7b2,0x7b7,0x7bb,0x7bf,0x7c2,0x7c6,0x7c9,0x7cc,0x7cf ; 6
    dw      0x7d2,0x7d4,0x7d7,0x7d9,0x7db,0x7dd,0x7df,0x7e1,0x7e3,0x7e4,0x7e6,0x7e7 ; 7
    dw      0x7e9,0x7ea,0x7eb,0x7ec,0x7ed,0x7ee,0x7ef,0x7f0,0x7f1,0x7f2,0x7f3,0x7f3 ; 8
    dw      0x7f4,0x7f5,0x7f5,0x7f6,0x7f6,0x7f7,0x7f7,0x7f8,0x7f8,0x7f9,0x7f9,0x7f9 ; 9

; ================================================================

DS_DummySequence:
    sound_end

DS_TestSequence:
    note    C_,3,4
    note    D_,3,4
    note    E_,3,4
    note    F_,3,4
    note    G_,3,4
    note    A_,3,4
    note    B_,3,4
    note    C_,4,4
    sound_end