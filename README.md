# Лабораторная работа 2

*Илья Востров Анатольевич, ITMO ID 465456,  группа К3139*

## Ход работы

**1. Сначала я указал интерпретатор, который должен быть использован для запуска скрипта.**
```bash
    #!/bin/bash 
```

**2. Далее определил функцию `decimal_to_binary`, которая принимает десятичное число в качестве аргумента и возвращает его двоичное представление.**
```bash
    decimal_to_binary() {
    decimal=$1
    binary=""
    while (( decimal > 0 )); do
        binary=$(($decimal % 2))$binary
        decimal=$((decimal / 2))
    done
    
    echo $binary | awk '{printf "%08d\n", $1}'
    }

```
- **`decimal=$1`** - присваивает значение первого аргумента функции (`$1`) локальной переменной  
- **`binary=""`** - инициализирует локальную переменную `binary` пустой строкой.
- **`while (( decimal > 0 )); do ... done`** -  цикл, который выполняется до тех пор, пока `decimal` больше 0.
-  **`binary=$(($decimal % 2))$binary`** - вычисляет остаток от деления `decimal` на 2 (оператор `%`) и добавляет его в начало строки `binary`.
- **`decimal=$((decimal / 2))`** -  делит `decimal` на 2 (оператор `/`) и сохраняет результат в переменной `decimal`.
- **`echo $binary | awk '{printf "%08d\n", $1}'`** -  выводит строку `binary` в поток `awk` для форматирования. 
- **`awk '{printf "%08d\n", $1}'`** -  команда `awk` добавляет ведущие нули к строке `binary`, чтобы получить 8-битный вывод.

**3. Потом предлагаю пользователю ввести IPv4 адрес и сохраняю его в переменную `ip_address`.**
```bash
    read -p "Введите IPv4 адрес: " ip_address 
```
**4. С помощью условного оператора `if` проверяю соотвествие `ip_address` регулярному выражению, определяющему формат IPv4 адреса. Если условие выполняется, то идет перевод каждого октета в двоичный код и ввыодит на экран результат. Если условие не выполняется, то выводится сообщение об ошибке и завершается скрипт с кодом ошибки 1.** 
```bash
    if [[$ip_address =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$]]; then
    
    IFS='.' read -ra octets <<< "$ip_address"
    ip=""
    
    for octet in "${octets[@]}"; do
        binary_octet=$(decimal_to_binary $octet)
        ip="${ip}.$binary_octet"
    done
    echo ${ip:1}
    else
    echo "Неверный IPv4 адрес."
    exit 1
    fi
```
- **`$ip_address =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ `** - это регулярное выражение, которое проверяет, является ли строка `$ip_address `действительным IPv4 адресом. 
- **`IFS='.' read -ra octets <<< "$ip_address"`** - Разделяет `ip_address` на отдельные октеты, используя `IFS` (Internal Field Separator) и сохраняет их в массиве `octets`.
- **`ip=""`** - Инициализирует переменную `ip` пустой строкой, в которую будет записываться двоичный код IPv4 адреса.
- **`for octet in "${octets[@]}"; do ... done`** - Цикл `for`, который перебирает каждый элемент массива `octets`.
- **`binary_octet=$(decimal_to_binary $octet)`** -  вызывает функцию `decimal_to_binary` для преобразования текущего октета в двоичный код.
- **`ip="${ip}.$binary_octet"`** -  добавляет двоичный код текущего октета к строке `ip`, отделяя его точкой.
-  **`echo ${ip:1}`** - Выводит на экран строку `ip`, удаляя начальную точку (с помощью `${ip:1}`). 
- **`echo "Неверный IPv4 адрес."`** -  выводит сообщение об ошибке.
- **`exit 1`** -  завершает скрипт с кодом ошибки 1. 

### Итоговый код файла bash.script
```bash
    #!/bin/bash
    decimal_to_binary() {
    decimal=$1
    binary=""
    while (( decimal > 0 )); do
        binary=$(($decimal % 2))$binary
        decimal=$((decimal / 2))
    done
    
    echo $binary | awk '{printf "%08d\n", $1}'
    }
    read -p "Введите IPv4 адрес: " ip_address
    if [[$ip_address =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$]]; then
    
    IFS='.' read -ra octets <<< "$ip_address"
    ip=""
    
    for octet in "${octets[@]}"; do
        binary_octet=$(decimal_to_binary $octet)
        ip="${ip}.$binary_octet"
    done
    echo ${ip:1}
    else
    echo "Неверный IPv4 адрес."
    exit 1
    fi
```

## Скриншот работы скрипта

![image](https://github.com/WillowRussia/ITMO-INFO-LAB2/blob/main/Assets/lab2image.png?raw=true)

![image](https://github.com/WillowRussia/ITMO-INFO-LAB2/blob/main/Assets/lab2image2.png?raw=true)
