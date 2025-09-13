import { Sequelize } from 'sequelize';
import umzug from './umzug-config.ts';

const { POSTGRES_HOST, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB } = process.env;

const database_conn_str = `postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:5432/${POSTGRES_DB}`

  if (!database_conn_str) {
  console.error('Environment variable DB_CONN_STR is not set.');
  process.exit(1);
}

// Create Sequelize instance
const sequelize = new Sequelize(database_conn_str, {
  dialect: 'postgres',
});


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