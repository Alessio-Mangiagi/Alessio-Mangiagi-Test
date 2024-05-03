/*
Magazzino: IdMagazzino; Indirizzo;

SogliaRestock: IdMagazzino; IdCategoria; Soglia;

Prodotto: IdProdotto; NomeProdotto; IdCategoria;

Negozio: IdNegozio; Indirizzo; NomeNegozio;

Transazione: Data; IdTransazione, IdNegozio; IdProdotto; QuantitaVenduta;

Categoria: IdCategoria; NomeCategoria;

Inventario: IdProdotto; IdMagazzino; QuantitaGiacenza;

*/

DROP DATABASE IF EXISTS VendiCose;
CREATE DATABASE VendiCose;
USE VendiCose;

CREATE TABLE Magazzino (
	IdMagazzino INT PRIMARY KEY,
    IndirizzoMagazzino VARCHAR(150)
);

CREATE TABLE Categoria (
	IdCategoria INT PRIMARY KEY,
    NomeCategoria VARCHAR(100)
);

CREATE TABLE SogliaRestock(
	IdMagazzino INT,
    IdCategoria INT,
    Soglia INT,
    PRIMARY KEY (IdMagazzino, IdCategoria),
    FOREIGN KEY (IdMagazzino) REFERENCES Magazzino(IdMagazzino) ON DELETE CASCADE,
    FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria) ON DELETE CASCADE
);

CREATE TABLE Prodotto (
	IdProdotto INT PRIMARY KEY,
    NomeProdotto VARCHAR(100),
    IdCategoria INT,
    FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria) ON DELETE SET NULL
);

CREATE TABLE Negozio (
	IdNegozio INT PRIMARY KEY,
    IndirizzoNegozio VARCHAR(150),
    NomeNegozio VARCHAR(50)
);

CREATE TABLE Inventario (
	IdMagazzino INT,
    IdProdotto INT,
    QuantitaGiacenza INT,
    InEsaurimento BOOLEAN,
    PRIMARY KEY (IdMagazzino, IdProdotto),
    FOREIGN KEY (IdMagazzino) REFERENCES Magazzino(IdMagazzino) ON DELETE CASCADE,
    FOREIGN KEY (IdProdotto) REFERENCES Prodotto(IdProdotto) ON DELETE CASCADE
);


CREATE TABLE Transazione (
	IdTransazione INT PRIMARY KEY auto_increment,
    DataTransazione date,
    QuantitaVenduta INT,
    IdNegozio INT,
    IdProdotto INT,
    idMagazzino INT,
    FOREIGN KEY (IdNegozio) REFERENCES Negozio(IdNegozio),
    FOREIGN KEY (IdProdotto, IdMagazzino) REFERENCES Inventario(IdProdotto, IdMagazzino)
); 


delimiter /

CREATE TRIGGER AggiornaInventarioDopoVendita AFTER INSERT ON Transazione
	FOR EACH ROW
	BEGIN
		UPDATE Inventario
		SET QuantitaGiacenza = QuantitaGiacenza - NEW.QuantitaVenduta
		WHERE (IdProdotto = NEW.IdProdotto and IdMagazzino = NEW.IdMagazzino);
		
		UPDATE Inventario
		SET InEsaurimento = True
		WHERE QuantitaGiacenza < (
									SELECT
										Soglia
									FROM 
										SogliaRestock JOIN Categoria USING (IdCategoria)
									JOIN
										Prodotto
									USING
										(IdCategoria)
									WHERE
										IdMagazzino = NEW.IdMagazzino and IdProdotto = NEW.IdProdotto
								);
	END;
/

delimiter ;

CREATE VIEW vw_ProdottiInEsaurimento AS
	SELECT
		IdProdotto, NomeProdotto,  IdMagazzino, IndirizzoMagazzino Magazzino,
        NomeCategoria CategoriaProdotto, QuantitaGiacenza QuantitaRimaste,
        Soglia SogliaRestock
	FROM
		inventario JOIN prodotto USING (idProdotto)
	JOIN
		Magazzino USING (idMagazzino)
	JOIN
		Categoria USING (IdCategoria)
	JOIN
		SogliaRestock USING (IdMagazzino, IdCategoria)
	WHERE
		InEsaurimento;