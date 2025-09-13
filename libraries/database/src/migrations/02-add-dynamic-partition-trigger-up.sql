CREATE OR REPLACE FUNCTION create_partition_if_not_exists()
RETURNS TRIGGER AS $$
DECLARE
  partition_name TEXT;
  start_date DATE;
  end_date DATE;
  create_sql TEXT;
  partition_exists INT;
BEGIN
    partition_name := 'tenant_logs_' || to_char(NEW.log_time, 'YYYYMM');
    start_date := date_trunc('month', NEW.log_time)::DATE;
    end_date := (start_date + INTERVAL '1 month')::DATE;

    SELECT COUNT(*) INTO partition_exists
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = partition_name;

    IF partition_exists = 0 THEN
        create_sql := format(
            'CREATE TABLE %I PARTITION OF tenant_logs FOR VALUES FROM (%L) TO (%L);',
            partition_name,
            start_date,
            end_date
        );
        EXECUTE create_sql;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tenant_logs_insert_trigger
BEFORE INSERT ON tenant_logs
FOR EACH ROW EXECUTE FUNCTION create_partition_if_not_exists();
