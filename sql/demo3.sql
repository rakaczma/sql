-- FUNKCJE SKALARNE
-- Transact-SQL !! Wprowadza dużą ilość różnych funkcji których nie damy rady omówić w całości -> i nikt by tego nie zapamiętał
-- Ważną informacją jest to że funkcję występujące w SQLServer nie muszą występować w innych RMDBS!!!!! -> T-SQL to rozwinięcie standardowego języka SQL

-- wyciągnięcie roku z daty
SELECT YEAR(SellStartDate) AS SellStartYear, ProductID, Name
FROM Production.Product
ORDER BY SellStartYear;

-- działania na dacie + GETDATE()
SELECT YEAR(SellStartDate) AS SellStartYear,
       DATENAME(mm,SellStartDate) AS SellStartMonth,
       DAY(SellStartDate) AS SellStartDay,
       DATENAME(dw, SellStartDate) AS SellStartWeekday,
       DATEDIFF(yy,SellStartDate, GETDATE()) AS YearsSold,
       ProductID,
       Name
FROM Production.Product
ORDER BY SellStartYear;

-- Funkcje w funkcjach
SELECT UPPER(Name) AS ProductName,
       ProductNumber,
       Weight,
       ROUND(Weight, 0) AS ApproxWeight,
       LEFT(ProductNumber, 2) AS ProductType,
       SUBSTRING(ProductNumber,CHARINDEX('-', ProductNumber) + 1, 4) AS ModelCode
FROM Production.Product;

-- Funkcje agregujące sum, count, average, minimum, or maximum.

SELECT COUNT(*) AS Products,
       COUNT(DISTINCT ProductSubcategoryID) AS SubCategories,
       AVG(ListPrice) AS AveragePrice
FROM Production.Product;

SELECT COUNT(DISTINCT p.ProductID) AS BikeModels, AVG(p.ListPrice) AS AveragePrice
FROM Production.Product AS p
         JOIN Production.ProductSubcategory AS c
              ON p.ProductSubcategoryID = c.ProductSubcategoryID
WHERE c.Name LIKE '%Bikes';

-- Grupowanie danych po wykonaniu funkcji agregujących

SELECT StoreID, COUNT(CustomerID) AS Customers
FROM Sales.Customer
GROUP BY StoreID
ORDER BY Customers desc;

-- połączenie grupowania z joinem
SELECT sp.businessentityid, SUM(oh.SubTotal) AS SalesRevenue
FROM Sales.Customer c
         JOIN sales.store s on s.businessentityid = c.storeid
         JOIN sales.salesperson sp on s.salespersonid = sp.businessentityid
         JOIN Sales.SalesOrderHeader oh ON c.CustomerID = oh.CustomerID
GROUP BY sp.businessentityid
ORDER BY SalesRevenue DESC;


-- TO nie zadziała
-- Spodziwamy się wyniku zwracającgo handlowców z ponad 100 klientami
-- Dlaczego to nie działa??!
SELECT sp.businessentityid, count(c.customerid) AS SalesRevenue
FROM Sales.Customer c
         JOIN sales.store s on s.businessentityid = c.storeid
         JOIN sales.salesperson sp on s.salespersonid = sp.businessentityid
         JOIN Sales.SalesOrderHeader oh ON c.CustomerID = oh.CustomerID
GROUP BY sp.businessentityid
WHERE COUNT(c.CustomerID) > 100
ORDER BY SalesRevenue DESC;

-- WHERE musi znaleźć się przed słowem kluczowym GROUP BY (Dalej nie działa)
SELECT sp.businessentityid, count(c.customerid) AS SalesRevenue
FROM Sales.Customer c
         JOIN sales.store s on s.businessentityid = c.storeid
         JOIN sales.salesperson sp on s.salespersonid = sp.businessentityid
         JOIN Sales.SalesOrderHeader oh ON c.CustomerID = oh.CustomerID
WHERE COUNT(c.CustomerID) > 100
GROUP BY sp.businessentityid
ORDER BY SalesRevenue DESC;





-- W jaki sposób filtorwać wyniki funkcji agregujących?
-- HAVING!! <- to pytanie pojawia się często na rozmowach kwalifikacyjnych
-- Ale w Having nie możemy użyć naszego aliasu

SELECT sp.businessentityid, count(c.customerid) AS Customers
FROM Sales.Customer c
         JOIN sales.store s on s.businessentityid = c.storeid
         JOIN sales.salesperson sp on s.salespersonid = sp.businessentityid
         JOIN Sales.SalesOrderHeader oh ON c.CustomerID = oh.CustomerID
GROUP BY sp.businessentityid
HAVING count(c.customerid) > 100
ORDER BY Customers DESC;


-- Oczywiście w jednym zapytaniu możemy połączyć oba WHERE i HAVING
-- chcemy wziac tylko pod uwagę klientów sklepów z rowerami
SELECT sp.businessentityid, count(c.customerid) AS Customers
FROM Sales.Customer c
         JOIN sales.store s on s.businessentityid = c.storeid
         JOIN sales.salesperson sp on s.salespersonid = sp.businessentityid
         JOIN Sales.SalesOrderHeader oh ON c.CustomerID = oh.CustomerID
WHERE s.name like '%Bike%'
GROUP BY sp.businessentityid
HAVING count(c.customerid) > 100
ORDER BY Customers DESC;