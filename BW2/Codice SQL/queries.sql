
-- Per controllare tutti i prodotti in esaurimento
SELECT
	IdProdotto, NomeProdotto,  IdMagazzino, IndirizzoMagazzino, NomeCategoria CategoriaProdotto, QuantitaGiacenza QuantitaRimaste, Soglia SogliaRestock
FROM
	Inventario JOIN Prodotto
USING
	(idProdotto)
JOIN
	Magazzino
USING
	(idMagazzino)
JOIN
	Categoria
USING
	(IdCategoria)
JOIN
	Sogliarestock
USING
	(IdMagazzino, IdCategoria)
WHERE
	InEsaurimento;

-- Oppure utilizzando la view vw_ProdottiInEsaurimento
SELECT
	*
FROM
	vw_ProdottiInEsaurimento;
    


-- Per controllare lo stato di un prodotto nell'inventario
--  (IdProdotto = 42 e IdMagazzino = 5 per esempio)

SELECT
	*
FROM
	Inventario
WHERE
	IdProdotto = 42 AND IdMagazzino = 5;

-- Per controllare la soglia restock del prodotto tramite IdProdotto e IdMagazzino
-- (IdProdotto = 42 e IdMagazzino = 5 per esempio)

SELECT
	*
FROM
	Inventario JOIN Magazzino
USING
	(IdMagazzino)
JOIN
	Prodotto
USING
	(IdProdotto)
JOIN
	Categoria
USING
	(IdCategoria)
JOIN
	SogliaRestock
USING
	(IdMagazzino, IdCategoria)
WHERE
	IdProdotto = 42 AND IdMagazzino = 5;



-- Inserimento di una nuova transazione (IdTransazione, DataTransazione, QuantitaVenduta, IdNegozio, IdProdotto, idMagazzino)
--  (IdProdotto = 42 e IdMagazzino = 5 per esempio) togliendo 190 unita' dal negozio co IdNegozio = 1

INSERT INTO Transazione VALUES
(null, "2024-04-25", 190, 1, 42, 5);


-- Rifornimento di un prodotto avendo IdProdotto e IdMagazzino, aggiornando anche il campo InEsaurimento a False
--  (IdProdotto = 42 e IdMagazzino = 5 per esempio) aggiugendo 200 unita'

UPDATE
	Inventario
SET
	QuantitaGiacenza = 200,
	InEsaurimento = FALSE
WHERE
	IdProdotto = 42 AND IdMagazzino = 5;
    
    
-- Come monitorare le soglie di restock

SELECT
	*
FROM
	SogliaRestock JOIN Categoria
USING
	(IdCategoria)
JOIN
	Magazzino
USING
	(IdMagazzino);