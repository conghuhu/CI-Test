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

-- luasql content
local luasqlSQL =
  [[
  INSERT INTO `casbin_rule` VALUES (1,'p','*','/','GET',NULL,NULL,NULL),(2,'p','admin','*','*',NULL,NULL,NULL),(3,'g','alice','admin',NULL,NULL,NULL,NULL)
]]

-- execute database action
conn:execute(luasqlSQL)

conn:close() -- close database connect
env:close() -- close database env
