local gui = require('yue.gui')

local janela = gui.Window.create()
janela.onclose = gui.MessageLoop.quit
janela:settitle('Meu primeiro código com Yue')
janela:setcontentsize{
        width = 480,
        height = 260
}

local root = gui.Container.create()
root:setstyle{
        padding = 10,
        flexdirection = 'row',
        height = 60,
}

local mensagem = gui.Label.create('Ola Mundo!!!')
mensagem:setalign('center')
mensagem:setstyle{
        width = 230
}

local botao = gui.Button.create('Tchau...')
botao:setenabled(true)
botao:setstyle{
        width = 230
}
botao.onclick = gui.MessageLoop.quit

root:addchildview(mensagem)
root:addchildview(botao)
janela:setcontentview(root)
janela:center()
janela:activate()
gui.MessageLoop.run()