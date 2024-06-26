# Utilisez une image de base avec un serveur web léger
FROM nginx

RUN yum update 
RUN yum install -y git

# Définir le répertoire de travail
WORKDIR /usr/share/nginx/html
RUN rm -rf  /usr/share/nginx/html
RUN mkdir  /usr/share/nginx/html

# Cloner le dépôt Git
RUN git clone https://github.com/Kassoumaye/TP_DevOps_Docker_Git.git /usr/share/nginx/html

# Utilisation de variables d'environnement pour personnaliser le site
ARG HEADER_TITLE="Charles Thomas DIATTA"
ARG FOOTER_NAME="Bienvenu chez les DevOpsiens"

# Remplacement des variables dans index.html
RUN sed -i 's/{{header_title}}/'"$HEADER_TITLE"'/g' /usr/share/nginx/html/index.html && \
    sed -i 's/{{footer_name}}/'"$FOOTER_NAME"'/g' /usr/share/nginx/html/index.html

# Expose le port 80 pour accéder au site
EXPOSE 80

