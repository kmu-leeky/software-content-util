#!/bin/bash

# http://www.linuxjournal.com/content/validating-ip-address-bash-script
function valid_ip() {
  local  ip=$1
  local  stat=1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
      stat=$?
  fi
  return $stat
}

domains=( $(sed -e 's|^[^/]*//||' -e 's|^www\.||' -e 's|/.*$||' $1 | uniq) )

for domain in "${domains[@]}"
do
  ips=( $(dig +short "$domain") )
  for ip in "${ips[@]}"
  do
    if valid_ip $ip; then
      echo $ip
    fi
  done
done 

