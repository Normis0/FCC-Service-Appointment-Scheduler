#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~~~ freeCodeCamp Beauty Salon ~~~~ \n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\n Welcome to freeCodeCamp Beauty Salon. What beauty service would you like to have?\n"
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) BOOK_SERVICE ;;
    2) BOOK_SERVICE ;;
    3) BOOK_SERVICE ;;
    *) MAIN_MENU "Enter a valid option"
  esac
}

BOOK_SERVICE() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  #get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  #check if empty
  if [[ -z $CUSTOMER_ID ]]
  then
    #ask for a name
    echo -e "\nLooks like it's your first time in out salon. What's your name?"
    read CUSTOMER_NAME
    #add to customers table
    CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi
  
  #get customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  #get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

  #get service time
  echo -e "\nAlright $CUSTOMER_NAME, when would you like to have your $SERVICE_NAME done?"
  read SERVICE_TIME

  #insert into appointments
  APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}

MAIN_MENU
