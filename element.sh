#!/bin/bash


PSQL="psql -x --username=freecodecamp --dbname=periodic_table --tuples-only -c"


# if no argument:
if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
  
  else 
    
    # if it is not a number 
    if [[ ! $1 =~ ^[0-9]+$ ]]
      then
      # search element by name or symbol
      GET_ELEMENT_SELECTED=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.symbol ILIKE '$1' OR elements.name ILIKE '$1'")
      
      # if it is a number
      else
        #search element by atomic_number
        GET_ELEMENT_SELECTED=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number=$1")
    fi

    # if element is not found
    if [[ -z $GET_ELEMENT_SELECTED ]]
      then
        echo I could not find that element in the database.
      
      # if element is found
      else
        # output result with element information
        echo $GET_ELEMENT_SELECTED | while read COL BAR ATOMIC_NUMBER COL BAR NAME COL BAR SYMBOL COL BAR TYPE COL BAR ATOMIC_MASS COL BAR MELTING_POINT COL BAR BOILING_POINT
        do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          done

    fi
    

fi
