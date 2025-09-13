import { Sequelize } from 'sequelize';
import umzug from './umzug-config.ts';

const DB_CONN_STR: string = process.env.DB_CONN_STR!;


if (!DB_CONN_STR) {
  console.error('Environment variable DB_CONN_STR is not set.');
  process.exit(1);
}

// Create Sequelize instance
const sequelize = new Sequelize(DB_CONN_STR);


(async () => {
  try {
    await sequelize.authenticate();
    await umzug(sequelize).up();
    console.log('All SQL migrations applied successfully.');
    process.exit(0);
  } catch (err) {
    console.error('Migration failed:', err);
    process.exit(1);
  }
})();