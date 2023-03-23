#!/bin/bash
if [[ $1 -eq 1 ]]
then 
  echo "Nedorezov Aleksandr Sergeevich"
elif [[ $1 -eq 2 ]]
then
  date
else
  echo "ERROR: unknown params"
fi