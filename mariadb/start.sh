length=10
options="123"

characters=""

if [[ $options == *"1"* ]]; then
  characters+="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
fi

if [[ $options == *"2"* ]]; then
  characters+="abcdefghijklmnopqrstuvwxyz"
fi

if [[ $options == *"3"* ]]; then
  characters+="0123456789"
fi

if [[ $options == *"4"* ]]; then
  characters+="!@#$%^&*()-=_+"
fi

password=$(LC_CTYPE=C tr -dc "$characters" < /dev/urandom | head -c $length)

SERVER_DOWNLOAD="$password"

# Génération du nom d'utilisateur personnalisé avec un suffixe aléatoire
username="admin-$(LC_CTYPE=C tr -dc '0123456789' < /dev/urandom | head -c 2)"


# Commandes SQL pour créer l'utilisateur et accorder les privilèges
sql_commands=$(cat <<EOF
CREATE USER '$username'@'%' IDENTIFIED BY '$SERVER_DOWNLOAD';
GRANT ALL PRIVILEGES ON *.* TO '$username'@'%';
GRANT ALL PRIVILEGES ON proddb.* TO '$username'@'%';
FLUSH PRIVILEGES;
EOF
)

printf "%s" "$password" > password.txt
printf "%s" "$username" > username.txt
echo "$sql_commands" | mysql -u root -p -e


printf "\e[1;31m========================== \e[0m%s\n"&&
printf "\e[1;31mUtilisateur : \e[0m%s\n" "$(cat username.txt)" &&
printf "\e[1;32mMot de passe : \e[0m%s\n" "$(cat password.txt)" &&
printf "\e[1;31m========================== \e[0m%s\n" &&
{ /usr/sbin/mysqld & } && sleep 5 && mysql -u root