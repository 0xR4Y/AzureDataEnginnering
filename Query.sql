USE [WideWorldImporters]
GO

/*Q1*/
SELECT FullName , PhoneNumber, FaxNumber FROM WideWorldImporters.Application.People;

SELECT * FROM WideWorldImporters.Application.People;


/*Q2*/
SELECT WideWorldImporters.Sales.Customers.PrimaryContactPersonID , WideWorldImporters.Application.People.PersonID, 

SELECT * FROM WideWorldImporters.Sales.Customers WHERE 

SELECT PrimaryContactPersonID FROM WideWorldImporters.Sales.Customers
INNER JOIN WideWorldImporters.Application.People 
ON WideWorldImporters.Sales.Customers.PhoneNumber = WideWorldImporters.Application.People;

SELECT * FROM WideWorldImporters.Application.People WHERE 
(SELECT PrimaryContactPersonID FROM WideWorldImporters.Sales.Customers);

/*Q3*/
SELECT C.*, O.OrderDate, O.CustomerID 
FROM  WideWorldImporters.Sales.Customers C, WideWorldImporters.Sales.Orders O
WHERE C.CustomerID =  O.CustomerID 
AND (O.OrderDate < '2016-01-01');

/*Q4*/
SELECT * FROM WideWorldImporters.Sales.Invoices;
SELECT *FROM WideWorldImporters.Sales.InvoiceLines;
SELECT * FROM WideWorldImporters.Sales.Orders WHERE OrderDate like '2013%';

SELECT A.StockItemID, A.Description, A.Quantity, C.OrderDate FROM WideWorldImporters.Sales.InvoiceLines A
INNER JOIN WideWorldImporters.Sales.Invoices B ON B.InvoiceID = A.InvoiceID
INNER JOIN WideWorldImporters.Sales.Orders C ON C.OrderID = B.OrderID AND  C.OrderDate like '2013%';

/*Q5*/
SELECT * FROM WideWorldImporters.Sales.InvoiceLines A WHERE LEN(A.Description) > 9;

/*Q6*/
 
SELECT * FROM WideWorldImporters.Application.People;
SELECT * FROM WideWorldImporters.Sales.Orders WHERE OrderDate like '2014%';
