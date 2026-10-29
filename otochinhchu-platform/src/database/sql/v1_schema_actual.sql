--
-- PostgreSQL database dump
--

\restrict liR7I5Dl1rwZMhGEq5PBbICLcXs7KaD5uXX2snoCYWXgt8fBiCwOmCsyUeGvLG9

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: account_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.account_status AS ENUM (
    'active',
    'pending',
    'suspended'
);


--
-- Name: audit_action; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_action AS ENUM (
    'business_account.create',
    'business_account.status',
    'vehicle.moderate',
    'deposit.confirm',
    'auth.login'
);


--
-- Name: audit_logs_action_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_logs_action_enum AS ENUM (
    'business_account.create',
    'business_account.status',
    'vehicle.moderate',
    'deposit.confirm',
    'auth.login'
);


--
-- Name: business_accounts_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.business_accounts_status_enum AS ENUM (
    'active',
    'pending',
    'suspended'
);


--
-- Name: business_doc_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.business_doc_type AS ENUM (
    'business_license',
    'tax_code',
    'bank_confirmation',
    'representative_id',
    'authorization_letter'
);


--
-- Name: business_documents_doc_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.business_documents_doc_type_enum AS ENUM (
    'business_license',
    'tax_code',
    'bank_confirmation',
    'representative_id',
    'authorization_letter'
);


--
-- Name: deposit_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.deposit_status AS ENUM (
    'pending_payment',
    'verifying',
    'paid',
    'disputed',
    'refunded'
);


--
-- Name: deposits_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.deposits_status_enum AS ENUM (
    'pending_payment',
    'verifying',
    'paid',
    'disputed',
    'refunded'
);


--
-- Name: notification_channel; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_channel AS ENUM (
    'in_app',
    'push',
    'sms'
);


--
-- Name: notifications_channel_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notifications_channel_enum AS ENUM (
    'in_app',
    'push',
    'sms'
);


--
-- Name: seller_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.seller_type AS ENUM (
    'personal',
    'business'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'buyer',
    'seller_personal',
    'business',
    'admin'
);


--
-- Name: users_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.users_role_enum AS ENUM (
    'buyer',
    'seller_personal',
    'business',
    'admin'
);


--
-- Name: users_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.users_status_enum AS ENUM (
    'active',
    'pending',
    'suspended'
);


--
-- Name: vehicle_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vehicle_status AS ENUM (
    'draft',
    'pending_review',
    'published',
    'rejected',
    'sold',
    'expired'
);


--
-- Name: vehicles_seller_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vehicles_seller_type_enum AS ENUM (
    'personal',
    'business'
);


--
-- Name: vehicles_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vehicles_status_enum AS ENUM (
    'draft',
    'pending_review',
    'published',
    'rejected',
    'sold',
    'expired'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    actor_id uuid,
    action public.audit_logs_action_enum NOT NULL,
    entity_type character varying(40) NOT NULL,
    entity_id character varying(64) NOT NULL,
    payload text,
    ip character varying(45),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: business_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_accounts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    code character varying(20) NOT NULL,
    owner_id uuid NOT NULL,
    "companyName" character varying(200) NOT NULL,
    business_license_number character varying(50) NOT NULL,
    tax_code character varying(20) NOT NULL,
    representative_name character varying(150) NOT NULL,
    email character varying(180) NOT NULL,
    phone character varying(20),
    address character varying(255) NOT NULL,
    bank_name character varying(150) NOT NULL,
    bank_account_number character varying(30) NOT NULL,
    bank_account_holder character varying(150) NOT NULL,
    "documentsVerified" boolean DEFAULT false NOT NULL,
    verified_at timestamp with time zone,
    created_by_id uuid,
    status public.business_accounts_status_enum DEFAULT 'pending'::public.business_accounts_status_enum NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: business_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_documents (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_account_id uuid NOT NULL,
    doc_type public.business_documents_doc_type_enum NOT NULL,
    "fileUrl" character varying(500) NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    verified_by_id uuid,
    note character varying(300),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: catalog_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.catalog_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    group_code character varying(40) NOT NULL,
    code character varying(60) NOT NULL,
    parent_id uuid,
    name character varying(150) NOT NULL,
    "sortOrder" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    metadata text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: content_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_pages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    slug character varying(120) NOT NULL,
    title character varying(200) NOT NULL,
    summary text,
    body text,
    category character varying(40) DEFAULT 'legal'::character varying NOT NULL,
    status character varying(20) DEFAULT 'published'::character varying NOT NULL,
    updated_by_id uuid,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: deposits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deposits (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    reference_code character varying(30) NOT NULL,
    buyer_id uuid NOT NULL,
    vehicle_id uuid NOT NULL,
    amount_vnd bigint NOT NULL,
    status public.deposits_status_enum DEFAULT 'pending_payment'::public.deposits_status_enum NOT NULL,
    payment_reference character varying(100),
    confirmed_at timestamp with time zone,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    title character varying(200) NOT NULL,
    body text,
    link character varying(40),
    channel public.notifications_channel_enum DEFAULT 'in_app'::public.notifications_channel_enum NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(180),
    phone character varying(20),
    "fullName" character varying(150) NOT NULL,
    "passwordHash" character varying(100),
    role public.users_role_enum DEFAULT 'buyer'::public.users_role_enum NOT NULL,
    status public.users_status_enum DEFAULT 'active'::public.users_status_enum NOT NULL,
    "identityVerified" boolean DEFAULT false NOT NULL,
    "vneidToken" character varying(64),
    cccd character varying(12),
    "avatarUrl" character varying(255),
    address character varying(255),
    "provinceCode" character varying(10),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vehicles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    seller_id uuid NOT NULL,
    seller_type public.vehicles_seller_type_enum NOT NULL,
    business_account_id uuid,
    title character varying(200) NOT NULL,
    make_id uuid,
    model_id uuid,
    year integer NOT NULL,
    "odometerKm" integer NOT NULL,
    transmission character varying(20) NOT NULL,
    "fuelType" character varying(20) NOT NULL,
    price_vnd bigint NOT NULL,
    location character varying(120) NOT NULL,
    province_code character varying(10) NOT NULL,
    description text,
    photos text,
    status public.vehicles_status_enum DEFAULT 'draft'::public.vehicles_status_enum NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    moderated_by_id uuid,
    moderation_note character varying(300),
    view_count integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: vehicles PK_18d8646b59304dce4af3a9e35b6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT "PK_18d8646b59304dce4af3a9e35b6" PRIMARY KEY (id);


--
-- Name: audit_logs PK_1bb179d048bbc581caa3b013439; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "PK_1bb179d048bbc581caa3b013439" PRIMARY KEY (id);


--
-- Name: content_pages PK_5f7201667a2be0ed2f8f9a0876d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_pages
    ADD CONSTRAINT "PK_5f7201667a2be0ed2f8f9a0876d" PRIMARY KEY (id);


--
-- Name: notifications PK_6a72c3c0f683f6462415e653c3a; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "PK_6a72c3c0f683f6462415e653c3a" PRIMARY KEY (id);


--
-- Name: business_documents PK_860ab003b3f784b2492a245ee45; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_documents
    ADD CONSTRAINT "PK_860ab003b3f784b2492a245ee45" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: catalog_items PK_dd1c29828c10a599d894b9b6535; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT "PK_dd1c29828c10a599d894b9b6535" PRIMARY KEY (id);


--
-- Name: business_accounts PK_f375eab37ba95b445041794b721; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_accounts
    ADD CONSTRAINT "PK_f375eab37ba95b445041794b721" PRIMARY KEY (id);


--
-- Name: deposits PK_f49ba0cd446eaf7abb4953385d9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT "PK_f49ba0cd446eaf7abb4953385d9" PRIMARY KEY (id);


--
-- Name: business_accounts UQ_1ed48d7614b263ad96a36d91eaa; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_accounts
    ADD CONSTRAINT "UQ_1ed48d7614b263ad96a36d91eaa" UNIQUE (code);


--
-- Name: users UQ_6b39f5894823becc3893231699d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_6b39f5894823becc3893231699d" UNIQUE ("vneidToken");


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: users UQ_a000cca60bcf04454e727699490; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_a000cca60bcf04454e727699490" UNIQUE (phone);


--
-- Name: deposits UQ_f9b815f455e647fe6e36c2e02ae; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT "UQ_f9b815f455e647fe6e36c2e02ae" UNIQUE (reference_code);


--
-- Name: IDX_0026f343cb32333c4ffa95e3f6; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_0026f343cb32333c4ffa95e3f6" ON public.business_documents USING btree (business_account_id, doc_type);


--
-- Name: IDX_1360099bd018167c768e9cb441; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_1360099bd018167c768e9cb441" ON public.deposits USING btree (status);


--
-- Name: IDX_14b239657a26fad8abbbfc45fb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_14b239657a26fad8abbbfc45fb" ON public.business_accounts USING btree (status);


--
-- Name: IDX_4f6029c86fc6311ce19a944e0a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_4f6029c86fc6311ce19a944e0a" ON public.vehicles USING btree (make_id, model_id);


--
-- Name: IDX_6b39f5894823becc3893231699; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_6b39f5894823becc3893231699" ON public.users USING btree ("vneidToken");


--
-- Name: IDX_7421efc125d95e413657efa3c6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_7421efc125d95e413657efa3c6" ON public.audit_logs USING btree (entity_type, entity_id);


--
-- Name: IDX_7e70f808337ee8ffe4f20b03ce; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_7e70f808337ee8ffe4f20b03ce" ON public.catalog_items USING btree (group_code, code);


--
-- Name: IDX_97672ac88f789774dd47f7c8be; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_97672ac88f789774dd47f7c8be" ON public.users USING btree (email);


--
-- Name: IDX_a000cca60bcf04454e72769949; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_a000cca60bcf04454e72769949" ON public.users USING btree (phone);


--
-- Name: IDX_af08fad7c04bb85403970afdc1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_af08fad7c04bb85403970afdc1" ON public.notifications USING btree (user_id, is_read);


--
-- Name: IDX_ba_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_ba_status" ON public.business_accounts USING btree (status);


--
-- Name: IDX_c45ab97393957761d7016f4483; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_c45ab97393957761d7016f4483" ON public.business_accounts USING btree (tax_code);


--
-- Name: IDX_c4d16de14442cb5aa45c096788; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_c4d16de14442cb5aa45c096788" ON public.vehicles USING btree (status, province_code);


--
-- Name: IDX_cc23a46df001843d70d6c3c650; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_cc23a46df001843d70d6c3c650" ON public.content_pages USING btree (slug);


--
-- Name: IDX_d66355e4e1e8bb09c82f59202d; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_d66355e4e1e8bb09c82f59202d" ON public.business_accounts USING btree (business_license_number);


--
-- Name: IDX_d6ee2d4bf901675877bb94977c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_d6ee2d4bf901675877bb94977c" ON public.users USING btree (role, status);


--
-- Name: IDX_d_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_d_status" ON public.deposits USING btree (status);


--
-- Name: IDX_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_users_email" ON public.users USING btree (email);


--
-- Name: IDX_users_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_users_phone" ON public.users USING btree (phone);


--
-- Name: IDX_users_role_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_users_role_status" ON public.users USING btree (role, status);


--
-- Name: IDX_users_vneidToken; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_users_vneidToken" ON public.users USING btree ("vneidToken");


--
-- Name: idx_audit_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_entity ON public.audit_logs USING btree (entity_type, entity_id);


--
-- Name: idx_ba_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ba_status ON public.business_accounts USING btree (status);


--
-- Name: idx_ci_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ci_parent ON public.catalog_items USING btree (parent_id);


--
-- Name: idx_d_buyer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_d_buyer ON public.deposits USING btree (buyer_id);


--
-- Name: idx_d_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_d_status ON public.deposits USING btree (status);


--
-- Name: idx_notif_user_read; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_user_read ON public.notifications USING btree (user_id, is_read);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_phone ON public.users USING btree (phone);


--
-- Name: idx_users_role_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_role_status ON public.users USING btree (role, status);


--
-- Name: idx_v_make_model; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_v_make_model ON public.vehicles USING btree (make_id, model_id);


--
-- Name: idx_v_seller; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_v_seller ON public.vehicles USING btree (seller_id);


--
-- Name: idx_v_status_province; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_v_status_province ON public.vehicles USING btree (status, province_code);


--
-- Name: uq_bd_account_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_bd_account_type ON public.business_documents USING btree (business_account_id, doc_type);


--
-- Name: uq_ci_group_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_ci_group_code ON public.catalog_items USING btree (group_code, code);


--
-- Name: audit_logs FK_177183f29f438c488b5e8510cdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "FK_177183f29f438c488b5e8510cdb" FOREIGN KEY (actor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: business_documents FK_2fe94f7a3c2e824e8dc1e317358; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_documents
    ADD CONSTRAINT "FK_2fe94f7a3c2e824e8dc1e317358" FOREIGN KEY (business_account_id) REFERENCES public.business_accounts(id) ON DELETE CASCADE;


--
-- Name: deposits FK_4bd645837e2ae15fb57ca8b8cb4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT "FK_4bd645837e2ae15fb57ca8b8cb4" FOREIGN KEY (buyer_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: deposits FK_4d6d4c4e95dccb35dbc3e1ee1b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT "FK_4d6d4c4e95dccb35dbc3e1ee1b2" FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id) ON DELETE RESTRICT;


--
-- Name: business_accounts FK_6ab0d3b36cd8632f773340b710f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_accounts
    ADD CONSTRAINT "FK_6ab0d3b36cd8632f773340b710f" FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: vehicles FK_b2f065df61d874c20a10d9182bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT "FK_b2f065df61d874c20a10d9182bc" FOREIGN KEY (seller_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict liR7I5Dl1rwZMhGEq5PBbICLcXs7KaD5uXX2snoCYWXgt8fBiCwOmCsyUeGvLG9

