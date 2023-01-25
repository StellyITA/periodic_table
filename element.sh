#!/bin/bash

PSQL="psql -U freecodecamp -d periodic_table -t -c"

GET_MESSAGE () {
  ELEMS=$($PSQL "SELECT properties.atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements RIGHT JOIN properties ON elements.atomic_number = properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id;") 
  echo $ELEMS | sed -E "s/([0-9]+ \| [a-z]+ \| [a-z]+ \| [a-z]+ \| [0-9]+\.?[0-9]+? \| -?[0-9]+\.?[0-9]+? \| -?[0-9]+\.?[0-9]+?)/\1\n/gi" | while read AN BAR NAME BAR SYM BAR TYPE BAR AM BAR MPC BAR BPC
  do
    if [[ $1 -eq $AN ]] || [[ $1 == $SYM ]] || [[ $1 == $NAME ]]
    then
      echo "The element with atomic number $AN is $NAME ($SYM). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius." | sed "s/The element with atomic number  is  (). It's a , with a mass of  amu.  has a melting point of  celsius and a boiling point of  celsius./I could not find that element in the database./"
      break
    fi
  done
}

if [[ -z $1 ]]
then
 echo Please provide an element as an argument.
else
 GET_MESSAGE $1
fi
