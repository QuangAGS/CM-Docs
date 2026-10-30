-- TFD-102 — SQL reference sketch (PostgreSQL)
-- Draft 0.1. This is a starter schema, not a production migration.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE person (
    person_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    record_status TEXT NOT NULL DEFAULT 'active'
      CHECK (record_status IN ('active','merged','archived','restricted')),
    notes TEXT
);

CREATE TABLE source (
    source_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_type TEXT NOT NULL,
    title TEXT NOT NULL,
    creator TEXT,
    date_text TEXT,
    repository TEXT,
    citation_text TEXT,
    uri TEXT,
    notes TEXT
);

CREATE TABLE person_name (
    person_name_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    name_text TEXT NOT NULL,
    name_type TEXT NOT NULL,
    language_code TEXT,
    script_code TEXT,
    is_preferred BOOLEAN NOT NULL DEFAULT FALSE,
    source_id UUID REFERENCES source(source_id) ON DELETE RESTRICT,
    certainty TEXT NOT NULL DEFAULT 'unassessed'
      CHECK (certainty IN ('unassessed','low','medium','high','conflicted')),
    notes TEXT
);

CREATE TABLE relationship_assertion (
    relationship_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_a_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    person_b_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    relationship_type TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'proposed'
      CHECK (status IN ('proposed','accepted','disputed','rejected','superseded')),
    certainty TEXT NOT NULL DEFAULT 'unassessed'
      CHECK (certainty IN ('unassessed','low','medium','high','conflicted')),
    valid_from_text TEXT,
    valid_to_text TEXT,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    notes TEXT,
    CHECK (person_a_id <> person_b_id)
);

CREATE TABLE relationship_source (
    relationship_id UUID NOT NULL
      REFERENCES relationship_assertion(relationship_id) ON DELETE RESTRICT,
    source_id UUID NOT NULL REFERENCES source(source_id) ON DELETE RESTRICT,
    evidence_role TEXT NOT NULL DEFAULT 'supports'
      CHECK (evidence_role IN ('supports','contradicts','mentions','context')),
    citation_locator TEXT,
    notes TEXT,
    PRIMARY KEY (relationship_id, source_id, evidence_role)
);

CREATE TABLE external_identifier (
    external_identifier_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    source_system TEXT NOT NULL,
    external_id TEXT NOT NULL,
    namespace TEXT NOT NULL DEFAULT '',
    UNIQUE (source_system, namespace, external_id)
);

CREATE TABLE merge_history (
    merge_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_person_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    target_person_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    merged_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    merged_by TEXT NOT NULL,
    reason TEXT NOT NULL,
    evidence_notes TEXT,
    CHECK (source_person_id <> target_person_id)
);

CREATE INDEX idx_relationship_a ON relationship_assertion(person_a_id);
CREATE INDEX idx_relationship_b ON relationship_assertion(person_b_id);
CREATE INDEX idx_relationship_type_status
  ON relationship_assertion(relationship_type, status);
CREATE INDEX idx_person_name_text ON person_name(name_text);
CREATE INDEX idx_external_identifier_person ON external_identifier(person_id);

-- Important implementation notes:
-- 1. Use a trigger or service-layer transaction to prevent cycles in parent-child edges.
-- 2. Add a controlled relationship-type registry instead of allowing arbitrary strings.
-- 3. Do not treat legal/adoptive/raising parent relationships as biological parentage.
-- 4. Preserve source text, uncertainty, audit history, and import/export loss reports.
