import satori from 'satori';
import { html } from 'satori-html';
import * as fs from 'node:fs';
import * as path from 'node:path';
import { getCollection } from 'astro:content';
import { Resvg } from '@resvg/resvg-js';

export async function getStaticPaths() {
  const blogPosts = await getCollection('blog');
  const projectPosts = await getCollection('projects');
  const posts = [...blogPosts, ...projectPosts];
  
  return posts.map(post => ({
    params: { slug: post.id },
    props: { title: post.data.title },
  }));
}

export async function GET({ props }: { props: { title: string } }) {
  const fontPath = path.join(process.cwd(), 'src/assets/fonts/Inter-Medium.otf');
  const fontData = fs.readFileSync(fontPath);

  const markup = html`
    <div style="height: 100%; width: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: #09090b; color: white; padding: 40px; font-family: 'Inter';">
      <div style="display: flex; flex-direction: column; align-items: center; border: 1px solid #27272a; padding: 60px; border-radius: 24px; background-color: #111113;">
        <p style="font-size: 24px; color: #3b82f6; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.1em;">Jordan Thirkle // Intelligence Hub</p>
        <h1 style="font-size: 72px; font-weight: 700; text-align: center; margin-bottom: 20px;">${props.title}</h1>
        <div style="display: flex; align-items: center; margin-top: 20px;">
            <span style="font-size: 24px; color: #a1a1aa;">Engineering at the speed of AI</span>
        </div>
      </div>
    </div>
  `;

  const svg = await satori(markup as any, {
    width: 1200,
    height: 630,
    fonts: [
      {
        name: 'Inter',
        data: fontData,
        weight: 500,
        style: 'normal',
      },
    ],
  });

  const resvg = new Resvg(svg);
  const pngData = resvg.render();
  const pngBuffer = pngData.asPng();

  return new Response(pngBuffer as any, {
    headers: { 
      'Content-Type': 'image/png',
      'Cache-Control': 'public, max-age=31536000, immutable'
    },
  });
}
