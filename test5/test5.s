# Funkcja sprawdzajaca czy w podanym lancuchu znakow znajduje sie ciag "aaa" i zwracajaca indeks poczatku tego ciagu w lancuchu.

.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512

komunikat: .ascii "W ciagu nie znaleziono takiej sekwencji \n"
komunikat_len = .-komunikat

znaleziono: .ascii "W ciagu nie znaleziono takiej sekwencji \n"
znaleziono_len = .-znaleziono


.bss
.comm textin, 512

.text
.globl _start
 
_start:
nop
movq $SYSREAD, %rax     
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

mov $0, %rdi    # wyzerowanie licznika
movq $0, %rbx
call szukaj

wyswietl_komunikat:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $komunikat, %rsi
movq $komunikat_len, %rdx
syscall

wyswietl_znaleziono:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $znaleziono, %rsi
movq $znaleziono_len, %rdx
syscall

koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall

szukaj: 
movb textin(, %rdi, 1),%bl 
cmp $0x32, %bl
je zwieksz_licznik
inc %rdi
cmp %rax, %rdi
jl szukaj
syscall

zwieksz_licznik: 
inc %rbx
cmp $3, %rbx
je wyswietl_znaleziono

ret

















