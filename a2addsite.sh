#! /bin/bash

# Script to automate creating new apache2 virtual hosts.
# Logs go in /var/log/apache2/$SN
# DocRt is /home/username/www/$SN
# SN = shortname -- used for directory names etc.
# DN = domainname -- used only in apache config file
#
# https://gist.github.com/hcooper/814250
# H Cooper - 18/10/06
#

echo -n "Enter full domain name (e.g. example.com): "
read -e DN
echo -n "Enter a unique 'nice' name for the site (e.g. example): "
read -e SN
echo ""

echo "Creating Apache Site Configuration File"
echo "..."

if [ -f "/etc/apache2/sites-available/$SN.conf" ]; then
        echo "Site $SN already exists"
        echo "" 
else
        echo "<VirtualHost *:80>
                ServerName $DN
                ServerAlias www.$DN
                ServerAdmin $SUDO_USER@localhost
                DocumentRoot /home/$SUDO_USER/www/$SN
                #
                # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
                # error, crit, alert, emerg.
                # It is also possible to configure the loglevel for particular
                # modules, e.g.
                #LogLevel info ssl:warn
                LogLevel debug
                #
                ErrorLog /var/log/apache2/$SN/error.log
                CustomLog /var/log/apache2/$SN/access.log combined
                #
                #Include conf-available/serve-cgi-bin.conf
                <Directory /home/$SUDO_USER/www/$SN>
                        Options FollowSymLinks
                        AllowOverride All
                        Require all granted
                </Directory>
        </VirtualHost>

        # vim: syntax=apache ts=4 sw=4 sts=4 sr noet" > /etc/apache2/sites-available/$SN.conf
        echo "Done!"
        echo ""
fi

echo "Creating Log File Directory"
echo "..."

if [ -d "/var/log/apache2/$SN" ]; then
        echo "/var/log/apache2/$SN already exists"
        echo ""
else
        mkdir /var/log/apache2/$SN
        echo "Done!"
        echo ""
fi

echo "Adding user $SUDO_USER to the www-data group"
echo "..."

sudo usermod -a -G www-data $SUDO_USER
echo "Done!"
echo ""

echo "Creating Site Document Root"
echo "..."

if [ -d "/home/$SUDO_USER/www/$SN" ]; then
        echo "/home/$SUDO_USER/www/$SN already exists"
        echo "" 
else
        mkdir -p /home/$SUDO_USER/www/$SN
        chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/www
        chmod 775 /home/$SUDO_USER/www
        chown $SUDO_USER:www-data /home/$SUDO_USER/www/$SN
        chmod 775 /home/$SUDO_USER/www/$SN
        echo "Done!"
        echo ""
fi

echo "Creating index.php"
echo "..."

if [ -f "/home/$SUDO_USER/www/$SN/index.php" ]; then
        echo "File /home/$SUDO_USER/www/$SN/index.php already exists"
        echo "" 
else
        echo "<?php echo '<p>Site $DN is working!</p>'; ?>" > /home/$SUDO_USER/www/$SN/index.php
        chown $SUDO_USER:www-data /home/$SUDO_USER/www/$SN/index.php
        chmod 664 /home/$SUDO_USER/www/$SN/index.php
        echo "Done!"
        echo ""
fi

# Configuring hosts file
echo "Added entry in hosts file"
echo "..."
ipforsite='127.0.0.1'
sed -i "0,/# The following lines are desirable for IPv6 capable hosts/s/^# The following lines are desirable.*/${ipforsite}            $DN\n&/" /etc/hosts
echo "Done!"
echo ""

echo "Enabling Site & Reloading Apache"
echo "..."
a2ensite $SN.conf 1>/dev/null
echo "Done!"
echo ""

echo "Restarted apache"
echo "..."
systemctl reload apache2
echo "All done! Visit your newly created virtual host at http://$DN"
