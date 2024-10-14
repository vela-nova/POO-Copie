
- Docker et Docker Compose
- Git


1. Copiez les fichiers de configuration :

cp .env.dist .env
cp Dockerfile.dist Dockerfile
etc ...


3. Modifiez le fichier `.env` avec vos propres valeurs.

4. Construisez et démarrez les conteneurs :

docker-compose build
docker-compose up -d


### Commandes utiles
- Logs : `docker-compose logs`
- Arrêter les conteneurs : `docker-compose down`
- Redémarrer un service : `docker-compose restart [service_name]`

