const fs = require('fs');
const html = fs.readFileSync('index.html', 'utf8');

const srcMatches = Array.from(html.matchAll(/src=["']\.\/assets\/([^"']+)["']/g)).map(m => m[1]);
console.log('Testing', srcMatches.length, 'src attributes:');
let missing = 0;
for (const p of srcMatches) {
  const full = 'assets/' + p;
  if (!fs.existsSync(full)) {
    console.error('MISSING SRC:', full);
    missing++;
  }
}

const modalMatches = Array.from(html.matchAll(/openQuietModal\([^,]+,\s*'([^']+)'/g)).map(m => m[1]);
console.log('Testing', modalMatches.length, 'modal image paths:');
for (const p of modalMatches) {
  const full = 'assets/' + p;
  if (!fs.existsSync(full)) {
    console.error('MISSING MODAL IMG:', full);
    missing++;
  }
}

const docMatches = Array.from(html.matchAll(/href=["']\.\/assets\/([^"']+)["']/g)).map(m => m[1]);
console.log('Testing', docMatches.length, 'doc links:');
for (const p of docMatches) {
  const full = 'assets/' + p;
  if (!fs.existsSync(full)) {
    console.error('MISSING DOC LINK:', full);
    missing++;
  }
}

if (missing === 0) {
  console.log('ALL', (srcMatches.length + modalMatches.length + docMatches.length), 'ASSET PATHS ARE 100% VALID!');
} else {
  console.error(missing, 'assets are missing!');
  process.exit(1);
}
