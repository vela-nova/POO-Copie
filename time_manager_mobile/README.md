# README pour le projet Time Manager Mobile

## Introduction

Bienvenue dans le projet **Time Manager Mobile** ! Cette application est conçue pour aider les utilisateurs à suivre efficacement leur temps et à gérer leurs tâches. Ce README fournit des instructions de configuration spécifiques pour mettre en place le projet avec Vue et Capacitor pour le développement Android.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé les éléments suivants sur votre machine :

- **Node.js** (version 14 ou supérieure)
- **npm** (Node Package Manager)
- **Java** (version 17 ou supérieure)
- **Android Studio** (pour le développement Android)
- **Capacitor CLI** (pour construire des applications mobiles)

### Installation de Java

Si Java n'est pas encore installé, vous pouvez l'installer via Homebrew. Exécutez les commandes suivantes dans votre terminal :

```bash
brew tap adoptopenjdk/openjdk
brew install --cask temurin

Vérifiez ensuite l'installation de Java :
java -version

Clonez le dépôt du projet depuis GitHub :
bash
git clone https://github.com/votreusername/time_manager_mobile.git
cd time_manager_mobile

Installer les Dépendances Node.js
Naviguez jusqu'au répertoire du projet et installez les dépendances requises :
bash
npm install

 Installer Capacitor
Si vous n'avez pas encore installé Capacitor, vous pouvez le faire en exécutant :
bash
npm install @capacitor/core @capacitor/cli

Configurer la Plateforme Android
Ajoutez la plateforme Android à votre projet Capacitor :
bash
npx cap add android

Configurer les Variables d'Environnement
Créez un fichier .env à la racine du projet et ajoutez vos variables d'environnement si nécessaire. Cela peut inclure des clés API ou d'autres configurations.
6. Construire le Projet
Construisez votre projet pour vous assurer que tout est configuré correctement :
bash
npm run build

Synchroniser avec Capacitor
Après la construction, synchronisez votre projet avec Capacitor :
bash
npx cap sync android

Ouvrir Android Studio
Vous pouvez maintenant ouvrir votre projet Android dans Android Studio :
bash
npx cap open android