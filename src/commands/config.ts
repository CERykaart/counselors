import type { Command } from 'commander';
import { CONFIG_FILE } from '../constants.js';
import { loadConfig } from '../core/config.js';
import { info } from '../ui/logger.js';

export function registerConfigCommand(program: Command): void {
  program
    .command('config')
    .description('Show resolved configuration')
    .action(() => {
      info(`Config file: ${CONFIG_FILE}\n`);
      const config = loadConfig();
      info(JSON.stringify(config, null, 2));
    });
}
