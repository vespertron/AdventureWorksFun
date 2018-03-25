USE [AdventureWorks]
GO
/****** Object:  StoredProcedure [dbo].[SalesOrderDetails]    Script Date: 3/20/2018 9:23:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SalesOrderDetails] 
	/* Set input param defaults to NULL so that proc executes with or without user input */
    @BeginDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
	/* SET NOCOUNT ON added to prevent extra result sets from
	interfering with SELECT statements. */
	SET NOCOUNT ON;

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
      /* convert INT to STRING with 4 characters */
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
      INNER JOIN Sales.SalesOrderStatus SS
      	ON SH.Status = SS.StatusID
      INNER JOIN Sales.SalesOrderDetail SD
      	ON SH.SalesOrderID = SD.SalesOrderID
      INNER JOIN Person.Address PA
      	ON SH.ShipToAddressID = PA.AddressID
      INNER JOIN Person.vStateProvinceCountryRegion PSC
      	ON PA.StateProvinceID = PSC.StateProvinceID
      INNER JOIN Production.Product PP
      	ON SD.ProductID = PP.ProductID
      INNER JOIN Production.ProductModel PM
      	ON PP.ProductModelID = PM.ProductModelID
      INNER JOIN Production.ProductSubcategory PS
      	ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
      INNER JOIN Production.ProductCategory PC
      	ON PS.ProductCategoryID = PC.ProductCategoryID
    WHERE SH.OrderDate BETWEEN @BeginDate AND @EndDate
    ORDER BY SalesOrderNumber
END

EXECUTE dbo.SalesOrderDetails @BeginDate = '', @EndDate = ''
GO
