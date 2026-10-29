-- ============================================================
-- OtoChinhChu — v1 Schema (PostgreSQL)
-- KHỚP cấu trúc TypeORM thực tế: columns giữ nguyên camelCase property name.
-- Idempotent. Chạy:  npm run db:schema:v1
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$ BEGIN
  CREATE TYPE users_role_enum AS ENUM ('buyer','seller_personal','business','admin');
  CREATE TYPE users_status_enum AS ENUM ('active','pending','suspended');
  CREATE TYPE business_accounts_status_enum AS ENUM ('active','pending','suspended');
  CREATE TYPE business_documents_doc_type_enum AS ENUM ('business_license','tax_code','bank_confirmation','representative_id','authorization_letter');
  CREATE TYPE vehicles_seller_type_enum AS ENUM ('personal','business');
  CREATE TYPE vehicles_status_enum AS ENUM ('draft','pending_review','published','rejected','sold','expired');
  CREATE TYPE deposits_status_enum AS ENUM ('pending_payment','verifying','paid','disputed','refunded');
  CREATE TYPE audit_logs_action_enum AS ENUM ('business_account.create','business_account.status','vehicle.moderate','deposit.confirm','auth.login');
  CREATE TYPE notifications_channel_enum AS ENUM ('in_app','push','sms');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================ users
CREATE TABLE IF NOT EXISTS users (
  id                 UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email              VARCHAR(180) UNIQUE,
  phone              VARCHAR(20)  UNIQUE,
  "fullName"         VARCHAR(150) NOT NULL,
  "passwordHash"     VARCHAR(100),
  role               users_role_enum    NOT NULL DEFAULT 'buyer',
  status             users_status_enum  NOT NULL DEFAULT 'active',
  "identityVerified" BOOLEAN      NOT NULL DEFAULT FALSE,
  "vneidToken"       VARCHAR(64)  UNIQUE,
  cccd               VARCHAR(12),
  "avatarUrl"        VARCHAR(255),
  address            VARCHAR(255),
  "provinceCode"     VARCHAR(10),
  "createdAt"        TIMESTAMP    NOT NULL DEFAULT NOW(),
  "updatedAt"        TIMESTAMP    NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS IDX_users_role_status ON users (role, status);

-- ============================================================ business_accounts
CREATE TABLE IF NOT EXISTS business_accounts (
  id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code                    VARCHAR(20)  UNIQUE NOT NULL,
  "ownerId"               UUID NOT NULL,
  "companyName"           VARCHAR(200) NOT NULL,
  "businessLicenseNumber" VARCHAR(50)  UNIQUE NOT NULL,
  "taxCode"               VARCHAR(20)  UNIQUE NOT NULL,
  "representativeName"    VARCHAR(150) NOT NULL,
  email                   VARCHAR(180) NOT NULL,
  phone                   VARCHAR(20),
  address                 VARCHAR(255) NOT NULL,
  "bankName"              VARCHAR(150) NOT NULL,
  "bankAccountNumber"     VARCHAR(30)  NOT NULL,
  "bankAccountHolder"     VARCHAR(150) NOT NULL,
  "documentsVerified"     BOOLEAN NOT NULL DEFAULT FALSE,
  "verifiedAt"            TIMESTAMP,
  "createdById"           UUID,
  status                  business_accounts_status_enum NOT NULL DEFAULT 'pending',
  "createdAt"             TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt"             TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS IDX_ba_status ON business_accounts (status);

-- ============================================================ business_documents
CREATE TABLE IF NOT EXISTS business_documents (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "businessAccountId" UUID NOT NULL,
  "docType"           business_documents_doc_type_enum NOT NULL,
  "fileUrl"           VARCHAR(500) NOT NULL,
  verified            BOOLEAN NOT NULL DEFAULT FALSE,
  "verifiedById"      UUID,
  note                VARCHAR(300),
  "createdAt"         TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_bd_account_type ON business_documents ("businessAccountId", "docType");

-- ============================================================ catalog_items
CREATE TABLE IF NOT EXISTS catalog_items (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "groupCode" VARCHAR(40) NOT NULL,
  code        VARCHAR(60) NOT NULL,
  "parentId"  UUID,
  name        VARCHAR(150) NOT NULL,
  "sortOrder" INT NOT NULL DEFAULT 0,
  "isActive"  BOOLEAN NOT NULL DEFAULT TRUE,
  metadata    JSONB,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_ci_group_code ON catalog_items ("groupCode", code);

-- ============================================================ vehicles
CREATE TABLE IF NOT EXISTS vehicles (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "sellerId"          UUID NOT NULL,
  "sellerType"        vehicles_seller_type_enum NOT NULL,
  "businessAccountId" UUID,
  title               VARCHAR(200) NOT NULL,
  "makeId"            UUID,
  "modelId"           UUID,
  year                INT NOT NULL,
  "odometerKm"        INT NOT NULL,
  transmission        VARCHAR(20) NOT NULL,
  "fuelType"          VARCHAR(20) NOT NULL,
  "priceVnd"          BIGINT NOT NULL,
  location            VARCHAR(120) NOT NULL,
  "provinceCode"      VARCHAR(10) NOT NULL,
  description         TEXT,
  photos              JSONB,
  status              vehicles_status_enum NOT NULL DEFAULT 'draft',
  verified            BOOLEAN NOT NULL DEFAULT FALSE,
  "moderatedById"     UUID,
  "moderationNote"    VARCHAR(300),
  "viewCount"         INT NOT NULL DEFAULT 0,
  "createdAt"         TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt"         TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS IDX_v_status_province ON vehicles (status, "provinceCode");
CREATE INDEX IF NOT EXISTS IDX_v_make_model ON vehicles ("makeId", "modelId");

-- ============================================================ deposits
CREATE TABLE IF NOT EXISTS deposits (
  id                 UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "referenceCode"    VARCHAR(30) UNIQUE NOT NULL,
  "buyerId"          UUID NOT NULL,
  "vehicleId"        UUID NOT NULL,
  "amountVnd"        BIGINT NOT NULL,
  status             deposits_status_enum NOT NULL DEFAULT 'pending_payment',
  "paymentReference" VARCHAR(100),
  "confirmedAt"      TIMESTAMP,
  "createdAt"        TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt"        TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS IDX_d_status ON deposits (status);

-- ============================================================ audit_logs
CREATE TABLE IF NOT EXISTS audit_logs (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "actorId"   UUID,
  action      audit_logs_action_enum NOT NULL,
  "entityType" VARCHAR(40) NOT NULL,
  "entityId"  VARCHAR(64) NOT NULL,
  payload     JSONB,
  ip          VARCHAR(45),
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS IDX_audit_entity ON audit_logs ("entityType", "entityId");

-- ============================================================ notifications
CREATE TABLE IF NOT EXISTS notifications (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId"   UUID NOT NULL,
  title      VARCHAR(200) NOT NULL,
  body       TEXT,
  link       VARCHAR(40),
  channel    notifications_channel_enum NOT NULL DEFAULT 'in_app',
  "isRead"   BOOLEAN NOT NULL DEFAULT FALSE,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS IDX_notif_user_read ON notifications ("userId", "isRead");
