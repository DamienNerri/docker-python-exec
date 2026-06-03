#!/bin/sh
set -e

echo "=== [Auto-Détection] Analyse de l'architecture du projet ==="

# 1. Recherche et installation de TOUS les fichiers requirements.txt
# Utile si tu as un requirements dans back/, un autre dans back/src/, etc.
echo "-> Recherche des dépendances..."
FOUND_REQS=$(find . -name "requirements.txt")

if [ -z "$FOUND_REQS" ]; then
    echo "Aucun fichier requirements.txt trouvé. Passage à l'étape suivante."
else
    for req in $FOUND_REQS; do
        echo "📦 Installation des dépendances trouvées dans : $req"
        pip install --upgrade -r "$req"
    done
fi

# 2. Détermination dynamique du script à lancer
if [ $# -eq 0 ]; then
    echo "-> Recherche automatique du point d'entrée (main.py ou script.py)..."
    # On cherche un main.py ou script.py, même caché dans des sous-dossiers (ex: back/src/main.py)
    # On prend le premier trouvé (head -n 1)
    DETECTED_SCRIPT=$(find . -type f \( -name "main.py" -o -name "script.py" \) | head -n 1)

    if [ -z "$DETECTED_SCRIPT" ]; then
        echo "❌ Erreur: Aucun script spécifié et aucun main.py/script.py trouvé dans l'arborescence."
        exit 1
    fi
    SCRIPT="$DETECTED_SCRIPT"
else
    # Si l'utilisateur a écrit explicitement le chemin du script
    SCRIPT="$1"
    shift
fi

echo "=== [Execution] Lancement de python $SCRIPT ==="

# Exécution avec conservation du PID 1
exec python "$SCRIPT" "$@"