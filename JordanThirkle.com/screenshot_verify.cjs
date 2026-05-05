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

  await page.goto('http://localhost:4321/blog');
  await page.screenshot({ path: 'screenshot_blog.png', fullPage: true });

  await page.goto('http://localhost:4321/blog/app-store-approval-guide');
  await page.screenshot({ path: 'screenshot_app_store_approval.png', fullPage: true });

  await page.goto('http://localhost:4321/blog/app-store-ranking-guide');
  await page.screenshot({ path: 'screenshot_app_store_ranking.png', fullPage: true });

  await browser.close();
  console.log("Screenshots taken.");
})();
