DROP TABLE IF EXISTS recording_sample;
DROP TABLE IF EXISTS users_roles;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS users_agencies;
DROP TABLE IF EXISTS users_brands;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS chart;
DROP TABLE IF EXISTS worksheet;
DROP TABLE IF EXISTS workbook;
DROP TABLE IF EXISTS dataset;
DROP TABLE IF EXISTS recording;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS brand;
DROP TABLE IF EXISTS agency;
DROP TABLE IF EXISTS organization;
CREATE TABLE organization (id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, skin VARCHAR(255) DEFAULT NULL, jwt_secret VARCHAR(255) DEFAULT NULL, permissions VARCHAR(255) DEFAULT NULL, account_limit INTEGER DEFAULT NULL, PRIMARY KEY(id));
CREATE TABLE agency (id INTEGER NOT NULL, organization_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, datasift_username VARCHAR(255) NOT NULL, datasift_apikey VARCHAR(45) DEFAULT NULL, skin VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id));
CREATE INDEX IDX_70C0C6E632C8A3DE ON agency (organization_id);
CREATE UNIQUE INDEX unique_agency_ds_username ON agency (datasift_username);
CREATE UNIQUE INDEX unique_agency_ds_apikey ON agency (datasift_apikey);
CREATE TABLE brand (id INTEGER NOT NULL, agency_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, datasift_identity_id VARCHAR(45) DEFAULT NULL, datasift_apikey VARCHAR(45) DEFAULT NULL, target_permissions VARCHAR(255) DEFAULT NULL, datasift_username VARCHAR(255) DEFAULT 'NULL' NOT NULL, PRIMARY KEY(id));
CREATE INDEX fk_brand_agency_1_idx ON brand (agency_id);
CREATE TABLE project (id INTEGER NOT NULL, brand_id INTEGER DEFAULT NULL, name VARCHAR(255) NOT NULL, type SMALLINT DEFAULT 0 NOT NULL, fresh SMALLINT DEFAULT 1 NOT NULL, recording_filter SMALLINT DEFAULT 0 NOT NULL, created_at INTEGER NOT NULL, PRIMARY KEY(id));
CREATE INDEX IDX_2FB3D0EE44F5D008 ON project (brand_id);
CREATE UNIQUE INDEX unique_project_brand_idx ON project (brand_id, name);
CREATE TABLE recording (id INTEGER NOT NULL, brand_id INTEGER NOT NULL, project_id INTEGER DEFAULT NULL, datasift_recording_id VARCHAR(255) NOT NULL, hash VARCHAR(255) NOT NULL, name VARCHAR(255) NOT NULL, status VARCHAR(10) DEFAULT 'started' NOT NULL, csdl BLOB DEFAULT NULL, vqb_generated SMALLINT NOT NULL, created_at INTEGER NOT NULL, PRIMARY KEY(id));
CREATE INDEX fk_recording_brand1_idx ON recording (brand_id);
CREATE INDEX fk_recording_project1_idx ON recording (project_id);
CREATE TABLE dataset (id INTEGER NOT NULL, brand_id INTEGER NOT NULL, recording_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, dimensions VARCHAR(255) NOT NULL, visibility VARCHAR(10) NOT NULL, data BLOB NOT NULL, analysis_type VARCHAR(45) DEFAULT NULL, filter BLOB DEFAULT NULL, schedule INTEGER DEFAULT NULL, schedule_units VARCHAR(45) DEFAULT NULL, time_range VARCHAR(45) DEFAULT NULL, status VARCHAR(10) DEFAULT NULL, last_refreshed INTEGER DEFAULT NULL, created_at INTEGER DEFAULT NULL, updated_at INTEGER DEFAULT NULL, PRIMARY KEY(id));
CREATE INDEX fk_dataset_brand_1 ON dataset (brand_id);
CREATE INDEX fk_dataset_recording_1 ON dataset (recording_id);
CREATE TABLE workbook (id INTEGER NOT NULL, project_id INTEGER DEFAULT NULL, recording_id INTEGER DEFAULT NULL, name VARCHAR(255) DEFAULT NULL, rank INTEGER DEFAULT NULL, PRIMARY KEY(id));
CREATE INDEX fk_workbook_project_idx ON workbook (project_id);
CREATE INDEX fk_workbook_recording_idx ON workbook (recording_id);
CREATE TABLE worksheet (id INTEGER NOT NULL, secondary_recording_id INTEGER DEFAULT NULL, baseline_dataset_id INTEGER DEFAULT NULL, parent_worksheet_id INTEGER DEFAULT NULL, workbook_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, rank INTEGER NOT NULL, comparison VARCHAR(10) DEFAULT 'baseline' NOT NULL, measurement VARCHAR(15) DEFAULT 'unique_authors' NOT NULL, chart_type VARCHAR(10) DEFAULT 'tornado' NOT NULL, analysis_type VARCHAR(10) DEFAULT 'freqDist' NOT NULL, secondary_recording_filters BLOB DEFAULT NULL, filters BLOB DEFAULT NULL, dimensions BLOB NOT NULL, start INTEGER DEFAULT NULL, "end" INTEGER DEFAULT NULL, created_at INTEGER DEFAULT NULL, updated_at INTEGER DEFAULT NULL, display_options CLOB DEFAULT 'NULL' NOT NULL, PRIMARY KEY(id));
CREATE UNIQUE INDEX unique_name_workbook_id ON worksheet (workbook_id, name);
CREATE INDEX fk_worksheet_recording2_idx ON worksheet (secondary_recording_id);
CREATE INDEX fk_worksheet_dataset1_idx ON worksheet (baseline_dataset_id);
CREATE INDEX fk_worksheet_workbook_idx ON worksheet (workbook_id);
CREATE INDEX fk_worksheet_worksheet1_idx ON worksheet (parent_worksheet_id);
CREATE TABLE chart (id INTEGER NOT NULL, worksheet_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, rank INTEGER NOT NULL, type VARCHAR(20) NOT NULL, data BLOB NOT NULL, PRIMARY KEY(id));
CREATE INDEX fk_chart_worksheet1_idx ON chart (worksheet_id);
CREATE TABLE user (id INTEGER NOT NULL, organization_id INTEGER NOT NULL, email VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL, username VARCHAR(255) NOT NULL, type INTEGER DEFAULT 0 NOT NULL, disabled BOOLEAN DEFAULT '0' NOT NULL, PRIMARY KEY(id));
CREATE INDEX fk_user_organization1_idx ON user (organization_id);
CREATE UNIQUE INDEX unique_key_email_org ON user (organization_id, email);
CREATE TABLE users_brands (user_id INTEGER NOT NULL, brand_id INTEGER NOT NULL);
CREATE INDEX fk_table1_user1_idx ON users_brands (user_id);
CREATE INDEX fk_users_projects_brand1_idx ON users_brands (brand_id);
CREATE UNIQUE INDEX user_brand_unique_idx ON users_brands (user_id, brand_id);
CREATE TABLE users_agencies (user_id INTEGER NOT NULL, agency_id INTEGER NOT NULL);
CREATE INDEX fk_users_agencies_user1_idx ON users_agencies (user_id);
CREATE INDEX fk_users_agencies_agency1_idx ON users_agencies (agency_id);
CREATE UNIQUE INDEX user_agency_unique_idx ON users_agencies (agency_id, user_id);
CREATE TABLE role (id INTEGER NOT NULL, name VARCHAR(64) NOT NULL, PRIMARY KEY(id));
CREATE TABLE users_roles (role_id INTEGER NOT NULL, user_id INTEGER NOT NULL);
CREATE INDEX fk_users_roles_role1_idx ON users_roles (role_id);
CREATE INDEX fk_users_roles_user1_idx ON users_roles (user_id);
CREATE TABLE recording_sample (id INTEGER NOT NULL, recording_id INTEGER NOT NULL, data BLOB NOT NULL, created_at INTEGER NOT NULL, PRIMARY KEY(id));
CREATE INDEX IDX_C2AEEB1F8CA9A845 ON recording_sample (recording_id);
