# 2. Wczytanie liczy ze stdin w reprezentacji trójkowej
# - sprawdzenie poprawności wpisanego ciągu 
# - zamiana na liczbę (podglad w GDB)
# - konwersja na system dziewiatkowy w formie tekstowej i wypisanie na ekran

.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
PODSTAWA_SYSTEMU = 3

niepoprawna: .ascii "Liczba nie jest zapisana w systemie 3kowym \n"
niepoprawna_len = .-niepoprawna

poprawna: .ascii "Liczba jest zapisana w systemie 3kowym \n"
poprawna_len = .-poprawna

.bss
.comm textin, 512

.text
.globl _start

_start:
nop
movq $SYSREAD, %rax      # w rax LICZBA znakow wczytanych
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

dec %rdi    # "/n" 
mov $0, %rdi    # wyzerowanie licznika
 
czy_poprawna:
movb textin(, %rdi, 1),%bl 
sub $0x30, %bl        # konwersja ze znaku do liczby - odejmujemy 0 w ASCII
cmp $PODSTAWA_SYSTEMU, %bl  # jezeli wartosc rejestru %bl wieksza lub rowna 3, to liczba nie jest poprawnie zapisana
jge wyswietl_niepoprawna
inc %rdi
cmp %rax, %rdi
jl czy_poprawna

wyswietl_poprawna:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $poprawna, %rsi
movq $poprawna_len, %rdx
syscall
jmp koniec

wyswietl_niepoprawna:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $niepoprawna, %rsi
movq $niepoprawna_len, %rdx
syscall

koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall


