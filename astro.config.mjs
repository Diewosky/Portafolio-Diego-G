// @ts-check
import { defineConfig } from 'astro/config';
import tailwind from "@astrojs/tailwind";

// https://astro.build/config
export default defineConfig({
  outDir: './docs',
  site: 'https://diewosky.github.io',
  base: '/Portafolio-Diego-G',
  integrations: [tailwind()]
});
