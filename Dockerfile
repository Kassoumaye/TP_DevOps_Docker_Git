# Utilisez une image de base avec un serveur web léger
FROM nginx:alpine

# Installez Python et les dépendances nécessaires
RUN apk add --no-cache python3 py3-pip

# Créez et activez un environnement virtuel
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Copiez le fichier requirements.txt et installez les dépendances dans l'environnement virtuel
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copiez les fichiers du site web dans le répertoire de nginx
COPY . /usr/share/nginx/html

# Copiez le fichier de configuration Nginx
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Définir le répertoire de travail pour Flask
WORKDIR /usr/share/nginx/html

# Utilisation de variables d'environnement pour personnaliser le site
ARG HEADER_TITLE="Mon Site Web"
ARG FOOTER_NAME="Charles Thomas DIATTA"

# Remplacement des variables dans index.html
RUN sed -i 's/{{header_title}}/'"$HEADER_TITLE"'/g' /usr/share/nginx/html/index.html && \
    sed -i 's/{{footer_name}}/'"$FOOTER_NAME"'/g' /usr/share/nginx/html/index.html

# Expose le port 80 pour Nginx et 5000 pour Flask
EXPOSE 80 5000

# Commande pour exécuter Flask et Nginx
CMD ["sh", "-c", "flask run --host=0.0.0.0 --port=5000 & nginx -g 'daemon off;'"]


