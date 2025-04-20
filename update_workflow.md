# Guía para mantener sincronizadas las ramas main y gh-pages

Este documento explica cómo utilizar los scripts que hemos creado para asegurarse de que los cambios en la rama `main` se reflejen correctamente en la rama `gh-pages`.

## Problema

En ocasiones, GitHub Actions puede tener problemas al desplegar automáticamente los cambios de la rama `main` a la rama `gh-pages`. Esto puede ocurrir por varias razones:

1. El workflow de GitHub Actions puede fallar por algún error.
2. Los permisos pueden no estar configurados correctamente.
3. Pueden haber conflictos entre las ramas.
4. GitHub Actions puede estar en mantenimiento o tener problemas temporales.

## Solución

Hemos creado dos scripts para ayudar a solucionar estos problemas:

1. `check_workflow.sh`: Para verificar el estado del workflow de GitHub Actions.
2. `sync_branches.sh`: Para sincronizar manualmente las ramas cuando sea necesario.

## Uso de check_workflow.sh

Este script verifica el estado del workflow de GitHub Actions después de hacer push a la rama `main`.

```bash
./check_workflow.sh <token_github> [workflow_id]
```

Donde:
- `<token_github>`: Es tu token personal de GitHub con permisos para acceder a los workflows.
- `[workflow_id]`: Opcional. El nombre del archivo del workflow a verificar. Por defecto es `deploy.yml`.

Ejemplo:
```bash
./check_workflow.sh ghp_xxxxxxxxxxxxxxxxxxxxxx
```

Este script:
1. Verifica el estado del último workflow ejecutado.
2. Si el workflow está en progreso, espera hasta que termine.
3. Muestra el resultado final del workflow.

## Uso de sync_branches.sh

Este script sincroniza manualmente la rama `gh-pages` con la rama `main` cuando el workflow automático falla.

```bash
./sync_branches.sh
```

Este script:
1. Cambia a la rama `main` y obtiene los últimos cambios.
2. Compila el sitio.
3. Cambia a la rama `gh-pages`.
4. Copia los archivos compilados a la raíz de `gh-pages`.
5. Crea un commit y lo envía a GitHub.
6. Vuelve a la rama `main`.

## ¿Cuándo usar cada script?

1. **Flujo normal**:
   - Haces cambios en la rama `main`.
   - Haces push a GitHub.
   - Ejecutas `./check_workflow.sh <token>` para verificar que el workflow se complete correctamente.
   - Si todo está bien, ¡listo!

2. **Si el workflow falla**:
   - Ejecutas `./sync_branches.sh` para sincronizar manualmente las ramas.
   - Esperas unos minutos a que GitHub Pages procese los cambios.

## Obtención de un token de GitHub

Para utilizar el script `check_workflow.sh`, necesitas un token personal de GitHub. Puedes obtenerlo así:

1. Ve a [GitHub Personal Access Tokens](https://github.com/settings/tokens).
2. Haz clic en "Generate new token".
3. Dale un nombre descriptivo como "Verificación de Workflows".
4. Selecciona los siguientes permisos:
   - `repo` (acceso completo al repositorio)
   - `workflow` (para ver y controlar workflows)
5. Haz clic en "Generate token" y guarda el token en un lugar seguro.

## Notas finales

- Estos scripts son una solución temporal hasta que se resuelvan los problemas con GitHub Actions.
- Recuerda que el token de GitHub es sensible y no debe compartirse con nadie.
- Es recomendable no subir estos scripts al repositorio si contienen tokens o información sensible. 