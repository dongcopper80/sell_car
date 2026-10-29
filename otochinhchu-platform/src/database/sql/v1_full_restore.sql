-- ============================================================
-- OtoChinhChu — Full restore v1: schema + data trong 1 lần chạy
-- Dùng khi setup môi trường mới từ đầu (dev machine, CI, staging)
-- Chạy:  npm run db:restore   (hoặc psql -h HOST -U USER -d DB -f file này)
-- ============================================================

\i v1_schema.sql
\i v1_data.sql

-- Verify nhanh
SELECT 'users' AS tbl, COUNT(*) FROM users
UNION ALL SELECT 'business_accounts', COUNT(*) FROM business_accounts
UNION ALL SELECT 'catalog_items', COUNT(*) FROM catalog_items
UNION ALL SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL SELECT 'deposits', COUNT(*) FROM deposits
UNION ALL SELECT 'notifications', COUNT(*) FROM notifications;
