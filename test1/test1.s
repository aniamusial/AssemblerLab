# 1. Sprawdzenie, czy liczba jest liczba pierwsza: 
# - rejestry 64-bitowe, liczba zapisana w stałej
# - odpowiedni komunikat


.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
LICZBA = 7

komzlozona: .ascii "Liczba nie jest pierwsza! \n"
komzlozona_len = .-komzlozona

kompierwsza: .ascii "Liczba jest pierwsza! \n"
kompierwsza_len = .-kompierwsza

.text
.globl _start

_start:

movq $LICZBA, %rdx
cmp $1, %rdx
jle wyswietl_komunikat

movq $LICZBA, %rdx
cmp $2, %rdx
je wyswietl_poprawna

mov $1, %rdi

petla: 
inc %rdi
cmp $LICZBA, %rdi
je wyswietl_poprawna

movq $LICZBA, %rax  # liczba w rax
movq $0, %rdx       # wyczyszczenie reszty
div %rdi            # wykonaj dzielenie dx:ax przez rdi i zapisz do tego rejestru 

cmp $0, %rdx      
je wyswietl_komunikat
jmp petla

wyswietl_komunikat:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $komzlozona, %rsi
movq $komzlozona_len, %rdx
syscall
jmp koniec


wyswietl_poprawna:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $kompierwsza, %rsi
movq $kompierwsza_len, %rdx
syscall
jmp koniec

koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall