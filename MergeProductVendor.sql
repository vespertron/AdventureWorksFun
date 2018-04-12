/*	MERGE QUESTION

	Below are links about the TSQL Merge statement. We often use that to update data with Interject.  
	Elliott would like to see how well you can employ a merge in the Adventure works database to update a table.  
	An approach I would suggest is to copy a table into a new table, change the data slightly, remove a record, 
	and then merge one with the other so they are the same at the end.

	I just found a few links to help describe the merge to help you get started.
 
	https://www.essentialsql.com/introduction-merge-statement/ 
	https://sqlsunday.com/2013/03/17/using-merge/ 
	https://sqlsunday.com/2013/08/04/cool-merge-features/ 
	http://www.made2mentor.com/2013/05/writing-t-sql-merge-statements-the-right-way/ 

*/


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
/*	Learning material: http://www.made2mentor.com/2013/06/using-the-output-clause-with-t-sql-merge/	*/
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
