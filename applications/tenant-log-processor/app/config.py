import os

KAFKA_BOOTSTRAP_SERVERS = os.getenv('KAFKA_BOOTSTRAP_SERVERS', 'kafka.logging.svc.cluster.local:9092')
KAFKA_TOPICS = os.getenv('KAFKA_TOPICS', 'tenant-logs')

POSTGRES_HOST = os.getenv('POSTGRES_HOST', 'postgresql.logging.svc.cluster.local')
POSTGRES_PORT = int(os.getenv('POSTGRES_PORT', '5432'))
POSTGRES_USER = os.getenv('POSTGRES_USER', '')
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD', '')
POSTGRES_DB = os.getenv('POSTGRES_DB', 'auditdb')

