const fs = require('fs');
const path = require('path');

const dataDir = process.env.DATA_DIR || '/data';
const templateDir = '/app/data-templates';

// Ensure data directory exists
if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
}

// Copy template databases if they don't exist in data dir
const templates = [
    'terminologue.template.sqlite',
    'lang.template.sqlite',
    'siteconfig.template.json'
];

templates.forEach(file => {
    const src = path.join(templateDir, file);
    const destName = file.replace('.template', '');
    const dest = path.join(dataDir, destName);
    
    if (!fs.existsSync(dest) && fs.existsSync(src)) {
        console.log(`Copying ${file} to ${destName}`);
        fs.copyFileSync(src, dest);
    }
});

console.log('Data initialization complete.');
