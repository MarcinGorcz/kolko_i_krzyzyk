#!/bin/bash

PLANSZA=('*' '*' '*' '*' '*' '*' '*' '*' '*')
koniec_gry=false

function rysuj_plansze
{
  echo "${PLANSZA[@]:0:3}"
  echo "${PLANSZA[@]:3:3}"
  echo "${PLANSZA[@]:6:3}"
}

function dodaj_krzyzyk
{
  echo "Wybierz pole:"
  czy_dobra_wartosc=false
  while [[ $czy_dobra_wartosc == false ]]
    do
      read POLE
      if [ "$POLE" -eq "$POLE" ] && [ "$POLE" -gt "0" ] && [ "$POLE" -le 9 ] 2> /dev/null; then
        if [ "${PLANSZA[$POLE-1]}" == "*" ];then
#         echo "Jest ok"
          PLANSZA[$POLE-1]="X"
          czy_dobra_wartosc=true
        else
          echo "Pole jest juz zajete"
        fi
      else
        echo "Nie liczba z zakresu 1-9!"
      fi
    done
}

function dodaj_KOLKO
{
  jest_dodane=false
  while [ "$jest_dodane" != true ] ; do
    WYLOSOWANA_LICZBA=$((0 + $RANDOM % 9))
    if [ "${PLANSZA[$WYLOSOWANA_LICZBA]}" == "*" ];then
#      echo $WYLOSOWANA_LICZBA
      PLANSZA[$WYLOSOWANA_LICZBA]="o"
      jest_dodane=true
    fi
  done
}

function sprawdz_czy_remis
{
  value="*"
  # shellcheck disable=SC2076
  if [[ ! " ${PLANSZA[*]} " =~ "${value}" ]]; then
    echo "REMIS"
    koniec_gry=true
#  else
#    echo "NIE REMIS"
  fi
}

function sprawdz_czy_koniec_gry
{
  OPCJE=("o" "X")
  #wiersze:
  for gracz in "${OPCJE[@]}"
  do
    if [[ "${PLANSZA[0]}" == $gracz ]] && [[ "${PLANSZA[1]}" == $gracz ]] && [[ "${PLANSZA[2]}" == $gracz ]]; then
      echo "WYGRANA 1: $gracz"
      koniec_gry=true
      break
    elif [[ "${PLANSZA[3]}" == $gracz ]] && [[ "${PLANSZA[4]}" == $gracz ]] && [[ "${PLANSZA[5]}" == $gracz ]]; then
      echo "WYGRANA 2: $gracz"
      koniec_gry=true
      break
    elif [[ "${PLANSZA[6]}" == $gracz ]] && [[ "${PLANSZA[7]}" == $gracz ]] && [[ "${PLANSZA[8]}" == $gracz ]]; then
      echo "WYGRANA 3: $gracz"
      koniec_gry=true
      break
    #kolumny
    elif [[ "${PLANSZA[0]}" == $gracz ]] && [[ "${PLANSZA[3]}" == $gracz ]] && [[ "${PLANSZA[6]}" == $gracz ]]; then
      echo "WYGRANA 4: $gracz"
      koniec_gry=true
      break
    elif [[ "${PLANSZA[1]}" == $gracz ]] && [[ "${PLANSZA[4]}" == $gracz ]] && [[ "${PLANSZA[7]}" == $$gracz ]]; then
      echo "WYGRANA 5: $gracz"
      koniec_gry=true
      break
    elif [[ "${PLANSZA[2]}" == $gracz ]] && [[ "${PLANSZA[5]}" == $gracz ]] && [[ "${PLANSZA[8]}" == $gracz ]]; then
      echo "WYGRANA 6: $gracz"
      koniec_gry=true
      break
    #przekatna
    elif [[ "${PLANSZA[0]}" == $gracz ]] && [[ "${PLANSZA[4]}" == $gracz ]] && [[ "${PLANSZA[8]}" == $gracz ]]; then
      echo "WYGRANA 7: $gracz"
      koniec_gry=true
      break
    elif [[ "${PLANSZA[2]}" == $gracz ]] && [[ "${PLANSZA[4]}" == $gracz ]] && [[ "${PLANSZA[6]}" == $gracz ]]; then
      echo "WYGRANA 8: $gracz"
      koniec_gry=true
      break
#    else
#      echo "NIE WYGRANA"
    fi
  done
}

function graj
{
  clear
  rysuj_plansze
  while [[ $koniec_gry == false ]]
    do
      dodaj_krzyzyk
      rysuj_plansze
      clear
      sprawdz_czy_koniec_gry
      sprawdz_czy_remis
      if [[ $koniec_gry == true ]]; then
        break
      fi
      dodaj_KOLKO
      clear
      rysuj_plansze
      sprawdz_czy_koniec_gry
      sprawdz_czy_remis
    done
}

graj