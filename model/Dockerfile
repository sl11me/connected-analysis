# Base Python (bookworm inclut les derniers correctifs de sécu Debian)
FROM python:3.10-slim-bookworm

# Crée un dossier dans le conteneur
WORKDIR /app

# Bonnes pratiques Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Met à jour les paquets système pour corriger CVEs du base image
RUN apt-get update \
 && apt-get -y dist-upgrade \
 && rm -rf /var/lib/apt/lists/*

# Copie les fichiers locaux dans le conteneur
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Crée un utilisateur non-root et ajuste les permissions
RUN addgroup --system app \
 && adduser --system --ingroup app app \
 && chown -R app:app /app
USER app

# Exposer le port
EXPOSE 5000

# Démarrer l'app
CMD ["python", "app.py"]
