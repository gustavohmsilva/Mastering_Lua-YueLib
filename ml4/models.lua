local sql = require 'luasql.sqlite3'

local db = {}
        db.connect = function(database)
                local env = sql.sqlite3()
                local conn = env:connect(database)
                local checa_tabela = 'SELECT name FROM sqlite_master WHERE type="table" \
                        AND name="clientes"'
                local cursor = assert(conn:execute(checa_tabela))
                local result = {}
                repeat
                        local line = cursor:fetch({}, 'a')
                        table.insert(result, line)
                until not line
                cursor:close()
                if #result == 0 then
                        local command = 'CREATE TABLE clientes(\
                                id INTEGER PRIMARY KEY,\
                                nome TEXT NOT NULL,\
                                empresa TEXT NOT NULL,\
                                telefone TEXT NOT NULL,\
                                email TEXT NOT NULL,\
                                endereco TEXT NOT NULL)'
                        conn:execute(command)
                end
                return conn
        end

        db.create = function(conn, nome, empresa, telefone, email, endereco)
                local query = 'INSERT INTO clientes (nome, empresa, telefone, email, endereco) \
                        VALUES ("%s", "%s", "%s", "%s", "%s")'
                query = query:format(nome, empresa, telefone, email, endereco)
                assert(conn:execute(query))
                return conn
        end

        db.edit = function(conn, id, nome, empresa, telefone, email, endereco)
                local query = 'UPDATE clientes \
                SET nome = "%s", empresa = "%s", telefone = "%s", email = "%s", endereco = "%s" \
                WHERE id = %s'
                query = query:format(nome, empresa, telefone, email, endereco, id)
                assert(conn:execute(query))
                return conn
        end

        db.read_all = function(conn)
                local query = 'SELECT * FROM clientes'
                local cursor = assert(conn:execute(query))
                local result = {}
                repeat
                        line = cursor:fetch({}, 'a')
                        table.insert(result, line)
                until not line
                cursor:close()
                return conn, result
        end

        db.read_unique = function(conn, id)
                local query = 'SELECT * FROM clientes WHERE id = %s LIMIT 1'
                query = query:format(id)
                local cursor = assert(conn:execute(query))
                local line = cursor:fetch({}, 'a')
                cursor:close()
                return conn, line
        end

        db.last_id = function(conn)
                local query = 'SELECT * FROM clientes ORDER BY ID DESC LIMIT 1'
                local cursor = assert(conn:execute(query))
                local line = cursor:fetch({}, 'a')
                cursor:close()
                return conn, line
        end

        db.delete = function(conn, rowid)
                local query = string.format('DELETE FROM clientes WHERE "id" = "%s"', rowid)
                assert(conn:execute(query))
                return conn
        end

return db