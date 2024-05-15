/* 	Esercizio 1: Cominciate facendo un’analisi esplorativa del database, ad esempio: 

/* 	- Fate un elenco di tutte le tabelle.*/
SHOW TABLES FROM chinook; -- se il DB non è settato come default
USE chinook; -- setta come default il DB
SHOW TABLES;

/* 	- Visualizzate le prime 10 righe della tabella Album.*/
SELECT 
    *
FROM
    album
LIMIT 10;

/*	- Trovate il numero totale di canzoni della tabella Tracks.*/
SELECT 
    COUNT(track.TrackId) AS NumeroCanzoni
FROM
    track;

/*	- Trovate i diversi generi presenti nella tabella Genre.*/
SELECT DISTINCT
    genre.Name
FROM
    genre;

/*	Esercizio 2: Recuperate il nome di tutte le tracce e del genere associato.*/
SELECT 
    track.Name AS NomeTraccia, genre.Name AS Genere
FROM
    track
        LEFT JOIN
    genre ON track.GenreId = genre.GenreId;
    
/*	Esercizio 3: Recuperate il nome di tutti gli artisti che hanno almeno un album nel database. Esistono artisti senza album nel database?*/
SELECT DISTINCT
    artist.Name AS Artista
FROM
    artist
        JOIN
    album ON artist.ArtistId = album.ArtistId;

SELECT 
    artist.Name AS Artista, COUNT(*) AS NumeroAlbum
FROM
    artist
        LEFT JOIN
    album ON artist.ArtistId = album.ArtistId
GROUP BY artist.Name
ORDER BY NumeroAlbum;

/*	Esercizio 4: Recuperate il nome di tutte le tracce, del genere associato e della tipologia di media. Esiste un modo per recuperare il nome 
	della tipologia di media?*/
SELECT 
    track.Name AS NomeTraccia,
    genre.Name AS Genere,
    mediatype.Name AS TipoMedia
FROM
    track
        LEFT JOIN
    genre ON track.GenreId = genre.GenreId
        LEFT JOIN
    mediatype ON track.MediaTypeId = mediatype.MediaTypeId;

/*	Esercizio 5: Elencate i nomi di tutti gli artisti e dei loro album.*/
SELECT 
    artist.Name AS Artista, album.Title AS Album
FROM
    artist
        LEFT JOIN
    album ON artist.ArtistId = album.ArtistId;