Master Architecture Guide: Jordan Thirkle Hub

This document outlines exactly how to translate the React prototype into a production-ready, highly scalable Astro application. By following this structure, your website will remain blazingly fast, easy to maintain, and perfectly optimized for SEO.

1. The Ideal Folder Structure

When you run npm create astro@latest, structure your repository exactly like this:

/
├── public/                 # Static assets (images, fonts, favicons)
│   ├── projects/           # Screenshots/GIFs for projects
│   └── og-images/          # Fallback OpenGraph images
├── src/
│   ├── components/         # Reusable UI pieces
│   │   ├── react/          # Interactive components (Islands)
│   │   │   ├── CommandPalette.jsx
│   │   │   ├── EngagementDock.jsx
│   │   │   └── ToastProvider.jsx
│   │   └── astro/          # Static, zero-JS components
│   │       ├── Navbar.astro
│   │       ├── Footer.astro
│   │       └── ProjectCard.astro
│   ├── content/            # The heart of your site (Markdown/MDX)
│   │   ├── blog/           # All your blog posts (.mdx)
│   │   ├── projects/       # All your case studies (.mdx)
│   │   └── config.ts       # Strict TypeScript schemas for content
│   ├── layouts/            # Page wrappers
│   │   ├── MainLayout.astro
│   │   └── ArticleLayout.astro
│   ├── pages/              # Routing
│   │   ├── index.astro     # Home page
│   │   ├── blog/
│   │   │   ├── index.astro # Blog archive
│   │   │   └── [slug].astro# Dynamic article routing
│   │   ├── work/
│   │   │   └── [slug].astro# Dynamic project routing
│   │   └── uses.astro      # Uses page
│   └── store.js            # Nano Stores (Global state)
├── astro.config.mjs        # Astro configuration (Tailwind, MDX)
└── tailwind.config.cjs     # Zinc color palette configuration


2. Content Collections (The Secret Weapon)

Do not hardcode your projects or articles into arrays like in the prototype. In src/content/config.ts, you will define strict schemas using Zod. This ensures every markdown file has the right data (dates, tags, URLs) before it even compiles.

import { z, defineCollection } from 'astro:content';

const blogCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    date: z.date(),
    tags: z.array(z.string()),
    readTime: z.string(),
    draft: z.boolean().default(false),
  }),
});

const projectCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    category: z.enum(['Games', 'SaaS', 'Open Source', 'Tools']),
    tech: z.array(z.string()),
    liveUrl: z.string().url().optional(),
    githubUrl: z.string().url().optional(),
    heroImage: z.string(), // Path to public/projects/
  }),
});

export const collections = {
  'blog': blogCollection,
  'projects': projectCollection,
};


3. Managing Global State (Nano Stores)

Because Astro uses an "Islands Architecture" (meaning React components are isolated from each other to save Javascript), you can't use React Context for global state like the Cmd+K modal.

You must use Nano Stores.

Create src/store.js:

import { atom } from 'nanostores';
export const isSearchOpen = atom(false);


Import this store into your React Navbar.jsx (to trigger it) and your CommandPalette.jsx (to display it). They will instantly sync without wrapping your whole app in a provider.

4. The Comment System Integration

Instead of building a database to hold comments, use Giscus.

Create a public GitHub repository named jordan-thirkle-comments.

Install the Giscus app on that repository.

In your ArticleLayout.astro, drop the Giscus script tag at the bottom. It will automatically create a discussion thread in your repo for every new blog post URL, handling authentication (via GitHub) and storage completely for free.

5. Deployment & SEO Automation

Hosting: Deploy to Vercel. It is the gold standard for front-end hosting.

Analytics: Add the Plausible Analytics snippet to your MainLayout.astro <head>.

Sitemap: Run npm install @astrojs/sitemap. Add it to your astro.config.mjs. Every time you push a new markdown file to GitHub, Vercel will rebuild the site and generate a fresh XML sitemap for Google automatically.  