#!/bin/bash

# Prints details about an element located in periodic_table.sql
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEM_NAME=$($PSQL "SELECT name FROM elements WHERE elements.atomic_number=$1")
  else
    ELEM_NAME=$($PSQL "SELECT name FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number WHERE (name='$1') OR (symbol='$1')")
  fi

  if [[ -z $ELEM_NAME ]] 
  then
    echo "I could not find that element in the database."
  else
    EDITED_NAME=$(echo $ELEM_NAME | sed 's/ //g')

    ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$EDITED_NAME'")
    EDITED_NUM=$(echo $ATOMIC_NUM | sed 's/ //g')

    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$EDITED_NAME'")
    TYPE=$($PSQL "SELECT types.type FROM properties LEFT JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$EDITED_NUM")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$EDITED_NUM")
    MELT_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$EDITED_NUM")
    BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$EDITED_NUM")

    echo "The element with atomic number $EDITED_NUM is $EDITED_NAME ($(echo $SYMBOL | sed 's/ //g')). It's a $(echo $TYPE | sed 's/ //g'), with a mass of $(echo $MASS | sed 's/ //g') amu. $EDITED_NAME has a melting point of $(echo $MELT_POINT | sed 's/ //g') celsius and a boiling point of $(echo $BOIL_POINT | sed 's/ //g') celsius."
  fi
fi
