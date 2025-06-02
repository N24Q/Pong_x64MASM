extrn RegisterClassExW: proc
extrn CreateWindowExW: proc
extrn ShowWindow: proc
extrn UpdateWindow: proc
extrn GetMessageW: proc
extrn TranslateMessage: proc
extrn DispatchMessageW: proc
extrn DefWindowProcW: proc
extrn PostQuitMessage: proc
extrn BeginPaint: proc
extrn EndPaint: proc
extrn FillRect: proc
extrn CreateSolidBrush: proc
extrn DeleteObject: proc
extrn GetAsyncKeyState: proc
extrn SetTimer: proc
extrn KillTimer: proc
extrn ExitProcess: proc
extrn GetModuleHandleW: proc
extrn LoadCursorW: proc
extrn InvalidateRect: proc
extrn Rectangle: proc
extrn PlaySoundA : proc
extrn TextOutA : proc
extrn SetTextColor : proc
extrn SetBkMode : proc
extrn CreateFontA : proc
extrn SelectObject : proc
extrn AddFontResourceA : proc
extrn RemoveFontResourceA : proc
.data
    className dw 'P','O','N','G','C','l','a','s','s', 0
    windowTitle dw 'P','O','N','G',' ','G','a','m','e', 0
    GAME_STATE_HOME equ 0
    GAME_STATE_PLAYING equ 1
    GAME_STATE_WIN equ 2
    WIN_TIMER_ID equ 2
    WIN_DISPLAY_DURATION equ 3000
    WINDOW_WIDTH equ 800
    WINDOW_HEIGHT equ 600
    PADDLE_WIDTH equ 20
    PADDLE_HEIGHT equ 100
    BALL_SIZE equ 15
    PADDLE_SPEED equ 5
    BALL_SPEED equ 5
    TIMER_ID equ 1
    BLACK_COLOR equ 000000h
    WHITE_COLOR equ 0FFFFFFh
    gameState dq GAME_STATE_HOME
    ballX dq 400
    ballY dq 300
    ballVelX dq BALL_SPEED
    ballVelY dq BALL_SPEED
    paddle1Y dq 250
    paddle2Y dq 250
    score1 dq 0
    score2 dq 0
    winnerPlayer dq 0
    musicPlaying dq 0
    hWnd dq 0
    hInstance dq 0
    hFont dq 0
    hBlackBrush dq 0
    hWhiteBrush dq 0
    score_strings:
        db "0", 0
        db "1", 0
        db "2", 0
        db "3", 0
        db "4", 0
        db "5", 0
        db "6", 0
        db "7", 0
        db "8", 0
        db "9", 0
    format_str db "%d", 0
    player1WinText db "Player  1  Wins!", 0
    player2WinText db "Player  2  Wins!", 0
    pressSpaceText db "Press  SPACE  to  continue", 0
    PongText db "Pong", 0
    playText db "Press  SPACE  to  play", 0
    PaddleCollisionSound db "Sounds\PaddleCollisionSound.wav", 0
    WallCollisionSound db "Sounds\WallCollisionSound.wav", 0
    ResetBallSound db "Sounds\ResetBallSound.wav", 0
    BackgroundMusic db "Sounds\BackgroundMusic.wav", 0
    WinSound db "Sounds\WinSound.wav", 0
    ArcadeFont db "Fonts\ARCADECLASSIC.ttf", 0
    fontFaceName db "ArcadeClassic", 0
    msg_hwnd dq 0
    msg_message dq 0
    msg_wParam dq 0
    msg_lParam dq 0
    msg_time dq 0
    msg_pt_x dq 0
    msg_pt_y dq 0
    msg_private dq 0
    ps_hdc dq 0
    ps_fErase dd 0
    ps_rcPaint_left dd 0
    ps_rcPaint_top dd 0
    ps_rcPaint_right dd 0
    ps_rcPaint_bottom dd 0
    ps_fRestore dd 0
    ps_fIncUpdate dd 0
    ps_rgbReserved db 32 dup(0)
    wc_cbSize dd 80
    wc_style dd 3
    wc_lpfnWndProc dq WindowProc
    wc_cbClsExtra dd 0
    wc_cbWndExtra dd 0
    wc_hInstance dq 0
    wc_hIcon dq 0
    wc_hCursor dq 0
    wc_hbrBackground dq 0
    wc_lpszMenuName dq 0
    wc_lpszClassName dq offset className
    wc_hIconSm dq 0
.code
main PROC
    push rbp
    mov rbp, rsp
    sub rsp, 80h
    mov rcx, 0
    call GetModuleHandleW
    mov hInstance, rax
    mov wc_hInstance, rax
    mov rcx, 0
    mov rdx, 32512
    call LoadCursorW
    mov wc_hCursor, rax
    mov ecx, BLACK_COLOR
    call CreateSolidBrush
    mov hBlackBrush, rax
    mov wc_hbrBackground, rax
    mov ecx, WHITE_COLOR
    call CreateSolidBrush
    mov hWhiteBrush, rax
    lea rcx, ArcadeFont
    call AddFontResourceA
    mov rcx, 48
    mov rdx, 0
    mov r8, 0
    mov r9, 0
    mov qword ptr [rsp+20h], 400
    mov qword ptr [rsp+28h], 0
    mov qword ptr [rsp+30h], 0
    mov qword ptr [rsp+38h], 0
    mov qword ptr [rsp+40h], 0
    mov qword ptr [rsp+48h], 0
    mov qword ptr [rsp+50h], 0
    mov qword ptr [rsp+58h], 0
    mov qword ptr [rsp+60h], 0
    lea rax, fontFaceName
    mov qword ptr [rsp+68h], rax
    call CreateFontA
    mov hFont, rax
    lea rcx, wc_cbSize
    call RegisterClassExW
    test rax, rax
    jz exit_program
    mov rcx, 0
    lea rdx, className
    lea r8, windowTitle
    mov r9, 0CF0000h
    mov qword ptr [rsp+20h], 100
    mov qword ptr [rsp+28h], 100
    mov qword ptr [rsp+30h], WINDOW_WIDTH + 16
    mov qword ptr [rsp+38h], WINDOW_HEIGHT + 39
    mov qword ptr [rsp+40h], 0
    mov qword ptr [rsp+48h], 0
    mov rax, hInstance
    mov qword ptr [rsp+50h], rax
    mov qword ptr [rsp+58h], 0
    call CreateWindowExW
    test rax, rax
    jz exit_program
    mov hWnd, rax
    mov rcx, rax
    mov rdx, 1
    call ShowWindow
    mov rcx, hWnd
    call UpdateWindow
    mov rcx, hWnd
    mov rdx, TIMER_ID
    mov r8, 16
    mov r9, 0
    call SetTimer
    call ResetGameState
    call StartBackgroundMusic
message_loop:
    lea rcx, msg_hwnd
    mov rdx, 0
    mov r8, 0
    mov r9, 0
    call GetMessageW
    cmp rax, 0
    je exit_program
    lea rcx, msg_hwnd
    call TranslateMessage
    lea rcx, msg_hwnd
    call DispatchMessageW
    jmp message_loop
exit_program:
    lea rcx, ArcadeFont
    call RemoveFontResourceA
    mov rcx, hBlackBrush
    call DeleteObject
    mov rcx, hWhiteBrush
    call DeleteObject
    mov rcx, hFont
    call DeleteObject
    mov rcx, 0
    call ExitProcess
main ENDP
WindowProc PROC
    push rbp
    mov rbp, rsp
    sub rsp, 40h
    cmp rdx, 15
    je handle_paint
    cmp rdx, 2
    je handle_destroy
    cmp rdx, 275
    je handle_timer
    cmp rdx, 256
    je handle_keydown
    call DefWindowProcW
    jmp proc_exit
handle_paint:
    call PaintGame
    xor rax, rax
    jmp proc_exit
handle_destroy:
    mov rcx, TIMER_ID
    call KillTimer
    mov rcx, 0
    call PostQuitMessage
    xor rax, rax
    jmp proc_exit
handle_timer:
    cmp rdx, WIN_TIMER_ID
    je handle_win_timer
    cmp gameState, GAME_STATE_PLAYING
    jne skip_update
    call UpdateGame
skip_update:
    mov rcx, hWnd
    mov rdx, 0
    mov r8, 1
    call InvalidateRect
    xor rax, rax
    jmp proc_exit
handle_win_timer:
    mov rcx, hWnd
    mov rdx, WIN_TIMER_ID
    call KillTimer
    call ResetScores
    mov gameState, GAME_STATE_HOME
    call StartBackgroundMusic
    mov rcx, hWnd
    mov rdx, 0
    mov r8, 1
    call InvalidateRect
    xor rax, rax
    jmp proc_exit
handle_keydown:
    cmp r8, 32
    jne proc_default
    cmp gameState, GAME_STATE_HOME
    je start_game
    cmp gameState, GAME_STATE_WIN
    je return_to_home_manual
    jmp proc_default
start_game:
    call StopBackgroundMusic
    mov gameState, GAME_STATE_PLAYING
    call ResetGameState
    mov rcx, hWnd
    mov rdx, 0
    mov r8, 1
    call InvalidateRect
    xor rax, rax
    jmp proc_exit
return_to_home_manual:
    call ResetScores
    mov gameState, GAME_STATE_HOME
    call StartBackgroundMusic
    mov rcx, hWnd
    mov rdx, 0
    mov r8, 1
    call InvalidateRect
    xor rax, rax
    jmp proc_exit
proc_default:
    call DefWindowProcW
    jmp proc_exit
proc_exit:
    add rsp, 40h
    pop rbp
    ret
WindowProc ENDP
ResetGameState PROC
    push rbp
    mov rbp, rsp
    mov ballX, WINDOW_WIDTH / 2
    mov ballY, WINDOW_HEIGHT / 2
    mov ballVelX, BALL_SPEED
    mov ballVelY, BALL_SPEED
    mov paddle1Y, (WINDOW_HEIGHT - PADDLE_HEIGHT) / 2
    mov paddle2Y, (WINDOW_HEIGHT - PADDLE_HEIGHT) / 2
    call ResetScores
    pop rbp
    ret
ResetGameState ENDP
ResetScores PROC
    push rbp
    mov rbp, rsp
    mov score1, 0
    mov score2, 0
    pop rbp
    ret
ResetScores ENDP
UpdateGame PROC
    push rbp
    mov rbp, rsp
    sub rsp, 40h
    mov rcx, 87
    call GetAsyncKeyState
    test ax, 8000h
    jz check_s
    mov rax, paddle1Y
    sub rax, PADDLE_SPEED
    cmp rax, 0
    jl check_s
    mov paddle1Y, rax
check_s:
    mov rcx, 83
    call GetAsyncKeyState
    test ax, 8000h
    jz check_up
    mov rax, paddle1Y
    add rax, PADDLE_SPEED
    mov rbx, WINDOW_HEIGHT - PADDLE_HEIGHT
    cmp rax, rbx
    jg check_up
    mov paddle1Y, rax
check_up:
    mov rcx, 38
    call GetAsyncKeyState
    test ax, 8000h
    jz check_down
    mov rax, paddle2Y
    sub rax, PADDLE_SPEED
    cmp rax, 0
    jl check_down
    mov paddle2Y, rax
check_down:
    mov rcx, 40
    call GetAsyncKeyState
    test ax, 8000h
    jz update_ball
    mov rax, paddle2Y
    add rax, PADDLE_SPEED
    mov rbx, WINDOW_HEIGHT - PADDLE_HEIGHT
    cmp rax, rbx
    jg update_ball
    mov paddle2Y, rax
update_ball:
    mov rax, ballX
    add rax, ballVelX
    mov ballX, rax
    mov rax, ballY
    add rax, ballVelY
    mov ballY, rax
    cmp ballY, 0
    jle bounce_y
    mov rax, WINDOW_HEIGHT - BALL_SIZE
    cmp ballY, rax
    jge bounce_y
    jmp check_paddles
bounce_y:
    lea rcx, WallCollisionSound
    call play_sound
    neg ballVelY
    cmp ballY, 0
    jg check_bottom
    mov ballY, 0
    jmp check_paddles
check_bottom:
    mov rax, WINDOW_HEIGHT - BALL_SIZE
    cmp ballY, rax
    jl check_paddles
    mov ballY, rax
check_paddles:
    mov rax, ballX
    cmp rax, PADDLE_WIDTH + 10
    jg check_right_paddle
    mov rbx, ballY
    add rbx, BALL_SIZE/2
    mov rcx, paddle1Y
    cmp rbx, rcx
    jl check_right_paddle
    add rcx, PADDLE_HEIGHT
    cmp rbx, rcx
    jg check_right_paddle
    neg ballVelX
    mov ballX, PADDLE_WIDTH + 10
    lea rcx, PaddleCollisionSound
    call play_sound
check_right_paddle:
    mov rax, ballX
    mov rbx, WINDOW_WIDTH - PADDLE_WIDTH - 10 - BALL_SIZE
    cmp rax, rbx
    jl check_reset
    mov rbx, ballY
    add rbx, BALL_SIZE/2
    mov rcx, paddle2Y
    cmp rbx, rcx
    jl check_reset
    add rcx, PADDLE_HEIGHT
    cmp rbx, rcx
    jg check_reset
    neg ballVelX
    mov rax, WINDOW_WIDTH - PADDLE_WIDTH - 10 - BALL_SIZE
    mov ballX, rax
    lea rcx, PaddleCollisionSound
    call play_sound
    jmp update_done
check_reset:
    cmp ballX, -BALL_SIZE
    jl left_score
    mov rax, WINDOW_WIDTH
    cmp ballX, rax
    jg right_score
    jmp update_done
left_score:
    mov rax, score2
    add rax, 1
    mov score2, rax
    cmp rax, 5
    je player2_wins
    jmp reset_ball
right_score:
    mov rax, score1
    add rax, 1
    mov score1, rax
    cmp rax, 5
    je player1_wins
    jmp reset_ball
player1_wins:
    lea rcx, WinSound
    call play_sound
    mov winnerPlayer, 1
    mov gameState, GAME_STATE_WIN
    mov rcx, hWnd
    mov rdx, WIN_TIMER_ID
    mov r8, WIN_DISPLAY_DURATION
    mov r9, 0
    call SetTimer
    mov rcx, hWnd
    mov rdx, 0
    mov r8, 1
    call InvalidateRect
    jmp update_done
player2_wins:
    lea rcx, WinSound
    call play_sound
    mov winnerPlayer, 2
    mov gameState, GAME_STATE_WIN
    mov rcx, hWnd
    mov rdx, WIN_TIMER_ID
    mov r8, WIN_DISPLAY_DURATION
    mov r9, 0
    call SetTimer
    mov rcx, hWnd
    mov rdx, 0
    mov r8, 1
    call InvalidateRect
    jmp update_done
return_to_home:
    call ResetScores
    mov gameState, GAME_STATE_HOME
    call StartBackgroundMusic
    mov rcx, hWnd
    mov rdx, 0
    mov r8, 1
    call InvalidateRect
    jmp update_done
reset_ball:
    lea rcx, ResetBallSound
    call play_sound
    mov ballX, WINDOW_WIDTH / 2
    mov ballY, WINDOW_HEIGHT / 2
    neg ballVelX
update_done:
    add rsp, 40h
    pop rbp
    ret
UpdateGame ENDP
PaintGame PROC
    push rbp
    mov rbp, rsp
    sub rsp, 80h
    mov rcx, hWnd
    lea rdx, ps_hdc
    call BeginPaint
    mov [rbp-8], rax
    mov rcx, rax
    mov qword ptr [rsp+20h], 0
    mov qword ptr [rsp+28h], 0
    mov qword ptr [rsp+30h], WINDOW_WIDTH
    mov qword ptr [rsp+38h], WINDOW_HEIGHT
    lea rdx, qword ptr [rsp+20h]
    mov r8, hBlackBrush
    call FillRect
    cmp gameState, GAME_STATE_HOME
    je paint_home_screen
    jmp paint_game_screen
paint_home_screen:
    mov rcx, [rbp-8]
    mov rdx, WHITE_COLOR
    call SetTextColor
    mov rcx, [rbp-8]
    mov rdx, 1
    call SetBkMode
    mov rcx, [rbp-8]
    mov rdx, hFont
    call SelectObject
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH/2 - 55
    mov r8, WINDOW_HEIGHT/2 - 100
    lea r9, PongText
    mov qword ptr [rsp+20h], 4
    call TextOutA
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH/2 - 215
    mov r8, WINDOW_HEIGHT/2 + 100
    lea r9, playText
    mov qword ptr [rsp+20h], 22
    call TextOutA
    jmp paint_done
paint_game_screen:
    cmp gameState, GAME_STATE_WIN
    je paint_win_screen
    mov rcx, [rbp-8]
    mov rdx, hFont
    call SelectObject
    mov rcx, [rbp-8]
    mov rdx, 00FFFFFFh
    call SetTextColor
    mov rcx, [rbp-8]
    mov rdx, 1
    call SetBkMode
    mov rax, score1
    imul rax, 2
    lea r9, score_strings
    add r9, rax
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH/2 - 350
    mov r8, WINDOW_HEIGHT/2 - 250
    mov qword ptr [rsp+20h], 1
    call TextOutA
    mov rax, score2
    imul rax, 2
    lea r9, score_strings
    add r9, rax
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH/2 + 350
    mov r8, WINDOW_HEIGHT/2 - 250
    mov qword ptr [rsp+20h], 1
    call TextOutA
    mov rcx, [rbp-8]
    mov rdx, 10
    mov r8, paddle1Y
    mov r9, 10 + PADDLE_WIDTH
    mov rax, paddle1Y
    add rax, PADDLE_HEIGHT
    mov qword ptr [rsp+20h], rax
    call Rectangle
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH - PADDLE_WIDTH - 10
    mov r8, paddle2Y
    mov r9, WINDOW_WIDTH - 10
    mov rax, paddle2Y
    add rax, PADDLE_HEIGHT
    mov qword ptr [rsp+20h], rax
    call Rectangle
    mov rcx, [rbp-8]
    mov rdx, ballX
    mov r8, ballY
    mov rax, ballX
    add rax, BALL_SIZE
    mov r9, rax
    mov rax, ballY
    add rax, BALL_SIZE
    mov qword ptr [rsp+20h], rax
    call Rectangle
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH/2 - 2
    mov r8, 0
    mov r9, WINDOW_WIDTH/2 + 2
    mov qword ptr [rsp+20h], WINDOW_HEIGHT
    call Rectangle
    jmp paint_done
paint_win_screen:
    mov rcx, [rbp-8]
    mov rdx, WHITE_COLOR
    call SetTextColor
    mov rcx, [rbp-8]
    mov rdx, 1
    call SetBkMode
    mov rcx, [rbp-8]
    mov rdx, hFont
    call SelectObject
    cmp winnerPlayer, 1
    je display_player1_win
    lea r9, player2WinText
    mov qword ptr [rsp+20h], 16
    jmp display_win_text
display_player1_win:
    lea r9, player1WinText
    mov qword ptr [rsp+20h], 16
display_win_text:
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH/2 - 150
    mov r8, WINDOW_HEIGHT/2 - 100
    call TextOutA
    mov rcx, [rbp-8]
    mov rdx, WINDOW_WIDTH/2 - 275
    mov r8, WINDOW_HEIGHT/2 + 50
    lea r9, pressSpaceText
    mov qword ptr [rsp+20h], 26
    call TextOutA
    jmp paint_done
paint_done:
    mov rcx, hWnd
    lea rdx, ps_hdc
    call EndPaint
    add rsp, 80h
    pop rbp
    ret
PaintGame ENDP
play_sound:
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 32
    mov rdx, 0
    mov r8, 00020001h
    call PlaySoundA
    mov rsp, rbp
    pop rbp
    ret
StartBackgroundMusic PROC
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 32
    cmp musicPlaying, 1
    je music_already_playing
    lea rcx, BackgroundMusic
    mov rdx, 0
    mov r8, 00020009h
    call PlaySoundA
    mov musicPlaying, 1
music_already_playing:
    mov rsp, rbp
    pop rbp
    ret
StartBackgroundMusic ENDP
StopBackgroundMusic PROC
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 32
    mov rcx, 0
    mov rdx, 0
    mov r8, 0
    call PlaySoundA
    mov musicPlaying, 0
    mov rsp, rbp
    pop rbp
    ret
StopBackgroundMusic ENDP
END