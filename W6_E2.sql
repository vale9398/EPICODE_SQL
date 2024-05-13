/*	1.Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory).*/
SELECT 
    PROD.EnglishProductName,
    SUBCAT.EnglishProductSubcategoryName
FROM
    dimproduct AS PROD
        JOIN
    dimproductsubcategory AS SUBCAT ON PROD.ProductSubcategoryKey = SUBCAT.ProductSubcategoryKey;

/*	2.Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria 
	(DimProduct, DimProductSubcategory, DimProductCategory).*/
SELECT 
    PROD.EnglishProductName,
    SUBCAT.EnglishProductSubcategoryName,
    CAT.EnglishProductCategoryName
FROM
    dimproduct AS PROD
        JOIN
    dimproductsubcategory AS SUBCAT ON PROD.ProductSubcategoryKey = SUBCAT.ProductSubcategoryKey
        JOIN
    dimproductcategory AS CAT ON SUBCAT.ProductCategoryKey = CAT.ProductCategoryKey;
    
/*	3.Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales).*/
SELECT DISTINCT
    PROD.EnglishProductName, PROD.ProductKey
FROM
    dimproduct AS PROD
        JOIN
    factresellersales AS SALES ON PROD.ProductKey = SALES.ProductKey;

/*	4.Esponi l’elenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1).*/
SELECT 
    P.EnglishProductName, P.ProductKey
FROM
    dimproduct AS P
WHERE
    P.ProductKey NOT IN (SELECT 
            PROD.ProductKey
        FROM
            dimproduct AS PROD
                JOIN
            factresellersales AS SALES ON PROD.ProductKey = SALES.ProductKey)
        AND P.FinishedGoodsFlag = 1;

/*	5.Esponi l’elenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)*/
SELECT 
    SALES.SalesOrderNumber, PROD.EnglishProductName
FROM
    dimproduct AS PROD
        JOIN
    factresellersales AS SALES ON PROD.ProductKey = SALES.ProductKey;

/*	6.Esponi l’elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.*/
SELECT
    SALES.SalesOrderNumber, SALES.SalesOrderLineNumber, CAT.EnglishProductCategoryName, PROD.EnglishProductName
FROM
    factresellersales AS SALES
        JOIN
    dimproduct AS PROD ON SALES.ProductKey = PROD.ProductKey
        JOIN
    dimproductsubcategory AS SUBCAT ON PROD.ProductSubcategoryKey = SUBCAT.ProductSubcategoryKey
        JOIN
    dimproductcategory AS CAT ON SUBCAT.ProductCategoryKey = CAT.ProductCategoryKey;

/*	7.Esplora la tabella DimReseller.*/
SELECT *
FROM dimreseller;

/*	8.Esponi in output l’elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica.*/
SELECT 
    dimreseller.ResellerName AS Nome,
    dimgeography.EnglishCountryRegionName AS Stato,
    dimgeography.City AS Citta
FROM
    dimgeography
        JOIN
    dimreseller ON dimgeography.GeographyKey = dimreseller.GeographyKey;

/*	9.Esponi l’elenco delle transazioni di vendita. Il result set deve esporre i campi: 
	SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. 
	Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, 
    il nome del reseller e l’area geografica.*/
SELECT 
    SALES.SalesOrderNumber AS NumOrdine,
    SALES.SalesOrderLineNumber AS LineOrdine,
    SALES.OrderDate AS DataOrdine,
    SALES.UnitPrice AS PrezzoUnitario,
    SALES.OrderQuantity AS Quantita,
    SALES.TotalProductCost AS Costo,
    PROD.EnglishProductName AS Prodotto,
    CAT.EnglishProductCategoryName AS Categoria,
    RESELLER.ResellerName AS Reseller,
    LUOGO.EnglishCountryRegionName AS Stato,
    LUOGO.City AS Citta
FROM
    factresellersales AS SALES
    JOIN dimproduct AS PROD ON SALES.ProductKey = PROD.ProductKey
    JOIN dimproductsubcategory AS SUBCAT ON PROD.ProductSubcategoryKey = SUBCAT.ProductSubcategoryKey
    JOIN dimproductcategory AS CAT ON SUBCAT.ProductCategoryKey = CAT.ProductCategoryKey
    JOIN dimreseller AS RESELLER ON SALES.ResellerKey = RESELLER.ResellerKey
    JOIN dimgeography AS LUOGO ON RESELLER.GeographyKey = LUOGO.GeographyKey;
    