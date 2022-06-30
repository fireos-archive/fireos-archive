import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { globby } from 'globby';
import fse from 'fs-extra';
import { Liquid } from 'liquidjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const devices = [
  { slug: 'Fire_7_Gen_12', name: 'Fire (7", 12th gen.)' },
  { slug: 'Fire_HD_10_Gen_11', name: 'Fire HD (10", 11th gen.)' },
  { slug: 'Fire_HD_10_Plus_Gen_11', name: 'Fire HD Plus (10", 11th gen.)' },
  { slug: 'Fire_HD_8_Gen_10', name: 'Fire HD (8", 10th gen.)' },
  { slug: 'Fire_HD_8_Plus_Gen_10', name: 'Fire HD Plus (8", 10th gen.)' },
  { slug: 'Fire_7_Gen_9', name: 'Fire (7", 9th gen.)' },
  { slug: 'Fire_HD_10_Gen_9', name: 'Fire HD (10", 9th gen.)' },
  { slug: 'Fire_HD_8_Gen_8', name: 'Fire HD (8", 8th gen.)' },
  { slug: 'Fire_7_Gen_7', name: 'Fire (7", 7th gen.)' },
  { slug: 'Fire_HD_8_Gen_7', name: 'Fire HD (8", 7th gen.)' },
  { slug: 'Fire_HD_10_Gen_7', name: 'Fire HD (10", 7th gen.)' },
  { slug: 'Fire_HD_8_Gen_6', name: 'Fire HD (8", 6th gen.)' },
  { slug: 'Fire_HD_8_Gen_5', name: 'Fire HD (8", 5th gen.)' },
  { slug: 'Fire_HD_10_Gen_5', name: 'Fire HD (10", 5th gen.)' },
  { slug: 'Fire_7_Gen_5', name: 'Fire (7", 5th gen.)' },
  { slug: 'Fire_HD_6_Gen_4', name: 'Fire HD (6", 4th gen.)' },
  { slug: 'Fire_HD_7_Gen_4', name: 'Fire HD (7", 4th gen.)' },
  { slug: 'Fire_HDX_8.9_Gen_4', name: 'Fire HDX (8.9", 4th gen.)' },
  { slug: 'Fire_HD_7_Gen_3', name: 'Kindle Fire HD (7", 3rd gen.)' },
  { slug: 'Fire_HDX_7_Gen_3', name: 'Kindle Fire HDX (7", 3rd gen.)' },
  { slug: 'Fire_HDX_8.9_Gen_3', name: 'Kindle Fire HDX (8.9", 3rd gen.)' },
  { slug: 'Fire_HD_7_Gen_2', name: 'Kindle Fire HD (7", 2nd gen.)' },
  { slug: 'Fire_HD_8.9_Gen_2', name: 'Kindle Fire HD (8.9", 2nd gen.)' },
  { slug: 'Fire_7_Gen_2', name: 'Kindle Fire (7", 1st gen.)' },
];

for (const device of devices) {
  Object.assign(device, { versions: [] });

  const files = await globby('./*.json', {
    cwd: path.resolve(__dirname, '../data', device.slug),
    absolute: true,
  });

  for (const file of files) {
    device.versions.push(await fse.readJSON(file));
  }

  device.versions
    .sort((a, b) => {
      return a.os_version.localeCompare(b.os_version, undefined, { numeric: true });
    })
    .reverse();
}

const engine = new Liquid();
const result = await engine.parseAndRender(await fse.readFile(path.resolve(__dirname, 'TEMPLATE.md'), 'utf-8'), {
  devices,
});

await fse.writeFile(path.resolve(__dirname, '../README.md'), result, 'utf-8');
