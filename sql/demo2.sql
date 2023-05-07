-- Inner joins

-- przykład wykorzystania Inner Join
USE AdventureWorks2014

select name
from production.product;

-- przykład wykorzystania Inner Join
-- Produkt -> SubKategoria -> Kategoria
SELECT Production.product.name         As ProductName,
       production.productsubcategory.name,
       production.ProductCategory.name AS CategoryName
FROM production.Product
         INNER JOIN production.productsubcategory
                    on production.productsubcategory.productcategoryid = Production.product.productsubcategoryid
         INNER JOIN production.ProductCategory
                    ON production.productsubcategory.productcategoryid = production.ProductCategory.productcategoryid;

-- Modyfikujemy zapytanie i usuwany z niego słowo kluczowe INNER
-- Wynik będzie taki sam ponieważ Inner Join jest domyślym łączeniem tabel w MsSql Server
SELECT Production.product.name         As ProductName,
       production.productsubcategory.name,
       production.ProductCategory.name AS CategoryName
FROM production.Product
         JOIN production.productsubcategory
              on production.productsubcategory.productcategoryid = Production.product.productsubcategoryid
         JOIN production.ProductCategory
              ON production.productsubcategory.productcategoryid = production.ProductCategory.productcategoryid;

-- Zastosujemy Aliasy dla czytelności
-- Przy łączeniu tabel szczególnie ważne jest używanie Aliasów - ułatwiają one czytelność
-- Przy wielu łączonych tabelach na prawdę można się pogubić.
-- Tutaj przykład aliasowania całych tabel (nie trzeba podawać słowa kluczowego as)
SELECT p.name As ProductName, pc.name As SubCategoryName, c.name AS CategoryName
FROM production.Product p
         JOIN production.productsubcategory pc on pc.productcategoryid = p.productsubcategoryid
         JOIN production.ProductCategory c ON pc.productcategoryid = c.productcategoryid;

-- WHERE i ORDER by normalnie działają na złączeniach
SELECT p.name As ProductName, pc.name As SubCategoryName, c.name AS CategoryName
FROM production.Product p
         JOIN production.productsubcategory pc on pc.productcategoryid = p.productsubcategoryid
         JOIN production.ProductCategory c ON pc.productcategoryid = c.productcategoryid
WHERE c.name like '%Clo%'
ORDER BY SubCategoryName desc, ProductName;

-- Outer joins

-- Wyświetlmy liczbę klientów - 19820
Select count(c.customerid)
from Sales.Customer AS c;

-- Wyniki zawierają dane dla każdego klienta. Jeśli klient złożył zamówienie,
-- wyświetlany jest numer zamówienia. Klienci, którzy zarejestrowali się,
-- ale nie złożyli zamówienia, są wyświetlani z numerem zamówienia NULL.
SELECT c.customerid, oh.salesorderid
FROM Sales.Customer AS c
         LEFT OUTER JOIN Sales.SalesOrderHeader AS oh ON c.CustomerID = oh.CustomerID
ORDER BY c.CustomerID;

-- Potwierdzenie
SELECT c.customerid, oh.salesorderid
FROM Sales.Customer AS c
         LEFT OUTER JOIN Sales.SalesOrderHeader AS oh
                         ON c.CustomerID = oh.CustomerID
WHERE oh.salesorderid is NULL
ORDER BY c.CustomerID;

-- OK, ale chcemy otrzymać klientów którzy wykonali jakies zamówienia -> PROSTA sprawa WHERE -> TAK?
SELECT c.customerid, oh.salesorderid
FROM Sales.Customer AS c
         LEFT OUTER JOIN Sales.SalesOrderHeader AS oh
                         ON c.CustomerID = oh.CustomerID
WHERE oh.salesorderid is not NULL
ORDER BY c.CustomerID;

-- Lepsze rozwiązanie: Zamieniająć Łączenie tabel z LEFT -> RIGHT otrzymamy tylko klientów którzy złożyli jakieś zamówienie
-- W poprzednim przykładnie będzie więcej łączeń i będzie to mniej wydajne
SELECT c.customerid, oh.salesorderid
FROM Sales.Customer AS c
         RIGHT OUTER JOIN Sales.SalesOrderHeader AS oh
                          ON c.CustomerID = oh.CustomerID
ORDER BY c.CustomerID;

-- Potwierdzenie, tutaj powinniśmy dostać w wyniku 0 wierszy
-- Dodajemy Where is Null
SELECT c.customerid, oh.salesorderid
FROM Sales.Customer AS c
         RIGHT OUTER JOIN Sales.SalesOrderHeader AS oh
                          ON c.CustomerID = oh.CustomerID
WHERE oh.salesorderid is NULL
ORDER BY c.CustomerID;

-- Dodajemy więcej Łączeń
-- wyniki obejmują wszystkie produkty wraz z numerami zamówień dla tych, które zostały zakupione.
-- Wymagało to sekwencji połączeń od Product do SalesOrderDetail do SalesOrderHeader.

SELECT p.Name As ProductName, oh.salesorderid
FROM production.Product AS p
         LEFT JOIN Sales.SalesOrderDetail AS od
                   ON p.ProductID = od.ProductID
         LEFT JOIN Sales.SalesOrderHeader AS oh
                   ON od.SalesOrderID = oh.SalesOrderID
ORDER BY p.ProductID;

-- Dlaczego daje nam to 0 wierszy?
SELECT DISTINCT c.CustomerID, oh.salesorderid
from Sales.Customer AS c
         left join Sales.SalesOrderHeader As oh on c.CustomerID = oh.CustomerID
         right join Sales.SalesOrderDetail od on oh.SalesOrderID = od.SalesOrderID
where oh.salesorderid is NULL;


-- Te 2 złączenia wykluczają się - trzeba bardzo uważać podczas sekwencji złączeń
-- Przeanalizujmy je po kolei
-- Po analizie wychodzi nam że przy złączeniu w linii 111 chcemy łączyć
-- wszystkie SalesOrderDetail które mają klucz główny NULL i nie da nam to żadnych wyników

-- Zamieniając right joina na left joina dostaniemy wyniki które chcemy otrzymać
--      -> czyli wszystkich klientów którzy nie mają zamówienia


-- TODO SUBQUERIES

-- maksymalna cena jednostkowa w Sales.SalesOrderDetail (najwyższa cena, za jaką sprzedano pojedynczy produkt).
-- MAX - jest to funkcja agregująca -> będziemy o tym mówić za chwilę
SELECT MAX(UnitPrice)
FROM Sales.SalesOrderDetail;

-- Używając właśnie uruchomionego zapytania jako podzapytania otrzymamy produkty z ListPrice równą maksymalnej cenie sprzedaży.

SELECT Name, ListPrice
FROM production.Product
WHERE ListPrice =
      (SELECT MAX(UnitPrice)
       FROM sales.SalesOrderDetail);

-- Znajdź produkty które były zamówione przynajmniej 20 razy
SELECT ProductID
FROM Sales.SalesOrderDetail
WHERE OrderQty >= 20
order by productid desc;

-- Tutaj zastosujmy distinct - po co nam powtórki w IN -> Bo zaraz wykorzystamy to zapytanie w sekcji IN(...)
SELECT DISTINCT ProductID
FROM Sales.SalesOrderDetail
WHERE OrderQty >= 20;

-- Wynik zawiera nazwy produktów, które zostały zamówione w ilości 20 lub więcej.
-- ProductID IN
-- Pisianie podzapytań tego typu jest bardziej wydajne niż przekazywanie gotowych ID do IN -> wynika to już z wewnętrznej implemetnacji SQL Server
SELECT DISTINCT Name
FROM production.Product
WHERE ProductID IN
      (SELECT DISTINCT ProductID
       FROM Sales.SalesOrderDetail
       WHERE OrderQty >= 20)
ORDER BY name;

-- A teraz ten sam wynik osiągniety w inny sposób (JOIN) -> Tutaj Pamiętamy o DISTINCT!
SELECT DISTINCT p.Name
FROM production.Product AS p
         JOIN Sales.SalesOrderDetail AS o ON p.ProductID = o.ProductID
WHERE OrderQty >= 20;