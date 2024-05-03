-- Cosa contiene Inventario:

SELECT
	*
FROM
	Inventario;

-- Supponiamo di voler rifornire il Prodotto 42 nel Magazzino 5
-- che sembra essere in esaurimento:

SELECT
	*
FROM
	Inventario
WHERE
	IdProdotto = 42 and IdMagazzino = 5;
    
-- Andiamo a vedere la soglia di restock della categoria di questo prodotto:

SELECT
	IdProdotto, IdMagazzino, NomeCategoria, QuantitaGiacenza, Soglia
FROM
	SogliaRestock
JOIN
	Categoria USING (IdCategoria)
JOIN
	Magazzino USING (IdMagazzino)
JOIN
	Prodotto USING (IdCategoria)
JOIN
	Inventario USING (IdProdotto, IdMagazzino)
WHERE
	IdProdotto = 42 and IdMagazzino = 5;
    
-- Rifornimento:

UPDATE
	Inventario
SET
	QuantitaGiacenza = 200,
	InEsaurimento = FALSE
WHERE
	IdProdotto = 42 AND IdMagazzino = 5;
    

-- Supponiamo di ricevere una nuova Transazione che segna la vendita
-- nell'inventario del Prodotto con IdProdotto = 42 e IdMagazzino = 5
-- per una QuantitaVenduta di 190 unita' dal Negozio con id = 1:

INSERT INTO
	Transazione(IdTransazione, DataTransazione, QuantitaVenduta, IdNegozio, IdProdotto, idMagazzino)
VALUES
	(null, "2024-04-25", 190, 1, 42, 5);

-- Osserviamo il risultato sul DB:

SELECT
	*
FROM
	Inventario
WHERE
	IdProdotto = 42 and IdMagazzino = 5;


-- Se andiamo a vedere sulla view apposita, noteremo che
-- compare anche il nostro prodotto:

SELECT
	*
FROM
	vw_ProdottiInEsaurimento;