
/***************************************** DEMO #1 *******************************************************
Compatibility level: be aware of deprecated features

More info at:
https://docs.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-deprecated-features-object?view=sql-server-2017
**********************************************************************************************************/
-- SQL 2019 will not return results: https://docs.microsoft.com/en-us/sql/database-engine/deprecated-database-engine-features-in-sql-server-version-15?view=sql-server-ver15

USE master;
GO

SELECT *
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Deprecated Features';

/******************************************* DEMO #2 *****************************************************
Filtering basics: SARGABLE arguments

More info at:
https://www.sqlguatemala.com/2017/09/performance-basics-filter-date-columns.html
**********************************************************************************************************/
USE AdventureWorks2017;
GO

/*
-- IF exists index delete it

DROP INDEX [IX_Address_City] ON [Person].[Address]

*/
-- Create a simple index for this example
CREATE NONCLUSTERED INDEX [IX_Address_City] ON [Person].[Address] ([City]) 
INCLUDE (
    [AddressLine1]
    , [AddressLine2]
    );

-- NON SARGABLE
SELECT AddressID
    , AddressLine1
    , AddressLine2
    , City
FROM Person.Address
WHERE left(City, 1) = 'M';

--SARGABLE
SELECT AddressID
    , AddressLine1
    , AddressLine2
    , City
FROM Person.Address
WHERE City LIKE 'M%';


/******************************************* DEMO #3 *****************************************************
Table scan - Index scan - Index seek

**********************************************************************************************************/
/*

if index exists delete it

DROP INDEX IX_CarrierTrackingNumber ON Sales.SalesOrderDetail;

-- if exists table, delete it

DROP TABLE Sales.SalesOrderDetail2;

*/
USE AdventureWorks2017;
GO



-- Table Scan
-- We create a Heap by using a SELECT INTO
SELECT *
INTO Sales.SalesOrderDetail2 
FROM Sales.SalesOrderDetail;



SELECT CarrierTrackingNumber 
FROM Sales.SalesOrderDetail2 
WHERE CarrierTrackingNumber = N'6431-4D57-83';


-- Index Scan, original table with a clustered index
SELECT CarrierTrackingNumber 
FROM Sales.SalesOrderDetail
WHERE CarrierTrackingNumber = N'6431-4D57-83';


-- Index Seek
CREATE NONCLUSTERED INDEX IX_CarrierTrackingNumber
ON Sales.SalesOrderDetail (CarrierTrackingNumber);

SELECT CarrierTrackingNumber 
FROM Sales.SalesOrderDetail
WHERE CarrierTrackingNumber = N'6431-4D57-83';

-- What happens if we search for an inexistent value? Will an index seek be performed?

SELECT CarrierTrackingNumber 
FROM Sales.SalesOrderDetail
WHERE CarrierTrackingNumber = N'I DO NOT EXISTS';



/******************************************* DEMO #4 *****************************************************
Covering indexes

More info at:
https://www.sqlguatemala.com/2018/02/performance-basics-key-lookup-operator.html
**********************************************************************************************************/
/*

if index exists delete it

DROP INDEX [AK_Product_ProductNumber] ON [Production].[Product];

*/
USE AdventureWorks2017;
GO

-- Index creation for product number
CREATE UNIQUE NONCLUSTERED INDEX [AK_Product_ProductNumber] 
ON [Production].[Product] ([ProductNumber]);

-- First query execution, an index seek is performed 
SELECT ProductNumber
FROM Production.Product
WHERE ProductNumber = N'BC-R205';

-- If we add another field to the query, a key lookup is performed 
SELECT ProductNumber
    , [Name]
FROM Production.Product
WHERE ProductNumber = N'BC-R205';

-- we drop the index and recreate with "Name" field as an included column
DROP INDEX [AK_Product_ProductNumber]
    ON [Production].[Product];

CREATE UNIQUE NONCLUSTERED INDEX [AK_Product_ProductNumber] 
	ON [Production].[Product] ([ProductNumber]) 
	INCLUDE ([Name]);

-- If we execute the query again, an index seek is performed, so the index "covers" all the query
SELECT ProductNumber
    , [Name]
FROM Production.Product
WHERE ProductNumber = N'BC-R205';


/******************************************* DEMO #5 *****************************************************
Indexed views

More info at:
https://www.sqlguatemala.com/2018/08/performance-basics-indexed-views.html
**********************************************************************************************************/
/*
-- DROP object if it exists

 DROP VIEW VI_DEMO_4;

*/
USE AdventureWorks2017;
GO

-- WE create a simple view with sales total by product on orderDetail table
CREATE VIEW VI_DEMO_4
AS
SELECT ProductID
    , SUM(lineTotal) AS TotalbyProduct
FROM Sales.SalesOrderDetail
GROUP BY ProductID;
GO

-- If we select this view and filter by a simple product, Base table indexes and aggregations are made
SELECT ProductID
    , TotalbyProduct
FROM VI_DEMO_4
WHERE ProductID = 733;

--Since we will use indexed view, we will drop and recreate the view with schemabinging
DROP VIEW VI_DEMO_4;
GO

CREATE VIEW VI_DEMO_4
    WITH SCHEMABINDING
AS
SELECT 
	COUNT_BIG(*) AS [count_rows]
	, ProductID
    , SUM(lineTotal) AS TotalbyProduct
FROM Sales.SalesOrderDetail
GROUP BY ProductID;
GO

-- Now we can create an index over the view, since we are using group by, a unique clustered index will be created
CREATE UNIQUE CLUSTERED INDEX IX_VI_DEMO_4 ON [dbo].[VI_DEMO_4] (ProductID);
GO

-- if we select the view again, the index is used to cover the view
SELECT ProductID
    , TotalbyProduct
FROM VI_DEMO_4
WHERE ProductID = 733;

-- Why the plan does not use a key lookup operation, even when we don't add included columns?


/******************************************* DEMO #6 *****************************************************
Implicit conversions

More info at:
https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017
**********************************************************************************************************/
/*

DROP Index if already created

DROP INDEX [IX_UnitPrice] ON [Sales].[SalesOrderDetail];

*/

USE AdventureWorks2017;
GO


-- We create an index on unit price, include OrderDetailID field
CREATE NONCLUSTERED INDEX [IX_UnitPrice] ON [Sales].[SalesOrderDetail] (UnitPrice) 
INCLUDE (SalesOrderDetailID);

-- We filter orderDetail table by one unit price, using the same column datatype for the variable
DECLARE @demo_var MONEY

-- Assigning value to the parameter
SET @demo_var = 3578.27;

-- filtering with the variable we declared earlier
SELECT SalesOrderID
    , SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE UnitPrice = @demo_var;

-- if we do the same query againt, but changing the parameter datatype to variant, we will see a performance decrease
DECLARE @demo_var2 sql_variant


-- Assigning value to the parameter
SET @demo_var2 = 3578.27;

-- filtering with the variable we declared earlier
SELECT SalesOrderID
    , SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE UnitPrice = @demo_var2;

-- why does this happen?


/******************************************* DEMO #7 *****************************************************

Parameter sniffing

**********************************************************************************************************/
/*

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON; -- Default is ON
GO

*/

USE TestDB1;
GO

-- Check info on the table and the high density variation over CharData field 
-- will copy query in Plan explorer to see histogram

SELECT COUNT(id), CharData
FROM TestParameterSniffing
GROUP BY CharData;

-- First Execution over millions of records
SELECT COUNT(id)
FROM TestParameterSniffing
WHERE CharData =N'XXXXXXXXX';

-- Second Execution, even when we only have one row, query is optimized for million of rows
SELECT COUNT(id)
FROM TestParameterSniffing
WHERE CharData =N'a';

-- Suggested Solution 1: using a query hint can improve execution plan. RECOMPILE
-- NOTE: this could not work for you. with millions of executions you can experience degraded performance
SELECT COUNT(id)
FROM TestParameterSniffing
WHERE CharData =N'a'
OPTION(RECOMPILE);


-- Suggested Solution 2: using a query hint can improve execution plan. OPTIMIZE FOR UNKNOWN
-- NOTE: you can use this method just for specific parameters, plan could not be optimal for all cases
SELECT COUNT(id)
FROM TestParameterSniffing
WHERE CharData =N'a'
OPTION(OPTIMIZE FOR UNKNOWN);


--Suggested Solution 3: Enable database scoped configuration (since SQL 2016)
--Note that this is an estimate and could not provide accurate plans as with recompile

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = OFF; -- Default is ON
GO

SELECT COUNT(id)
FROM TestParameterSniffing
WHERE CharData =N'a';

-- Why estimated rows are different now?
-- HINT: see the new execution plan for first query:

SELECT COUNT(id)
FROM TestParameterSniffing
WHERE CharData =N'XXXXXXXXX';

--- average distribution of rows
SELECT AVG(n) FROM
(
SELECT count(id) as n
FROM TestParameterSniffing
GROUP BY CharData
) a



ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON; -- Default is ON
GO

/******************************************* DEMO #8 *****************************************************
 Memory grants: Memory needed for the engine to run a query

More info at:
https://www.mssqltips.com/sqlservertip/5793/sql-server-2019-memory-grant-feedback-example-and-data-collection/
**********************************************************************************************************/

ALTER DATABASE [WideWorldImporters] SET COMPATIBILITY_LEVEL = 140 --SQL 2017 compatibility level
GO

USE WideWorldImporters;
GO

/*
Drop index if already exists

DROP INDEX [IX_PeopleLogonName] ON [Application].[People];

*/

-- High memory grant
SELECT LogonName, UserPreferences
FROM [Application].[People]
ORDER BY LogonName;

-- Solution 1, remove order by
SELECT LogonName, UserPreferences
FROM [Application].[People];

--Solution 2, Create an index to support the sort operation
CREATE NONCLUSTERED INDEX [IX_PeopleLogonName] 
ON [Application].[People] (LogonName) INCLUDE (UserPreferences);

SELECT LogonName, UserPreferences
FROM [Application].[People]
ORDER BY LogonName;

--If we add another column, index stop working
SELECT LogonName, UserPreferences, PhoneNumber
FROM [Application].[People]
ORDER BY LogonName;

--Again, solution is to remove the order by
SELECT LogonName, UserPreferences, PhoneNumber
FROM [Application].[People];

-- Since SQL 2019, you can enable memory grant feedback at database level
ALTER DATABASE [WideWorldImporters] SET COMPATIBILITY_LEVEL = 150 --SQL 2019 compatibility level
GO

-- we execute our query again with the new compatibility level, 
--execute it more than 2 times so memory grant can adapt
SELECT LogonName, UserPreferences, PhoneNumber
FROM [Application].[People]
ORDER BY LogonName;

-- disable the property
ALTER DATABASE SCOPED CONFIGURATION SET ROW_MODE_MEMORY_GRANT_FEEDBACK = OFF; --ON is the default for sql 2019
-- try to execute the query again


--return it to ON
ALTER DATABASE SCOPED CONFIGURATION SET ROW_MODE_MEMORY_GRANT_FEEDBACK = ON; --ON is the default for sql 2019
-- try to execute the query again

/******************************************* DEMO #9 *****************************************************
 Joining NULLs

More info at:
http://www.sqlguatemala.com/2019/01/understanding-and-working-with-null-in.html
**********************************************************************************************************/
USE TestDB1;
GO

-- Trying to merge information from 2 systems
-- First, we check the info on the base tables

SELECT * FROM CarRegistry;
SELECT * FROM CarService;


-- If we join assumming data is complete, we don't obtain all info
SELECT 
	CR.Brand +' '+CR.Model  +' '+ CR.Year as [Car],
	CR.LicensePlate as [Registry Plate],
	CR.Owner,
	CS.Comments,
	CS.Cost
FROM CarRegistry CR
INNER JOIN CarService CS
	ON CR.Brand = CS.Brand
	AND CR.Model = CS.Model
	AND CR.Year = CS.Year
	AND CR.LicensePlate = CS.LicensePlate;

-- To try to complete missing info we convert NULL on both sides of the join
-- and when even when we are able to see all the info, a seek predicate is not used for all the joins

SELECT 
	CR.Brand +' '+CR.Model  +' '+ CR.Year as [Car],
	CR.LicensePlate as [Registry Plate],
	CR.Owner,
	CS.Comments,
	CS.Cost
FROM CarRegistry CR
INNER JOIN CarService CS
	ON CR.Brand = CS.Brand
	AND CR.Model = CS.Model
	AND CR.Year = CS.Year
	AND ISNULL(CR.LicensePlate,'') = ISNULL(CS.LicensePlate,'');


-- Correct form must be to evaluate NULL by separate
SELECT 
	CR.Brand +' '+CR.Model  +' '+ CR.Year as [Car],
	CR.LicensePlate as [Registry Plate],
	CR.Owner,
	CS.Comments,
	CS.Cost
FROM CarRegistry CR
INNER JOIN CarService CS
	ON CR.Brand = CS.Brand
	AND CR.Model = CS.Model
	AND CR.Year = CS.Year
	AND (CR.LicensePlate = CS.LicensePlate
		OR (CR.LicensePlate IS NULL and CS.LicensePlate IS NULL));




/******************************************* DEMO #10*****************************************************
helpful queries

More info at:
http://www.sqlguatemala.com/p/free-tools.html#StudyyourServer
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/execution-related-dynamic-management-views-and-functions-transact-sql?view=sql-server-2017
**********************************************************************************************************/

USE master;
GO

-- sys.dm_exec_* are helpful to check: Connections, sessions, requests, and query execution
-- Returns info about all system and user sessions
SELECT *
FROM sys.dm_exec_sessions;

-- Returns info about request running on the SQL Server instance (including SQL handle)
SELECT *
FROM sys.dm_exec_requests;

-- returns the query text associated to a query handle
--sys.dm_exec_sql_text
SELECT qt.TEXT AS QueryText
FROM sys.dm_exec_requests QR
CROSS APPLY sys.dm_exec_sql_text(sql_handle) QT;

-- Find locks and waiting task by session
SELECT *
FROM sys.dm_os_waiting_tasks;

-- Find memory grants by query
SELECT * 
FROM sys.dm_exec_query_memory_grants;


/*
--Or use Adam Machanic's sp_WhoIsActive
https://github.com/amachanic/sp_whoisactive/releases

How to use it? http://whoisactive.com/docs/

*/

-- just create it and enjoy!


sp_whoisactive;


/* DUMB QUERY ON PURPOSE*/
USE WideWorldImporters;
GO

WITH A 
as
(
SELECT LogonName, UserPreferences
FROM [Application].[People]
UNION ALL
SELECT * FROM A
WHERE A.UserPreferences like '%'+ UserPreferences +'%'
)
SELECT * FROM A 
ORDER BY A.LogonName
OPTION (MAXRECURSION 0);
