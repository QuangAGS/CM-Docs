-- TFD-103: Quy tắc sự kiện, niên đại và nguồn chứng cứ
-- Draft 0.1; PostgreSQL reference schema, not production-ready.
-- Align identifiers/FKs with TFD-101 and TFD-102 before deployment.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS tfd_source (
    source_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_type TEXT NOT NULL,
    title TEXT NOT NULL,
    creator TEXT,
    date_created_original TEXT,
    date_created_start DATE,
    date_created_end DATE,
    repository TEXT,
    source_identifier TEXT,
    language_code TEXT,
    script_code TEXT,
    format_description TEXT,
    rights_note TEXT,
    access_conditions TEXT,
    provenance_note TEXT,
    file_sha256 CHAR(64),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (date_created_start IS NULL OR date_created_end IS NULL OR date_created_start <= date_created_end),
    CHECK (file_sha256 IS NULL OR file_sha256 ~ '^[0-9a-fA-F]{64}$')
);

CREATE TABLE IF NOT EXISTS tfd_event (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type TEXT NOT NULL DEFAULT 'OTHER',
    label TEXT,
    description TEXT,
    date_original TEXT,
    date_start DATE,
    date_end DATE,
    date_precision TEXT NOT NULL DEFAULT 'UNKNOWN',
    date_qualifier TEXT,
    calendar_system TEXT NOT NULL DEFAULT 'UNKNOWN',
    date_normalization_note TEXT,
    place_id UUID,
    place_text_original TEXT,
    status TEXT NOT NULL DEFAULT 'PROPOSED',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (date_start IS NULL OR date_end IS NULL OR date_start <= date_end),
    CHECK (date_precision IN ('EXACT_DAY','MONTH','YEAR','DECADE','CENTURY','RANGE','BEFORE','AFTER','ABOUT','CALCULATED','UNKNOWN')),
    CHECK (status IN ('PROPOSED','SUPPORTED','CONFLICTED','VERIFIED','REJECTED','DEPRECATED'))
);

CREATE TABLE IF NOT EXISTS tfd_event_participant (
    event_id UUID NOT NULL REFERENCES tfd_event(event_id) ON DELETE RESTRICT,
    person_id UUID NOT NULL,
    role_code TEXT NOT NULL,
    role_original TEXT,
    certainty TEXT NOT NULL DEFAULT 'UNKNOWN',
    note TEXT,
    PRIMARY KEY (event_id, person_id, role_code),
    CHECK (certainty IN ('HIGH','MEDIUM','LOW','UNKNOWN'))
);

CREATE TABLE IF NOT EXISTS tfd_citation (
    citation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_id UUID NOT NULL REFERENCES tfd_source(source_id) ON DELETE RESTRICT,
    locator_type TEXT NOT NULL,
    locator_value TEXT NOT NULL,
    quote_original TEXT,
    transcription TEXT,
    translation TEXT,
    access_date DATE,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS tfd_assertion (
    assertion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_type TEXT NOT NULL,
    subject_id TEXT NOT NULL,
    predicate TEXT NOT NULL,
    object_type TEXT,
    object_id TEXT,
    object_value TEXT,
    date_scope_original TEXT,
    status TEXT NOT NULL DEFAULT 'PROPOSED',
    confidence TEXT NOT NULL DEFAULT 'UNKNOWN',
    rationale TEXT,
    created_by TEXT,
    reviewed_by TEXT,
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (status IN ('PROPOSED','SUPPORTED','CONFLICTED','VERIFIED','REJECTED','DEPRECATED')),
    CHECK (confidence IN ('HIGH','MEDIUM','LOW','UNKNOWN')),
    CHECK (object_id IS NOT NULL OR object_value IS NOT NULL OR object_type IS NULL)
);

CREATE TABLE IF NOT EXISTS tfd_assertion_evidence (
    assertion_id UUID NOT NULL REFERENCES tfd_assertion(assertion_id) ON DELETE RESTRICT,
    citation_id UUID NOT NULL REFERENCES tfd_citation(citation_id) ON DELETE RESTRICT,
    evidence_role TEXT NOT NULL,
    interpretation TEXT,
    relevance_note TEXT,
    evaluator TEXT,
    evaluated_at TIMESTAMPTZ,
    PRIMARY KEY (assertion_id, citation_id, evidence_role),
    CHECK (evidence_role IN ('SUPPORTS','CONTRADICTS','CONTEXT','MENTIONS'))
);

CREATE TABLE IF NOT EXISTS tfd_source_derivation (
    source_id UUID NOT NULL REFERENCES tfd_source(source_id) ON DELETE RESTRICT,
    related_source_id UUID NOT NULL REFERENCES tfd_source(source_id) ON DELETE RESTRICT,
    relation_type TEXT NOT NULL,
    note TEXT,
    PRIMARY KEY (source_id, related_source_id, relation_type),
    CHECK (source_id <> related_source_id)
);

CREATE TABLE IF NOT EXISTS tfd_audit_log (
    audit_id BIGSERIAL PRIMARY KEY,
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    field_name TEXT,
    old_value JSONB,
    new_value JSONB,
    changed_by TEXT,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    change_reason TEXT
);

CREATE INDEX IF NOT EXISTS idx_tfd_event_type ON tfd_event(event_type);
CREATE INDEX IF NOT EXISTS idx_tfd_event_dates ON tfd_event(date_start, date_end);
CREATE INDEX IF NOT EXISTS idx_tfd_citation_source ON tfd_citation(source_id);
CREATE INDEX IF NOT EXISTS idx_tfd_assertion_subject ON tfd_assertion(subject_type, subject_id);
CREATE INDEX IF NOT EXISTS idx_tfd_evidence_citation ON tfd_assertion_evidence(citation_id);

-- Implementation notes:
-- 1. person_id is intentionally not FK-bound here; align to the actual TFD-101 person table.
-- 2. DATE fields represent normalized Gregorian dates only. Do not fake a day/month for year-only data.
-- 3. Store non-Gregorian/partial/qualified dates using additional structured fields or a dedicated date-expression table.
-- 4. Enforce VERIFIED workflow, row-level security, audit triggers and update timestamp triggers before production.
-- 5. file_sha256 records integrity, not historical authenticity.
