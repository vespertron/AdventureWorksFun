﻿/*** CREATE TABLE COPY USING SSMS GUI ***/
--https://docs.microsoft.com/en-us/sql/relational-databases/tables/duplicate-tables


/*** COPY SOURCE DATA TO TARGET TABLE ***/
/* INSERT INTO Purchasing.ProductVendorTarget
SELECT * FROM Purchasing.ProductVendor */


/*** MESS UP THE TARGET TABLE A BIT ***/
/* DELETE FROM Purchasing.ProductVendorTarget
WHERE ProductID IN (4, 371, 869) */
/* UPDATE Purchasing.ProductVendorTarget
SET AverageLeadTime = 100, StandardPrice = 5.00
WHERE BusinessEntityID = 1584; */


/*** MERGE TARGET WITH SOURCE TABLE ***/
MERGE	Purchasing.ProductVendorTarget	AS Target
USING	Purchasing.ProductVendor	AS Source
	ON	Target.ProductID = Source.ProductID
	AND	Target.BusinessEntityID = Source.BusinessEntityID  --resolved error
WHEN MATCHED AND EXISTS
	(SELECT Source.ProductID, Source.BusinessEntityID, Source.AverageLeadTime, Source.StandardPrice, Source.LastReceiptCost, Source.LastReceiptDate, Source.MinOrderQty, Source.MaxOrderQty, Source.OnOrderQty, Source.UnitMeasureCode
	 EXCEPT
	 SELECT Target.ProductID, Target.BusinessEntityID, Target.AverageLeadTime, Target.StandardPrice, Target.LastReceiptCost, Target.LastReceiptDate, Target.MinOrderQty, Target.MaxOrderQty, Target.OnOrderQty, Target.UnitMeasureCode)
THEN
	UPDATE SET
		 Target.ProductID = Source.ProductID
		,Target.BusinessEntityID = Source.BusinessEntityID
WHEN NOT MATCHED BY TARGET
THEN
	INSERT (ProductID, BusinessEntityID, AverageLeadTime, StandardPrice, LastReceiptCost, LastReceiptDate, MinOrderQty, MaxOrderQty, OnOrderQty, UnitMeasureCode)
	VALUES (ProductID, BusinessEntityID, Source.AverageLeadTime, Source.StandardPrice, Source.LastReceiptCost, Source.LastReceiptDate, Source.MinOrderQty, Source.MaxOrderQty, Source.OnOrderQty, Source.UnitMeasureCode)
WHEN NOT MATCHED BY SOURCE THEN DELETE;
