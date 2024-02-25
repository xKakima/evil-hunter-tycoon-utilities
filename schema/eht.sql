DROP SCHEMA IF EXISTS eht CASCADE;

CREATE SCHEMA eht;

CREATE TYPE eht.hunter_type AS ENUM ('DPS', 'Tank');
CREATE TYPE eht.gear_type AS ENUM ('Weapon', 'Hat', 'Armor', 'Glove', 'Shoe', 'Belt', 'Necklace', 'Ring');
CREATE TYPE eht.gear_variant AS ENUM ('Ancient', 'Primal', 'Original', 'Chaos');

CREATE TABLE eht.gears (
    id UUID NOT NULL DEFAULT uuid_generate_v4 (),
    name varchar(255) NOT NULL,
    type gear_type NOT NULL DEFAULT 'Weapon',
    variant gear_variant NOT NULL DEFAULT 'Ancient',
    created_at timestamp without time zone NOT NULL DEFAULT now (),
    updated_at timestamp without time zone NOT NULL DEFAULT now (),
    CONSTRAINT gears_pkey PRIMARY KEY (id)

);
ALTER TABLE eht.gears ENABLE ROW LEVEL SECURITY;

CREATE TABLE
    eht.hunters (
        id UUID NOT NULL,
        name character varying(255) NOT NULL,
        type eht.hunter_type DEFAULT 'DPS',
        created_at timestamp without time zone NOT NULL DEFAULT now (),
        updated_at timestamp without time zone NOT NULL DEFAULT now (),
        CONSTRAINT hunters_pkey PRIMARY KEY (id),
        CONSTRAINT fk_users FOREIGN KEY (id) REFERENCES auth.users (id)
    );
ALTER TABLE eht.hunters ENABLE ROW LEVEL SECURITY;

CREATE TABLE
    eht.stats (
        hunter_id UUID NOT NULL,
        hp float NOT NULL DEFAULT 0,
        attack float NOT NULL DEFAULT 0,
        defense float NOT NULL DEFAULT 0,
        crit_chance float NOT NULL DEFAULT 0,
        crit_damage float NOT NULL DEFAULT 0,
        attack_speed float NOT NULL DEFAULT 0,
        evasion float NOT NULL DEFAULT 0,
        created_at timestamp without time zone NOT NULL DEFAULT now (),
        updated_at timestamp without time zone NOT NULL DEFAULT now (),
        CONSTRAINT stats_pkey PRIMARY KEY (hunter_id),
        CONSTRAINT fk_hunters FOREIGN KEY (hunter_id) REFERENCES eht.hunters (id)
    );
ALTER TABLE eht.stats ENABLE ROW LEVEL SECURITY;

CREATE TABLE
    eht.base_classes (
        id UUID NOT NULL DEFAULT uuid_generate_v4 (),
        name character varying(255) NOT NULL,
        created_at timestamp without time zone NOT NULL DEFAULT now (),
        updated_at timestamp without time zone NOT NULL DEFAULT now (),
        CONSTRAINT base_classes_pkey PRIMARY KEY (id)
    );

CREATE TABLE
    eht.second_classes (
        id UUID NOT NULL DEFAULT uuid_generate_v4 (),
        base_class_id UUID NOT NULL,
        name character varying(255) NOT NULL,
        created_at timestamp without time zone NOT NULL DEFAULT now (),
        updated_at timestamp without time zone NOT NULL DEFAULT now (),
        CONSTRAINT second_classes_pkey PRIMARY KEY (id),
        CONSTRAINT fk_base_classes FOREIGN KEY (base_class_id) REFERENCES eht.base_classes (id)
    );

CREATE TABLE
    eht.third_classes (
        id UUID NOT NULL DEFAULT uuid_generate_v4 (),
        base_class_id UUID NOT NULL,
        name character varying(255) NOT NULL,
        created_at timestamp without time zone NOT NULL DEFAULT now (),
        updated_at timestamp without time zone NOT NULL DEFAULT now (),
        CONSTRAINT third_classes_pkey PRIMARY KEY (id),
        CONSTRAINT fk_base_classes FOREIGN KEY (base_class_id) REFERENCES eht.base_classes (id)
    );
    

-- Insert Initial Data

-- Insert 'Berserker' base class and its second and third classes
DO $$
DECLARE 
    base_class_id UUID;
BEGIN
    INSERT INTO eht.base_classes (name)
    VALUES ('Berserker')
    RETURNING id INTO base_class_id;

    INSERT INTO eht.second_classes (base_class_id, name)
    VALUES 
        (base_class_id, 'Duelist'),
        (base_class_id, 'Warrior'),
        (base_class_id, 'Slayer');

    INSERT INTO eht.third_classes (base_class_id, name)
    VALUES 
         (base_class_id, 'Barbarian'),
        (base_class_id, 'SwordSaint'),
        (base_class_id, 'Destroyer');
END $$;

-- Insert 'Sorceror' base class and its second and third classes
DO $$
DECLARE 
    base_class_id UUID;
BEGIN
    INSERT INTO eht.base_classes (name)
    VALUES ('Sorceror')
    RETURNING id INTO base_class_id;

    INSERT INTO eht.second_classes (base_class_id, name)
    VALUES 
        (base_class_id, 'ArchMage'),
        (base_class_id, 'DarkMage'),
        (base_class_id, 'Ignis');

    INSERT INTO eht.third_classes (base_class_id, name)
    VALUES 
        (base_class_id, 'Conjuror'),
        (base_class_id, 'DarkLord'),
        (base_class_id, 'Illusionist');
END $$;

-- Insert 'Paladin' base class and its second and third classes
DO $$
DECLARE 
    base_class_id UUID;
BEGIN
    INSERT INTO eht.base_classes (name)
    VALUES ('Paladin')
    RETURNING id INTO base_class_id;

    INSERT INTO eht.second_classes (base_class_id, name)
    VALUES 
        (base_class_id, 'Crusader'),
        (base_class_id, 'Templar'),
        (base_class_id, 'DarkPaladin');

    INSERT INTO eht.third_classes (base_class_id, name)
    VALUES 
        (base_class_id, 'Guardian'),
        (base_class_id, 'Inquisitor'),
        (base_class_id, 'Executor');
END $$;

-- Insert 'Archer' base class and its second and third classes
DO $$
DECLARE 
    base_class_id UUID;
BEGIN
    INSERT INTO eht.base_classes (name)
    VALUES ('Archer')
    RETURNING id INTO base_class_id;

    INSERT INTO eht.second_classes (base_class_id, name)
    VALUES 
        (base_class_id, 'HawkEye'),
        (base_class_id, 'Sniper'),
        (base_class_id, 'Summonarcher');

    INSERT INTO eht.third_classes (base_class_id, name)
    VALUES 
        (base_class_id, 'Ministrel'),
        (base_class_id, 'Scout'),
        (base_class_id, 'Arcanearcher');
END $$;

-- Functions

-- Create a function that inserts a row into the stats table
CREATE OR REPLACE FUNCTION eht.create_stats() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO eht.stats (hunter_id, hp, attack, defense, crit_chance, crit_damage, attack_speed, evasion)
    VALUES (NEW.id, 0, 0, 0, 0, 0, 0, 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger that calls the create_stats function after an insert operation on the hunters table
CREATE TRIGGER create_stats_after_insert
AFTER INSERT ON eht.hunters
FOR EACH ROW
EXECUTE FUNCTION eht.create_stats();

create policy "Users can view their own data" on auth.users
for select
using ( auth.uid() = auth.users.id );

GRANT USAGE ON SCHEMA eht TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA eht TO authenticated;