from flask import Flask, request, redirect, url_for, render_template
import os

app = Flask(__name__)
UPLOAD_FOLDER = 'static/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Vérifier si le fichier a une extension autorisée
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Route principale pour afficher et télécharger une nouvelle image
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # Vérifier si le fichier est dans la requête
        if 'file' not in request.files:
            return redirect(request.url)
        file = request.files['file']
        # Vérifier si un fichier a été sélectionné et s'il est autorisé
        if file.filename == '':
            return redirect(request.url)
        if file and allowed_file(file.filename):
            # Sauvegarder le fichier téléchargé
            filename = 'center_image' + os.path.splitext(file.filename)[1]
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            return redirect(url_for('index'))
    # Déterminer l'URL de l'image à afficher
    image_url = os.path.join('uploads', 'center_image.jpg') if os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], 'center_image.jpg')) else 'images/default.jpg'
    return render_template('index.html', header_title="Bienvenue sur mon site", footer_name="Jean Dupont", image_url=image_url)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
