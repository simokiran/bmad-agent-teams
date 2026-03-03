#!/usr/bin/env node
/**
 * BMad Agent Teams CLI
 * Installs the 15-agent BMad Method into any project directory
 */

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const YELLOW = '\x1b[1;33m';
const GREEN = '\x1b[0;32m';
const BLUE = '\x1b[0;34m';
const BOLD = '\x1b[1m';
const NC = '\x1b[0m';

// Parse command line arguments
const args = process.argv.slice(2);
const command = args[0] || 'help';

function printHeader() {
  console.log(`${BOLD}`);
  console.log('╔══════════════════════════════════════════════════╗');
  console.log('║  BMad Method — 15-Agent AI Development Team     ║');
  console.log('║  Claude Code Extension                           ║');
  console.log('╚══════════════════════════════════════════════════╝');
  console.log(`${NC}\n`);
}

function printHelp() {
  printHeader();
  console.log('Usage:');
  console.log('  npx @bmad-code/agent-teams install [directory] [options]');
  console.log('');
  console.log('Commands:');
  console.log('  install [dir]    Install BMad Method to directory (default: current)');
  console.log('  update [dir]     Update agents/commands/scripts (preserves project state)');
  console.log('  help             Show this help message');
  console.log('  version          Show version');
  console.log('');
  console.log('Options:');
  console.log('  --yes, -y        Skip confirmation prompts');
  console.log('  --force          Overwrite all files including config');
  console.log('  --update         Update mode (refresh plugin, preserve state)');
  console.log('');
  console.log('Examples:');
  console.log('  npx @bmad-code/agent-teams install');
  console.log('  npx @bmad-code/agent-teams install ./my-project --yes');
  console.log('  npx @bmad-code/agent-teams update ./my-project');
  console.log('  npx @bmad-code/agent-teams install ~/projects/webapp --force');
  console.log('');
}

function printVersion() {
  const pkg = require('./package.json');
  console.log(`BMad Agent Teams v${pkg.version}`);
}

function run(isUpdate) {
  // Find the command word index to parse args after it
  const cmdWord = isUpdate ? 'update' : 'install';
  const targetIndex = args.indexOf(cmdWord) + 1;
  let targetDir = '.';
  let autoYes = false;
  let force = false;
  let update = isUpdate;

  // Parse arguments
  for (let i = targetIndex; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--yes' || arg === '-y') {
      autoYes = true;
    } else if (arg === '--force') {
      force = true;
    } else if (arg === '--update') {
      update = true;
    } else if (!arg.startsWith('--')) {
      targetDir = arg;
    }
  }

  // Resolve target directory
  const target = path.resolve(process.cwd(), targetDir);

  // Check if directory exists
  if (!fs.existsSync(target)) {
    if (update) {
      console.error(`${YELLOW}Directory does not exist: ${targetDir}. Cannot update.${NC}`);
      process.exit(1);
    }
    fs.mkdirSync(target, { recursive: true });
  }

  // Run the install script
  const scriptPath = path.join(__dirname, 'install.sh');

  try {
    execSync(`bash "${scriptPath}" "${target}"`, {
      stdio: 'inherit',
      env: {
        ...process.env,
        BMAD_AUTO_YES: autoYes ? '1' : '0',
        BMAD_FORCE: force ? '1' : '0',
        BMAD_UPDATE: update ? '1' : '0'
      }
    });
  } catch (error) {
    console.error(`${YELLOW}${update ? 'Update' : 'Installation'} failed${NC}`);
    process.exit(1);
  }
}

// Main command router
switch (command) {
  case 'install':
    run(false);
    break;
  case 'update':
    run(true);
    break;
  case 'version':
  case '--version':
  case '-v':
    printVersion();
    break;
  case 'help':
  case '--help':
  case '-h':
  default:
    printHelp();
    break;
}
