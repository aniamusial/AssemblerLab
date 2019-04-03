# 1. Wczytanie z pliku 2 dużych liczb w reprezentacji szesnastkowej w ASCII
# 2. Zamiana na poprawny zapis liczby w pamięci (wyswietlenie w GDB)
# 3. Wykonanie dodawania z użyciem rejestru 64b  flagi CF (adc) 
# 4. Zamiana na zapis tekstowy w reprezentacji ósemkowej (ASCII) i zapis do pliku


.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
FREAD = 0
FWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0

plik_wejsciowy: .ascii "dane.txt" 
 
.bss
.comm textin, 1024   # Bufor na liczby odczytane z pliku w ASCII
 
.section .text
.globl _start
 
_start:
nop
# Otworzenie i wczytanie danych z pliku
movq $SYSOPEN, %rax
movq $plik_wejsciowy, %rdi
movq $FREAD, %rsi
syscall

movq %rax, %r8      # open file handler
 
# Przepisanie liczb z pliku do bufora
mov $SYSREAD, %rax
mov %r8, %rdi
mov $textin, %rsi
mov $1024, %rdx
syscall

konwersja:
mov textin(,%r8,1), %bl

# Zamknięcie pliku
movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
