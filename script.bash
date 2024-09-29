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

if [[ $ip_address =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  
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

