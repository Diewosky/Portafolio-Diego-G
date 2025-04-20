#!/bin/bash

# Script para sincronizar las ramas main y gh-pages

# Asegurarse de que estamos en la rama main
echo "Cambiando a la rama main..."
git checkout main

# Obtener los últimos cambios
echo "Obteniendo los últimos cambios de origin/main..."
git pull origin main

# Compilar el sitio
echo "Compilando el sitio..."
npm run build

# Verificar que el directorio dist existe
if [ ! -d "dist" ]; then
  echo "Error: El directorio 'dist' no existe. La compilación ha fallado."
  exit 1
fi

# Asegurar que dist/.nojekyll existe para GitHub Pages
touch dist/.nojekyll

# Cambiar a la rama gh-pages
echo "Cambiando a la rama gh-pages..."
git checkout gh-pages

# Guardar el estado actual de los archivos en la rama gh-pages (por si acaso)
echo "Haciendo backup de gh-pages en caso de conflictos..."
mkdir -p ~/.gh-pages-backup
cp -r ./* ~/.gh-pages-backup/ 2>/dev/null || true

# Copiar los archivos compilados
echo "Copiando los archivos compilados de dist/ a la raíz de gh-pages..."
find . -maxdepth 1 -not -path "./dist" -not -path "./.git" -not -path "." -exec rm -rf {} \;
cp -r dist/* .
rm -rf dist

# Agregar todos los cambios
echo "Agregando los cambios al staging..."
git add .

# Hacer commit
echo "Creando commit con los cambios..."
git commit -m "Actualización manual desde rama main ($(date))"

# Empujar los cambios a GitHub
echo "Enviando los cambios a GitHub..."
git push origin gh-pages

# Volver a la rama main
echo "Volviendo a la rama main..."
git checkout main

echo "¡Sincronización completada con éxito!"
echo "La rama gh-pages ha sido actualizada con los últimos cambios de main."
echo "Recuerda esperar unos minutos a que GitHub Pages procese los cambios." 