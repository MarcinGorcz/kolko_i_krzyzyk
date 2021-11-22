#!/bin/bash

# Zadania projektu:
# 3.0 - działa w trybie gry turowej,                                -> OK
# 4.0 - pozwala na zapis i odtwarzanie przerwanej gry (save game),  -> OK
# 5.0 - pozwala na grę z komputerem.                                -> OK

board=('*' '*' '*' '*' '*' '*' '*' '*' '*')
is_game_finished=false

function draw_board
{
  echo "${board[@]:0:3}"
  echo "${board[@]:3:3}"
  echo "${board[@]:6:3}"
}

function check_who_moves_next
{
  count_of_x=$(echo ${board[*]} | grep -o "X" | wc -l)
  count_of_o=$(echo "${board[*]}" | grep -o "o" | wc -l)

  if [ $count_of_x == $count_of_o ]; then
    {
      echo "X"
    }
  else
    {
      echo "o"
    }
  fi
}

function save_game
{
  echo "${board[*]}" > save.txt
}

function load_game
{
   read -a board < save.txt
}

function add_sign_to_board
{
  echo "Wybierz pole:"
  is_value_correct=false
  while [[ $is_value_correct == false ]]
    do
      read field
      if [ "$field" -eq "$field" ] && [ "$field" -gt "0" ] && [ "$field" -le 9 ] 2> /dev/null; then
        if [ "${board[$field-1]}" == "*" ];then
          board[$field-1]=$1
          is_value_correct=true
        else
          echo "Pole jest juz zajete"
        fi
      elif [ "$field" -eq "$field" ] && [ "$field" -eq "10" ]; then
        {
          save_game
        }
      else
        echo "Nie liczba z zakresu 1-9!"
      fi
    done
}

function add_circle_to_board_as_computer
{
  is_circle_added=false
  while [ "$is_circle_added" != true ] ; do
    field=$((0 + $RANDOM % 9))
    if [ "${board[$field]}" == "*" ];then
      board[$field]="o"
      is_circle_added=true
    fi
  done
}

function check_if_draw
{
  value="*"
  # shellcheck disable=SC2076
  if [[ ! " ${board[*]} " =~ "${value}" ]] && [[ $is_game_finished == false ]]; then
    echo "REMIS"
    is_game_finished=true
  fi
}

function check_if_game_is_finished
{
  sign_options=("o" "X")
  #wiersze:
  for player in "${sign_options[@]}"
  do
    if [[ "${board[0]}" == $player ]] && [[ "${board[1]}" == $player ]] && [[ "${board[2]}" == $player ]]; then
      echo "WYGRANA 1: $player"
      is_game_finished=true
      break
    elif [[ "${board[3]}" == $player ]] && [[ "${board[4]}" == $player ]] && [[ "${board[5]}" == $player ]]; then
      echo "WYGRANA 2: $player"
      is_game_finished=true
      break
    elif [[ "${board[6]}" == $player ]] && [[ "${board[7]}" == $player ]] && [[ "${board[8]}" == $player ]]; then
      echo "WYGRANA 3: $player"
      is_game_finished=true
      break
    #kolumny
    elif [[ "${board[0]}" == $player ]] && [[ "${board[3]}" == $player ]] && [[ "${board[6]}" == $player ]]; then
      echo "WYGRANA 4: $player"
      is_game_finished=true
      break
    elif [[ "${board[1]}" == $player ]] && [[ "${board[4]}" == $player ]] && [[ "${board[7]}" == $$player ]]; then
      echo "WYGRANA 5: $player"
      is_game_finished=true
      break
    elif [[ "${board[2]}" == $player ]] && [[ "${board[5]}" == $player ]] && [[ "${board[8]}" == $player ]]; then
      echo "WYGRANA 6: $player"
      is_game_finished=true
      break
    #przekatna
    elif [[ "${board[0]}" == $player ]] && [[ "${board[4]}" == $player ]] && [[ "${board[8]}" == $player ]]; then
      echo "WYGRANA 7: $player"
      is_game_finished=true
      break
    elif [[ "${board[2]}" == $player ]] && [[ "${board[4]}" == $player ]] && [[ "${board[6]}" == $player ]]; then
      echo "WYGRANA 8: $player"
      is_game_finished=true
      break
    fi
  done
}

function play
{
  clear
  if [[ $2 == "CONTINUE" ]]; then
  {
    load_game
    local nastepny_gracz=$(check_who_moves_next)
    if [[ $nastepny_gracz == 'o' ]]; then
    {
      if [ $1 == "SINGLE" ]; then
        {
          add_circle_to_board_as_computer
        }
      else
        {
          add_sign_to_board "o"
        }
      fi
      check_if_game_is_finished
      check_if_draw
    }
    fi
  }
  fi

  clear
  draw_board

  while [[ $is_game_finished == false ]]
    do
      add_sign_to_board "X"
      clear
      draw_board
      check_if_game_is_finished
      check_if_draw
      if [[ $is_game_finished == true ]]; then
        break
      fi
      if [ $1 == "SINGLE" ]; then
        {
          add_circle_to_board_as_computer
        }
      else
        {
          add_sign_to_board "o"
        }
      fi
      clear
      draw_board
      check_if_game_is_finished
      check_if_draw
    done
}

function main_menu
{
  clear
  echo "Hej! Witaj w grze kolko i krzyzyk."
  echo "Co chcesz zrobic?"
  echo "1. Gra z komputerem."
  echo "2. Gra z innym graczem."
  echo "3. Wyjdz."
  echo ""
  echo "Wybierz 1-3"
  read selected_option_in_main_menu

  if [ "$selected_option_in_main_menu" -eq "$selected_option_in_main_menu" ] && [ "$selected_option_in_main_menu" -gt "0" ] && [ "$selected_option_in_main_menu" -le 3 ] 2> /dev/null; then
  {
    if [ "$selected_option_in_main_menu" -eq "1" ]; then
    {
      mode_select_menu "SINGLE"
    }
    elif [ "$selected_option_in_main_menu" -eq "2" ]; then
    {
      mode_select_menu "MULTI"
    }
    elif [ "$selected_option_in_main_menu" -eq "3" ]; then
    {
      echo "Wyjdz"
    }
    fi
  }
  else
  {
    main_menu
  }
  fi
}

function mode_select_menu()
{
  clear
  echo "*Tip: Aby zapisac gre wpisz 10 w pole wyboru pola*"
  echo "$1"
  echo "Wybierz tryb gry:"
  echo "1. Nowa gra"
  echo "2. Kontynuuj zapisana gre"
  read selected_option_in_mode_select_menu
  if [ "$selected_option_in_mode_select_menu" -eq "$selected_option_in_mode_select_menu" ] && [ "$selected_option_in_mode_select_menu" -gt "0" ] && [ "$selected_option_in_mode_select_menu" -le 2 ] 2> /dev/null; then
  {
    if [ "$selected_option_in_mode_select_menu" -eq "1" ]; then
    {
      board=('*' '*' '*' '*' '*' '*' '*' '*' '*')
      play $1 "NEW_GAME"
    }
    elif [ "$selected_option_in_mode_select_menu" -eq "2" ]; then
    {
      play $1 "CONTINUE"
    }
    fi
  }
  else
  {
    mode_select_menu $1
  }
  fi
}

main_menu