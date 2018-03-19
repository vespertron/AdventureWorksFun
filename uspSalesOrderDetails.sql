USE AdventureWorks
GO

CREATE PROCEDURE dbo.SalesOrderDetails
AS
SELECT top 100
  SH.SalesOrderID
  ,RevisionNumber
  ,OrderDate
  ,Status AS OrderStatusText
  ,SalesOrderNumber
  ,SubTotal
  ,TaxAmt
  ,Freight
  ,TotalDue
  ,RIGHT('000' + CONVERT(VARCHAR(4), SD.OrderQty),4) AS OrderQtyText
  ,UnitPrice
  ,UnitPriceDiscount
  ,LineTotal
  ,City AS ShipToCity
  ,StateProvinceCode AS ShipToState
  ,PostalCode AS ShipToZip
  ,CountryRegionCode AS ShipToCountryCode
  ,CountryRegionName AS ShipToCountryName
  ,ProductModel.Name AS ModelName
  ,ProductCategory.Name AS CategoryName
FROM Sales.SalesOrderHeader SH
  LEFT OUTER JOIN Sales.SalesOrderDetail SD ON OH.SalesOrderID = SD.SalesOrderID
  LEFT OUTER JOIN Person.Address PA ON SH.ShipToAddressID = PA.AddressID
  LEFT OUTER JOIN Person.vStateProvinceCountryRegion PSC ON PA.StateProvinceID=PSC.StateProvinceID
  LEFT OUTER JOIN Production.Product PP ON SD.ProductID = PP.ProductID
  LEFT OUTER JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
  LEFT OUTER JOIN Production.ProductSubcategory PS ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
  LEFT OUTER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
ORDER BY SalesOrderNumber
GO
