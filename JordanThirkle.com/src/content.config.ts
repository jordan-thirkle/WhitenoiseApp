import { defineCollection } from 'astro:content';
import { z } from 'astro:schema';
import { glob } from 'astro/loaders';

const blog = defineCollection({
	loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: "src/data/blog" }),
	schema: z.object({
		title: z.string().max(60),
		description: z.string().max(160),
		pubDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		category: z.enum(['AI', 'Web Development', 'Systems', 'Design', 'Productivity']).default('Web Development'),
		tags: z.array(z.string()),
		readTime: z.string(),
		draft: z.boolean().default(false),
		image: z.string(),
		featured: z.boolean().default(false),
		views: z.number().default(0),
		likes: z.number().default(0),
	}),
});

const projects = defineCollection({
	loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: "src/data/projects" }),
	schema: z.object({
		title: z.string(),
		description: z.string(),
		category: z.enum(['Websites', 'Mobile Apps', 'SaaS', 'Open Source', 'Tools', 'Infrastructure']),
		tech: z.array(z.string()),
		pubDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		timeline: z.string().optional(),
		mission: z.string().optional(),
		liveUrl: z.string().url().optional(),
		githubUrl: z.string().url().optional(),
		xThreadUrl: z.string().url().optional(),
		image: z.string(),
		featured: z.boolean().default(false),
		views: z.number().default(0),
		likes: z.number().default(0),
	}),
});

const devlog = defineCollection({
	loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: "src/data/devlog" }),
	schema: z.object({
		title: z.string(),
		description: z.string().max(160),
		pubDate: z.coerce.date(),
		tags: z.array(z.string()).default([]),
	}),
});

export const collections = { blog, projects, devlog };
