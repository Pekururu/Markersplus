import { Resvg } from '@resvg/resvg-js';
import { copyFile, mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const toolsPath = process.argv[2] || process.env.ARMA3_TOOLS;
if (!toolsPath) {
  throw new Error('Pass the Arma 3 Tools directory or set ARMA3_TOOLS.');
}
const converter = join(toolsPath, 'ImageToPAA', 'ImageToPAA.exe');
const output = join(root, '.build', 'icons');
await mkdir(output, { recursive: true });

const jobs = [
  ['icons', join(root, 'addons', 'MarkersPlus', 'data', 'img')],
  ['ui', join(root, 'addons', 'MarkersPlus_UI', 'data')],
  ['branding', join(root, 'addons', 'MarkersPlus', 'data')],
];
for (const [folder, destination] of jobs) {
  if (process.argv.includes('--ui-only') && folder !== 'ui') continue;
  if (process.argv.includes('--branding-only') && folder !== 'branding') continue;
  const sources = join(root, 'artwork', folder);
  let files;
  try {
    files = await readdir(sources);
  } catch (error) {
    // Branding sources are local-only; fresh checkouts keep the runtime PAA.
    if (folder === 'branding' && error.code === 'ENOENT' && !process.argv.includes('--branding-only')) continue;
    throw error;
  }
  await mkdir(destination, { recursive: true });
  for (const file of files.filter(file => file.endsWith('.svg')).sort()) {
    const stem = folder === 'branding' ? 'logo' : file.slice(0, -4);
    const png = join(output, `${stem}_ca.png`);
    const paa = join(destination, `${stem}.paa`);
    const svg = await readFile(join(sources, file));
    const rendered = new Resvg(svg, { fitTo: { mode: 'width', value: folder === 'branding' ? 1024 : 256 } });
    await writeFile(png, rendered.render().asPng());
    const result = spawnSync(converter, [png, paa], { encoding: 'utf8', windowsHide: true });
    if (result.error || result.status !== 0) {
      throw result.error || new Error(`Texture conversion failed for ${file}: ${result.stdout}\n${result.stderr}`);
    }
    console.log(`Built ${stem}.paa`);
    if (folder === 'branding') {
      await copyFile(paa, join(destination, 'logoOver.paa'));
    }
  }
}
