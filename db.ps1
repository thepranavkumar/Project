if [ "$mysql" = 'yes' ]; then
    mycnf="my-small.cnf"
    if [ $memory -gt 1200000 ]; then
        mycnf="my-medium.cnf"
    fi
    if [ $memory -gt 3900000 ]; then
        mycnf="my-large.cnf"
    fi

    # Configuring MySQL/MariaDB
    wget $edevcp/mysql/$mycnf -O /etc/mysql/my.cnf
    if [ "$release" != '16.04' ]; then
        mysql_install_db
    fi
    update-rc.d mysql defaults
    service mysql start
    check_result $? "mysql start failed"

    # Securing MySQL/MariaDB installation
    mysqladmin -u root password $vpass
    echo -e "[client]\npassword='$vpass'\n" > /root/.my.cnf
    chmod 600 /root/.my.cnf
    mysql -e "DELETE FROM mysql.user WHERE User=''"
    mysql -e "DROP DATABASE test" >/dev/null 2>&1
    mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
    mysql -e "DELETE FROM mysql.user WHERE user='' or password='';"
    mysql -e "FLUSH PRIVILEGES"

    # Configuring phpMyAdmin
    if [ "$apache" = 'yes' ]; then
        wget $edevcp/pma/apache.conf -O /etc/phpmyadmin/apache.conf
        ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf
    fi
    wget $edevcp/pma/config.inc.php -O /etc/phpmyadmin/config.inc.php
    chmod 777 /var/lib/phpmyadmin/tmp
fi
