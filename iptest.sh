#!/bin/bash
#V2 script verificare ip
validate_ip() {
    local name=$1
    local ip=$2
    local dns_server=$3

    if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
        return
    fi

    nslookup "$name" "$dns_server" | while read -r line; do
        if echo "$line" | grep -q "Name:"; then
            read -r address_line
            read -r label good_ip <<< "$address_line"
            if [ "$ip" != "$good_ip" ]; then
                echo "Bogus IP for $name in /etc/hosts!"
            fi
            break
        fi
    done
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <dns_server>"
    exit 1
fi

dns_server=$1

while read -r ip host; do
    if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
        continue
    fi
    validate_ip "$host" "$ip" "$dns_server"
done < /etc/hosts


# vlad a fost aici
