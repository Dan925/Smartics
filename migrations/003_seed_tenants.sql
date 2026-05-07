-- Dev/test seed data. Two tenants with hardcoded API keys.
-- Safe to re-run thanks to ON CONFLICT.

INSERT INTO tenants (id, name, api_key) VALUES
    ('acme',   'Acme Corp',   'sk_test_acme_001'),
    ('globex', 'Globex Ltd',  'sk_test_globex_001')
ON CONFLICT (id) DO NOTHING;
