-- Add migration script here
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Contemplation of enums here. Enums make the db less portable.
-- We don't care about storage space. And it abstracts logic from users and makes
-- Application evelopers make decision that could make the system too rigid for future use.
-- CREATE TYPE case_status AS ENUM ('Open', 'Closed', 'Pending');
-- CREATE TYPE party_type AS ENUM ('Plaintiff', 'Defendant');

CREATE TABLE
    IF NOT EXISTS notes (
        id UUID PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4()),
        title VARCHAR(255) NOT NULL UNIQUE,
        content TEXT NOT NULL,
        category VARCHAR(100),
        published BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP
        WITH
            TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP
        WITH
            TIME ZONE DEFAULT NOW()
    );


CREATE TABLE
    IF NOT EXISTS addresses (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(20),
    country VARCHAR(255)
);



--This table will store different roles.
CREATE TABLE
    IF NOT EXISTS roles (
        id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
        name VARCHAR(255) UNIQUE NOT NULL,
        description TEXT,
        published BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);




--This table will store user information including a reference to their role.
CREATE TABLE
    IF NOT EXISTS users (
    id UUID PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4()),
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role_name VARCHAR(255) NOT NULL DEFAULT 'public',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMPTZ,
    FOREIGN KEY (role_name) REFERENCES roles(name)
);

--Since a user can have multiple roles and a role can belong to multiple users, you need an association table.
CREATE TABLE
    IF NOT EXISTS user_roles (
    user_id UUID,
    role_id UUID,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE IF NOT EXISTS courtrooms (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name VARCHAR(255),
    location TEXT
);
-- Relationship should be assigned to a judge and then a courtroom. 
-- This is wrong.
CREATE TABLE
    IF NOT EXISTS court_cases (
        id UUID PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4()),
        case_number VARCHAR(50) UNIQUE,
        title VARCHAR(255),
        filing_date DATE,
        case_status VARCHAR(255),
        courtroom_id UUID,
        scheduled_date DATE
);



CREATE TABLE
    IF NOT EXISTS judges (
        id UUID PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4()),
        title VARCHAR(20),
        firstname VARCHAR(255),
        lastname VARCHAR(255),
        appointment_date DATE,
        district VARCHAR(100)
);
CREATE TABLE
    IF NOT EXISTS law_firms (
    id UUID PRIMARY KEY,
    name TEXT,
    address_id UUID,
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE
    IF NOT EXISTS lawyers (
        id UUID PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4()),
        firstname VARCHAR(20),
        lastname VARCHAR(20),
        bar_number VARCHAR(100),
        law_firm_id UUID NULL,
        FOREIGN KEY (law_firm_id) REFERENCES law_firms(id)
);


CREATE TABLE IF NOT EXISTS parties (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    representation_id UUID NOT NULL,
    FOREIGN KEY (representation_id) REFERENCES lawyers(id)
);



CREATE TABLE IF NOT EXISTS case_parties (
    case_id UUID,
    party_id UUID,
    PRIMARY KEY (case_id, party_id),
    FOREIGN KEY (case_id) REFERENCES court_cases(id),
    FOREIGN KEY (party_id) REFERENCES parties(id)
);




-- Documents stored in cloud storage (not in DB).
-- For managing documents and filings associated with court_cases.
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    case_id UUID,
    title VARCHAR(255),
    description TEXT,
    file_path TEXT,
    submitted_by UUID,  -- User who submitted the document
    submission_date TIMESTAMPTZ,
    FOREIGN KEY (case_id) REFERENCES court_cases(id),
    FOREIGN KEY (submitted_by) REFERENCES users(id)
);



CREATE TABLE IF NOT EXISTS hearings (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    case_id UUID,
    date TIMESTAMP,
    judge_id UUID,
    courtroom_id UUID,
    FOREIGN KEY (case_id) REFERENCES court_cases(id),
    FOREIGN KEY (judge_id) REFERENCES judges(id),
    FOREIGN KEY (courtroom_id) REFERENCES courtrooms(id)
);


CREATE TABLE IF NOT EXISTS hearing_details (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    hearing_id UUID,
    detail TEXT,
    FOREIGN KEY (hearing_id) REFERENCES hearings(id)
);



--For tracking court events, hearings, and other important dates.
CREATE TABLE IF NOT EXISTS court_events (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    case_id UUID,
    title VARCHAR(255),
    description TEXT,
    event_date TIMESTAMPTZ,
    created_by UUID,
    FOREIGN KEY (case_id) REFERENCES court_cases(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- For storing notes or comments on court_cases by users.
CREATE TABLE IF NOT EXISTS case_notes (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    case_id UUID,
    note TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES court_cases(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- For managing tasks related to court_cases.
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    case_id UUID,
    title VARCHAR(255),
    description TEXT,
    due_date TIMESTAMPTZ,
    assigned_to UUID,
    status VARCHAR(50),
    FOREIGN KEY (case_id) REFERENCES court_cases(id),
    FOREIGN KEY (assigned_to) REFERENCES users(id)
);



-- Create Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    user_id UUID,
    message TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Track Financial Transactions
CREATE TABLE IF NOT EXISTS financial_transactions (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    case_id UUID,
    amount DECIMAL,
    transaction_date TIMESTAMPTZ,
    description TEXT,
    FOREIGN KEY (case_id) REFERENCES court_cases(id)
);

-- Association handles many to many relationships
--1. Court court_cases and Judges
--Since a court case can be associated with multiple judges and vice versa, an association table is needed.


CREATE TABLE courtcase_judges (
    courtcase_id UUID,
    judge_id UUID,
    PRIMARY KEY (courtcase_id, judge_id),
    FOREIGN KEY (courtcase_id) REFERENCES court_cases(id),
    FOREIGN KEY (judge_id) REFERENCES judges(id)
);
-- Court court_cases and Lawyers
-- Lawyers can represent multiple court_cases, and court_cases might have multiple lawyers (e.g., for different parties).

CREATE TABLE courtcase_lawyers (
    courtcase_id UUID,
    lawyer_id UUID,
    role VARCHAR(255), -- e.g., 'Representing Plaintiff', 'Representing Defendant'
    PRIMARY KEY (courtcase_id, lawyer_id),
    FOREIGN KEY (courtcase_id) REFERENCES court_cases(id),
    FOREIGN KEY (lawyer_id) REFERENCES lawyers(id)
);
-- 3. Court court_cases and Parties (Plaintiffs and Defendants)
-- This association is to link parties to their court_cases. Since your Defendant and Plaintiff structures are similar, you might consider merging them into a single Parties table with a role type. But for this example, I'll keep them separate as per your original structure.

CREATE TABLE courtcase_parties (
    courtcase_id UUID,
    party_id UUID,
    party_type VARCHAR(50), -- 'Plaintiff' or 'Defendant'
    PRIMARY KEY (courtcase_id, party_id),
    FOREIGN KEY (courtcase_id) REFERENCES court_cases(id),
    FOREIGN KEY (party_id) REFERENCES parties(id) -- Assuming parties table includes both plaintiffs and defendants
);



-- Update Judges Table
ALTER TABLE judges
ADD COLUMN address_id UUID,
ADD FOREIGN KEY (address_id) REFERENCES addresses(id);

-- Update Lawyers Table
ALTER TABLE lawyers
ADD COLUMN address_id UUID,
ADD FOREIGN KEY (address_id) REFERENCES addresses(id);

-- Update Parties Table
-- Assuming you have a single 'parties' table that includes both plaintiffs and defendants
ALTER TABLE parties
ADD COLUMN address_id UUID,
ADD FOREIGN KEY (address_id) REFERENCES addresses(id);


ALTER TABLE judges
ADD COLUMN last_modified_by UUID,
ADD COLUMN last_modified_date TIMESTAMPTZ,
ADD FOREIGN KEY (last_modified_by) REFERENCES users(id);

ALTER TABLE lawyers
ADD COLUMN last_modified_by UUID,
ADD COLUMN last_modified_date TIMESTAMPTZ,
ADD FOREIGN KEY (last_modified_by) REFERENCES users(id);

ALTER TABLE parties
ADD COLUMN last_modified_by UUID,
ADD COLUMN last_modified_date TIMESTAMPTZ,
ADD FOREIGN KEY (last_modified_by) REFERENCES users(id);

ALTER TABLE court_cases
ADD COLUMN last_modified_by UUID,
ADD COLUMN last_modified_date TIMESTAMPTZ,
ADD FOREIGN KEY (last_modified_by) REFERENCES users(id);
--SELECT * FROM documents WHERE document_text_tsvector @@ to_tsquery('english', 'search_term');

ALTER TABLE documents ADD COLUMN document_text_tsvector tsvector;
UPDATE documents SET document_text_tsvector = to_tsvector('english', coalesce(title, '') || ' ' || coalesce(description, ''));
CREATE INDEX idx_document_text_search ON documents USING GIN (document_text_tsvector);


-- SELECT * FROM search_court_cases('search_term');
CREATE OR REPLACE FUNCTION search_court_cases(search_text VARCHAR)
RETURNS SETOF court_cases AS $$
BEGIN
    RETURN QUERY 
    SELECT * FROM court_cases
    WHERE title ILIKE '%' || search_text || '%'
    OR case_number ILIKE '%' || search_text || '%';
END;
$$ LANGUAGE plpgsql;
-- Add a audit_log


CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(255) NOT NULL,
    record_id UUID NOT NULL,
    action_type VARCHAR(50) NOT NULL, -- e.g., 'INSERT', 'UPDATE', 'DELETE'
    changed_by UUID NOT NULL, -- Assuming you have a users table to reference
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    old_value JSONB, -- Stores the previous state of the record
    new_value JSONB, -- Stores the new state of the record
    FOREIGN KEY (changed_by) REFERENCES users(id)
);

CREATE OR REPLACE FUNCTION audit_case_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, record_id, action_type, changed_by, old_value, new_value)
        VALUES ('court_cases', OLD.id, TG_OP, current_user_id(), row_to_json(OLD), NULL);
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, record_id, action_type, changed_by, old_value, new_value)
        VALUES ('court_cases', NEW.id, TG_OP, current_user_id(), row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, record_id, action_type, changed_by, old_value, new_value)
        VALUES ('court_cases', NEW.id, TG_OP, current_user_id(), NULL, row_to_json(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER documents_audit
AFTER INSERT OR UPDATE OR DELETE ON documents
    FOR EACH ROW EXECUTE FUNCTION audit_case_changes();

CREATE OR REPLACE FUNCTION audit_case_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- Use current_user to get the name of the user executing the query
    -- You might need additional logic to get the user's ID from the username
    INSERT INTO audit_log (table_name, record_id, action_type, changed_by, old_value, new_value)
    VALUES ('court_cases', NEW.id, TG_OP, (SELECT id FROM users WHERE username = current_user), row_to_json(OLD), row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
CREATE INDEX idx_case_number ON court_cases (case_number);
--
CREATE INDEX idx_notifications_user ON notifications (user_id);
--
CREATE INDEX idx_documents_case ON documents (case_id);
--
CREATE INDEX idx_case_notes_creator ON case_notes (created_by);
--
CREATE INDEX idx_documents_submitter ON documents (submitted_by);
--
CREATE INDEX idx_user_roles_user ON user_roles (user_id);
--
CREATE INDEX idx_user_roles_role ON user_roles (role_name);

CREATE INDEX idx_parties_name ON parties (name);


INSERT INTO roles (name, description) VALUES 
('attorney', 'A user with attorney privileges'),
('party', 'A standard user'),
('clerk', 'A user with clerk privileges'),
('clerkofcourt', 'A user with clerk of court privileges'),
('judge', 'A user with judge privileges'),
('public', 'A user with public privileges');


INSERT INTO users (username, password_hash, email, role_name)
VALUES ('new_user', 'hashed_password', 'user@example.com', 'public');
