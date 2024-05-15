/*	1.Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
	Quali considerazioni/ragionamenti è necessario che tu faccia?*/
SELECT 
    COUNT(dimproduct.ProductKey) AS NumeroRighe,
    COUNT(DISTINCT dimproduct.ProductKey) AS NumeroRigheSenzaRipetizioni
FROM
    dimproduct;

/*	2.Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.*/
-- MODO 1
SELECT 
    COUNT(*) AS NumeroRighe,
    COUNT(DISTINCT CONCAT(factresellersales.SalesOrderNumber,
                factresellersales.SalesOrderLineNumber)) AS NumeroRigheSenzaRipetizioni
FROM
    factresellersales;
-- MODO 2
SELECT 
    SalesOrderNumber, SalesOrderLineNumber
FROM
    factresellersales;
SELECT DISTINCT
    SalesOrderNumber, SalesOrderLineNumber
FROM
    factresellersales;
-- MODO 3
SELECT DISTINCT
    CONCAT(SalesOrderNumber,
            '-',
            SalesOrderLineNumber)
FROM
    factresellersales;
-- MODO 4
SELECT 
    SalesOrderNumber, SalesOrderLineNumber, COUNT(*)
FROM
    factresellersales
GROUP BY 1 , 2
HAVING COUNT(*) > 1;

/*	3.Conta il numero transazioni (SalesOrderNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.*/
SELECT 
    OrderDate AS Giorno,
    COUNT(DISTINCT SalesOrderNumber) AS NumeroTransazioni
FROM
    factresellersales
WHERE
    YEAR(OrderDate) > 2019
        -- AND OrderDate = '2020-01-10' /*per fare un test*/
GROUP BY OrderDate
ORDER BY OrderDate;

/*	4.Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) e 
	il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020. Il result set 
    deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. 
    I campi in output devono essere parlanti!*/
SELECT 
    dimproduct.EnglishProductName AS NomeProdotto,
    SUM(factresellersales.SalesAmount) AS FatturatoTotale,
    SUM(factresellersales.OrderQuantity) AS QuantitaTotale,
    SUM(factresellersales.SalesAmount)/SUM(factresellersales.OrderQuantity) AS PrezzoMedio
FROM
    factresellersales
        LEFT JOIN
    dimproduct ON factresellersales.ProductKey = dimproduct.ProductKey
WHERE
    YEAR(factresellersales.OrderDate) > 2019
GROUP BY dimproduct.EnglishProductName
ORDER BY FatturatoTotale DESC;

/*	5.Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per 
	Categoria prodotto (DimProductCategory). Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale 
    e la quantità totale venduta. I campi in output devono essere parlanti!*/
SELECT 
    dimproductcategory.EnglishProductCategoryName AS CategoriaProdotto,
    SUM(factresellersales.SalesAmount) AS FatturatoTotale,
    SUM(factresellersales.OrderQuantity) AS QuantitaTotale
FROM
    factresellersales
        LEFT JOIN
    dimproduct ON factresellersales.ProductKey = dimproduct.ProductKey
        LEFT JOIN
    dimproductsubcategory ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
        LEFT JOIN
    dimproductcategory ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey
GROUP BY dimproductcategory.EnglishProductCategoryName
ORDER BY 1;

/*	6.Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. Il result set deve esporre 
l’elenco delle città con fatturato realizzato superiore a 60K.*/
SELECT 
    dimgeography.City AS Citta,
    SUM(factresellersales.SalesAmount) AS FatturatoTotale
FROM
    factresellersales
        LEFT JOIN
    dimreseller ON factresellersales.ResellerKey = dimreseller.ResellerKey
        LEFT JOIN
    dimgeography ON dimreseller.GeographyKey = dimgeography.GeographyKey
WHERE
    YEAR(factresellersales.OrderDate) > 2019
GROUP BY dimgeography.City
HAVING FatturatoTotale > 60000
ORDER BY FatturatoTotale DESC;