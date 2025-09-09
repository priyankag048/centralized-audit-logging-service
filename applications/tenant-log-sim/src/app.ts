import winston from 'winston';
import { faker } from '@faker-js/faker/locale/en';
import { tenants, logIntervalMs } from './config.ts';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'tenantlogs.log' })
  ]
});

const generateLog = () => {
  const tenant_id = tenants[Math.floor(Math.random() * tenants.length)];
  const service = `service for ${tenant_id}`;
  const log_level = ['info', 'warn', 'error'][Math.floor(Math.random() * 3)];
  return {
    timestamp: new Date().toISOString(),
    tenant_id,
    service,
    log_level,
    message: faker.lorem.sentence(),
    user: faker.person.fullName()
  }

}

console.log('TenantLogSim started: generating multi-tenant logs every', logIntervalMs, 'ms...');

setInterval(() => {
  const log = generateLog();
  logger.log(log.log_level, log);
}, logIntervalMs);



