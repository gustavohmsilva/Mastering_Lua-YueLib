#!/usr/bin/lua5.3
local pegasus = require 'pegasus'
local web = require 'htk'

servidor_web = pegasus:new{
        port = 8000,
        location = '/'
}

servidor_web:start(function(requisicao, resposta)
        pagina = web.HTML{
                web.HEAD{
                        web.META{charset = 'utf-8'},
                        web.TITLE{'Meu servidor local com botão no tray usando pegasus e Yue!'}
                },
                web.BODY{
                        web.H2{'Meu servidor local com botão no tray usando pegasus e Yue!'}
                }
        }

        local caminho = requisicao:path()
        if caminho == '/sair' then
                resposta:write('')
                os.exit(0)
        else
                resposta:write(pagina)
        end
end)