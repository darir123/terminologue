# Déploiement en ligne (Gratuit)

Ce guide explique comment héberger votre **site web personnel** et **Terminologue** en ligne, accessibles depuis n'importe où, gratuitement.

---

## Architecture

| Service | Plateforme | URL | Rôle |
|---------|-----------|-----|------|
| Site web personnel | **GitHub Pages** | `https://votre-nom.github.io` | Page d'accueil + liens |
| Terminologue | **Fly.io** | `https://terminologue.fly.dev` | TMS + bases de données |

---

## Étape 1 : Créer un compte GitHub

1. Allez sur https://github.com/signup
2. Créez un compte (gratuit)
3. Vérifiez votre email

---

## Étape 2 : Publier ce projet sur GitHub

```bash
cd C:\Users\mor\Documents\kimi\workspace\terminologue
git init
git add .
git commit -m "Initial commit"
git branch -M main
```

Puis sur GitHub, créez un nouveau repo nommé `terminologue` et :

```bash
git remote add origin https://github.com/VOTRE_NOM/terminologue.git
git push -u origin main
```

---

## Étape 3 : Déployer le site web sur GitHub Pages

1. Sur votre repo GitHub, allez dans **Settings > Pages**
2. Source : **GitHub Actions**
3. Le workflow dans `.github/workflows/deploy.yml` s'occupe du reste
4. Votre site sera disponible à : `https://VOTRE_NOM.github.io/terminologue`

---

## Étape 4 : Créer un compte Fly.io

1. Allez sur https://fly.io/app/sign-up
2. Inscrivez-vous (gratuit, pas de carte requise pour le tier de base)
3. Installez le CLI : https://fly.io/docs/hands-on/install-flyctl/

---

## Étape 5 : Déployer Terminologue sur Fly.io

### 5.1 Se connecter
```bash
flyctl auth login
```

### 5.2 Lancer l'application
```bash
cd C:\Users\mor\Documents\kimi\workspace\terminologue
flyctl launch --name terminologue
```
- Choisissez la région : `Paris, France (cdg)` ou `Amsterdam, Netherlands (ams)`
- Répondez **Non** à la question sur la base de données (on utilise SQLite)

### 5.3 Créer un volume persistant (pour les données SQLite)
```bash
flyctl volumes create terminologue_data --size 1 --region cdg
```

### 5.4 Déployer
```bash
flyctl deploy
```

### 5.5 Vérifier
```bash
flyctl open
```

Votre Terminologue sera accessible à : `https://terminologue.fly.dev`

---

## Étape 6 : Mettre à jour le site web avec l'URL réelle

Une fois que Fly.io vous a donné votre URL (ex: `terminologue.fly.dev`), mettez à jour le lien dans le site web :

1. Ouvrez `public/index.html`
2. Remplacez `http://localhost:3000/` par votre URL Fly.io
3. Commitez et pushez sur GitHub :
```bash
git add public/index.html
git commit -m "Update Terminologue URL"
git push
```

GitHub Pages se mettra à jour automatiquement.

---

## Étape 7 : Migrer vos données locales vers le cloud

Pour copier vos bases de données locales vers Fly.io :

```bash
flyctl sftp shell
# Puis dans le shell SFTP:
# cd /data
# put data/terminologue.sqlite
# put data/lang.sqlite
```

Ou créez un nouveau compte admin sur l'instance cloud :
1. Accédez à `https://terminologue.fly.dev/`
2. Utilisez **Sign up** pour créer un compte
3. L'email doit être dans la liste `admins` du `siteconfig.cloud.json`

---

## Coût

| Service | Coût mensuel |
|---------|-------------|
| GitHub Pages | **0€** |
| Fly.io (free tier) | **0€** |
| **Total** | **0€** |

**Limites Fly.io free tier :**
- 2,340 heures/mois d'uptime (suffisant pour 24/7)
- 256 MB RAM
- Volume persistant de 1 GB gratuit
- Le service peut redémarrer après inactivité (rare)

---

## Résumé des URLs

| Environnement | Site web | Terminologue |
|--------------|----------|-------------|
| **Local** | `http://localhost:8080/` | `http://localhost:3000/` |
| **En ligne** | `https://VOTRE_NOM.github.io/terminologue` | `https://terminologue.fly.dev` |

---

## Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs Fly.io : `flyctl logs`
2. Vérifiez le statut : `flyctl status`
3. Consultez la documentation : https://fly.io/docs/
