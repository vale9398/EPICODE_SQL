/*	Esercizio 1: Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quei generi che hanno meno di 10 tracce.*/
SELECT 
    genre.Name AS Genere,
    COUNT(DISTINCT track.Name) AS NumeroTracce
FROM
    track
        LEFT JOIN
    genre ON track.GenreId = genre.GenreId
GROUP BY genre.Name
HAVING NumeroTracce >= 10
ORDER BY NumeroTracce DESC;

/*	Esercizio 2: Trovate le tre canzoni più costose.*/
SELECT 
    track.Name AS TitoloCanzone, track.UnitPrice AS Prezzo
FROM
    track
WHERE
    track.MediaTypeId <> 3
ORDER BY Prezzo DESC
LIMIT 3;

/*	Esercizio 3: Elencate gli artisti che hanno canzoni più lunghe di 6 minuti.*/
SELECT 
    artist.Name AS Artista, MAX(track.Milliseconds) AS DurataMax
FROM
    track
        LEFT JOIN
    album ON track.AlbumId = album.AlbumId
        LEFT JOIN
    artist ON album.ArtistId = artist.ArtistId
GROUP BY Artista
HAVING DurataMax > 6 * 60 * 1000
ORDER BY DurataMax DESC;

/*	Esercizio 4: Individuate la durata media delle tracce per ogni genere.*/
SELECT 
    genre.Name AS Genere,
    CAST(AVG(track.Milliseconds) / 1000 / 60 AS DECIMAL (5 , 3)) AS DurataMediaMinuti
FROM
    track
        JOIN
    genre ON track.GenreId = genre.GenreId
GROUP BY Genere
ORDER BY DurataMediaMinuti DESC;

/*	OK Esercizio 5: Elencate tutte le canzoni con la parola “Love” nel titolo, ordinandole alfabeticamente prima per genere e poi per nome.*/
SELECT 
    track.Name AS TitoloCanzone, genre.Name AS Genere
FROM
    track
        JOIN
    genre ON track.GenreId = genre.GenreId
WHERE
    track.Name LIKE '%LOVE%'
ORDER BY genre.Name , track.Name;

/*	Esercizio 6: Trovate il costo medio per ogni tipologia di media.*/
SELECT 
    mediatype.Name AS TipoMedia,
    CAST(AVG(track.UnitPrice) AS DECIMAL(5,2)) AS PrezzoMedio
FROM
    track
        JOIN
    mediatype ON track.MediaTypeId = mediatype.MediaTypeId
GROUP BY TipoMedia
ORDER BY PrezzoMedio DESC;

/*	Esercizio 7: Individuate il genere con più tracce.*/
SELECT 
    genre.Name AS Genere, COUNT(track.TrackId) AS NumeroTracce
FROM
    track
        JOIN
    genre ON track.GenreId = genre.GenreId
GROUP BY Genere
ORDER BY 2 DESC
LIMIT 1;

/*	Esercizio 8: Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones.*/
SELECT 
    artist.Name AS Artisti, COUNT(*) AS NumeroAlbum
FROM
    artist
        LEFT JOIN
    album ON artist.ArtistId = album.ArtistId
GROUP BY Artisti
HAVING COUNT(*) = (SELECT 
        COUNT(*) AS NumeroAlbum
    FROM
        artist
            LEFT JOIN
        album ON artist.ArtistId = album.ArtistId
    WHERE
        artist.Name = 'The Rolling Stones');

/*	Esercizio 9: Trovate l’artista con l’album più costoso.*/
SELECT 
    artist.Name AS Artista, album.Title AS Album
FROM
    track
        LEFT JOIN
    album ON track.AlbumId = album.AlbumId
        LEFT JOIN
    artist ON album.ArtistId = artist.ArtistId
GROUP BY Artista , Album
HAVING SUM(track.UnitPrice) = (SELECT 
        MAX(Tabella.PrezzoAlbum)
    FROM
        (SELECT 
            artist.Name AS Artista,
                album.Title AS Album,
                SUM(track.UnitPrice) AS PrezzoAlbum
        FROM
            track
        LEFT JOIN album ON track.AlbumId = album.AlbumId
        LEFT JOIN artist ON album.ArtistId = artist.ArtistId
        GROUP BY Artista , Album) AS Tabella);

/* Metodo alternativo*/
SELECT 
    artist.Name AS Artista,
    album.Title AS Album,
    SUM(track.UnitPrice) AS PrezzoAlbum
FROM
    track
        LEFT JOIN
    album ON track.AlbumId = album.AlbumId
        LEFT JOIN
    artist ON album.ArtistId = artist.ArtistId
GROUP BY Artista , Album
ORDER BY PrezzoAlbum DESC
LIMIT 1;