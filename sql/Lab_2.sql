-- Składnia SQL – JOINs

USE AdventureWorks2014

-- 1. Wybierz nazwę produktu i cenę katalogową dla wszystkich produktów w tabeli
-- [Production.Product] i dołącz nazwę kategorii produktów [Production.ProductCategory]

SELECT P.Name, P.ListPrice
FROM Production.Product P
JOIN Production.ProductSubcategory PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC
ON PS.ProductCategoryID = PC.ProductCategoryID

-- 2. Wybierz imię, nazwisko i adres e-mail dla wszystkich pracowników w
-- [HumanResources.Employee] i podaj nazwy działu z tabeli [HumanResources.Department]

SELECT P.FirstName, P.LastName, D.Name
FROM HumanResources.Employee E
JOIN Person.Person P
ON E.BusinessEntityID = P.BusinessEntityID
JOIN Person.EmailAddress EA
ON EA.BusinessEntityID = P.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory DH
ON E.BusinessEntityID = DH.BusinessEntityID
JOIN HumanResources.Department D
ON DH.DepartmentID = D.DepartmentID



-- 3. Wybierz datę zamówienia, nazwa klienta (Imię + Nazwisko) i sumę należności dla wszystkich
-- zamówień w tabeli [Sales.SalesOrderHeader], i podaj nazwę obszaru sprzedaży z tabeli
-- [Sales.SalesTerritory]
-- 4. Pobierz listę wszystkich klientów i odpowiadające im zamówienia sprzedaży [Sales.Customer]
-- [Sales.SalesOrderHeader]
-- 5. Wybierz Imię i Nazwisko wszystkich klientów [Sales.Customer] wraz z ich adresami e-mail
-- [Person.EmailAddress]
-- 6. Pobierz listę wszystkich zamówień sprzedaży [Sales.SalesOrderHeader] oraz odpowiadających
-- im klientów [Sales.Customer] do wyniku załącz adresy [Person.Address]
-- 7. Wybierz wszystkich pracowników [HumanResources.Employee] wraz z nazwami
-- departamentów. [humanresources.department]. Posortuj dane po Nazwisku malejąco i Sart
-- Date rosnąco
-- 8. Wybierz wszystkie nazwy produktów [Production.Product] wraz z ich dostawcami (tylko
-- nazwa) [Purchasing.Vendor]
-- 9. Wybierz wszystkie zamówienia pracowników [humanresources.employee] o imieniu
-- zaczynającym się na 'E' oraz metodzie dostawy zawierającej 'OVER' [purchasing.shipmethod]
-- 10. Wybierz wszystkie zamówienia [Sales.SalesOrderHeader] wraz z danymi o pracownikach
-- odpowiedzialnych za ich obsługę [HumanResources.Employee]
-- 11. Wybierz wszystkie produkty [Production.Product] z kategorii "Clothing"
-- [production.productcategory] wraz z danymi o dostawcach[Purchasing.Vendor]
-- 12. Wybierz wszystkie zamówienia złożone w 2008 roku wraz z danymi o klientach.
-- [Sales.SalesOrderHeader] [Sales.Customer]
-- 13. Wybierz wszystkie produkty [Production.Product] z ceną detaliczną (ListPrice) większą niż 25
-- dolarów wraz z danymi o dostawcach [Purchasing.Vendor]. Posortuj wyniki po cenie malejąco