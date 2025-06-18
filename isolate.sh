# installing dependancies

sudo pacman -S iptables


# isolating network

sudo iptables -F                                                                                                                                                                       ─╯
sudo iptables -X

sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

sudo iptables -P OUTPUT ACCEPT

sudo iptables -A OUTPUT -d 192.168.68.1 -j ACCEPT
sudo iptables -A OUTPUT -d 10.0.0.0/8 -j DROP
sudo iptables -A OUTPUT -d 172.16.0.0/12 -j DROP
sudo iptables -A OUTPUT -d 192.168.0.0/16 -j DROP
sudo iptables -A OUTPUT -d 224.0.0.0/4 -j DROP
sudo iptables -A OUTPUT -d 255.255.255.255 -j DROP

sudo iptables-save > /etc/iptables/iptables.rules
sudo systemctl enable iptables.service
sudo systemctl start iptables.service
