import fs from 'node:fs/promises';
import path from 'node:path';

// Using fetch to interact with GitHub REST API
async function fetchRecentActivity(actor: string, token: string) {
  // We'll fetch events for the user to find recent pushes, issues, PRs
  const response = await fetch(`https://api.github.com/users/${actor}/events`, {
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/vnd.github.v3+json',
      'User-Agent': 'Astro-Blog-Generator'
    }
  });

  if (!response.ok) {
    throw new Error(`Failed to fetch GitHub events: ${response.statusText}`);
  }

  const events = await response.json();

  // Filter for the last 14 days
  const fourteenDaysAgo = new Date();
  fourteenDaysAgo.setDate(fourteenDaysAgo.getDate() - 14);

  const recentEvents = events.filter((e: any) => new Date(e.created_at) > fourteenDaysAgo);

  const activity = [];
  for (const event of recentEvents) {
    const repoName = event.repo.name;
    if (event.type === 'PushEvent') {
      for (const commit of event.payload.commits) {
        activity.push(`Push to ${repoName} | Commit: ${commit.message}`);
      }
    } else if (event.type === 'IssuesEvent' && event.payload.action === 'opened') {
        activity.push(`Opened issue in ${repoName} | Title: ${event.payload.issue.title}`);
    } else if (event.type === 'PullRequestEvent' && event.payload.action === 'opened') {
        activity.push(`Opened PR in ${repoName} | Title: ${event.payload.pull_request.title}`);
    }
  }

  return activity;
}

async function generateBlogContent(activity: string[], geminiApiKey: string, slug: string) {
  const prompt = `You are an expert technical SEO copywriter and senior software architect.

Your task is to write a highly technical, SEO-optimized blog post for an Astro 6 portfolio site.

1. Review my recent GitHub activity, open issues, or a designated "ideas" folder/issue in my repository to determine the topic. The topic should be centered around: AI workflows for developers, Astro/React performance optimization, minimalist web architecture, or indie hacking.
Here is my recent GitHub activity:
${activity.length > 0 ? activity.join('\n') : "No significant activity found. Write about AI workflows for developers or minimalist web architecture."}

2. Write a comprehensive, deeply technical blog post (800-1500 words). Include real code snippets (TS/React/Astro), architectural diagrams (using markdown or mermaid if supported), and actionable takeaways.
3. Optimize for semantic SEO: use appropriate H2/H3 tags, bold key concepts, and structure the post for readability (scannable lists, short paragraphs).
4. The tone must be authoritative, pragmatic, and devoid of marketing fluff. Speak from the perspective of an experienced full-stack builder building fast, resilient systems.
5. Format the output as an MDX file and commit it directly to my portfolio repository under the directory \`src/data/blog/\`.
6. Use the following frontmatter schema:

---
title: "[SEO-Optimized, click-worthy but highly technical title]"
description: "[160-character maximum meta description summarizing the technical value proposition]"
pubDate: ${new Date().toISOString().split('T')[0]}
category: "[Choose ONE: AI, Web Development, Systems, Design, Productivity]"
tags: ["[Tag 1]", "[Tag 2]", "[Tag 3]"]
readTime: "[X] min read"
draft: false
image: "/assets/blog/${slug}.png"
---

**TL;DR:** [2-3 sentence summary of the article's core technical thesis]

[Main article body]`;

  const requestBody = {
    contents: [
      {
        parts: [
          { text: prompt }
        ]
      }
    ],
    generationConfig: {
      temperature: 0.7,
      maxOutputTokens: 8192,
    }
  };

  const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${geminiApiKey}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(requestBody)
  });

  if (!response.ok) {
    throw new Error(`Failed to generate content: ${response.statusText}`);
  }

  const data = await response.json();
  let text = data.candidates?.[0]?.content?.parts?.[0]?.text || '';

  // Clean up any markdown code block wrappers
  text = text.replace(/^\`\`\`(md|mdx|markdown)?\n/, '').replace(/\n\`\`\`$/, '');
  return text;
}

async function main() {
  try {
    const githubToken = process.env.GITHUB_TOKEN;
    const geminiApiKey = process.env.GEMINI_API_KEY;
    const githubActor = process.env.GITHUB_ACTOR || 'google-labs-jules'; // fallback

    if (!githubToken || !geminiApiKey) {
      console.error('Missing required environment variables: GITHUB_TOKEN or GEMINI_API_KEY');
      process.exit(1);
    }

    console.log('Fetching recent activity...');
    const activity = await fetchRecentActivity(githubActor, githubToken);

    console.log(`Found ${activity.length} activity events. Generating Blog Post...`);
    const dateStr = new Date().toISOString().split('T')[0];
    const slug = `automated-blog-${dateStr}`;

    const blogContent = await generateBlogContent(activity, geminiApiKey, slug);

    const filename = `${slug}.mdx`;
    const filepath = path.join(process.cwd(), 'src', 'data', 'blog', filename);

    await fs.mkdir(path.dirname(filepath), { recursive: true });
    await fs.writeFile(filepath, blogContent, 'utf-8');

    console.log(`Successfully generated Blog Post: ${filepath}`);
  } catch (error) {
    console.error('Error generating Blog Post:', error);
    process.exit(1);
  }
}

main();
