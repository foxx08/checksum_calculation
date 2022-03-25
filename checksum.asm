; ----------------------------------------------------------------------------
;  checksum calculation for German ID card number
; ----------------------------------------------------------------------------

        global  main
        extern  printf

        section .text
main:
        mov     eax, [esp+4]            ; argc
        cmp     eax, 2                  ; die Kommandozeile muss genau 2 Parameter haben, d.h. 1 Argument
        jne     badCommand

        mov     eax, [esp+8]            ; argv
        mov	ebx, [eax+4]            ; Startadresse der Zeichenkette, auf die das zweite argv-Element zeigt
		
		;;;;;;;;;;;;;;;;;;;;;;;;; eigentl. Programm ;;;;;;;;;;;;;;;;;;;;;;;;;


	call    checksum		;rufe Unterprogramm auf und speichere in eax
        push    eax                     ; Prüfziffer
        push    ebx                     ; String der Nummer
        push    stringFormat
        call    printf                  ; Pruefziffer und Nummer ausgeben lassen
        add     esp, 12			; ESP um 3 DWORD zurückstellen		
        ret     		      


		;;;;;;;;;;;; Unterprogramm: checksum ;;;;;;;;;;;;
       	
checksum: 
    push ebx                        
    push esi
    mov esi, 0                      ;make sure register is empty
    mov ecx, 0                      ;"

loop:
    mov edx, 0                      ;
    mov dl, [ebx+ecx]               ;
    cmp edx, 64                     ;compare edx with 64
    ja buchstabe                    ;bigger -> letter
    cmp edx, 58                     ;compare edx with 58
    jb nummer                       ;smaller -> number

add:                                ;get last character
    cmp edx, 10
    jge letztenummer
    add esi, edx 
    add ecx, 1                   ;increment
    cmp ecx, 9                   
    jne loop                     ;if equal then loop
    mov eax,esi

zifferadd:    
    cmp eax, 10                 ;save result
    jge letzteziffer
    pop esi                     ;
    pop ebx                     ;"
    ret                         


letzteziffer:                    ;
    sub eax, 10
    jmp zifferadd

letztenummer:                   ;last character
    sub edx, 10
    jmp add

block:                       
    cmp ecx, 0                ;Loop Counter
    je sieben                 ;seven

    cmp ecx, 1 
    je drei                     ;three

    cmp ecx, 2
    je eins                    ;one

    cmp ecx, 3
    je sieben                  ;seven

    cmp ecx, 4
    je drei                    ;three

    cmp ecx, 5
    je eins                    ;one

    cmp ecx, 6
    je sieben                 ;seven

    cmp ecx, 7
    je drei                   ;three

    cmp ecx, 8
    je eins                   ;one

    jmp  add


sieben:
    imul edx,7
    jmp add

drei:
    imul edx,3
    jmp add

eins:
    imul edx,1
    jmp add
    


buchstabe:                       ;ASCII conversion
    sub edx, 55
    jmp block

nummer:                       ;ASCII conversion
    sub edx,48
    jmp block


        ;; eax, ecx, edx dürfen im Upr verwendet werden (im Hpr zu sichern, call-used)
        ;; ebx, esi, edi sind im Upr vor Benutzung zu sichern (call-saved)


	; Rücksprung aus checksum
		
		;;;;;;;;;;;;;;;;;;;;;;;;; Ausgaben ;;;;;;;;;;;;;;;;;;;;;;;;;
		
badCommand:
        push    badArgumentFormat
        call    printf
        add     esp, 4			; ESP um 1 DWORD zurückstellen
        ret

	
		section .data
		
badArgumentFormat:
        db      'bad argument', 10, 0		; 10 = LF

dummy:  db      'NN', 0

stringFormat:
        db      '"%s%1d"', 10, 0

n:    db 0 


