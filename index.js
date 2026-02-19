/**
 * BMad Agent Teams - Main Module
 *
 * This package installs the BMad Method (Breakthrough Method for Agile AI-Driven Development)
 * into your project as a Claude Code extension.
 *
 * Usage:
 *   npx @bmad-code/agent-teams install
 *
 * Or programmatically:
 *   const bmad = require('@bmad-code/agent-teams');
 *   bmad.install('/path/to/project');
 */

const { execSync } = require('child_process');
const path = require('path');

module.exports = {
  /**
   * Install BMad Method to a target directory
   * @param {string} targetDir - Target project directory
   * @param {Object} options - Installation options
   * @param {boolean} options.force - Overwrite existing files
   * @param {boolean} options.autoYes - Skip confirmation prompts
   * @returns {boolean} Success status
   */
  install: function(targetDir = '.', options = {}) {
    const scriptPath = path.join(__dirname, 'install.sh');
    const target = path.resolve(process.cwd(), targetDir);

    try {
      const cmd = `bash "${scriptPath}" "${target}"`;
      execSync(cmd, {
        stdio: 'inherit',
        env: {
          ...process.env,
          BMAD_FORCE: options.force ? '1' : '0',
          BMAD_AUTO_YES: options.autoYes ? '1' : '0'
        }
      });
      return true;
    } catch (error) {
      console.error('Installation failed:', error.message);
      return false;
    }
  },

  /**
   * Get version information
   * @returns {string} Version string
   */
  version: function() {
    const pkg = require('./package.json');
    return pkg.version;
  }
};
