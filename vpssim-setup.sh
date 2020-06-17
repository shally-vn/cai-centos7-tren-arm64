#!/bin/bash
###################################################################################################
#
#############             VPSSIM - VPS SIMPLE by vpssim.vn & VPSSIM.COM             ############
#
###################################################################################################
ranus=`date |md5sum |cut -c '1-3'`
checktruenumber='^[0-9]+$'
moduledir=/usr/local/vpssim
opensslversion=openssl-1.0.2o
zlibversion=zlib-1.2.11
kiemtraemail3="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~])+\.)*[-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,24}$";
svip=$(wget http://ipecho.net/plain -O - -q ; echo)
###################################################################################################
###################################################################################################

if [ -f /home/vpssim.conf ]; then
clear
echo "========================================================================="
echo "========================================================================="
echo "Your Server is installed VPSSIM"
echo "-------------------------------------------------------------------------"
echo "Use command [ vpssim ] to access VPSSIM menu"
echo "-------------------------------------------------------------------------"
echo "Bye !"
echo "========================================================================="
echo "========================================================================="
rm -rf install*
exit
fi

echo "=========================================================================="
echo "Mac dinh server se duoc cai dat PHP 7.1. Thay doi phien ban PHP bang chuc"
echo "--------------------------------------------------------------------------"
echo "nang [Change PHP Version] trong [Update System (Nginx,PHP...)] cua VPSSIM.  "
echo "--------------------------------------------------------------------------"
echo "PHP versions support: 7.3, 7.2, 7.1, 7.0, 5.6, 5.5 & 5.4"
echo "--------------------------------------------------------------------------"
echo "MariaDB versions support: 10.3, 10.2, 10.1 & 10.0"
cpuname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
cpufreq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
svram=$( free -m | awk 'NR==2 {print $2}' )
svhdd=$( df -h | awk 'NR==2 {print $2}' )
svswap=$( free -m | awk 'NR==3 {print $2}' )
echo "=========================================================================="
echo "Thong Tin Server:  "
echo "--------------------------------------------------------------------------"
echo "Server Type: $(virt-what | awk 'NR==1 {print $NF}')"
echo "CPU Type: $cpuname"
echo "CPU Core: $cpucores"
echo "CPU Speed: $cpufreq MHz"
echo "Memory: $svram MB"
echo "Disk: $svhdd"
echo "IP: $svip"
echo "=========================================================================="
echo "Dien Thong Tin Cai Dat: "
echo "--------------------------------------------------------------------------"
echo -n "Nhap PhpMyAdmin Port [ENTER]: " 
read svport
if [ "$svport" = "443" ] || [ "$svport" = "3306" ] || [ "$svport" = "465" ] || [ "$svport" = "587" ]; then
	svport="2313"
echo "Phpmyadmin khong the trung voi port cua dich vu khac !"
echo "--------------------------------------------------------------------------"
echo "VPSSIM se dat phpmyadmin port la 2313"
fi
if [ "$svport" = "" ] ; then
clear
echo "=========================================================================="
echo "$svport khong duoc de trong."
echo "--------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !" 
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi
if ! [[ $svport -ge 100 && $svport -le 65535  ]] ; then  
clear
echo "=========================================================================="
echo "$svport khong hop le!"
echo "--------------------------------------------------------------------------"
echo "Port hop le la so tu nhien nam trong khoang (100 - 65535)."
echo "--------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !" 
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi 
echo "--------------------------------------------------------------------------"
echo -n "Nhap dia chi email quan ly [ENTER]: " 
read vpssimemail
if [ "$vpssimemail" = "" ]; then
clear
echo "=========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi

if [[ ! "$vpssimemail" =~ $kiemtraemail3 ]]; then
clear
echo "=========================================================================="
echo "$vpssimemail co le khong dung dinh dang email!"
echo "--------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi
echo "-------------------------------------------------------------------------"
echo "Mat khau bao ve phpMyAdmin toi thieu 8 ki tu va chi dung chu cai va so."
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau bao ve phpMyAdmin [ENTER]: " 
read matkhaubv
if [[ ! ${#matkhaubv} -ge 8 ]]; then
clear
echo "========================================================================="
echo "Mat khau bao ve phpMyAdmin toi thieu phai co 8 ki tu."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi  

checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhaubv" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi   
echo "-------------------------------------------------------------------------"
echo "Mat khau root MySQL toi thieu 8 ki tu va chi su dung chu cai va so."
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau root MySQL [ENTER]: " 
read passrootmysql
if [[ ! ${#passrootmysql} -ge 8 ]]; then
clear
echo "========================================================================="
echo "Mat khau tai khoan root MySQL toi thieu phai co 8 ki tu."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi  

checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$passrootmysql" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau MySQL !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /etc/vpssim/.tmp/vpssim-setup
exit
fi  

prompt="Nhap lua chon cua ban: "
options=( "MariaDB 10.3 " "MariaDB 10.2 " "MariaDB 10.1" "MariaDB 10.0")
echo "=========================================================================="
echo "Lua Chon Cai Dat Phien Ban MariaDB  "
echo "=========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) mariadbversion="10.3"; break;;
    2) mariadbversion="10.2"; break;;
    3) mariadbversion="10.1"; break;;
    4) mariadbversion="10.0"; break;;
            
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
if [ "$mariadbversion" = "10.0" ]; then
phienbanmariadb=10.0
elif [ "$mariadbversion" = "10.1" ]; then
phienbanmariadb=10.1
elif [ "$mariadbversion" = "10.2" ]; then
phienbanmariadb=10.2
else
phienbanmariadb=10.3
fi
arch=`uname -m`
if [ "$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)" == "6" ]; then 
centosver=6
else
centosver=7
fi
if [ "$arch" = "x86_64" ]; then
XXX=amd64
else
XXX=x86
fi
# Download vpssim_main_menu + Chmod
cd /etc/vpssim
download_vpssim_data () {
rm -rf menu.zip
wget --progress=dot https://vpssim.vn/script/vpssim/menu.zip 2>&1 | grep --line-buffered "%"
unzip -q menu.zip
rm -rf menu.zip
}
download_vpssim_data
if [ ! -f /etc/vpssim/menu/inc/check-download-menu ]; then
download_vpssim_data
fi
cd
find /etc/vpssim/menu/inc -type f -exec chmod 755 {} \;
/etc/vpssim/menu/inc/vpssim-cai-dat-glibc-khong-duoc-ma-hoa  # Setup GLIBC 2.17 (Centos 6) or GLIBC 2.22 (centos 7)
/etc/vpssim/menu/inc/set-permison-vpssim-menu
/etc/vpssim/menu/inc/download-vpssim-main-menu
###############################################################################
#Download Nginx, VPSSIM & phpMyadmin Version
/etc/vpssim/menu/inc/vpssim-download-nginx-version-phpmyadmin-version-vpssim-version
###############################################################################
phpmyadmin_version=`cat /etc/vpssim/.tmp/version.vpssim | awk '{print $1}'`
Nginx_VERSION=`cat /etc/vpssim/.tmp/version.vpssim | awk '{print $2}'`
vpssim_version=`cat /etc/vpssim/.tmp/version.vpssim | awk '{print $3}'`
###############################################################################

# End Download Nginx, VPSSIM & phpMyadmin Version
###############################################################################

clear
prompt="Nhap lua chon cua ban: "
options=("Nginx Mainline Version" "Nginx Stable Version")
echo "=========================================================================="
echo "LUA CHON CAI DAT PHIEN BAN NGINX STABLE HOAC MAINLINE: "
echo "=========================================================================="
echo "STABLE: VPSSIM cai dat Nginx tu Nginx Repo."
echo "--------------------------------------------------------------------------"
echo "Day la phien ban stable. Qua trinh cai dat cho server se nhanh hon."
echo "--------------------------------------------------------------------------"
echo "Sau khi cai dat, ban khong the thay doi phien ban Nginx tuy chon. "
echo "--------------------------------------------------------------------------"
echo "Ban co the update Nginx cung voi he thong centos."
echo "=========================================================================="
echo "=========================================================================="
echo "MAINLINE: VPSSIM cai dat Nginx tu source."
echo "--------------------------------------------------------------------------"
echo "Day la phien ban moi nhat cua Nginx, download tu Nginx.org. "
echo "--------------------------------------------------------------------------"
echo "Qua trinh cai dat se lau hon, sau khi cai dat ban co the thay do phien ban"
echo "--------------------------------------------------------------------------"
echo "Nginx va update Nginx tu source."
echo "=========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 
    case "$REPLY" in
    1) chonnginx="0"; break;;
    2) chonnginx="1"; break;;          
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
if [ "$chonnginx" = "1" ]; then
nginxrepo=1
echo "=========================================================================="
echo "=========================================================================="
echo "Nginx se duoc cai dat tu Nginx repo"; sleep 4
else
nginxrepo=0
clear
echo "=========================================================================="
echo "Nginx se duoc cai dat tu source"; sleep 2
echo "Neu qua trinh cai dat that bai hoac gap loi "; sleep 4
echo "VPSSIM se tu dong chuyen sang cai dat Nginx stable version tu Nginx Repo"; sleep 5
fi

clear

echo "=========================================================================="
echo "VPSSIM Se Cai Dat Server Theo Thong Tin:"
echo "=========================================================================="
echo "eMail Quan Ly: $vpssimemail"
echo "--------------------------------------------------------------------------"
echo "phpMyAdmin Port: $svport"
echo "--------------------------------------------------------------------------"
echo "phpMyAdmin Version: $phpmyadmin_version"
echo "--------------------------------------------------------------------------"
echo "Mat khau bao ve phpMyadmin: $matkhaubv"
echo "--------------------------------------------------------------------------"
echo "MariaDB Version: $phienbanmariadb"
echo "--------------------------------------------------------------------------"
echo "Mat khau tai khoan root MySQL: $passrootmysql"
echo "--------------------------------------------------------------------------"
if [ "$nginxrepo" != "1" ]; then
echo "Nginx Version: $Nginx_VERSION"
else
echo "Nginx Version: Stable Version"
fi
echo "--------------------------------------------------------------------------"
echo "PHP Version: 7.1"
echo "--------------------------------------------------------------------------"
echo "VPSSIM Version: $vpssim_version"
echo "=========================================================================="
prompt="Nhap lua chon cua ban: "
options=( "Dong Y" "Khong Dong Y")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) xacnhanthongtin="dongy"; break;;
    2) xacnhanthongtin="khongdongy"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done

if [ "$xacnhanthongtin" = "dongy" ]; then
echo "--------------------------------------------------------------------------"
echo "Chuan Bi Cai Dat VPSSIM ..."
sleep 2
else 
clear
rm -rf /root/install && bash /etc/vpssim/.tmp/vpssim-setup
exit
fi
cat >> "/root/.bash_profile" <<END
IPvpssimcheck="\$(echo \$SSH_CONNECTION | cut -d " " -f 1)"
timeloginvpssimcheck=\$(date +"%e %b %Y, %a %r")
echo 'Someone has IP address '\$IPvpssimcheck' login to $svip on '\$timeloginvpssimcheck'.' | mail -s 'eMail Notifications From VPSSIM On $svip' ${vpssimemail}
END
echo "$svport" > /etc/vpssim/.tmp/priport.txt
cat > "/etc/yum.repos.d/mariadb.repo" <<END
# MariaDB $phienbanmariadb CentOS repository list
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/$phienbanmariadb/centos${centosver}-$XXX
gpgkey=http://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
END

# Disable And remove unnessery service
/etc/vpssim/menu/inc/disable-remove-service-vpssim-setup
# Check & install remi repo
/etc/vpssim/menu/inc/vpssim-check-and-install-remi-repo

mkdir -p /usr/local/vpssim
groupadd nginx
useradd -g nginx -d /dev/null -s /sbin/nologin nginx
sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ pcre pcre-devel sshpass zlib zlib-devel tar exim mailx autoconf bind-utils GeoIP GeoIP-devel ca-certificates perl socat perl-devel perl-ExtUtils-Embed make automake perl-libwww-perl tree virt-what openssl-devel openssl which libxml2-devel libxml2 libxslt libxslt-devel gd gd-devel iptables* openldap openldap-devel curl curl-devel diffutils pkgconfig sudo lsof pkgconfig libatomic_ops-devel gperftools gperftools-devel 
sudo yum -y install unzip zip rsync psmisc syslog-ng-libdbi syslog-ng cronie cronie-anacron

### Cai dat Nginx ##############################################################

if [ "$nginxrepo" != "1" ];then

echo "=========================================================================="
echo "Download Nginx Module ... "
echo "=========================================================================="
sleep 3
cd /usr/local/vpssim
# /usr/local/vpssim/echo-nginx-module
rm -rf echo-nginx-module*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/echo-nginx-module.zip 2>&1 | grep --line-buffered "%"
unzip -oq echo-nginx-module.zip
rm -rf echo-nginx-module.zip
# /usr/local/vpssim/ngx_http_substitutions_filter_module
rm -rf ngx_http_substitutions_filter_module*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/ngx_http_substitutions_filter_module.zip 2>&1 | grep --line-buffered "%"
unzip -oq ngx_http_substitutions_filter_module.zip
rm -rf ngx_http_substitutions_filter_module.zip
# /usr/local/vpssim/ngx_cache_purge-master
rm -rf ngx_cache_purge*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/ngx_cache_purge.zip 2>&1 | grep --line-buffered "%"
unzip -oq ngx_cache_purge.zip
rm -rf ngx_cache_purge.zip
# /usr/local/vpssim/headers-more-nginx-module
rm -rf headers-more-nginx-module*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/headers-more-nginx-module.zip 2>&1 | grep --line-buffered "%"
unzip -oq headers-more-nginx-module.zip
rm -rf headers-more-nginx-module.zip
# /usr/local/vpssim/openssl-1.0.2o
rm -rf ${opensslversion}
wget -q https://vpssim.com/script/vpssim/module-nginx/${opensslversion}.tar.gz 2>&1 | grep --line-buffered "%"
tar -xzxf ${opensslversion}.tar.gz
rm -rf ${opensslversion}.tar.gz
# $moduledir/${zlibversion}
rm -rf ${zlibversion}
wget -q https://vpssim.com/script/vpssim/module-nginx/${zlibversion}.tar.gz 2>&1 | grep --line-buffered "%"
tar -xzxf ${zlibversion}.tar.gz
rm -rf ${zlibversion}.tar.gz
# /usr/local/vpssim/pcre-8.41
rm -rf pcre-8.41
wget -q https://vpssim.com/script/vpssim/module-nginx/pcre-8.41.zip 2>&1 | grep --line-buffered "%"
unzip -oq pcre-8.41.zip
rm -rf pcre-8.41.zip
# /usr/local/vpssim/ngx_http_redis-0.3.8
rm -rf ngx_http_redis-0.3.8
wget -q https://vpssim.com/script/vpssim/module-nginx/ngx_http_redis-0.3.8.tar.gz 2>&1 | grep --line-buffered "%"
tar -xzxf ngx_http_redis-0.3.8.tar.gz
rm -rf ngx_http_redis-0.3.8.tar.gz
# /usr/local/vpssim/redis2-nginx-module
rm -rf redis2-nginx-module*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/redis2-nginx-module.zip 2>&1 | grep --line-buffered "%"
unzip -oq redis2-nginx-module.zip
rm -rf redis2-nginx-module.zip
# /usr/local/vpssim/set-misc-nginx-module
rm -rf set-misc-nginx-module*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/set-misc-nginx-module.zip 2>&1 | grep --line-buffered "%"
unzip -oq set-misc-nginx-module.zip
rm -rf set-misc-nginx-module.zip
# /usr/local/vpssim/ngx_devel_kit
rm -rf ngx_devel_kit*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/ngx_devel_kit.zip 2>&1 | grep --line-buffered "%"
unzip -oq ngx_devel_kit.zip
rm -rf ngx_devel_kit.zip
# /usr/local/vpssim/ngx_http_concat
rm -rf ngx_http_concat
wget -q https://vpssim.com/script/vpssim/module-nginx/ngx_http_concat.tar.gz 2>&1 | grep --line-buffered "%"
tar -xzxf ngx_http_concat.tar.gz
rm -rf ngx_http_concat.tar.gz
# /usr/local/vpssim/srcache-nginx-module
rm -rf srcache-nginx-module*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/srcache-nginx-module.zip 2>&1 | grep --line-buffered "%"
unzip -oq srcache-nginx-module.zip
rm -rf srcache-nginx-module.zip
# /usr/local/vpssim/memc-nginx-module
rm -rf memc-nginx-module*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/memc-nginx-module.zip 2>&1 | grep --line-buffered "%"
unzip -oq memc-nginx-module.zip
rm -rf memc-nginx-module.zip
# /usr/local/vpssim/libatomic_ops-master
rm -rf libatomic_ops*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/libatomic_ops.zip 2>&1 | grep --line-buffered "%"
unzip -oq libatomic_ops.zip
rm -rf libatomic_ops.zip
# /usr/local/vpssim/ngx-fancyindex-master
rm -rf ngx-fancyindex*
wget --progress=dot https://vpssim.com/script/vpssim/module-nginx/ngx-fancyindex.zip 2>&1 | grep --line-buffered "%"
unzip -oq ngx-fancyindex.zip
rm -rf ngx-fancyindex.zip
cd
cd /usr/local/vpssim
#cai dat  nginx
wget --progress=dot http://nginx.org/download/nginx-${Nginx_VERSION}.tar.gz 2>&1 | grep --line-buffered "%"
tar -xzf nginx-${Nginx_VERSION}.tar.gz
rm -rf /usr/local/vpssim/nginx-${Nginx_VERSION}.tar.gz 
cd /usr/local/vpssim/nginx-${Nginx_VERSION}
./configure --group=nginx --user=nginx \
--pid-path=/var/run/nginx.pid \
--prefix=/usr/share/nginx \
--sbin-path=/usr/sbin/nginx \
--with-http_v2_module \
--with-http_ssl_module \
--with-ipv6 \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_xslt_module=dynamic \
--with-http_addition_module \
--with-http_dav_module \
--with-http_geoip_module=dynamic \
--with-http_image_filter_module=dynamic \
--with-http_perl_module=dynamic \
--with-ld-opt="-Wl,-E" \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-file-aio \
--with-pcre-jit \
--with-google_perftools_module \
--with-debug \
--with-openssl-opt="enable-tlsext" \
--conf-path=/etc/nginx/nginx.conf \
--with-http_gzip_static_module \
--with-threads \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module=dynamic \
--with-stream_ssl_preread_module \
--with-http_realip_module \
--with-compat \
--http-log-path=/var/log/nginx/access.log \
--with-zlib=$moduledir/${zlibversion} \
--with-openssl=$moduledir/${opensslversion} \
--with-pcre=$moduledir/pcre-8.41 \
--add-dynamic-module=$moduledir/ngx_devel_kit-master \
--add-dynamic-module=$moduledir/echo-nginx-module-master \
--add-dynamic-module=$moduledir/memc-nginx-module-master \
--add-dynamic-module=$moduledir/set-misc-nginx-module-master \
--add-dynamic-module=$moduledir/srcache-nginx-module-master \
--add-module=$moduledir/ngx_http_concat \
--add-dynamic-module=$moduledir/ngx_http_substitutions_filter_module-master \
--add-dynamic-module=$moduledir/ngx_cache_purge-master \
--add-dynamic-module=$moduledir/headers-more-nginx-module-master \
--add-dynamic-module=$moduledir/redis2-nginx-module-master \
--add-dynamic-module=$moduledir/ngx_http_redis-0.3.8 \
--add-dynamic-module=$moduledir/ngx-fancyindex-master
make
make install

else
if [ "$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)" == "6" ]; then 
centosver=6
else
centosver=7
fi
cat > "/etc/yum.repos.d/nginx.repo" <<END
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$centosver/\$basearch/
gpgcheck=0
enabled=1
END
yum -y update
yum -y install nginx
yum -y install nginx-module-geoip
fi

######### Het cai dat Nginx ##############################################
if [ ! -d /etc/nginx ]; then
mkdir -p /etc/nginx
fi
#########################################################################
# Download init & config file for nginx
rm -f /etc/init.d/nginx
rm -rf /etc/nginx/nginx.conf
if [ "$nginxrepo" != "1" ];then
cp -r /etc/vpssim/menu/inc/nginx.init/nginx /etc/init.d/nginx
cp -r /etc/vpssim/menu/inc/nginx.init/nginx.conf /etc/nginx/nginx.conf
else
cp -r /etc/vpssim/menu/inc/nginxFrepo/nginx /etc/init.d/nginx
cp -r /etc/vpssim/menu/inc/nginxFrepo/nginx.conf /etc/nginx/nginx.conf
fi
chmod +x /etc/init.d/nginx
chmod +x /usr/sbin/nginx
#########################################################################
## Dem luot cai dat VPSSIM neu cai dat thanh cong - VPSSIM setup count: 
/etc/vpssim/menu/inc/vpssim-dem-luot-cai-dat-setup-count
#########################################################################
# Download /etc/nginx/conf
cp -avr /etc/vpssim/menu/inc/conf/ /etc/nginx
#unzip /etc/vpssim/menu/inc/conf.zip -d /etc/nginx/
find /etc/nginx/conf -type f -exec chmod 644 {} \;
# End Download init & config file for nginx
############################
yum -y install MariaDB-server MariaDB-client
yum-config-manager --enable remi-php71
yum -y install php php-common php-fpm php-gd php-devel php-json
yum -y install php-curl php-pecl-zip php-zip php-soap php-cli php-ldap php-mysqlnd php-pear-Net-SMTP php-enchant php-mysql php-pear php-opcache php-pdo php-zlib php-xml php-mbstring php-mcrypt
########### Check qua trinh cai dat Nginx ######################################
if [ "$nginxrepo" != "1" ];then
/etc/vpssim/menu/inc/vpssim-setup-nginx-from-repo
fi
################################################################################
echo "=========================================================================="
echo "Cai Dat Hoan Tat, Bat Dau Qua Trinh Cau Hinh...... "
echo "=========================================================================="
sleep 3
	ramformariadb=$(calc $svram/10*6)
	ramforphpnginx=$(calc $svram-$ramformariadb)
	max_children=$(calc $ramforphpnginx/30)
	memory_limit=$(calc $ramforphpnginx/5*3)M
	mem_apc=$(calc $ramforphpnginx/5)M
	buff_size=$(calc $ramformariadb/10*8)M
	log_size=$(calc $ramformariadb/10*2)M
	

systemctl enable  syslog-ng.service
systemctl enable php-fpm.service 
systemctl start php-fpm.service
systemctl enable mysql.service
systemctl enable nginx.service 

mkdir -p /home/vpssim.demo/public_html
mkdir /home/vpssim.demo/private_html
mkdir /home/vpssim.demo/logs
chmod -R 777 /home/vpssim.demo/logs
cp -r /etc/vpssim/menu/inc/index/index.zip /home/vpssim.demo/public_html/index.html
#chmodlog
mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx
mkdir -p /var/lib/php/session
chown -R nginx:nginx /var/lib/php/session
chown -R exim:exim /var/spool/exim /var/log/exim

#Vhost for vpssim.demo
rm -rf /etc/nginx/conf.d
mkdir -p /etc/nginx/conf.d
cp -r /etc/vpssim/menu/inc/vhost-sample/vpssim.demo.conf /etc/nginx/conf.d/vpssim.demo.conf
sed -i "s/portbimat/$svport/g" /etc/nginx/conf.d/vpssim.demo.conf

#Config www.conf & php.ini
/etc/vpssim/menu/inc/config-php.ini-www.conf-belong-ram

if [ ! -d /home/0-VPSSIM-SHORTCUT ];then
mkdir -p /home/0-VPSSIM-SHORTCUT
mkdir -p /home/vpssim.demo/private_html/backup
ln -s /home/vpssim.demo/private_html/backup /home/0-VPSSIM-SHORTCUT/Backup\ \(Website\ +\ Database\)
ln -s /etc/nginx/conf.d /home/0-VPSSIM-SHORTCUT/Vhost\ \(Vitual\ Host\)
echo "This is shortcut to Backup ( Code & Database ) and Vitual Host in VPS" > /home/0-VPSSIM-SHORTCUT/readme.txt
echo "Please do not delete it" >>  /home/0-VPSSIM-SHORTCUT/readme.txt
fi
#Cau Hinh opcache.ini, sysctl.conf, php-fpm.conf, limits.conf
if [ "$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)" == "6" ]; then 
ver=6
else
ver=7
fi
/etc/vpssim/menu/inc/config-opcache.ini-sysctl.conf-php-fpm.conf-limits.conf-belong-ram-cpu-centos$ver
##################################################################
if [ ! "$(grep LANG=en_US.utf-8 /etc/environment)" == "LANG=en_US.utf-8" ]; then
cat > "/etc/environment" <<END
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
END
fi
rm -f /home/vpssim.conf
    cat > "/home/vpssim.conf" <<END
mainsite="vpssim.demo"
priport="$svport"
serverip="$svip"
mariadbpass="$passrootmysql"
emailmanage="$vpssimemail"
END
# Config server.cnf
/etc/vpssim/menu/inc/config-server.cnf-belong-ram
/etc/vpssim/menu/inc/set-mysql-chown-log
# Start MySQL
rm -rf /var/lib/mysql/ibdata1
rm -rf /var/lib/mysql/ib_logfile*
service mysql start
#echo "=========================================================================="
#echo "Dat Mat Khau Cho Tai Khoan root Cua MYSQL ... "
#echo "=========================================================================="
/etc/vpssim/menu/inc/mysql-secure-installation
#clear
##echo "=========================================================================="
#echo "Cai dat phpMyAdmin... "
#echo "=========================================================================="
/etc/vpssim/menu/inc/phpmyadmin-download
###
## Edit motd
rm -rf /etc/motd
motdxxx=$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)
wget -q https://vpssim.vn/script/vpssim/motd$motdxxx -O /etc/motd
#Setup Acme.sh
wget -O -  https://get.acme.sh | sh
/root/.acme.sh/acme.sh --uninstallcronjob
###################################################
# Dat mat khau bao ve phpmyadmin, backup files
clear
echo "=========================================================================="
echo "Tao Username & Password bao ve phpMyadmin, backup files  ... "
echo "=========================================================================="
sleep 3
cp -r /etc/vpssim/menu/inc/htpasswd.py /usr/local/bin/htpasswd.py
if [ ! -f /usr/local/bin/htpasswd.py ]; then
cp -r /etc/vpssim/menu/inc/htpasswd.py /usr/local/bin/htpasswd.py
fi
chmod +x /usr/local/bin/htpasswd.py
rm -rf /etc/nginx/.htpasswd
usernamebv=`echo "${vpssimemail};" | sed 's/\([^@]*\)@\([^;.]*\)\.[^;]*;[ ]*/\1 \2\n/g' | awk 'NR==1 {print $1}'`
#if [[ ${#usernamebv} -lt 5 ]]; then
#usernamebv=vpssim$ranus
#fi
htpasswd.py -c -b /etc/nginx/.htpasswd $usernamebv $matkhaubv
if [ ! -f /etc/nginx/.htpasswd ]; then
/etc/vpssim/menu/inc/htpasswd.py -c -b /etc/nginx/.htpasswd $usernamebv $matkhaubv
fi
if [ ! -f /etc/nginx/.htpasswd ]; then
htpasswd -b -c /etc/nginx/.htpasswd $usernamebv $matkhaubv
fi
chmod -R 644 /etc/nginx/.htpasswd
cat > "/etc/vpssim/pwprotect.default" <<END
userdefault="$usernamebv"
passdefault="$matkhaubv"
END
rm -rf /etc/vpssim/defaulpassword.php
cat > "/etc/vpssim/defaulpassword.php" <<END
<?php
define('ADMIN_USERNAME','$usernamebv');   // Admin Username
define('ADMIN_PASSWORD','$matkhaubv');    // Admin Password
?>
END
###################################################
#SVM SVUPLOAD Install
/etc/vpssim/menu/inc/vpssim-svm-vsupload-config
###################################################
## Download GEOIP
mv /usr/share/GeoIP/GeoIP.dat /usr/share/GeoIP/GeoIP.dat.bak
cd /usr/share/GeoIP/
wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
gunzip GeoIP.dat.gz
if [ ! -f /usr/share/GeoIP/GeoIP.dat ]; then
cp /etc/vpssim/menu/inc/geoip/GeoIP.dat /usr/share/GeoIP/
fi
####################################################
## Setting Server Timezone & PHP Timezone
/etc/vpssim/menu/inc/vpssim-server-timzone-php-timezone
## IPtables Settings
/etc/vpssim/menu/inc/vpssim-iptables-setting
/etc/vpssim/menu/inc/thong-bao-finished-cai-dat
rm -rf /root/install*


# increase SSH login speed
if [ -f /etc/ssh/sshd_config ]; then 
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
fi
mkdir -p /var/cache/ngx_pagespeed
chown -R nginx:nginx /var/cache/ngx_pagespeed
#Change default folder ssh login
#if [ -f /root/.bash_profile ]; then
#sed -i "/.*#\ .bash_profile.*/acd /home" /root/.bash_profile
#fi
## Bat nginx & Php-FPM
/etc/vpssim/menu/inc/vpssim-thong-bao-vpssim-update-config
/etc/vpssim/menu/inc/vpssim-tao-shortcut-command-ng-mql-phpfpm
/etc/vpssim/menu/inc/start-php-fpm-service
/etc/vpssim/menu/inc/start-nginx-service
clear
echo "=========================================================================="
echo "Qua trinh cai dat server da hoan tat. "
echo "=========================================================================="
echo "Lenh goi VPSSIM: vpssim"
echo "--------------------------------------------------------------------------"
echo "Link quan ly Server: http://$svip:$svport/svm"
echo "--------------------------------------------------------------------------"
echo "Thong tin dang nhap link quan ly:"
echo "--------------------------------------------------------------------------"
echo "Username: $usernamebv  | Password: $matkhaubv"
echo "--------------------------------------------------------------------------"
echo "Thay thong tin dang nhap nay:"
echo "--------------------------------------------------------------------------"
echo "VPSSIM menu ==> Bao Mat Server & Website ==> User & Password Mac Dinh."
echo "=========================================================================="
echo "Thong tin quan ly duoc luu tai: /home/VPSSIM-manage-info.txt "
echo "=========================================================================="
echo "=========================================================================="
echo ""
echo "Tham gia cong dong VPSSIM: http://community.vpssim.vn"
echo ""
echo ""
echo "Nhung viec nen lam sau khi them website vao VPS: http://go.vpssim.vn/1138"
echo ""
echo "--------------------------------------------------------------------------"
echo "Server se khoi dong lai sau 3 giay.... "
sleep 3
reboot
exit
