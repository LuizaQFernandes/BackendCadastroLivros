import express from 'express'
const app = express()
const port = 4000

app.use(express.urlencoded({extended: true})) // converterá caracteres especiais em html entity 
app.use(express.json()) // Faré o Parse no conteudo JSON
app.disable('x-powered-by')

import rotasLivros from './routes/livros.js'

//rotas RESTfull
app.use('/api/livros', rotasLivros)

app.get('/api', (req, res) => {
    res.status(200).json({
        mensagem: 'API da Livraria 100% funcional!',
        versao: '1.0.0'
    })
})

//rota de conteudo publico
app.use('/', express.static('public'))

//rota para tratar 404
app.use(function(req, res){
    res.status(404).json({
        mensagem: `A rota ${req.originalUrl} não existe!`    })
})

app.listen(port, function(){
    console.log(`Servidor web rodando no terminal ${port}`)
})