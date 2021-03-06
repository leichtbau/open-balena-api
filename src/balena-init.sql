CREATE EXTENSION IF NOT EXISTS pg_trgm;

ALTER TABLE "user"
ALTER COLUMN "password" DROP NOT NULL;

ALTER TABLE "user"
ADD COLUMN IF NOT EXISTS "email" TEXT;

ALTER TABLE "user"
ADD COLUMN IF NOT EXISTS "jwt secret" VARCHAR(255) NULL;

ALTER TABLE "device"
ALTER COLUMN "api heartbeat state" SET DEFAULT 'unknown';

CREATE INDEX IF NOT EXISTS "release_application_commit_status_idx"
ON "release" ("belongs to-application", "commit", "status");

CREATE INDEX IF NOT EXISTS "api_key_actor_idx"
ON "api key" ("is of-actor");

CREATE INDEX IF NOT EXISTS "user_actor_idx"
ON "user" ("actor");

CREATE INDEX IF NOT EXISTS "device_actor_idx"
ON "device" ("actor");

CREATE INDEX IF NOT EXISTS "application_actor_idx"
ON "application" ("actor");

CREATE INDEX IF NOT EXISTS "device_application_idx"
ON "device" ("belongs to-application");

CREATE INDEX IF NOT EXISTS "application_device_type_idx"
ON "application" ("is for-device type");

CREATE INDEX IF NOT EXISTS "application_is_host_idx"
ON "application" ("is host");

CREATE INDEX IF NOT EXISTS "device_device_type_idx"
ON "device" ("is of-device type");

CREATE INDEX IF NOT EXISTS "image_status_push_timestamp_idx"
ON "image" ("status", "push timestamp");

CREATE INDEX IF NOT EXISTS "image_is_build_of_service_idx"
ON "image" ("is a build of-service");

CREATE INDEX IF NOT EXISTS "image_is_stored_at_image_location_idx"
ON "image" USING GIN ("is stored at-image location" gin_trgm_ops);

CREATE INDEX IF NOT EXISTS "device_is_managed_by_device_idx"
ON "device" ("is managed by-device");

CREATE INDEX IF NOT EXISTS "application_depends_on_application_idx"
ON "application" ("depends on-application");

CREATE INDEX IF NOT EXISTS "device_name_idx"
ON "device" ("device name");

CREATE INDEX IF NOT EXISTS "device_api heartbeat state_idx"
ON "device" ("api heartbeat state");

CREATE INDEX IF NOT EXISTS "device_uuid_idx"
ON "device" ("uuid" text_pattern_ops);

CREATE INDEX IF NOT EXISTS "device_is_managed_by_service_instance_idx"
ON "device" ("is managed by-service instance");

-- Optimizes the rule `It is necessary that each device that should be
-- managed by a supervisor release, should be managed by a supervisor release
-- that is for a device type that describes the device.`
-- as it relies heavily on these two columns
CREATE INDEX IF NOT EXISTS "device_supervisor_release_device_type_idx"
ON "device" ("should be managed by-supervisor release", "is of-device type");

CREATE INDEX IF NOT EXISTS "ii_ipr_idx"
ON "image install" ("is provided by-release");

-- Optimisation for device state query
CREATE INDEX IF NOT EXISTS "image_install_image_device_idx"
ON "image install" ("installs-image", "device");

-- Optimisation for device state query
CREATE INDEX IF NOT EXISTS "image_install_device_image_idx"
ON "image install" ("device", "installs-image");

-- Optimisation for device state query
CREATE INDEX IF NOT EXISTS "ipr_ipr_image_idx"
ON "image-is part of-release" ("is part of-release", "image");

-- Optimisation for device state query
CREATE INDEX IF NOT EXISTS "device_id_actor_managed_device_idx"
ON "device" ("id", "actor", "is managed by-device");

-- Optimisation for device state query
CREATE INDEX IF NOT EXISTS "release_id_belongs_to_app_idx"
ON "release" ("id", "belongs to-application");
