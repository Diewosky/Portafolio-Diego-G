#!/bin/bash

# Script para solucionar problemas comunes de GitHub Pages
echo "🔄 Iniciando script de corrección para GitHub Pages..."

# Asegurarse de que estamos en la rama principal
git checkout main

# Crear archivos necesarios
echo "📄 Creando archivos necesarios..."
touch .nojekyll

# Crear archivo _redirects en public
mkdir -p public
cat > public/_redirects << EOL
/* /index.html 200
/Portafolio-Diego-G/* /index.html 200
EOL

# Crear archivo simple 404.html
cat > public/404.html << EOL
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Página no encontrada</title>
  <meta http-equiv="refresh" content="0;URL='/Portafolio-Diego-G/'">
  <script>
    window.location = "/Portafolio-Diego-G/";
  </script>
</head>
<body>
  <h1>404 - Página no encontrada</h1>
  <p>Redireccionando a la <a href="/Portafolio-Diego-G/">página principal</a>...</p>
</body>
</html>
EOL

# Crear un index.html simple en la raíz de public para redirección
cat > public/index-redirect.html << EOL
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Redireccionando...</title>
  <meta http-equiv="refresh" content="0;URL='/Portafolio-Diego-G/'">
  <script>
    window.location = "/Portafolio-Diego-G/";
  </script>
</head>
<body>
  <p>Redireccionando a <a href="/Portafolio-Diego-G/">página principal</a>...</p>
</body>
</html>
EOL

# Simplificar la configuración de Astro
cat > astro.config.mjs << EOL
// @ts-check
import { defineConfig } from 'astro/config';
import tailwind from "@astrojs/tailwind";

// https://astro.build/config
export default defineConfig({
  integrations: [tailwind()],
  site: 'https://diewosky.github.io',
  base: '/Portafolio-Diego-G',
});
EOL

# Reconstruir el proyecto
echo "🔨 Reconstruyendo el proyecto..."
npm run build

# Copiar archivos necesarios a dist
echo "📋 Copiando archivos a dist..."
cp public/404.html dist/404.html
cp public/_redirects dist/_redirects
cp public/index-redirect.html dist/index-redirect.html
touch dist/.nojekyll

# Mostrar estructura de archivos
echo "📂 Estructura de archivos generada:"
ls -la dist

echo "✅ Script completado. Ahora puedes hacer commit y push de los cambios." 