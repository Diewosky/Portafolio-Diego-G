#!/bin/bash

# Script para verificar el estado del último workflow de GitHub Actions
# Uso: ./check_workflow.sh <token> [workflow_id]

# Definir variables
OWNER="Diewosky"
REPO="Portafolio-Diego-G"
GITHUB_TOKEN="$1"
WORKFLOW_ID="${2:-deploy.yml}"

# Verificar que se proporcionó un token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: Es necesario proporcionar un token de GitHub."
    echo "Uso: ./check_workflow.sh <token> [workflow_id]"
    exit 1
fi

echo "Verificando el estado del workflow $WORKFLOW_ID en $OWNER/$REPO..."

# Obtener el último workflow run
response=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$OWNER/$REPO/actions/workflows/$WORKFLOW_ID/runs?per_page=1")

# Verificar si hay algún error en la respuesta
if [[ "$response" == *"Not Found"* ]]; then
    echo "Error: No se encontró el workflow o no tienes permisos para acceder a él."
    exit 1
fi

# Extraer información del último run
run_id=$(echo "$response" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
status=$(echo "$response" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
conclusion=$(echo "$response" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)
created_at=$(echo "$response" | grep -o '"created_at":"[^"]*"' | head -1 | cut -d'"' -f4)
updated_at=$(echo "$response" | grep -o '"updated_at":"[^"]*"' | head -1 | cut -d'"' -f4)
head_sha=$(echo "$response" | grep -o '"head_sha":"[^"]*"' | head -1 | cut -d'"' -f4)
html_url=$(echo "$response" | grep -o '"html_url":"[^"]*"' | head -1 | cut -d'"' -f4)

# Mostrar la información
echo "====================================="
echo "ID del Run: $run_id"
echo "Estado: $status"
echo "Conclusión: $conclusion"
echo "Creado: $created_at"
echo "Actualizado: $updated_at"
echo "SHA del commit: $head_sha"
echo "URL: $html_url"
echo "====================================="

# Si el workflow está en progreso, esperar hasta que termine
if [ "$status" == "in_progress" ] || [ "$status" == "queued" ]; then
    echo "El workflow está en progreso. Esperando a que termine..."
    
    while [ "$status" == "in_progress" ] || [ "$status" == "queued" ]; do
        echo "Verificando estado... ($(date))"
        sleep 15
        
        response=$(curl -s -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/$OWNER/$REPO/actions/runs/$run_id")
        
        status=$(echo "$response" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
        conclusion=$(echo "$response" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)
        updated_at=$(echo "$response" | grep -o '"updated_at":"[^"]*"' | head -1 | cut -d'"' -f4)
    done
    
    echo "====================================="
    echo "El workflow ha terminado!"
    echo "Estado final: $status"
    echo "Conclusión: $conclusion"
    echo "Actualizado: $updated_at"
    echo "URL: $html_url"
    echo "====================================="
fi

# Salir con código de error si el workflow falló
if [ "$conclusion" == "failure" ]; then
    echo "El workflow ha fallado."
    exit 1
elif [ "$conclusion" == "success" ]; then
    echo "El workflow ha completado con éxito."
    exit 0
else
    echo "El workflow ha terminado con estado: $conclusion"
    exit 0
fi 