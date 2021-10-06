//api rest de livros
import express from 'express'
import sql from 'mssql'
import {sqlConfig} from '../sql/config.js'
const router = express.Router()

/***************************************** 
 * GET /livros
 * Retornar a lista de todos os livros
 *****************************************/
router.get("/", (req, res) => {
    try{
        sql.connect(sqlConfig).then(pool => {
            return pool.request().execute('SP_S_LIV_CADASTROLIVRO')
        }).then(dados => {
            res.status(200).json(dados.recordset)
        }).catch(err => {
            res.status(400).json(err)
        })
    } catch(err){
        console.error(err)
    }
})



/***************************************** 
 * GET /livros/:nome
 * Retornar um ou mais livros através do título ou nome do autor
 *****************************************/
 
router.get("/:nome", (req, res) => {
    const nome = req.params.nome
    try{
        sql.connect(sqlConfig).then(pool => {
            return pool.request().input('nome', sql.VarChar(50), nome)
            .execute('SP_S_LIV_CADASTROLIVRO_NOME')
        }).then(dados => {
            res.status(200).json(dados.recordset)
        }).catch(err => {
            res.status(400).json(err)
        })
    } catch(err){
        console.error(err)
    }
})

/***************************************** 
 * POST /livros
 * Insere um novo livro
 *****************************************/
router.post("/", (req, res) => {
    sql.connect(sqlConfig).then(pool => {
        const {nome, autor, paginas, sinopse, preco} = req.body
        return pool.request()
        .input('nome', sql.VarChar(50), nome)
        .input('autor', sql.VarChar(50), autor)
        .input('paginas', sql.Int, paginas)
        .input('sinopse', sql.VarChar(200), sinopse)
        .input('preco', sql.Numeric(4,2), preco)

        .execute('SP_I_LIV_CADASTROLIVRO')
    }).then(dados => {
        res.status(200).json('livro incluído com sucesso!')

    }).catch(err => {
        res.status(400).json(err.message)
    })
})


/***************************************** 
 * PUT /livros
 * altera os dados de um livro
 *****************************************/
router.put("/", (req, res) => {
    sql.connect(sqlConfig).then(pool => {
        const {nome, autor, paginas, sinopse, preco} = req.body
        return pool.request()
        .input('nome', sql.VarChar(50), nome)
        .input('autor', sql.VarChar(50), autor)
        .input('paginas', sql.Int, paginas)
        .input('sinopse', sql.VarChar(200), sinopse)
        .input('preco', sql.Numeric(4,2), preco)
        .execute('SP_U_LIV_CADASTROLIVRO')
    }).then(dados => {
        res.status(200).json('livro alterado com sucesso!')

    }).catch(err => {
        res.status(400).json(err.message)
    })
})


/***************************************** 
 * DELETE /livros/:nome
 * Apaga um livro pelo nome
 *****************************************/
router.delete('/:nome', (req, res) => {
    sql.connect(sqlConfig).then(pool => {
        const nome = req.params.nome
        return pool.request()
        .input('nome', sql.VarChar(50), nome)
        .execute('SP_D_LIV_CADASTROLIVRO')

    }).then(dados => {
        res.status(200)
        .json('Livro excluído com sucesso!')

    }).catch(err => {

        res.status(400).json(err.message)
    })
})


export default router