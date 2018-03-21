USE AdventureWorks
GO

-- Drop stored procedure if it already exists.
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'SalesOrdersDataReview'
)
   DROP PROCEDURE dbo.SalesOrdersDataReview
GO


-- Create stored procedure

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
 WHERE DIFFERENCE(sum(SD.LineTotal), SH.SubTotal) > 0
 GROUP BY SH.SalesOrderID
  ,SalesOrderNumber
  ,SubTotal
GO


-- Execute stored procedure.
EXECUTE dbo.SalesOrdersDataReview
GO
