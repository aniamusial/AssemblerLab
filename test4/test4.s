# 1. Generowanie liczb pierwszych wedlug Sita Erastosenesa
# Zakres 64 bit
# Koniecznosc uzycia rejestru o rozmiarze 8B
# Zapis wygenerowanych liczb do pamieci
# 2. Wypisanie liczb na ekran
# Za pierwsze dwa podpunkty odpowiada jedna funkcja

.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
ILOSC_LICZB = 1000  
PODSTAWA_WYJSCIA = 10 # Stałe wykorzystywane przy wyświetlaniu liczb. 
 
.bss
.comm sito_bufor, 9999 # Bufor wartości 0/1 decydujących czy dana
                       # liczba (indeks+2) jest liczbą pierwszą
                       # czy nie. Jego rozmiar to ilość liczb
                       # do wygenerowanie-2.
.comm liczby, 79992 # Bufor przechowujący liczby pierwsze
                    # wygenerowane przez algorytm. Każda liczba
                    # zapisywana jest na 64 bitach, czyli 8 bajtach,
                    # więc jego rozmiar to 8*rozmiar poprzedniego
                    # bufora.
.comm textinv, 512  # Bufory wykorzystywane do zamiany liczb
.comm textout, 512  # na postać ciągów kodów ASCII kolejnych cyfr.
 
.text
.globl _start
 
_start:

call sito_eratostenesa
 
# WYŚWIETLENIE WYNIKU DZIAŁANIA ALGORYTMU
#
# Zamiana wartości liczb wygenerowanych i umieszczonych przez
# algorytm w buforze "liczby" do postaci ciągów kodów ASCII
# i ich wyświetlanie.
#
 
mov $0, %r8 # Licznik do pętli - zostanie ona wykonana dla każdej
            # komórki bufora "liczby". Liczby o wartości zero nie
            # zostaną wyświetlone.
 
petla1:
mov liczby(, %r8, 8), %rax # Skopiowanie liczby do rejestru RAX
cmp $0, %rax
je pomin # Jeśli liczba jest równa 0, pominięcie konwersji
         # i wyświetlania
 
#
# DEKODOWANIE WARTOŚCI LICZBY W PĘTLI
#
 
mov $PODSTAWA_WYJSCIA, %rbx
mov $0, %rcx
 
petla2:
mov $0, %rdx
div %rbx
# Dzielenie bez znaku liczby z rejestru RAX przez RBX
# i zapis wyniku do RAX oraz reszty z dzielenie do RDX.
# Reszta z dzielenia to przy każdej iteracji pętli kolejna
# pozycja wyniku. Po dodaniu kodu znaku pierwszej liczby,
# są to kody znaków ASCII liczb na kolejnych pozycjach.
add $0x30, %rdx
# Zapis znaków do bufora w odwrotnej kolejności
mov %dl, textinv(, %rcx, 1)
 
# Zwiększenie licznika i w kolejnych iteracjach powrót
# na początek pętli, aż do uzyskania zerowego wyniku dzielenia
inc %rcx
cmp $0, %rax
jne petla2

#
# ODWRÓCENIE KOLEJNOŚCI CYFR
#
 
# Po wykonaniu ostatniego kroku, cyfry zapisane są w buforze
# w odwrotnej kolejności, w tej pętli są przepisywane z końca
# na początek do nowego bufora textout.

mov $0, %rdi
mov %rcx, %rsi
dec %rsi
 
petla3:
mov textinv(, %rsi, 1), %rax
mov %rax, textout(, %rdi, 1)
 
inc %rdi
dec %rsi
cmp %rcx, %rdi
jle petla3
 
#
# WYŚWIETLENIE LICZBY
#
 
# Dopisanie na końcu bufora wyjściowego znaku nowej linii
movb $0x0A, textout(, %rcx, 1)
inc %rcx
 
# Wyświetlenie tekstu z bufora textout
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $textout, %rsi
mov %rcx, %rdx
syscall
 
pomin:
# Powrót na początek pętli aż do wykonania instrukcji dla
# wszystkich liczb.
inc %r8
cmp $ILOSC_LICZB, %r8
jl petla1
 
 
 
#
# ZAKOŃCZENIE PROGRAMU
#
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
 
#
# FUNKCJA REALIZUJĄCA ALGORYTM SITA ERATOSTENESA
#
sito_eratostenesa:
 
# Czyszczenie bufora liczb i sita w pętli
mov $ILOSC_LICZB, %rdi
sito_petla1:
    dec %rdi
    movb $1, sito_bufor(, %rdi, 1)
    movq $0, liczby(, %rdi, 8)
cmp $0, %rdi
jg sito_petla1
 
# Pętla wykonująca się dla każdej liczby z sita
# [ for(i=2; i<$ILOSC_LICZB+2; i++) ]
mov $0, %r10
mov $0, %rdi # Licznik indeksów w buforze sita
             # - od 0 do $ILOSC_LICZB.
mov $2, %rsi # Licznik wartości elementów odpowiadających
             # indeksom w buforze sita. Dla pierwszego elementu
             # z bufora tj. o indeksie 0, wartością będzie 2,
             # ponieważ w obliczeniach pomijamy liczby 0 i 1.
 
sito_petla2:
    # Jeśli aktualna liczba nie jest liczbą pierwszą przechodzimy
    # do kolejnego wykonania pętli.
    # [ if(sito[i-2] == 0) continue; ]
    mov sito_bufor(, %rdi, 1), %al
    cmp $0, %al
    je sito_pomin2
 
    # Jeśli liczba jest liczbą pierwszą tj. w buforze sita ma
    # przypisaną wartość true, dopisujemy ją do bufora "liczby".
    mov %rsi, liczby(, %r10, 8)
    inc %r10
 
    # Oznaczenie każdej wielokrotności wybranej liczby w buforze
    # sita jako liczbę nie pierwszą - tj. przypisanie jej wartości 0.
    # [ for(j=i; j<$ILOSC_LICZB+2; j+=i) ]
    mov %rdi, %r8 # Licznik indeksów w buforze sita
                  # - od (i-2) do $ILOSC_LICZB.
    mov %rsi, %r9 # Licznik wartości - od i do $ILOSC_LICZB+2.
    sito_petla3:
        mov $0, %al
        mov %al, sito_bufor(, %r8, 1)
    add %rsi, %r8
    add %rsi, %r9
    cmp $ILOSC_LICZB, %r8
    jl sito_petla3
 
    sito_pomin2:
# Zwiększenie liczników i ew. powrót na początek pętli głównej.
inc %rdi
inc %rsi
cmp $ILOSC_LICZB, %rdi
jl sito_petla2
 
ret # Powrót do miejsca wywołania funkcji
