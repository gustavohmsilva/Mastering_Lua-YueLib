local gui = require 'yue.gui'

janela = gui.Window.create()
janela:settitle('Navegador - Lua Tray App')
janela:setcontentsize{
        width = 1280,
        height = 720
}
local browser = gui.Browser.create()
browser:setstyle{
        flex = 1
}
janela:setcontentview(browser)
janela:center()

local tray_icon = gui.Image.createfrompath('globe.png')
local tray = gui.Tray.createwithimage(tray_icon)
local tray_menu = gui.Menu.create{
        {
                type = 'label',
                visible = true,
                enabled = true,
                label = 'Iniciar servidor',
                onclick = function()
                        io.popen('./server.lua')
                        browser:loadurl('http://0.0.0.0:8000')
                        janela:activate()
                end
        },
        {
                type = 'label',
                visible = true,
                enabled = true,
                label = 'Encerrar servidor',
                onclick = function()
                        os.execute('curl --silent --output /dev/null http://0.0.0.0:8000/sair')
                end
        },
        {
                type = 'label',
                visible = true,
                enabled = true,
                label = 'Sair...',
                onclick = function()
                        os.execute('curl --silent --output /dev/null http://0.0.0.0:8000/sair')
                        gui.MessageLoop.quit()
                end
        }
}
tray:setmenu(tray_menu)
gui.MessageLoop.run()