/*	Esercizio 1: Identificate tutti i clienti che non hanno effettuato nessun noleggio a febbraio 2006.*/
SELECT DISTINCT
    CONCAT(customer.first_name,
            ' ',
            customer.last_name) AS Cliente
FROM
    rental
        LEFT JOIN
    customer ON customer.customer_id = rental.customer_id
WHERE
    customer.customer_id NOT IN (SELECT DISTINCT
            customer.customer_id
        FROM
            rental
                JOIN
            customer ON customer.customer_id = rental.customer_id
        WHERE
            YEAR(rental.rental_date) = 2006
                AND MONTH(rental.rental_date) = 2)
ORDER BY Cliente;

/*	Esercizio 2: Elencate tutti i film che sono stati noleggiati più di 10 volte nel penultimo quarto del 2005.*/
SELECT 
    film.title AS TitoloFilm,
    COUNT(rental.rental_id) AS NumeroNoleggi
FROM
    rental
        LEFT JOIN
    inventory ON inventory.inventory_id = rental.inventory_id
        LEFT JOIN
    film ON film.film_id = inventory.film_id
WHERE
    rental.rental_id IN (SELECT DISTINCT
            rental.rental_id
        FROM
            rental
        WHERE
            YEAR(rental.rental_date) = 2005
                AND MONTH(rental.rental_date) BETWEEN 7 AND 9)
GROUP BY TitoloFilm
HAVING NumeroNoleggi > 10
ORDER BY NumeroNoleggi DESC;

/*	Esercizio 3: Trovate il numero totale di noleggi effettuati il giorno 14/2/2006.*/
SELECT 
    COUNT(*) AS NumeroNoleggi
FROM
    rental
WHERE
    DATE(rental.rental_date) = '2006-02-14';

/*	Esercizio 4: Calcolate la somma degli incassi generati nei weekend (sabato e domenica).*/
SELECT 
    SUM(payment.amount) AS IncassiWeekend
FROM
    payment
WHERE
    DAYOFWEEK(payment_date) = 1 -- la domenica è il primo giorno della settimana
        OR DAYOFWEEK(payment_date) = 7; -- il sabato è l'ultimo

/*	Esercizio 5: Individuate il cliente che ha speso di più in noleggi.*/
SELECT 
    CONCAT(customer.first_name,
            ' ',
            customer.last_name) AS Cliente,
    SUM(payment.amount) AS SpesaTotale
FROM
    payment
        JOIN
    customer ON payment.customer_id = customer.customer_id
GROUP BY Cliente
HAVING SUM(payment.amount) = (SELECT 
        MAX(Tabella.SommaSpesa)
    FROM
        (SELECT 
            SUM(payment.amount) AS SommaSpesa
        FROM
            payment
        JOIN customer ON payment.customer_id = customer.customer_id
        GROUP BY customer.customer_id) AS Tabella);
/*	Soluzione alternativa*/
SELECT 
    CONCAT(customer.first_name,
            ' ',
            customer.last_name) AS Cliente,
    SUM(payment.amount) AS SpesaTotale
FROM
    payment
        JOIN
    customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY SpesaTotale DESC
LIMIT 1;

/*	Esercizio 6: Elencate i 5 film con la maggior durata media di noleggio.*/
SELECT 
    film.title AS TitoloFilm,
    CAST(AVG(DATEDIFF(DATE(rental.return_date),
                DATE(rental_date)))
        AS DECIMAL (10,2)) AS DurataMediaNoleggio
FROM
    film
        LEFT JOIN
    inventory ON film.film_id = inventory.film_id
        LEFT JOIN
    rental ON inventory.inventory_id = rental.inventory_id
GROUP BY TitoloFilm
ORDER BY DurataMediaNoleggio DESC
LIMIT 5;

/*	Esercizio 7: Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente.*/
SELECT 
    customer.first_name AS NomeCliente,
    customer.last_name AS CognomeCliente,
    AVG(DATEDIFF(next_rental.rental_date, rental.rental_date)) AS TempoMedioDueNoleggi
FROM 
    sakila.customer
JOIN 
    sakila.rental ON customer.customer_id = rental.customer_id
LEFT JOIN 
    sakila.rental AS next_rental ON rental.customer_id = next_rental.customer_id 
                                    AND next_rental.rental_date = (
                                        SELECT MIN(nr.rental_date)
                                        FROM sakila.rental nr
                                        WHERE nr.customer_id = rental.customer_id 
                                          AND nr.rental_date > rental.rental_date
                                    )
GROUP BY 
    customer.first_name, customer.last_name
ORDER BY 
    TempoMedioDueNoleggi DESC;
    
/*	Esercizio 8: Individuate il numero di noleggi per ogni mese del 2005.*/
SELECT 
    MONTHNAME(rental.rental_date) AS Mese,
    COUNT(rental.rental_id) AS NumeroNoleggi
FROM
    rental
WHERE
    YEAR(rental.rental_date) = 2005
GROUP BY Mese;

/*	Esercizio 9: Trovate i film che sono stati noleggiati almeno due volte lo stesso giorno.*/
SELECT DISTINCT
    Tabella.TitoloFilm
FROM
    (SELECT 
        film.title AS TitoloFilm,
            DATE(rental.rental_date) AS DataNoleggio,
            COUNT(*) AS NumeroNoleggi
    FROM
        film
    LEFT JOIN inventory ON film.film_id = inventory.film_id
    LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
    GROUP BY DataNoleggio , TitoloFilm
    HAVING NumeroNoleggi >= 2) AS Tabella;

/*	Esercizio 10: Calcolate il tempo medio di noleggio.*/
SELECT 
    CAST(AVG(DATEDIFF(rental.return_date, rental.rental_date))
        AS DECIMAL (5 , 3 )) AS TempoMedioNoleggio
FROM
    rental;