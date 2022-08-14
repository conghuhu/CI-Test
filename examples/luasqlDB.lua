local dirver = require("luasql.mysql")

-- create env
local env = dirver.mysql()

local database = os.getenv("MYSQL_DB") or "casbin"
local user = os.getenv("MYSQL_USER") or "root"
local password = os.getenv("MYSQL_PASSWORD") or "root"

print(database)
print(user)
print(password)

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

local all = conn:execute("select * from casbin_rule")
local row = all:fetch({}, "a")

while row do
  local var = string.format("%d %s %s %s %s\n", row.id, row.ptype, row.v0, row.v1, tostring(row.v2))

  print(var)

  row = all:fetch(row, "a")
end

conn:close() -- close database connect
env:close() -- close database env
