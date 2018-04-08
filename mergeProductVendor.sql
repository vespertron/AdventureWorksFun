/*** CREATE TABLE COPY USING SSMS GUI ***/
--https://docs.microsoft.com/en-us/sql/relational-databases/tables/duplicate-tables


/*** COPY SOURCE DATA TO TARGET TABLE ***/
/* INSERT INTO Purchasing.ProductVendorTarget
SELECT *
FROM Purchasing.ProductVendor */


/*** ALTER TARGET***/
/*DELETE FROM Purchasing.ProductVendorTarget
WHERE ProductID IN (4, 371, 869);

INSERT INTO Purchasing.ProductVendorTarget (ProductID, BusinessEntityID, AverageLeadTime, StandardPrice, LastReceiptCost, LastReceiptDate, MinOrderQty, MaxOrderQty, OnOrderQty, UnitMeasureCode)
VALUES (0, 111, 1, 100.50, 50.00, 1/1/10, 5, 10, 7, 4);

UPDATE Purchasing.ProductVendorTarget
SET AverageLeadTime = 100, StandardPrice = 5.00
WHERE BusinessEntityID = 1584; */


/*** OUTPUT ***/
DECLARE @MergeLog TABLE
(
	MergeAction VARCHAR(50)
	,ProductID INT
	,BusinessEntityID INT
	,AverageLeadTime INT
	,StandardPrice INT
	,LastReceiptCost INT
	,LastReceiptDate DATE
	,MinOrderQty INT
	,MaxOrderQty INT
	,OnOrderQty INT
	,UnitMeasureCode VARCHAR(10)
	,ModifiedDate DATE
);


/*** MERGE ***/
MERGE	Purchasing.ProductVendorTarget T
USING	Purchasing.ProductVendor S
	ON	T.ProductID = S.ProductID
	AND	T.BusinessEntityID = S.BusinessEntityID
WHEN MATCHED AND EXISTS
	(SELECT S.ProductID, S.BusinessEntityID, S.AverageLeadTime, S.StandardPrice, S.LastReceiptCost, S.LastReceiptDate, S.MinOrderQty, S.MaxOrderQty, S.OnOrderQty, S.UnitMeasureCode
	 EXCEPT
	 SELECT T.ProductID, T.BusinessEntityID, T.AverageLeadTime, T.StandardPrice, T.LastReceiptCost, T.LastReceiptDate, T.MinOrderQty, T.MaxOrderQty, T.OnOrderQty, T.UnitMeasureCode)
THEN
	UPDATE SET
		 T.ProductID = S.ProductID
		,T.BusinessEntityID = S.BusinessEntityID
WHEN NOT MATCHED BY TARGET
THEN
	INSERT (ProductID, BusinessEntityID, AverageLeadTime, StandardPrice, LastReceiptCost, LastReceiptDate, MinOrderQty, MaxOrderQty, OnOrderQty, UnitMeasureCode)
	VALUES (ProductID, BusinessEntityID, S.AverageLeadTime, S.StandardPrice, S.LastReceiptCost, S.LastReceiptDate, S.MinOrderQty, S.MaxOrderQty, S.OnOrderQty, S.UnitMeasureCode)
WHEN NOT MATCHED BY SOURCE 
THEN DELETE
OUTPUT	$action AS MergeAction
	,deleted.*
INTO @MergeLog;


/*** LOG DETAIL ***/
SELECT * FROM @MergeLog


/*** LOG SUMMARY ***/
SELECT MergeAction, count(*)
FROM   @MergeLog
GROUP BY MergeAction
