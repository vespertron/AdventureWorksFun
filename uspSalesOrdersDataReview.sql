USE AdventureWorks
GO

CREATE PROCEDURE dbo.SalesOrdersDataReview
AS
 SELECT
   SH.SalesOrderID
   ,SalesOrderNumber
   ,SubTotal AS OriginalSubtotal
   ,SUM(LineTotal) AS CalculatedSubtotalFromDetail
   ,DIFFERENCE(sum(SD.LineTotal), SH.SubTotal) AS Difference
 FROM Sales.SalesOrderHeader SH
  INNER JOIN Sales.SalesOrderDetail SD
    ON SH.SalesOrderID = SD.SalesOrderID
 WHERE DIFFERENCE('CalculatedSubtotalFromDetail', 'Difference') > 0
 GROUP BY SH.SalesOrderID
  ,SalesOrderNumber
  ,SubTotal
GO

-- Execute stored procedure.
EXECUTE dbo.SalesOrdersDataReview
GO
