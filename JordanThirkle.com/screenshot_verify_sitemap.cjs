const { chromium } = require('playwright');
const http = require('http');

async function waitForServer() {
  return new Promise((resolve) => {
    const interval = setInterval(() => {
      http.get('http://localhost:4321', (res) => {
        if (res.statusCode === 200) {
          clearInterval(interval);
          resolve();
        }
      }).on('error', () => {});
    }, 1000);
  });
}

(async () => {
  console.log("Waiting for server...");
  await waitForServer();
  console.log("Server is up. Taking screenshot...");
  const browser = await chromium.launch();
  const page = await browser.newPage();

  await page.goto('http://localhost:4321/blog/sitemap-seo-ai-2026');
  await page.screenshot({ path: 'screenshot_sitemap_blog.png', fullPage: true });

  await browser.close();
  console.log("Screenshots taken.");
})();
