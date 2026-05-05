import { defineConfig, fontProviders } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import react from '@astrojs/react';
import mdx from '@astrojs/mdx';
import remarkToc from 'remark-toc';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  site: 'https://jordanthirkle.com',
  integrations: [
    tailwind(),
    react(),
    mdx({ remarkPlugins: [[remarkToc, { heading: 'toc|table of contents', maxDepth: 3 }]] }),
    sitemap(),
  ],
  experimental: {
    rustCompiler: true,
  },
  fonts: [
    {
      name: 'Inter',
      cssVariable: '--font-inter',
      provider: fontProviders.google(),
    },
    {
      name: 'Outfit',
      cssVariable: '--font-outfit',
      provider: fontProviders.google(),
    },
  ],
});