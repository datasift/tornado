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
CREATE TABLE organization (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, skin VARCHAR(255) DEFAULT NULL, jwt_secret VARCHAR(255) DEFAULT NULL, permissions VARCHAR(255) DEFAULT NULL, account_limit INT DEFAULT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE agency (id INT AUTO_INCREMENT NOT NULL, organization_id INT NOT NULL, name VARCHAR(255) NOT NULL, datasift_username VARCHAR(255) NOT NULL, datasift_apikey VARCHAR(45) DEFAULT NULL, skin VARCHAR(255) DEFAULT NULL, INDEX IDX_70C0C6E632C8A3DE (organization_id), UNIQUE INDEX unique_agency_ds_username (datasift_username), UNIQUE INDEX unique_agency_ds_apikey (datasift_apikey), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE brand (id INT AUTO_INCREMENT NOT NULL, agency_id INT NOT NULL, name VARCHAR(255) NOT NULL, datasift_identity_id VARCHAR(45) DEFAULT NULL, datasift_apikey VARCHAR(45) DEFAULT NULL, target_permissions VARCHAR(255) DEFAULT NULL, datasift_username VARCHAR(255) DEFAULT 'NULL' NOT NULL, INDEX fk_brand_agency_1_idx (agency_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE project (id INT AUTO_INCREMENT NOT NULL, brand_id INT DEFAULT NULL, name VARCHAR(255) NOT NULL, type SMALLINT DEFAULT 0 NOT NULL, fresh SMALLINT DEFAULT 1 NOT NULL, recording_filter SMALLINT DEFAULT 0 NOT NULL, created_at INT NOT NULL, INDEX IDX_2FB3D0EE44F5D008 (brand_id), UNIQUE INDEX unique_project_brand_idx (brand_id, name), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE recording (id INT AUTO_INCREMENT NOT NULL, brand_id INT NOT NULL, project_id INT DEFAULT NULL, datasift_recording_id VARCHAR(255) NOT NULL, hash VARCHAR(255) NOT NULL, name VARCHAR(255) NOT NULL, status VARCHAR(10) DEFAULT 'started' NOT NULL, csdl LONGBLOB DEFAULT NULL, vqb_generated SMALLINT NOT NULL, created_at INT NOT NULL, INDEX fk_recording_brand1_idx (brand_id), INDEX fk_recording_project1_idx (project_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE dataset (id INT AUTO_INCREMENT NOT NULL, brand_id INT NOT NULL, recording_id INT NOT NULL, name VARCHAR(255) NOT NULL, dimensions VARCHAR(255) NOT NULL, visibility VARCHAR(10) NOT NULL, data LONGBLOB NOT NULL, analysis_type VARCHAR(45) DEFAULT NULL, filter LONGBLOB DEFAULT NULL, schedule INT DEFAULT NULL, schedule_units VARCHAR(45) DEFAULT NULL, time_range VARCHAR(45) DEFAULT NULL, status VARCHAR(10) DEFAULT NULL, last_refreshed INT DEFAULT NULL, created_at INT DEFAULT NULL, updated_at INT DEFAULT NULL, INDEX fk_dataset_brand_1 (brand_id), INDEX fk_dataset_recording_1 (recording_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE workbook (id INT AUTO_INCREMENT NOT NULL, project_id INT DEFAULT NULL, recording_id INT DEFAULT NULL, name VARCHAR(255) DEFAULT NULL, rank INT DEFAULT NULL, INDEX fk_workbook_project_idx (project_id), INDEX fk_workbook_recording_idx (recording_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE worksheet (id INT AUTO_INCREMENT NOT NULL, secondary_recording_id INT DEFAULT NULL, baseline_dataset_id INT DEFAULT NULL, parent_worksheet_id INT DEFAULT NULL, workbook_id INT NOT NULL, name VARCHAR(255) NOT NULL, rank INT NOT NULL, comparison VARCHAR(10) DEFAULT 'baseline' NOT NULL, measurement VARCHAR(15) DEFAULT 'unique_authors' NOT NULL, chart_type VARCHAR(10) DEFAULT 'tornado' NOT NULL, analysis_type VARCHAR(10) DEFAULT 'freqDist' NOT NULL, secondary_recording_filters LONGBLOB DEFAULT NULL, filters LONGBLOB DEFAULT NULL, dimensions LONGBLOB NOT NULL, start INT DEFAULT NULL, end INT DEFAULT NULL, created_at INT DEFAULT NULL, updated_at INT DEFAULT NULL, display_options LONGTEXT NOT NULL, UNIQUE INDEX unique_name_workbook_id (workbook_id, name), INDEX fk_worksheet_recording2_idx (secondary_recording_id), INDEX fk_worksheet_dataset1_idx (baseline_dataset_id), INDEX fk_worksheet_workbook_idx (workbook_id), INDEX fk_worksheet_worksheet1_idx (parent_worksheet_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE chart (id INT AUTO_INCREMENT NOT NULL, worksheet_id INT NOT NULL, name VARCHAR(255) NOT NULL, rank INT NOT NULL, type VARCHAR(20) NOT NULL, data LONGBLOB NOT NULL, INDEX fk_chart_worksheet1_idx (worksheet_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE user (id INT AUTO_INCREMENT NOT NULL, organization_id INT NOT NULL, email VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL, username VARCHAR(255) NOT NULL, type INT DEFAULT 0 NOT NULL, disabled TINYINT(1) DEFAULT '0' NOT NULL, INDEX fk_user_organization1_idx (organization_id), UNIQUE INDEX unique_key_email_org (organization_id, email), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE users_brands (user_id INT NOT NULL, brand_id INT NOT NULL, INDEX fk_table1_user1_idx (user_id), INDEX fk_users_projects_brand1_idx (brand_id), UNIQUE INDEX user_brand_unique_idx (user_id, brand_id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE users_agencies (user_id INT NOT NULL, agency_id INT NOT NULL, INDEX fk_users_agencies_user1_idx (user_id), INDEX fk_users_agencies_agency1_idx (agency_id), UNIQUE INDEX user_agency_unique_idx (agency_id, user_id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE role (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(64) NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE users_roles (role_id INT NOT NULL, user_id INT NOT NULL, INDEX fk_users_roles_role1_idx (role_id), INDEX fk_users_roles_user1_idx (user_id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE recording_sample (id INT AUTO_INCREMENT NOT NULL, recording_id INT NOT NULL, data LONGBLOB NOT NULL, created_at INT NOT NULL, filter_hash VARCHAR(255) NOT NULL, INDEX IDX_C2AEEB1F8CA9A845 (recording_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
ALTER TABLE agency ADD CONSTRAINT fk_agency_organization_1 FOREIGN KEY (organization_id) REFERENCES organization (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE brand ADD CONSTRAINT fk_brand_agency_1 FOREIGN KEY (agency_id) REFERENCES agency (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE project ADD CONSTRAINT fk_project_brand1 FOREIGN KEY (brand_id) REFERENCES brand (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE recording ADD CONSTRAINT fk_recording_brand1 FOREIGN KEY (brand_id) REFERENCES brand (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE recording ADD CONSTRAINT fk_recording_project1 FOREIGN KEY (project_id) REFERENCES project (id) ON UPDATE NO ACTION ON DELETE SET NULL;
ALTER TABLE dataset ADD CONSTRAINT fk_dataset_brand_1 FOREIGN KEY (brand_id) REFERENCES brand (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE dataset ADD CONSTRAINT fk_dataset_recording_1 FOREIGN KEY (recording_id) REFERENCES recording (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE workbook ADD CONSTRAINT fk_workbook_project FOREIGN KEY (project_id) REFERENCES project (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE workbook ADD CONSTRAINT fk_workbook_recording FOREIGN KEY (recording_id) REFERENCES recording (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE worksheet ADD CONSTRAINT fk_worksheet_recording2 FOREIGN KEY (secondary_recording_id) REFERENCES recording (id) ON UPDATE NO ACTION ON DELETE SET NULL;
ALTER TABLE worksheet ADD CONSTRAINT fk_worksheet_dataset1 FOREIGN KEY (baseline_dataset_id) REFERENCES dataset (id) ON UPDATE NO ACTION ON DELETE SET NULL;
ALTER TABLE worksheet ADD CONSTRAINT fk_parent_worksheet FOREIGN KEY (parent_worksheet_id) REFERENCES worksheet (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE worksheet ADD CONSTRAINT fk_worksheet_workbook FOREIGN KEY (workbook_id) REFERENCES workbook (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE chart ADD CONSTRAINT fk_chart_worksheet1 FOREIGN KEY (worksheet_id) REFERENCES worksheet (id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE user ADD CONSTRAINT fk_user_organization1 FOREIGN KEY (organization_id) REFERENCES organization (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE users_brands ADD CONSTRAINT fk_table1_user1 FOREIGN KEY (user_id) REFERENCES user (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE users_brands ADD CONSTRAINT fk_users_projects_brand1 FOREIGN KEY (brand_id) REFERENCES brand (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE users_agencies ADD CONSTRAINT fk_users_agencies_user1 FOREIGN KEY (user_id) REFERENCES user (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE users_agencies ADD CONSTRAINT fk_users_agencies_agency1 FOREIGN KEY (agency_id) REFERENCES agency (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE users_roles ADD CONSTRAINT fk_users_roles_role1 FOREIGN KEY (role_id) REFERENCES role (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE users_roles ADD CONSTRAINT fk_users_roles_user1 FOREIGN KEY (user_id) REFERENCES user (id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE recording_sample ADD CONSTRAINT fk_recording_sample_recording_1 FOREIGN KEY (recording_id) REFERENCES recording (id) ON UPDATE NO ACTION ON DELETE CASCADE;
