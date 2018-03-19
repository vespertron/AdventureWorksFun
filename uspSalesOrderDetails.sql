USE AdventureWorks
GO

CREATE PROCEDURE dbo.SalesOrderDetails
  /* Input Parameters set to NULL so procedure will run even if user defines no dates */
  @BeginDate DATE = NULL
  @EndDate DATE = NULL
AS
  SET NOCOUNT ON
  /* User defines input parameters */
  SET @BeginDate DATE = ISNULL(@BeginDate, GETDATE())
  SET @EndDate DATE = ISNULL(@EndDate, GETDATE())
SELECT top 100
  SH.SalesOrderID
  ,SH.RevisionNumber
  ,SH.OrderDate
  ,SH.Status AS OrderStatusText
  ,SH.SalesOrderNumber
  ,SH.SubTotal
  ,SH.TaxAmt
  ,SH.Freight
  ,SD.TotalDue
  ,RIGHT('000' + CONVERT(VARCHAR(4), SD.OrderQty),4) AS OrderQtyText
  ,PP.UnitPrice
  ,PP.UnitPriceDiscount
  ,SD.LineTotal
  ,PA.City AS ShipToCity
  ,PA.StateProvinceCode AS ShipToState
  ,PA.PostalCode AS ShipToZip
  ,PSC.CountryRegionCode AS ShipToCountryCode
  ,PSC.CountryRegionName AS ShipToCountryName
  ,PM.Name AS ModelName
  ,PC.Name AS CategoryName
FROM Sales.SalesOrderHeader SH
  LEFT OUTER JOIN Sales.SalesOrderDetail SD ON OH.SalesOrderID = SD.SalesOrderID
  LEFT OUTER JOIN Person.Address PA ON SH.ShipToAddressID = PA.AddressID
  LEFT OUTER JOIN Person.vStateProvinceCountryRegion PSC ON PA.StateProvinceID = PSC.StateProvinceID
  LEFT OUTER JOIN Production.Product PP ON SD.ProductID = PP.ProductID
  LEFT OUTER JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
  LEFT OUTER JOIN Production.ProductSubcategory PS ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
  LEFT OUTER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
/* Input parameters */
WHERE SH.OrderDate BETWEEN @BeginDate AND @EndDate
ORDER BY SalesOrderNumber
GO
