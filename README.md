# Описание установки LAMP (Linux Apache MySQL PHP)

1. Выполнить инструкции из файла `lamp.md`

2. Выполнить инструкции из файла `php.md`

Первых двух пунктов должно быть достаточно для того, что заработала связка Apache и PHP.

Пользоваться скриптом `a2addsite.sh` для создания виртуальных сайтов.  
Запустить скрип с правами `root`.  
Скрипт сначала будет ожидать ввод имени сайта, это имя которое будет использоваться в адресной строке веб-браузера.  
Имя может быть произвольным, например, `mysite.local`, `lab.home`, `php.learn`, `superproject`.  

Затем скрипт будет ожидать короткое имя сайта.  
В соответствии с ранее введенном именем сайта, короткое имя сайта может быть одним из:
`mysite`, `lab`, `php`, `superproject`.

Дождаться завершения работы скрипта!!!  
Скрипт выведет в консоль ссылку, по которой возможно перейти, зажав `Ctrl` и кликнув ЛКМ по ссылке, в веб-браузере откроется тестовая страница нового сайта.

Скрипт создает рабочие каталоги виртуальных веб-серверов в `/home/user-name/www/`
