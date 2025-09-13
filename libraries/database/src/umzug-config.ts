import { Umzug, SequelizeStorage } from 'umzug';
import path from 'path';
import { fileURLToPath } from 'url';
import { Sequelize } from 'sequelize';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const umzug = (sequelize: Sequelize) => new Umzug({
  migrations: {
    glob: path.resolve(__dirname, 'migrations/*up.sql'),
    resolve: ({ name, path: migrationPath, context }) => {
      return {
        name,
        up: async () => {
          const sql = fs.readFileSync(migrationPath!, 'utf8');
          return context.query(sql);
        },
        down: async () => {
          throw new Error('Down migrations not implemented for .sql files');
        }
      };
    },
  },
  context: sequelize,
  storage: new SequelizeStorage({ sequelize }),
  logger: console,
});

export default umzug;
