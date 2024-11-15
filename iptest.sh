#!/bin/bash

#am presupus ca nu trebie verifiat localhost
counter=0
cat /etc/hosts | while read -r ip name _ && [[ -n "$name" && -n "$ip" ]] 
do
	((counter++))
	if [ $counter -le 2 ]
	then
		continue
	fi
	true_ip=$(nslookup "$name" 2>/dev/null | grep -m 1 -oP '(?<=Address: ).*')
        
        if [ "$true_ip" != "$ip" ]; then
            echo "Bogus IP for $name in /etc/hosts!"
        else
            echo "$ip is the IP for $name"
	fi
done
