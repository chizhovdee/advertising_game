create TABLE players (
  id serial primary key,
  social_id bigint,

  level integer not null,
  experience integer not null,
  improvement_points integer not null,
  education_points integer not null,
  basic_money integer not null,
  vip_money integer not null,
  reputation integer not null,
  fuel integer not null,

  created_at timestamp not null,
  updated_at timestamp not null
);

CREATE INDEX index_players_on_social_id
  ON players
  USING btree
  (social_id);