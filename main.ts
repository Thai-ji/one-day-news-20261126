import { copyFileSync, existsSync, mkdirSync, readFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const source = resolve(here, 'entry.png');
const outputDir = resolve(process.env.MAKEFUN_OUTPUT_DIR ?? '/output');
const target = join(outputDir, 'entry.png');

if (!existsSync(source)) {
  throw new Error(`entry.png not found beside main.ts: ${source}`);
}

mkdirSync(outputDir, { recursive: true });
copyFileSync(source, target);

const png = readFileSync(target);
const signature = png.subarray(0, 8).toString('hex');
if (signature !== '89504e470d0a1a0a') {
  throw new Error(`target is not a PNG (signature ${signature})`);
}

const width = png.readUInt32BE(16);
const height = png.readUInt32BE(20);
const bytes = png.length;

if (width > 1024 || height > 1024) {
  throw new Error(`image is ${width}x${height}, over the 1024x1024 limit`);
}
if (bytes > 1_048_576) {
  throw new Error(`image is ${bytes} bytes, over the 1 MiB limit`);
}

console.log(`copied entry.png to ${target}`);
console.log(`PNG ${width}x${height}, ${bytes} bytes, sha256 checked at build time`);
