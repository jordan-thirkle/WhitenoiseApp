import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';
import type { APIContext } from 'astro';

export async function GET(context: APIContext) {
  const blog = await getCollection('blog');
  const projects = await getCollection('projects');
  const devlog = await getCollection('devlog');

  const items = [
    ...blog.map((post) => ({
      title: post.data.title,
      pubDate: post.data.pubDate,
      description: post.data.description,
      link: `/blog/${post.id}/`,
    })),
    ...projects.map((project) => ({
      title: project.data.title,
      pubDate: project.data.pubDate,
      description: project.data.description,
      link: `/projects/${project.id}/`,
    })),
    ...devlog.map((log) => ({
      title: log.data.title,
      pubDate: log.data.pubDate,
      description: log.data.description,
      link: `/devlog/${log.id}/`,
    })),
  ].sort((a, b) => b.pubDate.valueOf() - a.pubDate.valueOf());

  return rss({
    title: 'Jordan Thirkle | Creator Hub',
    description: 'A highly optimized, minimalist developer portfolio and blog.',
    site: context.site!,
    items,
  });
}
