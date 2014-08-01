Kerio Bugzilla
==============

Instalace
---------
1. Stáhněte a nainstalujte si GIT, Node.js a NPM (http://git-scm.com/, http://nodejs.org/, http://nodejs.org/dist/npm/)
2. Repozitář zkopírujete příkazem ```git clone git@github.com:claryaldringen/kerio.git```
3. Nainstalujte si Bower (http://bower.io/) přes npm
4. Přesuňte se do adresáře www a pro tento adresář otevřete konzoli
5. Do konzole napište ```bower install```. Tím nainstalujete javascriptové knihovny třetích stran, které nejsou součástí repozitáře
6. Nainstalujte si CoffeeScript (npm install -g coffee-script)
7. Přeložte *.coffee soubory (coffee --compile coffee/)
8. Naunstalujte si web server Apache2 (poběží na jakémkoli webserveru, který zvládne PHP, ale např. u nginx neumí htaccess a direktivy v něm uvedené je třeba řešit jinak)
9. Pokud vše problěho úspěšně, po otevření souboru index.php byste měli něco vidět :)
