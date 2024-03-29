create TABLE players (
  id serial primary key,
  social_id bigint,

  level integer not null,
  experience integer not null,
  basic_money integer not null,
  vip_money integer not null,

  town_level integer not null,
  town_bonus_collected_at timestamp,
  town_upgrade_at timestamp,

  town_materials jsonb,
  trucking jsonb,
  advertising jsonb,
  properties jsonb,
  transport jsonb,
  factories jsonb,
  materials jsonb,

  session_key varchar(255),
  session_secret_key varchar(255),
  installed boolean not null default false,

  last_visited_at timestamp not null,

  locale varchar(20),

  created_at timestamp not null,
  updated_at timestamp not null
);

CREATE INDEX index_players_on_social_id
  ON players
  USING btree
  (social_id);