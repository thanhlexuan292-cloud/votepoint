CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('organizer','jury','senior')),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS candidates (
  id BIGSERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  group_name TEXT NOT NULL DEFAULT '',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS settings (
  id INTEGER PRIMARY KEY DEFAULT 1 CHECK (id=1),
  event_name TEXT NOT NULL DEFAULT 'Cuộc thi tài năng',
  voting_open BOOLEAN NOT NULL DEFAULT FALSE,
  scoring_open BOOLEAN NOT NULL DEFAULT FALSE,
  audience_points INTEGER NOT NULL DEFAULT 150 CHECK (audience_points=150),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
INSERT INTO settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;
CREATE TABLE IF NOT EXISTS voter_codes (
  id BIGSERIAL PRIMARY KEY,
  token_hash TEXT UNIQUE NOT NULL,
  label TEXT NOT NULL DEFAULT '',
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  used_ballot_id BIGINT
);
CREATE TABLE IF NOT EXISTS ballots (
  id BIGSERIAL PRIMARY KEY,
  voter_code_id BIGINT UNIQUE NOT NULL REFERENCES voter_codes(id),
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  total_points INTEGER NOT NULL CHECK (total_points=150)
);
-- used_ballot_id is a trace reference; the unique voter_code_id on ballots enforces one ballot per code.
CREATE TABLE IF NOT EXISTS ballot_items (
  ballot_id BIGINT NOT NULL REFERENCES ballots(id) ON DELETE CASCADE,
  candidate_id BIGINT NOT NULL REFERENCES candidates(id),
  points INTEGER NOT NULL CHECK (points >= 0 AND points <= 150),
  PRIMARY KEY (ballot_id, candidate_id)
);
CREATE TABLE IF NOT EXISTS score_sheets (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  role TEXT NOT NULL CHECK (role IN ('jury','senior')),
  submitted_at TIMESTAMPTZ,
  locked BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (user_id, role)
);
CREATE TABLE IF NOT EXISTS scores (
  sheet_id BIGINT NOT NULL REFERENCES score_sheets(id) ON DELETE CASCADE,
  candidate_id BIGINT NOT NULL REFERENCES candidates(id),
  points INTEGER NOT NULL CHECK (points >= 0 AND points <= 100),
  comment TEXT NOT NULL DEFAULT '',
  PRIMARY KEY (sheet_id, candidate_id)
);
CREATE TABLE IF NOT EXISTS audit_log (
  id BIGSERIAL PRIMARY KEY,
  actor_user_id BIGINT REFERENCES users(id),
  action TEXT NOT NULL,
  details JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ballots_submitted_at_idx ON ballots(submitted_at);
CREATE INDEX IF NOT EXISTS scores_candidate_idx ON scores(candidate_id);
