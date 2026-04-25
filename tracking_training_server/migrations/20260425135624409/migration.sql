BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "exercise_templates" (
    "id" bigserial PRIMARY KEY,
    "routineDayId" bigint NOT NULL,
    "name" text NOT NULL,
    "note" text,
    "sortOrder" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "routine_days" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "sortOrder" bigint NOT NULL,
    "focusAreas" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workout_entries" (
    "id" bigserial PRIMARY KEY,
    "sessionId" bigint NOT NULL,
    "exerciseTemplateId" bigint NOT NULL,
    "exerciseName" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workout_sessions" (
    "id" bigserial PRIMARY KEY,
    "routineDayId" bigint NOT NULL,
    "routineDayTitle" text NOT NULL,
    "startedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workout_sets" (
    "id" bigserial PRIMARY KEY,
    "entryId" bigint NOT NULL,
    "setNumber" bigint NOT NULL,
    "reps" bigint NOT NULL,
    "weight" double precision NOT NULL,
    "note" text
);


--
-- MIGRATION VERSION FOR tracking_training
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tracking_training', '20260425135624409', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260425135624409', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
