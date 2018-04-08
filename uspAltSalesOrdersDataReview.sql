USE AdventureWorks
GO


CREATE PROCEDURE dbo.AltSalesOrdersDataReview
AS

GO


EXEC dbo.AltSalesOrdersDataReview
GO


SELECT
	*
FROM Sales.SalesOrderHeader

SELECT
	*
FROM Sales.SalesOrderDetail