create database test001;
-- 切换到对应的数据库
\c test001;
-- 创建schema
CREATE schema IF NOT EXISTS a_schema;
CREATE schema IF NOT EXISTS b_schema;
-- 创建数据表table
DROP TABLE IF EXISTS "public"."table_02";
CREATE TABLE "public"."table_02" (
    "id" varchar(32) COLLATE "default" NOT NULL,
    "name" varchar(255) COLLATE "default",
    "age" int4
);
DROP TABLE IF EXISTS "a_schema"."table_02";
CREATE TABLE "a_schema"."table_02" (
    "id" varchar(32) COLLATE "default" NOT NULL,
    "name" varchar(255) COLLATE "default",
    "age" int4
);
DROP TABLE IF EXISTS "b_schema"."table_02";
CREATE TABLE "b_schema"."table_02" (
    "id" varchar(32) COLLATE "default" NOT NULL,
    "name" varchar(255) COLLATE "default",
    "age" int4
);



-- 创建第2个数据库
create database test002;
-- 切换到对应的数据库
\c test002;
-- 创建schema
CREATE schema IF NOT EXISTS a_schema;
CREATE schema IF NOT EXISTS b_schema;
-- 创建数据表table
DROP TABLE IF EXISTS "public"."table_02";
CREATE TABLE "public"."table_02" (
    "id" varchar(32) COLLATE "default" NOT NULL,
    "name" varchar(255) COLLATE "default",
    "age" int4
);
DROP TABLE IF EXISTS "a_schema"."table_02";
CREATE TABLE "a_schema"."table_02" (
    "id" varchar(32) COLLATE "default" NOT NULL,
    "name" varchar(255) COLLATE "default",
    "age" int4
);
DROP TABLE IF EXISTS "b_schema"."table_02";
CREATE TABLE "b_schema"."table_02" (
    "id" varchar(32) COLLATE "default" NOT NULL,
    "name" varchar(255) COLLATE "default",
    "age" int4
);