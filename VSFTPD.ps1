if [ "$vsftpd" = 'yes' ]; then
    wget $edevcp/vsftpd/vsftpd.conf -O /etc/vsftpd.conf
    update-rc.d vsftpd defaults
    service vsftpd start
    check_result $? "vsftpd start failed"

    # To be deleted after release 0.9.8-18
    echo "/sbin/nologin" >> /etc/shells
fi
