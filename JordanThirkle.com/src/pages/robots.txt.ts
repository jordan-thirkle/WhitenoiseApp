import type { APIRoute } from 'astro';

/**
 * Advanced Crawler Strategy (2026 Tiered Intent Model)
 * 
 * 1. Discovery (ALLOW): Real-time retrieval for OAI-SearchBot, Perplexity, etc.
 * 2. Parametric (ALLOW): Training data for GPTBot, ClaudeBot to build long-term authority.
 * 3. Bad Actors (BLOCK): High-load, low-value crawlers like Bytespider and CCBot.
 */

const robotsTxt = `
User-agent: *
Allow: /

# Sitemap
Sitemap: ${new URL('sitemap-index.xml', import.meta.env.SITE).href}

# TIER 1 & 2: GENERATIVE DISCOVERY & PARAMETRIC AUTHORITY
# We allow these to ensure Jordan Thirkle is cited in AI-driven search and training.
User-agent: OAI-SearchBot
Allow: /

User-agent: GPTBot
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: Claude-Web
Allow: /

User-agent: Google-Extended
Allow: /

# TIER 3: PROTECTIVE BLOCKLIST (Resource Preservation)
# Blocking high-load scrapers that provide zero authority or lead-gen value.
User-agent: Bytespider
Disallow: /

User-agent: CCBot
Disallow: /

User-agent: Amazonbot
Disallow: /

User-agent: FacebookBot
Disallow: /

# DUAA (2026) Compliance: Data subjects may use /contact for formal complaints.
`.trim();

export const GET: APIRoute = () => {
  return new Response(robotsTxt, {
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
    },
  });
};
