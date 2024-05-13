/* 	Esplora la tabelle dei prodotti (DimProduct) */
SELECT 
    *
FROM
    adv.DimProduct;

/* 	Interroga la tabella dei prodotti (DimProduct) ed esponi in output i campi ProductKey, 
	ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag. 
	Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno. */
SELECT 
    ProductKey AS Codice_prodotto,
    ProductAlternateKey AS Codice_modello,
    EnglishProductName AS Nome_inglese,
    Color AS Colore,
    StandardCost AS Costo_standard,
    FinishedGoodsFlag AS Finito
FROM
    adv.DimProduct;

/* 	Partendo dalla query scritta nel passaggio precedente, esponi in output i soli prodotti 
	finiti cioè quelli per cui il campo FinishedGoodsFlag è uguale a 1. */
SELECT 
    ProductKey AS Codice_prodotto,
    ProductAlternateKey AS Codice_modello,
    EnglishProductName AS Nome_inglese,
    Color AS Colore,
    StandardCost AS Costo_standard,
    FinishedGoodsFlag AS Finito    
FROM
    adv.DimProduct
WHERE
    FinishedGoodsFlag = 1;

/* 	Scrivi una nuova query al fine di esporre in output i prodotti il cui codice modello 
	(ProductAlternateKey) comincia con FR oppure BK. Il result set deve contenere il codice 
	prodotto (ProductKey), il modello, il nome del prodotto, il costo standard (StandardCost) 
	e il prezzo di listino (ListPrice). */
SELECT 
    ProductKey AS Codice_prodotto,
    ProductAlternateKey AS Codice_modello,
    ModelName AS Modello,
    EnglishProductName AS Nome_inglese,
    StandardCost AS Costo_standard,
    ListPrice AS Prezzo_listino
FROM
    adv.DimProduct
WHERE
    ProductAlternateKey LIKE 'FR%'
        OR ProductAlternateKey LIKE 'BK%';

/* 	Arricchisci il risultato della query scritta nel passaggio precedente del Markup applicato
	dall’azienda (ListPrice - StandardCost) */
SELECT 
    ProductKey AS Codice_prodotto,
    ProductAlternateKey AS Codice_modello,
    ModelName AS Modello,
    EnglishProductName AS Nome_inglese,
    StandardCost AS Costo_standard,
    ListPrice AS Prezzo_listino,
    ListPrice - StandardCost AS Markup
FROM
    adv.DimProduct
WHERE
    ProductAlternateKey LIKE 'FR%'
        OR ProductAlternateKey LIKE 'BK%';

/* 	Scrivi un’altra query al fine di esporre l’elenco dei prodotti finiti il cui prezzo di 
	listino è compreso tra 1000 e 2000. */
SELECT 
    ProductKey AS Codice_prodotto,
    ProductAlternateKey AS Codice_modello,
    ModelName AS Modello,
    EnglishProductName AS Nome_inglese,
    StandardCost AS Costo_standard,
    ListPrice AS Prezzo_listino,
    ListPrice - StandardCost AS Markup
FROM
    adv.DimProduct
WHERE
    ListPrice BETWEEN 1000 AND 2000
        AND FinishedGoodsFlag = 1
ORDER BY StandardCost;

/* 	Esplora la tabella degli impiegati aziendali (DimEmployee) */
SELECT 
    *
FROM
    adv.DimEmployee;

/*	Esponi, interrogando la tabella degli impiegati aziendali, l’elenco dei soli agenti. 
	Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1. */
SELECT 
    *
FROM
    adv.DimEmployee
WHERE
    SalespersonFlag = 1;

/* 	Interroga la tabella delle vendite (FactResellerSales). Esponi in output l’elenco delle
	transazioni registrate a partire dal 1 gennaio 2020 dei soli codici prodotto: 597, 598, 
	477, 214. Calcola per ciascuna transazione il profitto (SalesAmount - TotalProductCost). */
SELECT 
    OrderDate AS Data_vendita,
    ProductKey AS Codice_prodotto,
    SalesAmount - TotalProductCost AS Profitto
FROM
    adv.FactResellerSales
WHERE
    ProductKey IN (214 , 477, 597, 598)
        AND YEAR(OrderDate) >= 2020 -- Va bene anche OrderDate >= '2020/01/01'
ORDER BY OrderDate;
