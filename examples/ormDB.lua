local dirver = require("luasql.mysql")

-- create env
local env = dirver.mysql()

local database = os.getenv("MYSQL_DB") or "casbin"
local user = os.getenv("MYSQL_USER") or "root"
local password = os.getenv("MYSQL_PASSWORD") or "root"

-- connect mysql
local conn, err = env:connect(database, user, password, "127.0.0.1", "3306")

if err then
  error("Could not create connection to database, error:" .. err)
end

-- set DB decode
conn:execute "SET NAMES UTF8"

-- 4daysorm content
local ormSQL =
  [[
    INSERT INTO `casbin` VALUES (1,'*','/','GET',NULL,NULL,NULL,'p'),(2,'admin','*','*',NULL,NULL,NULL,'p'),(3,'alice','admin',NULL,NULL,NULL,NULL,'g')
]]

-- execute database action
conn:execute(ormSQL)

conn:close() -- close database connect
env:close() -- close database env
