; This program draw a coin in the screen

.MODEL SMALL
.STACK 64
.CODE

DRAW_RECT MACRO X, Y, LEN, WID
LOCAL DRAW_WID, DRAW_LEN
    MOV CX, X           ; X-Pos
    MOV DX, Y           ; Y-Pos
    MOV AX, 0C0EH       ; AH: Draw Pixel | AL: Color

    ; Draw the right and left sides
    MOV BX, WID
    ADD BX, DX
    DRAW_WID:
        INT 10H
        ADD CX, LEN
        INT 10H
        SUB CX, LEN
        INC DX
        CMP DX, BX
    JNE DRAW_WID

    ; Draw the top and bottom sides
    MOV BX, LEN
    ADD BX, CX
    DRAW_LEN:
        INT 10H
        SUB DX, WID
        INT 10H
        ADD DX, WID
        INC CX
        CMP CX, BX
    JNE DRAW_LEN
    INT 10H

ENDM

DRAW_CUBOID MACRO X, Y, LEN, WID, HEIGHT
LOCAL DRAW_WID, DRAW_LEN, DRAW_HEIGHT, RIGHT, TOP

    MOV CX, X           ; X-Pos
    MOV DX, Y           ; Y-Pos
    MOV AX, 0C0EH       ; AH: Draw Pixel | AL: Color

    DRAW_RECT X, Y, LEN, HEIGHT

    MOV BX, DX
    MOV SI, WID
    SHR SI, 1
    SUB BX, SI

    DRAW_WID:
        INT 10H
        SUB DX, HEIGHT
        INT 10H
        SUB CX, LEN
        INT 10H
        ADD CX, LEN
        ADD DX, HEIGHT
        INC CX
        DEC DX
        CMP DX, BX
    JNE DRAW_WID

    MOV BX, DX
    SUB BX, HEIGHT
    RIGHT:
        INT 10H
        DEC DX
        CMP DX, BX
    JNE RIGHT

    MOV BX, CX
    SUB BX, LEN
    TOP:
        INT 10H
        DEC CX
        CMP CX, BX
    JNZ TOP
    INT 10H

ENDM

DRAW_FILLED_RECT MACRO X, Y, LEN, WID
LOCAL DRAW_WID, DRAW_LEN, FILL
    MOV CX, X           ; X-Pos
    MOV DX, Y           ; Y-Pos
    MOV AX, 0C0EH       ; AH: Draw Pixel | AL: Color

    ; Draw the right and left sides
    MOV BX, WID
    ADD BX, DX
    DRAW_WID:
        INT 10H
        MOV DI, CX
        ADD DI, LEN
        FILL:
            INC CX
            INT 10H
            CMP CX, DI
        JNE FILL
        SUB CX, LEN
        INC DX
        CMP DX, BX
    JNE DRAW_WID
ENDM

DRAW_FILLED_CUBOID MACRO X, Y, LEN, WID, HEIGHT
LOCAL DRAW, FILL_HEIGHT, FILL_LEN

    MOV CX, X           ; X-Pos
    MOV DX, Y           ; Y-Pos
    MOV AX, 0C0EH       ; AH: Draw Pixel

; To draw the front side
    DRAW_FILLED_RECT X, Y, LEN, HEIGHT

    ADD CX, LEN     ; Reset X-Pos and Y-Pos to the bottom right corner
    DEC DX

; To calculate the stop pos of the cuboid edges 
    MOV BX, DX
    MOV SI, WID
    SHR SI, 1
    SUB BX, SI

    MOV AL, 0FH             ; Color of Top and Left sides

    DRAW:
; To fill the right side of the cuboid
        INT 10H
        MOV DI, DX
        SUB DI, HEIGHT
        FILL_HEIGHT:
            DEC DX
            INT 10H
            CMP DX, DI
        JNE FILL_HEIGHT

; To fill the top side of the cuboid
        MOV DI, CX
        SUB DI, LEN
        FILL_LEN:
            DEC CX
            INT 10H
            CMP CX, DI
        JNE FILL_LEN
    
        ADD CX, LEN
        ADD DX, HEIGHT
        INC CX
        DEC DX
        CMP DX, BX
    JNE DRAW
ENDM

CLEAR_SCREEN PROC
    MOV AX, 0600H
    MOV BH, 01
    MOV CX, 0
    MOV DX, 184FH
    INT 10H
    RET
CLEAR_SCREEN ENDP

MAIN PROC FAR

; Change to video mode
    MOV AX, 0010H
    INT 10H

    DRAW_FILLED_CUBOID 140, 100, 20, 10, 15
    
    ;CALL CLEAR_SCREEN

    ; MOV AH, 4CH
    ; INT 21H
MAIN ENDP
END MAIN
