/*	TEST QUESTION 3

		Create a SQL statement to select the following column names:

		a.	SalesOrderID,RevisionNumber,OrderDate,OrderStatusText,SalesOrderNumber,
			SubTotal,TaxAmt,Freight,TotalDue,OrderQtyText,UnitPrice,UnitPriceDiscount,
			LineTotal,ShipToCity,ShipToState,ShipToZip,ShipToCountryCode,ShipToCountryName,
			ModelName,CategoryName

				i.		OrderStatusText is a translated column that notes what the OrderStatusID means.

				ii.		OrderQtyText is the order quantity but with leading zeros that forces the value
						to 4 characters wide.

				iii.	The rest of the columns closely match the database fields.

				iv.		Note the tables used will focus on [Sales].[SalesOrderHeader]
						and [Sales].[SalesOrderDetail] but to get the rest of the columns you will need
						to join to six additional tables.

		b.	Select the top 100 records. Sort by SalesOrderNumber.


	GENERAL COMMENTS
		
		The below code contains no table aliases, and is formatted with double spaces instead of tabs.
		This is corrected in TEST QUESTION 5.

 */


SELECT top 100
   SalesOrderHeader.SalesOrderID
  ,SalesOrderHeader.RevisionNumber
  ,SalesOrderHeader.OrderDate
  ,SalesOrderStatus.Status AS OrderStatusText -- custom table
  ,SalesOrderHeader.SalesOrderNumber
  ,SalesOrderHeader.SubTotal
  ,SalesOrderHeader.TaxAmt
  ,SalesOrderHeader.Freight
  ,SalesOrderHeader.TotalDue
--	OrderQtyText: how to add zeroes to front of integer
--	Source: https://stackoverflow.com/questions/16760900/pad-a-string-with-leading-zeros-so-its-3-characters-long-in-sql-server-2008?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  ,RIGHT('000' + CONVERT(VARCHAR(4), SalesOrderDetail.OrderQty),4) AS OrderQtyText
  ,SalesOrderDetail.UnitPrice
  ,SalesOrderDetail.UnitPriceDiscount
  ,SalesOrderDetail.LineTotal
  ,Address.City AS ShipToCity
  ,vStateProvinceCountryRegion.StateProvinceCode AS ShipToState
  ,Address.PostalCode AS ShipToZip
  ,vStateProvinceCountryRegion.CountryRegionCode AS ShipToCountryCode
  ,vStateProvinceCountryRegion.CountryRegionName AS ShipToCountryName
  ,ProductModel.Name AS ModelName
  ,ProductCategory.Name AS CategoryName
FROM Sales.SalesOrderHeader

--	Sales.SalesOrderStatus is a table which I created for the description of status for "OrderStatusText" column.
--	Source: https://dba.stackexchange.com/questions/201623/ssms-query-variables-from-table-design-mode-column-description?stw=2
  
  JOIN Sales.SalesOrderStatus ON SalesOrderHeader.Status = SalesOrderStatus.StatusID
  JOIN Sales.SalesOrderDetail  ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
  JOIN Person.Address ON SalesOrderHeader.ShipToAddressID = Address.AddressID
  JOIN Person.vStateProvinceCountryRegion ON Address.StateProvinceID = vStateProvinceCountryRegion.StateProvinceID
  JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
  JOIN Production.ProductModel ON Product.ProductModelID = ProductModel.ProductModelID
  JOIN Production.ProductSubcategory ON Product.ProductSubcategoryID = ProductSubcategory.ProductSubcategoryID
  JOIN Production.ProductCategory ON ProductSubcategory.ProductCategoryID = ProductCategory.ProductCategoryID
ORDER BY SalesOrderNumber;