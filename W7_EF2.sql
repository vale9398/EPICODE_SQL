/*	Esercizio 1: Recuperate tutte le tracce che abbiano come genere “Pop” o “Rock”.*/
SELECT 
    track.Name AS NomeTraccia, genre.Name AS Genere
FROM
    track
        JOIN
    genre ON track.GenreId = genre.GenreId
WHERE
    genre.Name IN ('Pop' , 'Rock');

/*	Esercizio 2: Elencate tutti gli artisti e/o gli album che inizino con la lettera “A”.*/
SELECT 
    artist.Name AS Artista, album.Title AS TitoloAlbum
FROM
    artist
        LEFT JOIN
    album ON artist.ArtistId = album.ArtistId
WHERE
    artist.Name LIKE 'A%'
        OR album.Title LIKE 'A%';

/*	Esercizio 3: Elencate tutte le tracce che hanno come genere ‘Jazz” o che durano meno di 3 minuti.*/
SELECT 
    track.Name AS TitoloCanzone,
    genre.Name AS Genere,
    CAST(track.Milliseconds / 1000 / 60 AS DECIMAL (5 , 2 )) AS DurataMinuti
FROM
    track
        LEFT JOIN
    genre ON track.GenreId = genre.GenreId
WHERE
    genre.Name = 'Jazz'
        OR track.Milliseconds < 180000
ORDER BY DurataMinuti DESC;

/*	Esercizio 4: Recuperate tutte le tracce più lunghe della durata media.*/
SELECT 
    track.Name AS TitoloCanzone,
    CAST(track.Milliseconds / 1000 / 60 AS DECIMAL (5 , 2 )) AS DurataMinuti
FROM
    track
WHERE
    track.Milliseconds > (SELECT 
            AVG(track.Milliseconds)
        FROM
            track)
ORDER BY DurataMinuti DESC;

/*	Esercizio 5: Individuate i generi che hanno tracce con una durata media maggiore di 4 minuti.*/
SELECT 
    genre.Name AS Genere, CAST(AVG(track.Milliseconds) AS DECIMAL(10,2)) AS MediaDurata
FROM
    track
        JOIN
    genre ON track.GenreId = genre.GenreId
GROUP BY genre.Name
HAVING MediaDurata > 4 * 1000 * 60
ORDER BY MediaDurata;

/*	Esercizio 6: Individuate gli artisti che hanno rilasciato più di un album.*/
SELECT 
    artist.Name AS Artista, COUNT(album.AlbumId) AS NumeroAlbum
FROM
    artist
        JOIN
    album ON artist.ArtistId = album.ArtistId
GROUP BY artist.Name
HAVING NumeroAlbum > 1;

/*	Esercizio 7: Trovate la traccia più lunga in ogni album.*/
SELECT 
    album.Title AS Album,
    track.Name AS TitoloCanzone,
    MAX(track.Milliseconds) AS Durata_ms
FROM
    track
        JOIN
    album ON track.AlbumId = album.AlbumId
WHERE
    track.Milliseconds = (SELECT 
            MAX(T.Milliseconds)
        FROM
            track AS T
                JOIN
            album AS A ON T.AlbumId = A.AlbumId
        WHERE
            A.Title = album.Title)
GROUP BY TitoloCanzone , Album
ORDER BY Durata_ms;

/*	Esercizio 8: Individuate la durata media delle tracce per ogni album.*/
SELECT 
    album.Title AS TitoloAlbum,
    CAST(AVG(track.Milliseconds) AS DECIMAL(10,2)) AS DurataMedia
FROM
    album
        LEFT JOIN
    track ON album.AlbumId = track.AlbumId
GROUP BY album.Title;
 
/*	Esercizio 9: Individuate gli album che hanno più di 20 tracce e mostrate il nome dell’album e il numero di tracce in esso contenute.*/
SELECT 
    album.Title AS Album, COUNT(*) AS NumeroTracce
FROM
    album
        LEFT JOIN
    track ON album.AlbumId = track.AlbumId
GROUP BY album.Title
HAVING NumeroTracce > 20
ORDER BY NumeroTracce;