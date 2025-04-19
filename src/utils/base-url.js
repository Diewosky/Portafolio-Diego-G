/**
 * Obtiene la ruta base completa para los recursos estáticos
 * Útil para evitar problemas en GitHub Pages con rutas base no raíz
 * 
 * @param {string} path - La ruta relativa del recurso
 * @returns {string} - La ruta completa incluyendo la base URL
 */
export function getAssetPath(path) {
  // Eliminar slash inicial si existe para evitar doble slash
  const cleanPath = path.startsWith('/') ? path.substring(1) : path;
  
  // Usar la variable de entorno de Astro para la URL base
  return `${import.meta.env.BASE_URL}/${cleanPath}`;
}

/**
 * Verifica si estamos ejecutando en GitHub Pages
 * 
 * @returns {boolean} - true si estamos en GitHub Pages
 */
export function isGitHubPages() {
  if (typeof window === 'undefined') return false;
  return window.location.hostname === 'diewosky.github.io';
} 