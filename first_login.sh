
echo "xóa kennel đã cài"
yum -y erase kernel-4.11.0-22.el7a
echo "Installing ntp ..."
yum -y install ntp ntpdate
systemctl enable ntpd --now
passwd root