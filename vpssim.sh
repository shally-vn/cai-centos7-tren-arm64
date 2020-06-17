#!/bin/sh
if [ $(id -u) != "0" ]; then
    echo "Error: You have to login by user root!"
    exit
fi
if [ -f /var/cpanel/cpanel.config ]; then
clear
echo "Your Server installed WHM/Cpanel, if you want to use  VPSSIM"
echo "Lets rebuild VPS, you should use centos 6 or 7 - 64 bit"
echo "Bye !"
exit
fi

if [ -f /etc/psa/.psa.shadow ]; then
clear
echo "Server installed Plesk, if you want to use VPSSIM"
echo "Lets rebuild VPS, you should use centos 6 or 7 - 64 bit"
echo "Bye !"
exit
fi

if [ -f /etc/init.d/directadmin ]; then
clear
echo "Your Server installed DirectAdmin, if you want to use VPSSIM"
echo "Lets rebuild VPS, you should use centos 6 or 7 - 64 bit"
echo "Bye !"
exit
fi

if [ -f /etc/init.d/webmin ]; then
clear
echo "Your Server installed webmin, if you want to use VPSSIM"
echo "Lets rebuild VPS, you should use centos 6 or 7 - 64 bit"
echo "Bye !"
exit
fi

if [ ! -f /home/vpssim.conf ]; then
#yum -y update
yum -y install epel-release
yum install -y centos-release-scl-rh
if [ -f /etc/yum.repos.d/epel.repo ]; then
sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
fi
#yum -y update
yum -y install psmisc bc gawk gcc wget unzip net-tools
yum -y -q install virt-what sudo zip iproute iproute2 curl deltarpm yum-utils tar nano
wget -q https://vpssim.com/script/vpssim/calc -O /bin/calc && chmod +x /bin/calc
if [ ! -f /bin/calc ]; then
curl -o /bin/calc https://vpssim.com/script/vpssim/calc
chmod +x /bin/calc
fi
if [ ! -d /etc/vpssim ]; then
mkdir -p /etc/vpssim
mkdir -p /etc/vpssim/.tmp
fi
rm -rf /root/vpssim*
rm -rf /etc/vpssim/.tmp/vpssim-setup*
fi

clear
echo "========================================================================="
echo "LUA CHON CAI DAT VPSSIM HOAC KIEM TRA VPS NAY."
echo "-------------------------------------------------------------------------"
echo "Voi chuc nang kiem tra VPS, VPSSIM se kiem tra: Dia diem dat VPS, thong " 
echo "-------------------------------------------------------------------------"
echo "tin cau hinh VPS (loai CPU, RAM ...), toc do o cung, SpeedTest..."
echo "-------------------------------------------------------------------------"
echo "Ban van co the su dung chuc nang check VPS sau khi da cai dat VPSSIM."
echo "========================================================================="
prompt="Nhap lua chon cua ban: "
options=( "Cai Dat VPSSIM Cho VPS Ngay Bay Gio" "Kiem Tra - Test VPS Nay")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachon="caidatvpssim"; break;;
    2) luachon="check"; break;;
    0) luachon="thoat"; break;;    
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
if [ "$luachon" = "caidatvpssim" ]; then
echo "========================================================================="
echo "OK, Please wait ...."; sleep 3
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://github" )
if [[ "$checkurlstt" == "200" ]]; then
curl -k https://github/vpssim-setup -o /etc/vpssim/.tmp/vpssim-setup
else
curl -k https://github/vpssim-setup -o /etc/vpssim/.tmp/vpssim-setup
fi
chmod +x /etc/vpssim/.tmp/vpssim-setup 
clear 
bash /etc/vpssim/.tmp/vpssim-setup
elif [ "$luachon" = "check" ]; then
echo "========================================================================="
echo "OK, Please wait ...."; sleep 3
wget -q https://vpssim.com/script/vpssim/checkvps.count -O /etc/vpssim/.tmp/axliasod
rm -rf /etc/vpssim/.tmp/axliasod
clear
curl -k https://vpssim.vn/script/vpssim/kiem-tra-test-vps -o testvps && sh testvps
else
clear
curl -k https://raw.githubusercontent.com/shally-vn/centos7/master/vpssim.sh -o vpssim && sh vpssim
fi