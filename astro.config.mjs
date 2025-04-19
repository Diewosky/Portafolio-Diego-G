// @ts-check
import { defineConfig } from 'astro/config';
import tailwind from "@astrojs/tailwind";

// https://astro.build/config
export default defineConfig({
  integrations: [tailwind()],
  site: 'https://diewosky.github.io',
  base: '/Portafolio-Diego-G',
  outDir: './dist',
  build: {
    assets: 'assets',
  },
  vite: {
    build: {
      cssCodeSplit: false,
    },
  },
});
