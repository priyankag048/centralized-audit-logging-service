CREATE TABLE tenant_logs (
    id BIGSERIAL,
    tenant_id TEXT NOT NULL,
    log_time TIMESTAMP NOT NULL,
    source TEXT,
    log_level TEXT,
    message JSONB,
    created_at TIMESTAMP DEFAULT now(),
    PRIMARY KEY (id, log_time)
) PARTITION BY RANGE (log_time);