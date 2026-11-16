# Documentation Terminologue - Setup Complet

**Date de création :** 11 juillet 2026  
**Utilisateur :** hassane-darir (darir123@GitHub)  
**Email admin :** h.darir@uca.ac.ma

---

## Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Solution recommandée (Node.js natif)](#solution-recommandée)
3. [Identifiants](#identifiants)
4. [URLs et accès](#urls-et-accès)
5. [Fichiers sur le Desktop](#fichiers-sur-le-desktop)
6. [Site web en ligne (Netlify)](#site-web-en-ligne)
7. [Partager Terminologue en ligne (tunnel)](#partager-terminologue-en-ligne)
8. [VM / Vagrant (optionnel)](#vm--vagrant)
9. [GitHub](#github)
10. [Dépannage](#dépannage)

---

## Vue d'ensemble

Ce projet contient trois composants :

| Composant | Description | Port local |
|-----------|-------------|------------|
| **Terminologue TMS** | Système de gestion terminologique | 3000 |
| **Site web personnel** | Page d'accueil statique | 8080 |
| **Repo GitHub** | Code source + déploiement | - |

---

## Solution recommandée

### Lancer Terminologue (Node.js natif)

**Double-cliquez sur :** `start-terminologue.bat` (sur le Desktop)

Attendez 2-3 secondes, puis ouvrez :
- **Terminologue :** http://localhost:3000/
- **Site web :** http://localhost:8080/

**Pour arrêter :** Appuyez sur `Ctrl+C` dans la fenêtre, puis confirmez avec `Y`.

### Architecture

```
PC Windows
├── Node.js (portable, dans terminologue/node/)
├── Terminologue (port 3000)
│   ├── SQLite databases (données persistantes)
│   └── node_modules (dépendances)
└── Site web (port 8080)
    ├── index.html
    ├── style.css
    └── server.js
```

---

## Identifiants

### Terminologue

| Champ | Valeur |
|-------|--------|
| Email | `h.darir@uca.ac.ma` |
| Password | `admin` |
| Rôle | Administrateur |

### Backup admin

| Email | Password |
|-------|----------|
| `root@localhost` | `admin` |

### GitHub

| Username | darir123 |
|----------|----------|
| Repo | terminologue |
| URL | https://github.com/darir123/terminologue |

---

## URLs et accès

### En local (votre PC)

| Service | URL | Quand l'utiliser |
|---------|-----|------------------|
| Terminologue | http://localhost:3000/ | Quotidiennement |
| Site web | http://localhost:8080/ | Quotidiennement |

### En ligne (permanent)

| Service | URL | Statut |
|---------|-----|--------|
| Site web | https://terminologue2.netlify.app | ✅ En ligne |
| GitHub | https://github.com/darir123/terminologue | ✅ Actif |

### En ligne (temporaire)

| Service | URL | Durée de vie |
|---------|-----|--------------|
| Tunnel Cloudflare | `*.trycloudflare.com` | Session uniquement |

**Pour créer un tunnel :** Double-cliquez sur `Share-Terminologue-Online.bat`

---

## Fichiers sur le Desktop

| Fichier | À quoi il sert | Quand l'utiliser |
|---------|----------------|------------------|
| `start-terminologue.bat` | Lance Terminologue + site web | **Tous les jours** |
| `Share-Terminologue-Online.bat` | Crée une URL publique temporaire | Pour partager |
| `Deploy-Terminologue.bat` | Met à jour le site sur GitHub | Si modifié |
| `Start-Terminologue-VM.bat` | Lance la VM (expérimental) | Optionnel |
| `Stop-Terminologue-VM.bat` | Arrête la VM | Optionnel |
| `VM-Start-Terminologue.bat` | Démarre les services dans la VM | Si VM active |

---

## Site web en ligne (Netlify)

### URL
> https://terminologue2.netlify.app

### Comment mettre à jour le site

1. Modifiez les fichiers dans `C:\Users\mor\Documents\kimi\workspace\terminologue\docs\`
2. Double-cliquez sur `Deploy-Terminologue.bat`
3. Le script pousse les changements sur GitHub
4. Netlify met à jour automatiquement (1-2 minutes)

### Ou drag & drop

1. Créez un ZIP du dossier `docs/`
2. Allez sur https://app.netlify.com/drop
3. Glissez-déposez le ZIP

---

## Partager Terminologue en ligne

### Méthode : Tunnel Cloudflare (gratuit, temporaire)

**Prérequis :** Terminologue doit tourner en local (`start-terminologue.bat`)

**Étapes :**
1. Assurez-vous que `start-terminologue.bat` est en cours d'exécution
2. Double-cliquez sur `Share-Terminologue-Online.bat`
3. Attendez 10-20 secondes
4. Une URL s'affiche (ex: `https://abc123.trycloudflare.com`)
5. Partagez cette URL — n'importe qui peut y accéder
6. **Appuyez sur Ctrl+C** pour fermer le tunnel

**Limites :**
- ❌ L'URL change à chaque session
- ❌ Le tunnel se ferme quand vous fermez la fenêtre
- ✅ Gratuit, pas de compte nécessaire

---

## VM / Vagrant

### ⚠️ Statut : Expérimental (non fonctionnel)

La VM a été créée mais le provisioning n'a pas complètement fonctionné. Les services ne démarrent pas automatiquement.

### Identifiants VM

| | |
|---|---|
| Username | `vagrant` |
| Password | `vagrant` |
| SSH | `ssh -p 2222 vagrant@127.0.0.1` |

### Commandes utiles

```bash
# Vérifier le statut
cd C:\Users\mor\Documents\kimi\workspace\terminologue
vagrant status

# Démarrer la VM
vagrant up

# Arrêter la VM
vagrant halt

# Détruire la VM (perte de données)
vagrant destroy -f

# Se connecter en SSH
vagrant ssh

# Relancer le provisioning
vagrant reload --provision
```

### Démarrer Terminologue manuellement dans la VM

```bash
# Dans la VM (après vagrant ssh)
cd /home/vagrant/terminologue/website
node terminologue.js
```

---

## GitHub

### Repo
> https://github.com/darir123/terminologue

### Dernière mise à jour
- Code source complet
- Site web (dossier `docs/`)
- Configuration Docker (supprimée, dossier `.github/workflows/`)

### Pour mettre à jour le code

```bash
cd C:\Users\mor\Documents\kimi\workspace\terminologue
# Modifier des fichiers
git add .
git commit -m "Description des changements"
git push origin master
```

Ou utiliser `Deploy-Terminologue.bat` sur le Desktop.

---

## Dépannage

### "Ce site est inaccessible" sur localhost:3000

| Cause | Solution |
|-------|----------|
| Le serveur n'est pas lancé | Double-cliquez sur `start-terminologue.bat` |
| Port 3000 déjà utilisé | Fermez les autres fenêtres Node.js (`Ctrl+C`) |
| Firewall Windows | Autorisez Node.js dans le firewall |

### Le tunnel ne se crée pas

| Cause | Solution |
|-------|----------|
| Terminologue pas lancé | Lancez d'abord `start-terminologue.bat` |
| Cloudflared absent | Le script le télécharge automatiquement |
| Pas de connexion internet | Vérifiez votre connexion |

### Erreur "Git not found"

| Cause | Solution |
|-------|----------|
| Git pas installé | Téléchargez https://git-scm.com/download/win |
| Git pas dans PATH | Réinstallez Git avec l'option "Add to PATH" |

### Données perdues

Les bases de données SQLite sont dans :
```
C:\Users\mor\Documents\kimi\workspace\terminologue\data\
├── terminologue.sqlite
├── lang.sqlite
└── siteconfig.json
```

**Sauvegardez ces fichiers** pour préserver vos données.

---

## Structure du projet

```
C:\Users\mor\Documents\kimi\workspace\terminologue\
├── node\                    ← Node.js portable (v22.13.1)
├── website\                 ← Application Terminologue
│   ├── terminologue.js
│   ├── node_modules\
│   └── ...
├── data\                    ← Bases SQLite + config
│   ├── terminologue.sqlite
│   ├── lang.sqlite
│   └── siteconfig.json
├── docs\                    ← Site web (GitHub Pages)
│   ├── index.html
│   └── style.css
├── public\                  ← Site web (local)
├── shared\                  ← Fichiers partagés
├── tools\                   ← Outils CLI
│   ├── gh.exe
│   ├── mingit\              ← Git portable
│   └── ...
├── start.bat                ← Lanceur local
├── Vagrantfile              ← Config VM (expérimental)
├── deploy.bat               ← Déploie sur GitHub
├── share-online.bat         ← Crée un tunnel
└── README.md
```

---

## Résumé rapide

| Je veux... | Je fais... |
|------------|------------|
| **Utiliser Terminologue** | Double-clique sur `start-terminologue.bat` |
| **Partager en ligne** | Lance le tunnel avec `Share-Terminologue-Online.bat` |
| **Mettre le site à jour** | Double-clique sur `Deploy-Terminologue.bat` |
| **Voir le site en ligne** | Va sur https://terminologue2.netlify.app |
| **Me connecter** | Email: `h.darir@uca.ac.ma`, Password: `admin` |

---

*Documentation générée automatiquement le 11 juillet 2026.*
