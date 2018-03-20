USE AdventureWorks
GO

-- Drop stored procedure if it already exists.
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'SalesOrderDetails'
)
   DROP PROCEDURE dbo.SalesOrderDetails
GO

-- Create stored procedure
CREATE PROCEDURE dbo.SalesOrderDetails
-- Set input param defaults so that proc executes with or without user input
  @BeginDate DATE = NULL,
  @EndDate DATE = NULL
AS
  SET @BeginDate = ISNULL(@BeginDate, GETDATE())
  SET @EndDate = ISNULL(@EndDate, GETDATE())
  
SELECT top 100
  SH.SalesOrderID
  ,SH.RevisionNumber
  ,SH.OrderDate
  ,SS.Status AS OrderStatusText
  ,SH.SalesOrderNumber
  ,SH.SubTotal
  ,SH.TaxAmt
  ,SH.Freight
  ,SH.TotalDue
-- convert INT to STRING with 4 characters
  ,RIGHT('000' + CONVERT(VARCHAR(4), SD.OrderQty),4) AS OrderQtyText
  ,SD.UnitPrice
  ,SD.UnitPriceDiscount
  ,SD.LineTotal
  ,PA.City AS ShipToCity
  ,PSC.StateProvinceCode AS ShipToState
  ,PA.PostalCode AS ShipToZip
  ,PSC.CountryRegionCode AS ShipToCountryCode
  ,PSC.CountryRegionName AS ShipToCountryName
  ,PM.Name AS ModelName
  ,PC.Name AS CategoryName
  FROM Sales.SalesOrderHeader SH
    LEFT OUTER JOIN Sales.SalesOrderStatus SS ON SH.Status = SS.StatusID
    LEFT OUTER JOIN Sales.SalesOrderDetail SD ON SH.SalesOrderID = SD.SalesOrderID
    LEFT OUTER JOIN Person.Address PA ON SH.ShipToAddressID = PA.AddressID
    LEFT OUTER JOIN Person.vStateProvinceCountryRegion PSC ON PA.StateProvinceID = PSC.StateProvinceID
    LEFT OUTER JOIN Production.Product PP ON SD.ProductID = PP.ProductID
    LEFT OUTER JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
    LEFT OUTER JOIN Production.ProductSubcategory PS ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
    LEFT OUTER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
  WHERE SH.OrderDate BETWEEN @BeginDate AND @EndDate
  ORDER BY SalesOrderNumber
GO


-- Execute stored procedure with or without input parameter entry
EXECUTE dbo.SalesOrderDetails @BeginDate = '2/1/2008', @EndDate = '2/14/2017'
GO
