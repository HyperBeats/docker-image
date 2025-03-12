FROM alpine:latest

# Installer les dépendances nécessaires
RUN apk --update --no-cache add curl ca-certificates nginx nginx-mod-stream

# Définir l'utilisateur et le répertoire de travail
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Copier le script entrypoint
COPY ./entrypoint.sh /entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /entrypoint.sh

# Commande par défaut
CMD ["/bin/ash", "/entrypoint.sh"]