# только python 3.10+
import sys
import os
import re
from datetime import datetime

def check(args):
    match args[1]:
        case '1': # Если 1
            # Выводим в консоль ФИО
            print('Nedorezov Aleksandr Sergeevich')
        case '2': # Если 2
            # Выводим в консоль текущую дату
            print(datetime.now())
        case '-ping': # Если -ping
            # Делаем пинг по заданному адресу
            result=os.popen("ping -c 1 " + args[2]).read()
            result=re.findall(r"time=(.*) ms", result)
            print(result[0])
        case '-simple_print': # Если simple_print
            # Выводим в консоль содержимое sys.arvg[2]
            print(args[2])
        case _: # Во всех остальных случаях
            # Выводим непонятый запрос в консоль.
            print(f"unknown input: {args[1]}")

check(sys.argv)