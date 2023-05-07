-----------------------------------------
-- SELECT
-- SSMS pomaga konstruować zapytania- kolorując
-- i podpowiadając (IntelliSense) składnię
-- tekst zaznaczony na zielono to komentarze.
-----------------------------------------
-- ustaw bazę AdventureWorks jako bieżącą
USE AdventureWorks

-- wyświetl wszystkie wiersze z tabeli Product w schemacie Production
SELECT * FROM Production.Product

-- przejdź do innej bazy danych
USE master

-- 3-part table name (DB-SCHEMA-TABLE)
SELECT * FROM AdventureWorks.Production.Product

USE AdventureWorks

-- Wyświetl tylko 5 kolumn z tabeli Product
SELECT ProductID, Name, ProductNumber, Color, StandardCost FROM Production.Product


-- Sortowanie wierszy
-- ORDER BY ASC | DESC
SELECT ProductID, Name, Color FROM Production.Product
ORDER BY Name

SELECT ProductID, Name, Color FROM Production.Product
ORDER BY Color, Name
-- the same result
SELECT ProductID, Name, Color FROM Production.Product
ORDER BY Color ASC, Name ASC

SELECT ProductID, Name, Color FROM Production.Product
ORDER BY Name DESC, Color



-- Filtrowanie danych
----------------------------------------
-- Odczytywanie produktów koloru czarnego
SELECT * FROM Production.Product WHERE Color = 'Black'


SELECT ProductID, Name, ProductNumber, Color, ProductSubcategoryID
FROM Production.Product WHERE Color = 'Black'

SELECT * FROM Production.ProductSubcategory

SELECT * FROM Production.ProductSubcategory WHERE ProductSubcategoryID = 2

SELECT * FROM Production.ProductCategory WHERE ProductCategoryID = 1

SELECT ProductID, Name, Color, ProductSubcategoryID
FROM Production.Product WHERE ProductSubcategoryID = 2

-- Operatory porównania
-- =, <>, >, <, >=, <, <=, !=
SELECT * FROM Production.ProductSubcategory
WHERE ProductSubcategoryID <= 10

SELECT * FROM Production.ProductSubcategory
WHERE Name <> 'Mountain Bikes' -- jest różna niż (ISO)

SELECT * FROM Production.ProductSubcategory
WHERE Name != 'Mountain Bikes' -- jest różna niż (not ISO standard)


SELECT * FROM Production.ProductSubcategory
WHERE ProductSubcategoryID <= 10 OR ProductSubcategoryID > 20





-- Porównywanie ciągów znaków
SELECT * FROM Production.ProductSubcategory
WHERE Name = 'Mountain Bikes'

-- % dowolna ilość (lub brak) dowolnego znaku
SELECT * FROM Production.ProductSubcategory
WHERE Name LIKE '%Bikes'

SELECT * FROM Production.ProductSubcategory
WHERE Name LIKE 'C%'

-- _ pojedynczy, dowolny znak
SELECT * FROM Production.Product WHERE Name LIKE 'Flat Washer _'


-- [] lista znaków
SELECT * FROM Production.Product WHERE Name LIKE 'Classic Vest, [LM]'
SELECT * FROM Production.Product WHERE Name LIKE 'Classic Vest, [K-Z]'




-- Operatory logiczne
-- Red Subcategory: 2, 14, 31
-- Kolejność operatorów
-- 1) AND
-- 2) OR
-- Spodziewaliśmy się wyników tylko z SUBCATEGORY = 1
SELECT Color, ProductSubcategoryID, * FROM Production.Product
WHERE Color = 'Red' OR Color = 'Black' AND ProductSubcategoryID = 1

SELECT Name, Color FROM Production.Product
WHERE Color = 'Black' OR Color = 'Red'

-- !!! wykluczający się warunek- kolumna może mieć tylko jedną wartość
SELECT Name, Color FROM Production.Product
WHERE Color = 'Black' AND Color = 'Red'

-- poprawnie
SELECT * FROM Production.Product
WHERE ProductSubcategoryID = 2 AND Color = 'Red'


SELECT * FROM Production.Product
WHERE ProductSubcategoryID = 2 AND NOT Color = 'Red'
-- taki sam wynik
SELECT * FROM Production.Product
WHERE ProductSubcategoryID = 2 AND Color <> 'Red'

SELECT * FROM Production.Product
WHERE Color = 'Black' OR Color= 'Silver' OR Color  = 'Red'
-- taki sam wynik
SELECT * FROM Production.Product
WHERE Color IN ('Black', 'Silver', 'Red')

SELECT * FROM Production.Product
WHERE Color NOT IN ('Black', 'Silver', 'Red')


-- nawiasy
SELECT ProductSubcategoryID, Color FROM Production.Product
WHERE (ProductSubcategoryID = 2 AND Color <> 'Red')
 OR (ProductSubcategoryID = 1 AND Color <> 'Black')

SELECT ProductSubcategoryID, Color FROM Production.Product
WHERE (ProductSubcategoryID = 2 AND Color <> 'Red')
 OR (ProductSubcategoryID = 1 AND Color <> 'Black')
ORDER BY ProductSubcategoryID, Color

-- Przykład z kolejnością działań poprawiony
SELECT Color, ProductSubcategoryID, * FROM Production.Product
WHERE (Color = 'Red' OR Color = 'Black') AND ProductSubcategoryID = 1




-- zakres wartosci
SELECT * FROM Production.ProductSubcategory
WHERE ProductSubcategoryID >= 10 AND ProductSubcategoryID < 20
-- taki sam wynik
SELECT * FROM Production.ProductSubcategory
WHERE ProductSubcategoryID BETWEEN 10 AND 19


SELECT * FROM Sales.SalesOrderHeader

SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '20040501' AND '20040507'
-- taki sam wynik
SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20040501' AND OrderDate <= '20040507'
-- taki sam wynik (inaczej podana data)
SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2004-05-01' AND OrderDate <= '2004-05-07'
-- jeszcze inaczej T-SQL
SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN CAST('2004-05-01' as date) AND CAST('2004-05-07' as date)


-- NULL
SELECT Name, Color FROM Production.Product

SELECT Name, Color FROM Production.Product
WHERE Color IS NOT NULL

SELECT Name, Color FROM Production.Product
WHERE Color IS NULL


-- przykład użycia funkcji
SELECT Name, Color, ISNULL(Color, 'no color') AS SuperColor FROM Production.Product


SELECT ISNULL(Color, 'NO COLOR') FROM Production.Product
-- eliminowanie duplikatów z wyniku
SELECT DISTINCT Color FROM Production.Product ORDER BY Color

-- aliasy kolumn
SELECT CustomerID, OrderDate, ShipDate
FROM Sales.SalesOrderHeader

SELECT CustomerID AS cliente, OrderDate AS [fecha de pedido], ShipDate AS [fecha de entrega]
FROM Sales.SalesOrderHeader

-- tabele również możemy aliasować (później..), na razie korzystamy max z 1 tabeli na zapytanie :)



-- TOP
-- 10 ostatnio modyfikowanych wierszy
SELECT TOP 5 * FROM HumanResources.Employee ORDER BY ModifiedDate DESC
SELECT COUNT(*) AS employeesCnt FROM HumanResources.Employee
-- Użycie TOP z procentem (daj mi top 10% wyników)
SELECT TOP 10 PERCENT * FROM HumanResources.Employee ORDER BY ModifiedDate DESC




-- Kontkatenacja, funkcje
SELECT * FROM Person.Contact

SELECT FirstName, LastName, FirstName + ' ' + LastName AS FullName
FROM Person.Contact

SELECT
 FirstName,
 LEFT(FirstName, 1) AS FirstLetterOfName,
 LEFT(FirstName, 3) AS First3LettersOfName
FROM Person.Contact

-- T-SQL MA BARDZO DUŻO INNYCH PRZYDATNYCH FUNKCJI - WSZYSTKICH NIE UDA NAM SIE POKAZAĆ