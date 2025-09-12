import winston from 'winston';
import { faker } from '@faker-js/faker/locale/en';

const tenant_id = process.env.TENANT_ID;

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'tenantlogs.log' })
  ]
});

const generateLog = () => {
  const service = `service for ${tenant_id}`;
  const log_level = ['info', 'warn', 'error'][Math.floor(Math.random() * 3)];
  return {
    timestamp: new Date().toISOString(),
    tenant_id,
    service,
    log_level,
    message: faker.lorem.sentence(),
    user: faker.person.fullName(),
    topic: "tenant-logs"
  }

}

const batchSize = 10;
for (let i = 0; i < batchSize; i++) {
  const log = generateLog();
  logger.log(log.log_level, log);
}

console.log(`TenantLogSim executed: generated ${batchSize} multi-tenant logs.`);




