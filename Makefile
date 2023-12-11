produce:
	git pull
	curl -o delegated-apnic-latest https://ftp.apnic.net/stats/apnic/delegated-apnic-latest
	curl -o china_ip_list.txt https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt
	echo ${secret.PASS_IPS}
	python3 produce.py --next tun0 --exclude 154.19.186.112/32 103.232.213.128/32 162.159.58.188/32 103.15.90.0/24 2a12:f8c1:50:2::127/64 2400:38e0:1:405d::12c/64
	echo -n "route 13.107.21.0/24 via \"tun0\"; \nroute 202.89.233.0/24 via \"tun0\"; \nroute 204.79.197.0/24 via \"tun0\";"  >> routes4.conf
