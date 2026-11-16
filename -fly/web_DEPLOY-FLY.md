# Deploy to Fly.io

## Prerequisites
- Install Fly.io CLI: https://fly.io/docs/hands-on/install-flyctl/
- Sign up: `flyctl auth signup`

## Steps

### 1. Launch the app
```bash
cd terminologue
flyctl launch --name terminologue
```

### 2. Create a persistent volume for data
```bash
flyctl volumes create terminologue_data --size 1 --region cdg
```

### 3. Set secrets (optional)
```bash
flyctl secrets set NODE_ENV=production
```

### 4. Deploy
```bash
flyctl deploy
```

### 5. Open your app
```bash
flyctl open
```

## Important Notes
- The volume persists your SQLite databases across deployments
- Your app URL will be: https://terminologue.fly.dev
- Update siteconfig.json with your actual URL before deploying
- The free tier includes 2,340 hours/month (enough for 24/7)
