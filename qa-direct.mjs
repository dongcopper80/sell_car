// qa-direct.mjs — chụp Flutter app Chrome không qua script-file (gặp 403 với script mode)
export default async function run(page) {
  await page.goto('http://localhost:62800/', { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(10000);
  await page.screenshot({ path: 'c:/Projects/oto/otochinhchu-platform/app-final.png' });
  return 'ok';
}
