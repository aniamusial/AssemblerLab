# 1. Sprawdzenie, czy liczba jest liczba pierwsza: 
# - rejestry 64-bitowe, liczba zapisana w stałej
# - odpowiedni komunikat

# Zalozenia poczatkowe: Liczba jest pierwsza, kiedy jej reszta z dzielenia przez 1 i przez siebie samą wynosi 0.


.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
LICZBA = 99

komzlozona: .ascii "Liczba nie jest pierwsza! \n"
komzlozona_len = .-komzlozona

kompierwsza: .ascii "Liczba jest pierwsza! \n"
kompierwsza_len = .-kompierwsza

.text
.globl _start

_start:
nop
movq $LICZBA, %rdx
cmp $1, %rdx
jle wyswietl_komunikat

movq $LICZBA, %rdx
cmp $2, %rdx
je wyswietl_poprawna

movq $1, %rdi        

petla:              # petla szuka, czy liczba ma jakies dzielniki i wyswietla odpowiedni komunikat jesli ma/nie ma
inc %rdi
cmp $LICZBA, %rdi   # jeżeli licznik jest równy zadanej liczbie to koniec pętli i liczba jest pierwsza
je wyswietl_poprawna

movq $LICZBA, %rax  
movq $0, %rdx       # wyczyszczenie reszty
div %rdi            # wykonaj dzielenie dx:ax przez rdi, iloraz w rax, reszta w rdx

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
