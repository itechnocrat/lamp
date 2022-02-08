# LAMP

## Linux Apache MySQL PHP

### Сначала удалить весь AMP:

```sh
sudo -i
#tasksel remove lamp-server
systemctl stop mysql
systemctl stop apache2
rm -rf /etc/apache2
rm -rf /etc/mysql
rm -rf /etc/php
rm -rf /var/lib/apache2
rm -rf /var/lib/mysql
rm -rf /var/lib/php
apt purge mysql-server*
apt purge php*
apt purge apache*
apt update -y && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y && apt autoclean -y && apt clean -y
```

### Файрвол

Может мешать работе Apache, но это не точно.

Узнать статус файрвола:

```sh
sudo -i
ufw status
```

Если файрвол активен, то дезактивировать

```sh
sudo -i
ufw disable
```

Когда Apache и PHP заработают, активировать:

```sh
sudo -i
ufw enable
```

### Добавление репозиториев Apache и PHP

```sh
sudo -i
apt install -y software-properties-common
add-apt-repository -y ppa:ondrej/apache2
add-apt-repository -y ppa:ondrej/php
```

### Подготовка к установке MySQL

Это конфигуратор MySQL.  
В конфигураторе пункты меню должны выглядет так, как на [картинке](https://macrodmin.ru/wp-content/uploads/2018/11/Configure-MySQL-APT-Config.png), но третий пункт тоже должен быть `Enabled`.

```sh
cd /tmp
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
sudo dpkg -i ./mysql-apt-config_0.8.22-1_all.deb
rm ./mysql-apt-config*.deb
apt update -y && apt upgrade -y
```

### Установка Apache MySQL PHP

```sh
apt --install-suggests -y install apache2 php php-mysql libapache2-mod-php mysql-server
```

### Во время установки будут вопросы программы-установщика

1. Нужно будет задать пароль администратора для MySQL, для учебных целей он может быть любым и его необходимо запомнить.
Чтобы отличать его от других паролей, пусть будет `r00t`, это `r` `два нуля` и `t`.

2. Во втором вопросе следует выбрать `Use Strong Password Encryption (RECOMMENDED)`.

3. Если будут еще вопросы, то выбирать вариант `install the package maintainer's version`, т.в. вводить `Y` и жать `Enter`.

### Последний штрих

```sh
sudo -i
apt update -y && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y && apt autoclean -y && apt clean -y
```

### Проверка Apache

```sh
sudo -i
systemctl status apache2
```

### Проверка MySQL

```sh
sudo -i
systemctl status mysql
```

### Проверка PHP

```sh
php -v
```

Если результаты проверки положительные, то идти дальше.

### Проверка работы Apache и PHP вместе

Создать файл `/var/www/index.php`, для этого скормить в консоль следующий блок команд:

```sh
sudo -i
cat << EOF > /var/www/html/index.php
<?php phpinfo(); ?>
EOF

```

Посмотреть содержимое файла `/var/www/index.php`:

```sh
cat /var/www/html/index.php
```

Если содержимое файла такое:

```php
<?php phpinfo(); ?>
```

то перейти по адресу [http://localhost/index.php](http://localhost/index.php)

### Немного тюнинга для Apache

1. В файле `/etc/apache2/conf-available/charset.conf` убрать символ `#` перед `AddDefaultCharset UTF-8`:

```sh
sudo -i
vi /etc/apache2/conf-available/charset.conf
```

2. В файле `/etc/apache2/mods-enabled/dir.conf`, в директиве `DirectoryIndex`, первым значением должно быть `index.php`:

```sh
sudo -i
vi /etc/apache2/mods-enabled/dir.conf
```

Таким должно быть содержимое файла:

```conf
<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
```

Перезапустить Apache:

```sh
sudo -i
systemctl reload apache2
```

Теперь в адресной строке веб-браузера необязательно указывать полный путь к файлу `index.php` на сервере, а достаточно ввести `localhost`

Перейти по адресу [http://localhost/](http://localhost/)

Каталог `/var/www/html` и его содержимое следует оставить в покое и адрес [http://localhost/](http://localhost/) использовать исключительно для диагностики работы PHP, а для других проектов (сайтов) использовать другие каталоги и конфигурации виртуальных серверов.

На этом все.

### Источники

Лучшие источники:  
[Установка комплекта Linux, Apache, MySQL, PHP (LAMP) в Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04-ru)  
[How To Install MySQL on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04)  
[How To Install the Latest MySQL on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-the-latest-mysql-on-ubuntu-20-04)  

Для кругозора:  
[Как установить стек LAMP (Apache, MySQL, PHP) на Ubuntu 20.04](https://timeweb.com/ru/community/articles/kak-ustanovit-stek-lamp-na-ubuntu-20-04?utm_medium=affilate&utm_source=admitad&utm_campaign=admitad-virtual-hosting&admitad_uid=84543c8414c2ed545da19f88364c3fce)  
[Установка LAMP-стека (Linux, Apache, MySQL, PHP) на Ubuntu](https://selectel.ru/blog/lamp-install-ubuntu/)  
[How to Install PHP 8 on Ubuntu 20.04](https://linuxize.com/post/how-to-install-php-8-on-ubuntu-20-04/)  
