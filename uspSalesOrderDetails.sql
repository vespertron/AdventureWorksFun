USE AdventureWorks
GO

CREATE PROCEDURE dbo.SalesOrderDetails
AS
SELECT top 100
  SalesOrderHeader.SalesOrderID
  ,RevisionNumber
  ,OrderDate
  ,Status AS OrderStatusText
  ,SalesOrderNumber
  ,SubTotal
  ,TaxAmt
  ,Freight
  ,TotalDue
  ,RIGHT('000' + CONVERT(VARCHAR(4),OrderQty),4) AS OrderQtyText --Convert Sales.SalesOrderDetails.OrderQty to 4 characters wide
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
FROM Sales.SalesOrderHeader
  LEFT OUTER JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID=SalesOrderDetail.SalesOrderID
  LEFT OUTER JOIN Person.Address ON Sales.SalesOrderHeader.ShipToAddressID=Person.Address.AddressID
  LEFT OUTER JOIN Person.vStateProvinceCountryRegion ON Person.Address.StateProvinceID=vStateProvinceCountryRegion.StateProvinceID
  LEFT OUTER JOIN Production.Product ON Sales.SalesOrderDetail.ProductID=Production.Product.ProductID
  LEFT OUTER JOIN Production.ProductModel ON Production.Product.ProductModelID=Production.ProductModel.ProductModelID
  LEFT OUTER JOIN Production.ProductSubcategory ON Production.Product.ProductSubcategoryID=Production.ProductSubcategory.ProductSubcategoryID
  LEFT OUTER JOIN Production.ProductCategory ON Production.ProductSubcategory.ProductCategoryID=Production.ProductCategory.ProductCategoryID
ORDER BY SalesOrderNumber
GO