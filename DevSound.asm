; ================================================================
; Macros
; ================================================================

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
%macro note 2
    db  %1
    db  %2
%endmacro

seq_loop    equ 0xFE
seq_end     equ 0xFF

; ================================================================
; Command definitions
; ================================================================

%macro sound_instrument 1
    db  0x80
    dw  %1
%endmacro

%macro sound_goto 1
    db  0x81
    dw  %1
%endmacro

%macro sound_loopcount 1
    db  0x82
    db  %1
%endmacro

%macro sound_loop 1
    db  0x83
    dw  %1
%endmacro

%macro sound_call 1
    db  0x84
    dw  %1
%endmacro

%macro sound_ret 0
    db  0x85
%endmacro

%macro sound_togglemode 0
    db  0x86
%endmacro

%macro sound_vibrato 2
    db  0x87
    db  %1
    db  %2
%endmacro

%macro sound_end 0
    db  0xFF
%endmacro

; ================================================================
; Note definitions
; ================================================================

nG_1 equ 0
nG#1 equ 1
nA_1 equ 2
nA#1 equ 3
nB_1 equ 4
nC_2 equ 5
nC#2 equ 6
nD_2 equ 7
nD#2 equ 8
nE_2 equ 9
nF_2 equ 10
nF#2 equ 11
nG_2 equ 12
nG#2 equ 13
nA_2 equ 14
nA#2 equ 15
nB_2 equ 16
nC_3 equ 17
nC#3 equ 18
nD_3 equ 19
nD#3 equ 20
nE_3 equ 21
nF_3 equ 22
nF#3 equ 23
nG_3 equ 24
nG#3 equ 25
nA_3 equ 26
nA#3 equ 27
nB_3 equ 28
nC_4 equ 29
nC#4 equ 30
nD_4 equ 31
nD#4 equ 32
nE_4 equ 33
nF_4 equ 34
nF#4 equ 35
nG_4 equ 36
nG#4 equ 37
nA_4 equ 38
nA#4 equ 39
nB_4 equ 40
nC_5 equ 41
nC#5 equ 42
nD_5 equ 43
nD#5 equ 44
nE_5 equ 45
nF_5 equ 46
nF#5 equ 47
nG_5 equ 48
nG#5 equ 49
nA_5 equ 50
nA#5 equ 51
nB_5 equ 52
nC_6 equ 53
nC#6 equ 54
nD_6 equ 55
nD#6 equ 56
nE_6 equ 57
nF_6 equ 58
nF#6 equ 59
nG_6 equ 60
nG#6 equ 61
nA_6 equ 62
nA#6 equ 63
nB_6 equ 64
nC_7 equ 65
nC#7 equ 66
nD_7 equ 67
nD#7 equ 68
nE_7 equ 69
nF_7 equ 70
nF#7 equ 71
nG_7 equ 72
nG#7 equ 73
nA_7 equ 74
nA#7 equ 75
nB_7 equ 76
nC_8 equ 77
nC#8 equ 78
nD_8 equ 79
nD#8 equ 80
nE_8 equ 81
nF_8 equ 82
nF#8 equ 83
nG_8 equ 84
nG#8 equ 85
nA_8 equ 86
nA#8 equ 87
nB_8 equ 88
nRest equ 89

; ================================================================
; RAM defines
; ================================================================

section .bss

DS_WaveBuffer           resb 64

DS_Playing              resb 1
DS_Speed1               resb 1
DS_Speed2               resb 1
DS_GlobalTick           resb 1
DS_TickCount            resb 1

%macro ds_channel 1
DS_CH%1Playing          resb 1
DS_CH%1Mode             resb 1
DS_CH%1Ptr              resw 1
DS_CH%1RetPtr           resw 1
DS_CH%1VolPtrL          resw 1
DS_CH%1VolPtrR          resw 1
DS_CH%1WavePtr          resw 1
DS_CH%1ArpPtr           resw 1
DS_CH%1VolPosL          resw 1
DS_CH%1VolPosR          resw 1
DS_CH%1WavePos          resw 1
DS_CH%1ArpPos           resw 1
DS_CH%1Note             resb 1
DS_CH%1Transpose        resb 1
DS_CH%1Volume           resb 1
DS_CH%1Wave             resb 1
DS_CH%1LoopCount        resb 1
DS_CH%1Tick             resb 1
DS_CH%1VibratoParams    resb 1
DS_CH%1VibratoPhase     resb 1
DS_Reserved%1           resb 2
%endmacro

ds_channel 1
ds_channel 2
ds_channel 3
ds_channel 4

; ================================================================

section .text

db  "DevSound-WS by DevEd | deved8@gmail.com"

; Initialize sound playback.
; Call this once during your game's init routine.
DS_Init:
    ; set up segment pointers
    push    cs
    pop     ds
    push    0
    pop     es
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
    mov     cl,6
    rep     stosw
    mov     di,DS_CH2Ptr
    mov     cl,6
    rep     stosw
    mov     di,DS_CH3Ptr
    mov     cl,6
    rep     stosw
    mov     di,DS_CH4Ptr
    mov     cl,6
    rep     stosw
    ; initialize waveforms
    mov     di,DS_WaveBuffer
    mov     si,DS_DefaultWave
    mov     cl,8
    rep     movsw
    mov     si,DS_DefaultWave
    mov     cl,8
    rep     movsw
    mov     si,DS_DefaultWave
    mov     cl,8
    rep     movsw
    mov     si,DS_DefaultWave
    mov     cl,8
    rep     movsw
    ; reset playing flag
    mov     al,0x00
    mov     [es:DS_Playing],al
    ret

; ================================================================

; load a song.
; INPUT: si = song pointer
DS_Load:
    push    ds
    push    0
    pop     es
    mov     di,DS_Speed1
    movsb
    movsb
    mov     di,DS_CH1Ptr
    movsw
    mov     di,DS_CH2Ptr
    movsw
    mov     di,DS_CH3Ptr
    movsw
    mov     di,DS_CH4Ptr
    movsw
    push    es
    pop     ds
    mov     al,1
    mov     [DS_Playing],al
    mov     [DS_CH1Playing],al
    mov     [DS_CH2Playing],al
    mov     [DS_CH3Playing],al
    mov     [DS_CH4Playing],al
    mov     [DS_GlobalTick],al
    mov     [DS_CH1Tick],al
    mov     [DS_CH2Tick],al
    mov     [DS_CH3Tick],al
    mov     [DS_CH4Tick],al
    pop     ds
    ret
 
; ================================================================

; Call this once per frame.
DS_Update:
    pusha
    push    0
    pop     ds
    push    0
    pop     es
    test    byte[DS_Playing],1
    jz      .skip
    
    dec     byte[DS_GlobalTick]
    jnz     .done
    inc     byte[DS_TickCount]
    mov     al,[DS_TickCount]
    ror     al,1
    jnc     .eventick
.oddtick:
    mov     al,[DS_Speed1]
    jmp     .settick
.eventick:
    mov     al,[DS_Speed2]
.settick:
    mov     [DS_GlobalTick],al
    
    ; TODO: sequence reading + parsing

    call    DS_UpdateCH1
    call    DS_UpdateCH2
    call    DS_UpdateCH3
    call    DS_UpdateCH4    

    push    0
    pop     ds
.done:  
    call    DS_UpdateRegisters
.skip:
    popa
    ret
    
; ================================================================

%macro ds_update_channel 1
DS_UpdateCH%1:
    test    byte[DS_CH%1Playing],1
    jnz     .doupdate
    ret
.doupdate:
    dec     byte[DS_CH%1Tick]
    jz      .doupdate2
    ret
    
.doupdate2:
    mov     si,[DS_CH%1Ptr]
.parseloop:
    cs      lodsb
    cmp     al,0x7f
    ja      .iscommand
    je      .isrest
.isnote:
    mov     [DS_CH%1Note],al
    cs      lodsb
    mov     [DS_CH%1Tick],al
    xor     ax,ax
    mov     di,DS_CH%1VolPosL
    mov     cx,4
    rep     stosw
    jmp     .done
.isrest:
    mov     [DS_CH%1Note],al
    lodsb
    mov     [DS_CH%1Tick],al
    xor     al,al
    mov     [DS_CH%1Volume],al
    jmp     .done
.iscommand:
    cmp     al,0xff
    je      .endchannel
.runcommand:
    sub     al,0x80
    xor     ah,ah
    push    si
    mov     si,DS_CH%1CommandTable
    add     si,ax
    add     si,ax
    cs      lodsw
    pop     si
    push    ax
    ret
.checknext:
    
    jmp     .parseloop
.done:
    mov     [DS_CH%1Ptr],si
    ret
.endchannel:
    mov     byte[DS_CH%1Playing],0
    ret

; ================================================================

DS_CH%1CommandTable:
    dw      .setinstrument
    dw      .goto
    dw      .loopcount
    dw      .loop
    dw      .call
    dw      .ret
    dw      .togglemode
    dw      .vibrato

.setinstrument:
    cs      lodsw
    push    si
    mov     si,ax
    mov     di,DS_CH%1VolPtrL
    mov     cl,4
    rep     cs movsw
    pop     si
    jmp     DS_UpdateCH%1.parseloop

.goto:
    cs      lodsw
    mov     si,ax
    jmp     DS_UpdateCH%1.parseloop

.loopcount:
    cs      lodsb
    mov     [DS_CH1LoopCount],al
    jmp     DS_UpdateCH%1.parseloop

.loop:
    cs      lodsw
    dec     byte[DS_CH%1LoopCount]
    jz      DS_UpdateCH%1.parseloop
    mov     si,ax
    jmp     DS_UpdateCH%1.parseloop

.call:
    cs      lodsw
    mov     [DS_CH%1RetPtr],si
    mov     si,ax
    jmp     DS_UpdateCH%1.parseloop
    
.ret:
    mov     si,[DS_CH%1RetPtr]
    jmp     DS_UpdateCH%1.parseloop
    
.togglemode:
    mov     al,[DS_CH%1Mode]
    xor     al,1
    mov     [DS_CH%1Mode],al
    jmp     DS_UpdateCH%1.parseloop

.vibrato:
    ; TODO
.dummy:
    jmp     DS_UpdateCH%1.parseloop
%endmacro

ds_update_channel 1
ds_update_channel 2
ds_update_channel 3
ds_update_channel 4

; ================================================================

DS_UpdateRegisters:
    call    DS_UpdateRegisters_CH1
    call    DS_UpdateRegisters_CH2
    call    DS_UpdateRegisters_CH3
    jmp     DS_UpdateRegisters_CH4

%macro ds_update_registers 1
DS_UpdateRegisters_CH%1:
    ; set volume level
    ; TODO: Looping
    mov     si,[DS_CH%1VolPtrL]
    mov     ax,[DS_CH%1VolPosL]
    mov     cx,ax
    add     si,ax
    mov     al,[cs:si]
    cmp     al,seq_end
    je      .skip1
    rol     al,4
    mov     bl,al
    inc     cx
    mov     [DS_CH%1VolPosL],cx
    jmp     .continue1
.skip1:
    cmp     cx,0
    jz      .continue1
    dec     si
    mov     bl,[cs:si]
    rol     bl,4
.continue1:
    
    mov     si,[DS_CH%1VolPtrR]
    mov     ax,[DS_CH%1VolPosR]
    mov     cx,ax
    add     si,ax
    mov     al,[cs:si]
    cmp     al,seq_end
    je      .skip2
    or      al,bl
    inc     cx
    mov     [DS_CH%1VolPosR],cx
    jmp     .continue2
.skip2:
    cmp     cx,0
    jz      .volume0
    dec     si
    mov     al,[cs:si]
    or      al,bl
    jmp     .continue2
.volume0:
    xor     al,al
.continue2:
    mov     [DS_CH%1Volume],al
    out     REG_SND_CH%1_VOL,al
.doarp:
    ; Arpeggio logic
    mov     si,[DS_CH%1ArpPtr]
    mov     ax,[DS_CH%1ArpPos]
    mov     cx,ax
    add     si,ax
    mov     al,[cs:si]
    cmp     al,seq_end
    je      .skiparp
    cmp     al,seq_loop
    je      .looparp
    ; default case: set transpose
    mov     [DS_CH%1Transpose],al
    inc     cx
    jmp     .continue3
.skiparp:
    cmp     cx,0
    jz      .continue3
    dec     si
    mov     al,[cs:si]
    jmp     .continue3
.looparp:
    inc     si
    mov     al,[cs:si]
    mov     ah,0
    sub     cx,ax
.continue3:
    mov     [DS_CH%1ArpPos],cx

    ; Wavetable logic
    mov     si,[DS_CH%1WavePtr]
    mov     ax,[DS_CH%1WavePos]
    mov     cx,ax
    add     si,ax
    mov     al,[cs:si]
    cmp     al,seq_end
    je      .skipwave
    cmp     al,seq_loop
    je      .loopwave
    ; default case: set wave
    mov     [DS_CH%1Wave],al
    inc     cx
    jmp     .continue4
.skipwave:
    cmp     cx,0
    jz      .continue4
    dec     si
    mov     al,[cs:si]
    jmp     .continue4
.loopwave:
    inc     si
    mov     al,[cs:si]
    mov     ah,0
    sub     cx,ax
.continue4:
    mov     [DS_CH%1WavePos],cx
    
    ; Read transpose value.
    ; A transpose value of 0-63 will be added to current note
    ; A transpose value of 64-127 will be subtracted by 64 then subtracted from the current note
    ; A transpose value of 128-255 will be subtracted by 128 and then be used instead of the current note
    cmp     byte [DS_CH%1Note],nRest
    jz      .isrest
    mov     bl,[DS_CH%1Transpose]
    cmp     bl,0x40
    jb      .transposeup
    cmp     bl,0x80
    jae     .setfreq
.transposeup:
    add     bl,[DS_CH%1Note]
    jmp     .setfreq
.transposedown:
    sub     bl,0x40
    neg     bl
    add     bl,[DS_CH%1Note]
.setfreq:
    mov     bh,0
    add     bx,bx
    add     bx,DS_FreqTable
    mov     ax,[cs:bx]
    out     REG_SND_CH%1_PITCH,ax
    jmp     .loadwave
.isrest:
    xor     al,al
    out     REG_SND_CH%1_VOL,al

.loadwave:
    cmp     byte [DS_CH%1Volume],0
    jz      .skipwave2
    mov     bl,[DS_CH%1Wave]
    mov     bh,0
    add     bx,bx
    add     bx,DS_WavePointers
    mov     si,[cs:bx]
    mov     di,DS_WaveBuffer
    add     di,((%1 - 1) << 4)
    mov     cl,8
    rep     cs movsw
.skipwave2:
    ret
%endmacro
    
ds_update_registers 1
ds_update_registers 2
ds_update_registers 3
ds_update_registers 4

; ================================================================

DS_WavePointers:
    dw      DS_SineWave
    dw      DS_SquareWave
    dw      DS_SawtoothWave

DS_DefaultWave:
DS_SineWave:        wave    08,10,12,13,14,14,15,15,15,15,14,14,13,12,11,09,07,05,03,02,01,01,00,00,00,00,01,01,02,03,04,06
DS_SquareWave:      wave    15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DS_SawtoothWave:    wave    00,00,01,01,02,02,03,03,04,04,05,05,06,06,07,07,08,08,09,09,10,10,11,11,12,12,13,13,14,14,15,15

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

ins_Test:   dw      DS_TestVolumeSeqL,DS_TestVolumeSeqR,DS_TestWaveSeq,DS_TestArpSeq

; ================================================================

DS_DummySoundSequence:
    db  0
DS_DummySequence:
    sound_end

DS_TestVolumeSeqL:
DS_TestVolumeSeqR:
    db  15,15,15,15,15,14,14,14,14,14,14,13,13,13,13,12,12,12,12,12,12,12,12,12,12,12,12,11,seq_end

DS_TestWaveSeq:
    db  2,seq_loop,1

DS_TestArpSeq:
    db  0,12,12,0,seq_end
    
DS_TestSequence1:
    sound_instrument ins_Test
    note    nC_5,4
    note    nB_4,4
    note    nC_5,4
    note    nRest,1
    sound_end
DS_TestSequence2:
    sound_instrument ins_Test
    note    nG_4,4
    note    nF_4,4
    note    nE_4,4
    note    nRest,1
    sound_end
DS_TestSequence3:
    sound_instrument ins_Test
    note    nC_4,4
    note    nD_4,4
    note    nC_4,4
    note    nRest,1
    sound_end
DS_TestSequence4:
    sound_instrument ins_Test
    note    nG_3,4
    note    nF_3,4
    note    nE_3,4
    note    nRest,1
    sound_end

; ================================================================

DS_TestSong:   
    db  22,22
    dw  DS_TestSequence1,DS_TestSequence2,DS_TestSequence3,DS_TestSequence4