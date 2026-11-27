// Entry program for make.fun news-image-20261126 (Node 22, standard library only).
// Validates entry.png beside this file (PNG signature, IHDR dimensions, 1 MiB cap),
// then copies it byte-for-byte to MAKEFUN_OUTPUT_DIR (or /output inside the grader).

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { createHash } from 'node:crypto';

const MAX_BYTES = 1_048_576;
const MAX_DIM = 1024;

const src = new URL('./entry.png', import.meta.url);
const buf = readFileSync(src);

const pngSig = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
if (buf.length < 24 || !buf.subarray(0, 8).equals(pngSig)) {
  throw new Error('entry.png is not a PNG file');
}
const width = buf.readUInt32BE(16);
const height = buf.readUInt32BE(20);
if (width > MAX_DIM || height > MAX_DIM) {
  throw new Error(`entry.png is ${width}x${height}, over ${MAX_DIM}px`);
}
if (buf.length > MAX_BYTES) {
  throw new Error(`entry.png is ${buf.length} bytes, over ${MAX_BYTES}`);
}

const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
mkdirSync(outDir, { recursive: true });
const dest = join(outDir, 'entry.png');
writeFileSync(dest, buf);

const sha256 = createHash('sha256').update(buf).digest('hex');
console.log(`entry.png ${width}x${height} ${buf.length} bytes sha256=${sha256} -> ${dest}`);
