# docker-python-exec

Image Docker générique pour exécuter n'importe quel projet Python — sans configuration manuelle.

## Pourquoi ce projet ?

Quand on développe plusieurs scripts ou projets Python, on se retrouve souvent à réécrire le même boilerplate Docker à chaque fois. Cette image règle le problème : elle s'adapte automatiquement à la structure de ton projet.

## Fonctionnement

Au démarrage du conteneur, l'entrypoint effectue automatiquement :

1. **Détection des dépendances** — recherche tous les `requirements.txt` dans l'arborescence (y compris dans les sous-dossiers) et les installe
2. **Détection du point d'entrée** — si aucun script n'est passé en argument, cherche automatiquement un `main.py` ou `script.py`
3. **Exécution** — lance le script avec `exec` pour conserver le PID 1 correctement

## Utilisation

### Lancement automatique (zero-config)

```bash
docker run -v $(pwd):/app ghcr.io/damiennerri/docker-python-exec
```

Le conteneur détecte et lance `main.py` tout seul.

### Spécifier un script manuellement

```bash
docker run -v $(pwd):/app ghcr.io/damiennerri/docker-python-exec mon_script.py
```

### Avec docker-compose

```yaml
services:
  app:
    image: ghcr.io/damiennerri/docker-python-exec
    volumes:
      - .:/app
```

## Structure attendue

```
mon-projet/
├── main.py              ← détecté automatiquement
├── requirements.txt     ← installé automatiquement
└── src/
    └── requirements.txt ← aussi installé !
```

## Stack technique

- `Python 3.13-slim` comme image de base
- `Shell` pour l'entrypoint
- `GitHub Actions` pour la CI/CD

## CI/CD

Le repo intègre une GitHub Action qui build et vérifie l'image automatiquement à chaque push.
