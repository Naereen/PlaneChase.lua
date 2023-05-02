# Fichier GNU Makefile pour PlaneChase.lua
# Voir en ligne https://GitHub.com/Naereen/PlaneChase.lua pour plus d'informations
# © Lilian et Elliot, avril 2023
#

build_lovezip:
	zip -r PlaneChase.zip ./*.lua ./*.ttf ./README ./LICENSE ./images
	mv -vf PlaneChase.zip PlaneChase.love

build_lovejs:	build_lovezip
	# npx love.js [options] <input> <output>
	npx love.js --compatibility --title "Plane Chase for Magic the Gathering ~ By Elliot & Lilian" --memory 70000000 ./PlaneChase.love www/
	git restore www/index.html

test_lovejs:
	firefox http://localhost:8910/ &
	cd www/ && python3 -m http.server 8910

send_zamok:
	rsync --exclude=.git --ipv4 --verbose --times --perms --compress --human-readable --progress --archive ./www/ besson@zamok.crans.org:~/www/publis/PlaneChase.lua/
	firefox https://perso.crans.org/besson/publis/PlaneChase.lua/
	# rsync --exclude=.git --ipv4 --verbose --times --perms --compress --human-readable --progress --archive ./PlaneChase.love besson@zamok.crans.org:~/www/publis/PlaneChase.lua/
