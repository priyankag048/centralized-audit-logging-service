ALTER TABLE tenant_logs ENABLE ROW LEVEL SECURITY;

-- Policy: only allow access to logs for the current tenant
CREATE POLICY tenant_access_policy
ON tenant_logs
FOR ALL
USING (tenant_id = current_setting('app.current_tenant'))
WITH CHECK (tenant_id = current_setting('app.current_tenant'));

