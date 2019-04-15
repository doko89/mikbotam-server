#!/bin/bash


## vars
tools="unzip curl"
pkgs="nginx php7.2-fpm php7.2-curl mysql-server"
dbname="mikbotam"
urlmikbotam="https://cloud.mikbotam.net/index.php?share/fileDownload&user=1&sid=yGfNZkWq"

## web vars
webdir=/var/www/html
webconf=/var/www/html/config/system.config.php

## database configuration
if [ ! -f password.txt ];then
    echo "export PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')" > password.txt
fi
source password.txt
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASS"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASS"

clear

echo "==================================================="
echo "script ini untuk generate web server untuk mikbotam"
echo "    silahkan ikuti petunjuk configurasi berikut"
echo "==================================================="
echo
read -p "Lanjutkan : (y/n) " process

installsrv(){
    echo "test"
    add-apt-repository -y ppa:ondrej/php 2> /dev/null |echo "install php repository"
    apt-get update 2> /dev/null |echo "update repository"
    apt-get install -y $tools 2> /dev/null |echo "install extra tools"
    apt-get install -y $pkgs  2> /dev/null |echo "install nginx php-fpm mysql"
}
configsrv(){

    ## config nginx
    if [ -f /etc/nginx/sites-enabled/default ];then
        unlink /etc/nginx/sites-enabled/default |echo "delete default config"
    fi
    cp -rf templates/php_params /etc/nginx/php_params
    cp -rf templates/redir_params /etc/nginx/redir_params
    cp -rf templates/mikbotam.conf /etc/nginx/conf.d/mikbotam.conf

    ## Download mikbotam
    wget "$urlmikbotam" -O $webdir/mikbotam.zip
    unzip $webdir/mikbotam.zip -d $webdir
    chown -R www-data:www-data $webdir

    ## config database
    checkdb=`mysqlshow --user=root --password=$PASS | grep $dbname`
    status=$?
    if [ ! "$status" == "0" ]; then
        mysql -uroot -p$PASS -e "create database $dbname"
    fi
    cat  $webdir/config/Newdatabase.sql| mysql --user=root --password=$PASS $dbname

    ## config mikbotam
    sed -i "s+'database_name' => 'bangacil'+'database_name' => '$dbname'+" $webconf
    sed -i "s+admin12345+$PASS+" $webconf
    sed -i "s+bangacil+root+" $webconf
}

if [ "$process" == "y" ];then
    installsrv
    configsrv
fi

