CREATE DATABASE LIVRARIA


CREATE TABLE LIV_CADASTROLIVRO
(
CAD_IN_CODIGO INT NOT NULL IDENTITY CONSTRAINT LIV_PK_CADASTROLIVRO PRIMARY KEY,
CAD_ST_NOME VARCHAR(50) NOT NULL,
CAD_ST_AUTOR VARCHAR(50) NOT NULL,
CAD_IN_PAGINAS INT NOT NULL CONSTRAINT LIV_CK_CAD_PAGINAS
	CHECK (CAD_IN_PAGINAS >= 0),
CAD_ST_SINOPSE VARCHAR(500) NOT NULL,
CAD_RE_PRECO NUMERIC(4,2) NOT NULL CONSTRAINT LIV_CK_CAD_PRECO
	CHECK (CAD_RE_PRECO >= 0),
CAD_DT_DATAINCLUSAO DATE DEFAULT GETDATE(),
);

INSERT INTO LIV_CADASTROLIVRO(CAD_ST_NOME, CAD_ST_AUTOR, CAD_IN_PAGINAS, CAD_ST_SINOPSE, CAD_RE_PRECO, CAD_DT_DATAINCLUSAO) VALUES 
(
'Anne de Green Gables', 
'Lucy Maud Montgomery', 
288, 
'Agora com 16 anos, sentindo-se quase adulta, Anne est� prestes a come�ar a lecionar na escola de Avonlea, a realidade de seu trabalho torna-se um teste para seu car�ter, surgindo v�rias d�vidas quanto ao seu futuro. ... Enfim, Anne decide deixar tudo para ir atr�s de seu grande sonho.',
19.99,
'2021-05-03'
);

SELECT * FROM LIV_CADASTROLIVRO;


/* PROCEDURES*/

/*Consulta para todos os registros*/
CREATE PROCEDURE SP_S_LIV_CADASTROLIVRO
AS
SELECT CAD_IN_CODIGO AS 'C�DIGO', CAD_ST_NOME AS 'NOME', CAD_ST_AUTOR AS 'AUTOR(A)',  
CAD_IN_PAGINAS AS 'N� DE P�GINAS', CAD_ST_SINOPSE AS 'SINOPSE', CAD_RE_PRECO AS 'PRE�O', CAD_DT_DATAINCLUSAO AS 'DATA DE INCLUS�O'
FROM LIV_CADASTROLIVRO
ORDER BY CAD_DT_DATAINCLUSAO
GO

SP_S_LIV_CADASTROLIVRO

/*Consulta para apenas um registro*/
CREATE PROCEDURE SP_S_LIV_CADASTROLIVRO_NOME
@NOME VARCHAR(50)
AS
SELECT CAD_IN_CODIGO AS 'CÓDIGO', CAD_ST_NOME AS 'NOME', CAD_ST_AUTOR AS 'AUTOR(A)',  
CAD_IN_PAGINAS AS 'N° DE PÁGINAS', CAD_ST_SINOPSE AS 'SINOPSE', CAD_RE_PRECO AS 'PREÇO', CAD_DT_DATAINCLUSAO AS 'DATA DE INCLUSÃO'
FROM LIV_CADASTROLIVRO
WHERE UPPER(TRIM(@NOME)) = UPPER(TRIM(CAD_ST_NOME))
ORDER BY CAD_DT_DATAINCLUSAO
GO

SP_S_LIV_CADASTROLIVRO_NOME 'Anne e a Casa dos SonHos'

/* Inclus�o*/
CREATE PROCEDURE SP_I_LIV_CADASTROLIVRO
@NOME VARCHAR(50),
@AUTOR VARCHAR(50),
@PAGINAS INT,
@SINOPSE VARCHAR(500),
@PRECO NUMERIC(4,2)
AS
DECLARE @NR_NOME INT

SELECT @NR_NOME = COUNT(CAD_ST_NOME)
FROM LIV_CADASTROLIVRO WHERE UPPER(TRIM(@NOME)) = UPPER(TRIM(CAD_ST_NOME))

IF @NR_NOME = 1
BEGIN
   RAISERROR('Esse livro já está registrado no banco de dados', 15,1)
   RETURN
END

IF @PAGINAS <= 0
BEGIN
   RAISERROR('O número de páginas não pode ser igual ou menor que 0', 15,1)
   RETURN
END

IF @PRECO < 0
BEGIN
   RAISERROR('O preço não pode ser menor que 0', 15,1)
   RETURN
END

IF LEN(TRIM(@NOME)) = 0 OR LEN(TRIM(@AUTOR)) = 0 OR LEN(TRIM(@SINOPSE)) = 0
BEGIN
   RAISERROR('Os campos Nome, Autor e Sinopse são obrigatórios ', 15,1)
   RETURN
END

INSERT INTO LIV_CADASTROLIVRO(CAD_ST_NOME, CAD_ST_AUTOR, CAD_IN_PAGINAS, CAD_ST_SINOPSE, CAD_RE_PRECO) VALUES 
(
TRIM(@NOME), @AUTOR, @PAGINAS, @SINOPSE, @PRECO
)
GO

SP_I_LIV_CADASTROLIVRO 'Ruína e Ascensão', 'Leich Bardugo', 328, 'Oculta nas profundezas de uma antiga rede de túneis e cavernas, Alina está fragilizada e deve se submeter a duvidosa proteção do Apparat e de fanáticos que a adoram como uma santa. No entanto, sua esperança está em outro lugar e seus planos exigem que ela recupere as forças para sair dali o mais rápido possível.', 50.00

SP_I_LIV_CADASTROLIVRO 'Harry Potter e a Câmara Secreta', 'JK Rowling', 288, 'Após as sofríveis fúrias na casa dos tios, Harry Potter se prepara para voltar a Hogwarts e começar seu segundo ano na escola de bruxos. Na véspera do início das aulas, a estranha criatura Dobby aparece em seu quarto e o avisa de que voltar é um erro e que algo muito ruim pode acontecer se Harry insistir em continuar os estudos de bruxaria. O garoto, no entanto, está disposto a correr o risco e se livrar do lar problemático.', 39.99

SP_I_LIV_CADASTROLIVRO 'Jogos Vorazes', 'Suzanne Collins', 400, 'Quando Katniss Everdeen, de 16 anos, decide participar dos Jogos Vorazes para poupar a irmã mais nova, causando grande comoção no país, ela sabe que essa pode ser a sua sentença de morte. Mas a jovem usa toda a sua habilidade de caça e sobrevivência ao ar livre para se manter viva.', 33.90

SP_S_LIV_CADASTROLIVRO

/*Altera��o*/
CREATE PROCEDURE SP_U_LIV_CADASTROLIVRO
@NOME VARCHAR(50),
@AUTOR VARCHAR(50),
@PAGINAS INT,
@SINOPSE VARCHAR(500),
@PRECO NUMERIC(4,2)
AS
DECLARE @NR_NOME INT

SELECT @NR_NOME = COUNT(CAD_ST_NOME)
FROM LIV_CADASTROLIVRO WHERE UPPER(TRIM(@NOME)) = UPPER(TRIM(CAD_ST_NOME))

IF @NR_NOME = 0
BEGIN
   RAISERROR('Esse livro não está registrado no banco de dados', 15,1)
   RETURN
END

IF @PAGINAS <= 0
BEGIN
   RAISERROR('O número de páginas não pode ser igual ou menor que 0', 15,1)
   RETURN
END

IF @PRECO < 0
BEGIN
   RAISERROR('O preço não pode ser menor que 0', 15,1)
   RETURN
END

IF LEN(TRIM(@NOME)) = 0 OR LEN(TRIM(@AUTOR)) = 0 OR LEN(TRIM(@SINOPSE)) = 0
BEGIN
   RAISERROR('Os campos Nome, Autor e Sinopse são obrigatórios ', 15,1)
   RETURN
END

UPDATE LIV_CADASTROLIVRO SET
CAD_ST_NOME = TRIM(@NOME),
CAD_ST_AUTOR = @AUTOR,
CAD_IN_PAGINAS = @PAGINAS, 
CAD_ST_SINOPSE = @SINOPSE, 
CAD_RE_PRECO = @PRECO
WHERE UPPER(TRIM(@NOME)) = UPPER(TRIM(CAD_ST_NOME))
GO

SP_U_LIV_CADASTROLIVRO 'Harry Potter e a Câmara Secreta', 'JK Rowling', 288, 'Após as sofríveis fúrias na casa dos tios, Harry Potter se prepara para voltar a Hogwarts e começar seu segundo ano na escola de bruxos. Na véspera do início das aulas, a estranha criatura Dobby aparece em seu quarto e o avisa de que voltar é um erro e que algo muito ruim pode acontecer se Harry insistir em continuar os estudos de bruxaria. O garoto, no entanto, está disposto a correr o risco e se livrar do lar problemático.', 39.99

SP_S_LIV_CADASTROLIVRO

/*Dele��o*/
CREATE PROCEDURE SP_D_LIV_CADASTROLIVRO
@NOME VARCHAR(50)
AS
DECLARE @NR_NOME INT

SELECT @NR_NOME = COUNT(CAD_ST_NOME)
FROM LIV_CADASTROLIVRO WHERE UPPER(TRIM(@NOME)) = UPPER(TRIM(CAD_ST_NOME))

IF @NR_NOME = 0
BEGIN
   RAISERROR('Esse livro não está registrado no banco de dados', 15,1)
   RETURN
END

DELETE FROM LIV_CADASTROLIVRO WHERE UPPER(TRIM(@NOME)) = UPPER(TRIM(CAD_ST_NOME))
GO

SP_D_LIV_CADASTROLIVRO 'Anne de Avonlea'

SP_S_LIV_CADASTROLIVRO

/*FUN��O*/

CREATE FUNCTION FN_VALORFRETE
(@NOME VARCHAR(50))
RETURNS NUMERIC(4,2) AS
BEGIN
--DECLARE
DECLARE @DATA DATE
DECLARE @FRETE NUMERIC(4,2)
DECLARE @PRECO NUMERIC (4,2)
--SET
SELECT @DATA =  CAD_DT_DATAINCLUSAO FROM LIV_CADASTROLIVRO WHERE CAD_ST_NOME = @NOME
SELECT @PRECO  =  CAD_RE_PRECO FROM LIV_CADASTROLIVRO WHERE CAD_ST_NOME = @NOME
SET @FRETE = 0


--SE O LIVRO FOI ADICIONADO NO MESMO DIA
IF DATEDIFF(DD, @DATA, CONVERT(date, getdate())) = 0
BEGIN
SELECT @FRETE = CAD_RE_PRECO * 0.30 FROM LIV_CADASTROLIVRO WHERE CAD_ST_NOME = @NOME
END

--SE O LIVRO FOI ADICIONADO entre 1 e 10 dias atras
IF DATEDIFF(DD, @DATA, CONVERT(date, getdate())) >=1 and DATEDIFF(DD, @DATA, CONVERT(date, getdate())) <10
BEGIN
SELECT @FRETE = CAD_RE_PRECO * 0.20 FROM LIV_CADASTROLIVRO WHERE CAD_ST_NOME = @NOME
END

--SE O LIVRO FOI ADICIONADO entre 10 e 20 dias atras
IF DATEDIFF(DD, @DATA, CONVERT(date, getdate())) >=10 and DATEDIFF(DD, @DATA, CONVERT(date, getdate())) <20
BEGIN
SELECT @FRETE = CAD_RE_PRECO * 0.10 FROM LIV_CADASTROLIVRO WHERE CAD_ST_NOME = @NOME
END

--SE O LIVRO FOI ADICIONADO mais de 20 dias atras
IF  DATEDIFF(DD, @DATA, CONVERT(date, getdate())) > 20
BEGIN
SELECT @FRETE = CAD_RE_PRECO * 0 FROM LIV_CADASTROLIVRO WHERE CAD_ST_NOME = @NOME
END

RETURN @FRETE

END

SELECT dbo.FN_VALORFRETE('Anne de green gables') -- 147 dias de dif 29.99 * 0 = 0

SELECT dbo.FN_VALORFRETE('Anne de avonlea') -- 17 dias de dif 19.99 * 10% = 1,99

SELECT dbo.FN_VALORFRETE('Harry Potter e a Câmara Secreta') -- 6 dias de dif 39.99 * 20% = 7,99

SELECT dbo.FN_VALORFRETE('Jogos Vorazes') -- 0 dias de dif 33.90 * 30% = 10.17

SP_S_LIV_CADASTROLIVRO