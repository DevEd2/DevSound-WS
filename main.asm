
; Wonderswan test

%include "Wonderswan.inc"

%macro memcopy 4
    xor     ax,ax
    mov     es,ax
    mov     di,%1
    mov     ax,%2
    mov     ds,ax
    mov     si,%3
    mov     cx,%4
    cld
    rep     movsw
%endmacro

; ================================

section .bss  start=0
section .data vfollows=.text
section .text start=0 vstart=0x0f0000

ProgramStart:
    cli
    xor     ax,ax
    mov     bx,ax
    mov     cx,ax
    mov     dx,ax
    mov     es,ax
    out     REG_DISP_CTRL,ax
    out     REG_LCD_CTRL,ax
    mov     al,0b11100000
    out     REG_DISP_MODE,ax
    
    xor     ax,ax
    out     REG_SCR1_X,ax
    out     REG_SCR1_Y,ax
    out     REG_SCR2_X,ax
    out     REG_SCR2_Y,ax
    out     REG_MAP_BASE,al
    
    mov     al,DispCtrl_SCR1On
    out     REG_DISP_CTRL,al
    mov     al,LCDIcon_BigCircle
    out     REG_LCD_ICON,al
    in      al,REG_LCD_CTRL
    or      al,0b00000001
    out     REG_LCD_CTRL,al
    
    call    DS_Init
    mov     si,DS_TestSong
    call    DS_Load

MainLoop:
    call    DS_Update

    push    ax
    call    WaitVBlank
    pop     ax
    inc     ax
    and     ax,0xFF
    jmp     MainLoop

WaitFrames:
    pusha
    call    WaitVBlank
    popa
    loop    WaitFrames
    ret

WaitVBlank:
    mov     al,100
    call    WaitLine
    mov     al,144
WaitLine:
    mov     bl,al
    mov     dx,REG_LINE_CUR
.loop:
    in      al,dx
    cmp     al,bl
    jne     .loop
    ret

%include "DevSound.asm"
    
section .footer start=0xfff0 vstart=0x0ffff0

CartridgeFooter:
    db      0xEA                ; opcode for jmp
    dw      ProgramStart        ; entry point
    dw      0xF000              ; ???
    db      0                   ; reserved
    db      0                   ; developer ID
    db      0                   ; color support
    db      0                   ; game ID
    db      0                   ; reserved
    db      2                   ; cartridge size
    db      0                   ; SRAM size
    db      ROMSPEED_1CYCLE | ORIENTATION_HORIZONTAL
    db      0                   ; additional capabilities
    dw      0                   ; checksum

    