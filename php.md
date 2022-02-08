## PHP

### Версия PHP

Узнать, какая версия уже установлена в системе:

```sh
php -v
```

Установить значение системной переменной равной версии PHP.

Например: для версии 8.1.2, значение для переменной будет 8.1:

```sh
version='8.1'
```

### Создание резервных копий конфигурационных файлов PHP

```sh
cp /etc/php/${version}/apache2/php.ini /etc/phpV/apache2/php.ini.buckup
cp /etc/php/${version}/cli/php.ini /etc/phpV/cli/php.ini.buckup
```

### Настройка PHP

Для обоих следующих файлов:

```sh
vi /etc/php/${version}/apache2/php.ini
vi /etc/php/${version}/cli/php.ini
```

сделать следующие настройки:

```
[Date]
date.timezone = "Europe/Moscow"
default_charset = "UTF-8"
short_open_tag = Off

[intl]
intl.default_locale = ru_RU.UTF-8
intl.error_level = E_ALL
```

Для одного файла:

```sh
vi /etc/php/${version}/apache2/php.ini
```

сделать такую настройку:

```
extension = mcrypt.so
display_errors=on
error_reporting = E_ALL | E_STRICT
post_max_size = 32M
upload_tmp_dir = /var/tmp
upload_max_filesize = 100M
```

На этом все.

#### PHP-фреймворк

[Laravel](https://laravel.com/)
