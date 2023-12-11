produce:
	git pull
	curl -o delegated-apnic-latest https://ftp.apnic.net/stats/apnic/delegated-apnic-latest
	curl -o china_ip_list.txt https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt
	python3 produce.py --next tun0 --exclude ${PASS_IPS}
	echo -n "route 13.107.21.0/24 via \"tun0\"; \nroute 202.89.233.0/24 via \"tun0\"; \nroute 204.79.197.0/24 via \"tun0\";"  >> /etc/bird/routes4.conf
