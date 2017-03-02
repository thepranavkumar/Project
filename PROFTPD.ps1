if [ "$proftpd" = 'yes' ]; then
    echo "127.0.0.1 $servername" >> /etc/hosts
    wget $edevcp/proftpd/proftpd.conf -O /etc/proftpd/proftpd.conf
    update-rc.d proftpd defaults
    service proftpd start
    check_result $? "proftpd start failed"
fi
