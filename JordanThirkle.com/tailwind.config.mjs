/** @type {import('tailwindcss').Config} */
import typography from '@tailwindcss/typography';

export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        // Highly optimized Zinc-based palette for a minimalist look
        zinc: {
          950: '#09090b',
        },
      },
      fontFamily: {
        sans: ['Inter', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
      typography: {
        DEFAULT: {
          css: {
            '--tw-prose-body': '#d4d4d8', // zinc-300
            '--tw-prose-headings': '#fafafa', // zinc-50
            '--tw-prose-links': '#ffffff',
            '--tw-prose-bold': '#ffffff',
            '--tw-prose-code': '#ffffff',
          },
        },
      },
    },
  },
  plugins: [typography],
};
