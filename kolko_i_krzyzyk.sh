#!/bin/bash

# Zadania projektu:
# 3.0 - działa w trybie gry turowej,                                -> OK
# 4.0 - pozwala na zapis i odtwarzanie przerwanej gry (save game),  -> ???
# 5.0 - pozwala na grę z komputerem.                                -> OK

PLANSZA=('*' '*' '*' '*' '*' '*' '*' '*' '*')
zapisana_gra=('*' 'X' '*' 'o' '*' 'X' 'o' '*' '*')
koniec_gry=false

function rysuj_plansze
{
  echo "${PLANSZA[@]:0:3}"
  echo "${PLANSZA[@]:3:3}"
  echo "${PLANSZA[@]:6:3}"
}

function czyj_nastepny_ruch
{
  count_of_x=$(echo ${zapisana_gra[*]} | grep -o "X" | wc -l)
  count_of_o=$(echo "${zapisana_gra[*]}" | grep -o "o" | wc -l)
  echo $count_of_x
  echo $count_of_o

  if [ $count_of_x == $count_of_o ]; then
    {
      echo "Zaczyna X"
    }
  else
    {
      echo "Zaczyna o"
    }
  fi
}

function zapisz_gre
{
  #$ { echo "${PLANSZA[*]}" } > save.txt
  echo "${zapisana_gra[*]}" > save.txt
  #echo "Zapisuje gre"
  #echo "Wybierz pole"
}

function wczytaj_gre
{
   read -a PLANSZA < save.txt
   rysuj_plansze

   echo "${PLANSZA[*]}"
}

function dodaj_znak
{
  echo "Wybierz pole:"
  czy_dobra_wartosc=false
  while [[ $czy_dobra_wartosc == false ]]
    do
      read POLE
      if [ "$POLE" -eq "$POLE" ] && [ "$POLE" -gt "0" ] && [ "$POLE" -le 9 ] 2> /dev/null; then
        if [ "${PLANSZA[$POLE-1]}" == "*" ];then
#         echo "Jest ok"
          PLANSZA[$POLE-1]=$1
          czy_dobra_wartosc=true
        else
          echo "Pole jest juz zajete"
        fi
      elif [ "$POLE" -eq "$POLE" ] && [ "$POLE" -eq "10" ]; then
        {
          zapisz_gre
        }
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
      clear
      rysuj_plansze
      dodaj_znak "X"
      sprawdz_czy_koniec_gry
      sprawdz_czy_remis
      if [[ $koniec_gry == true ]]; then
        break
      fi
      clear
      rysuj_plansze
      if [ $1 == '1' ]; then
        {
          dodaj_KOLKO
        }
      else
        {
          dodaj_znak "o"
        }
      fi
      sprawdz_czy_koniec_gry
      sprawdz_czy_remis
    done
}

function menu_glowne
{
  clear
  echo "Hej! Witaj w grze kolko i krzyzyk."
  echo "Co chcesz zrobic?"
  echo "1. Gra z komputerem."
  echo "2. Gra z innym graczem."
  echo "3. Wyjdz."
  echo ""
  echo "Wybierz 1-3"
  read zmienna_menu

  if [ "$zmienna_menu" -eq "$zmienna_menu" ] && [ "$zmienna_menu" -gt "0" ] && [ "$zmienna_menu" -le 3 ] 2> /dev/null; then
  {
    if [ "$zmienna_menu" -eq "1" ]; then
    {
      #echo "Tryb single"
      menu_wyboru_trybu "1"
    }
    elif [ "$zmienna_menu" -eq "2" ]; then
    {
      #echo "Tryb multi"
      menu_wyboru_trybu "2"
    }
    elif [ "$zmienna_menu" -eq "3" ]; then
    {
      echo "Wyjdz"
    }
    fi
  }
  else
  {
    menu_glowne
  }
  fi
}

function menu_wyboru_trybu()
{
  clear
  echo "*Tip: Aby zapisac gre wpisz 10 w pole wyboru pola*"
  echo "$1"
  echo "Wybierz tryb gry:"
  echo "1. Nowa gra"
  echo "2. Kontynuuj zapisana gre"
  read zmienna_menu_menu
  if [ "$zmienna_menu_menu" -eq "$zmienna_menu_menu" ] && [ "$zmienna_menu_menu" -gt "0" ] && [ "$zmienna_menu_menu" -le 2 ] 2> /dev/null; then
  {
    if [ "$zmienna_menu_menu" -eq "1" ]; then
    {
      PLANSZA=('*' '*' '*' '*' '*' '*' '*' '*' '*')
      #echo "Nowa gra"
      graj $1
    }
    elif [ "$zmienna_menu_menu" -eq "2" ]; then
    {
      PLANSZA=$zapisana_gra
      echo "Kontynuuj"
    }
    fi
  }
  else
  {
    menu_wyboru_trybu $1
  }
  fi

}

#menu_glowne
#graj
#czyj_nastepny_ruch


zapisz_gre
wczytaj_gre