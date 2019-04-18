local gui = require 'yue.gui'
local agenda = require 'models'
local base = agenda.connect('agenda.db')

local views = {}
        views.principal = function()
                -- INICIO CRIAÇÃO DA JANELA
                local janela = gui.Window.create{}
                janela.onclose = gui.MessageLoop.quit
                janela:settitle('Agenda Telefônica 0.1')
                janela:setcontentsize{
                        width = 1080,
                        height = 480
                }
                -- CRIAÇÃO DO CONTAINER PRINCIPAL
                local container = gui.Container.create()
                container:setstyle{padding = 10}

                -- CONSULTA BASE DE DADOS (TODOS O CONTEÚDO)
                local base, dados_agenda = agenda.read_all(base)

                -- CRIAÇÃO DO MODELO DA TABELA YUE
                mod_tabela = gui.SimpleTableModel.create(6)
                for _, row in ipairs(dados_agenda) do
                        mod_tabela:addrow{
                                tostring(row.id),
                                row.nome,
                                row.empresa,
                                row.telefone,
                                row.email,
                                row.endereco
                        }
                end

                -- CRIAÇÃO DO VISUALIZADOR DA TABELA YUE
                local view_tabela = gui.Table.create()
                view_tabela:setstyle{flex = 1}
                view_tabela:setmodel(mod_tabela)
                local colunas = {
                        {name = 'ID', width = 60},
                        {name = 'Nome', width = 240},
                        {name = 'Empresa', width = 200},
                        {name = 'Telefone', width = 160},
                        {name = 'E-mail', width = 200},
                        {name = 'Endereço', width = 200},
                }
                for _, v in ipairs(colunas) do
                        view_tabela:addcolumnwithoptions(v.name, {width = v.width})
                end

                -- CRIAÇÃO DO CONTAINER DAS AÇÕES NA BASE DE DADOS
                local barra_acoes = gui.Container.create()
                barra_acoes:setstyle{flexdirection = 'row'}

                --CRIAÇÃO DO BOTÃO DE CRIAR
                local btn_criar = gui.Button.create('Criar')
                btn_criar:setenabled(true)
                btn_criar:setstyle{
                        width = 100,
                        margin_top = 10,
                        margin_right = 10
                }
                btn_criar.onclick = views.criar

                --CRIAÇÃO DO BOTÃO DE EDITAR
                local btn_editar = gui.Button.create('Editar')
                btn_editar:setenabled(true)
                btn_editar:setstyle{
                        width = 100,
                        margin_top = 10,
                        margin_right = 10
                }

                --CRIAÇÃO DO BOTÃO DE DELETAR
                local btn_deletar = gui.Button.create('Deletar')
                btn_deletar:setenabled(true)
                btn_deletar:setstyle{
                        width = 100,
                        margin_top = 10,
                        margin_right = 10
                }
                btn_deletar.onclick = function()
                        row_number = view_tabela:getselectedrow()
                        agenda.delete(base, mod_tabela:getvalue(1, row_number))
                        mod_tabela:removerowat(row_number)
                end

                -- CONSTRUÇÃO DA ESTRUTURA DE ELEMENTOS
                janela:setcontentview(container)
                container:addchildview(view_tabela)
                container:addchildview(barra_acoes)
                barra_acoes:addchildview(btn_criar)
                barra_acoes:addchildview(btn_editar)
                barra_acoes:addchildview(btn_deletar)

                janela:center()
                janela:activate()
                gui.MessageLoop.run()
                base:close()
        end

        views.criar = function()
                -- INICIO CRIAÇÃO DA JANELA
                local janela = gui.Window.create{}
                janela:settitle('Criar Novo Contacto')
                janela:setcontentsize{
                        width = 720,
                        height = 180
                }
                -- CRIAÇÃO DO CONTAINER PRINCIPAL
                local container = gui.Container.create()
                container:setstyle{padding = 10}

                -- CRIAÇÃO DAS LINHAS-CONTAINERS
                local linhas = {}
                for i = 1, 5 do
                        table.insert(linhas, gui.Container.create())
                        linhas[i]:setstyle{flexdirection = 'row'}
                end

                -- CRIAÇÃO DOS LABELS DOS CAMPOS DO FORMULÁRIO
                local labels = {
                        'Nome',
                        'Empresa',
                        'Telefone',
                        'E-mail',
                        'Endereço'
                }
                for i in ipairs(labels) do
                        labels[i] = gui.Label.create(labels[i])
                        labels[i]:setalign('start')
                        labels[i]:setstyle{width = 80}
                end
                labels[4]:setstyle{margin_left = 10}

                -- CRIAÇÃO DOS ENTRIES DO FORMULÁRIO
                local entries = {
                        'nome',
                        'empresa',
                        'telefone',
                        'email',
                        'endereco'
                }
                -- TALVEZ DE MERDA!
                for _,v in ipairs(entries) do
                        entries[v] = gui.Entry.create()
                        entries[v]:setstyle{
                                flex = 1,
                                margin_bottom = 2
                        }
                end

                -- CRIAÇÃO DO BOTÃO DE REGISTRO DOS DADOS NA PLANILHA
                local btn_registrar = gui.Button.create('Registrar Contacto')
                btn_registrar:setenabled(true)
                btn_registrar:setstyle{
                        width = 100,
                        margin_top = 8
                }

                -- CADASTRO NA BASE DE DADOS E ATUALIZAÇÃO DO MODEL DA TABELA
                btn_registrar.onclick = function()
                        base = agenda.create(
                                base,
                                entries.nome:gettext(),
                                entries.empresa:gettext(),
                                entries.telefone:gettext(),
                                entries.email:gettext(),
                                entries.endereco:gettext()
                        )
                        base, ult_linha = agenda.last_id(base)
                        mod_tabela:addrow{
                                tostring(ult_linha.id),
                                ult_linha.nome,
                                ult_linha.empresa,
                                ult_linha.telefone,
                                ult_linha.email,
                                ult_linha.endereco
                        }
                end

                -- CONTRUÇÃO DA ESTRUTURA DE ELEMENTOS
                janela:setcontentview(container)
                for _,v in ipairs(linhas) do
                        container:addchildview(v)
                end
                linhas[1]:addchildview(labels[1])
                linhas[1]:addchildview(entries.nome)
                linhas[2]:addchildview(labels[2])
                linhas[2]:addchildview(entries.empresa)
                linhas[3]:addchildview(labels[3])
                linhas[3]:addchildview(entries.telefone)
                linhas[3]:addchildview(labels[4])
                linhas[3]:addchildview(entries.email)
                linhas[4]:addchildview(labels[5])
                linhas[4]:addchildview(entries.endereco)
                linhas[5]:addchildview(btn_registrar)

                --INICIALIZAÇÃO DA JANELA
                janela:center()
                janela:activate()
        end

return views