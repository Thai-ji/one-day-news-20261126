/**
 * make.fun entry wrapper for news-image-20261126.
 * Validates the rendered PNG (signature, IHDR dimensions, 1 MiB cap) and copies
 * it to the output directory requested by the harness.
 */
import { copyFileSync, mkdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const MAX_BYTES = 1_048_576;
const MAX_SIDE = 1024;
const PNG_SIGNATURE = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];

const here = dirname(fileURLToPath(import.meta.url));
const source = join(here, "entry.png");

const bytes = readFileSync(source);

if (bytes.length > MAX_BYTES) {
  throw new Error(`entry.png is ${bytes.length} bytes, over the ${MAX_BYTES} byte cap`);
}
if (bytes.length < 24) {
  throw new Error("entry.png is too short to contain a PNG header");
}
for (let i = 0; i < PNG_SIGNATURE.length; i += 1) {
  if (bytes[i] !== PNG_SIGNATURE[i]) {
    throw new Error(`entry.png has an invalid PNG signature at byte ${i}`);
  }
}
const width = bytes.readUInt32BE(16);
const height = bytes.readUInt32BE(20);
if (width > MAX_SIDE || height > MAX_SIDE) {
  throw new Error(`entry.png is ${width}x${height}, over the ${MAX_SIDE}x${MAX_SIDE} limit`);
}

const outputDir = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";
mkdirSync(outputDir, { recursive: true });
const destination = join(outputDir, "entry.png");
copyFileSync(source, destination);

console.log(`entry.png OK: ${width}x${height}, ${bytes.length} bytes -> ${destination}`);
