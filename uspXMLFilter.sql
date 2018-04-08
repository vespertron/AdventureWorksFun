SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  XML_filter
	@xml XML
AS
BEGIN
	SET NOCOUNT ON;
	
	--take data from @xml variable and pass it to a temp table
	SELECT T.C.value('@ProductNumber','nvarchar(30)') AS Item_product,
			T.C.value('@SafetyStock','INT') AS Item_safety
			INTO #temp_xml
		FROM	@xml.nodes('root/Item') AS T(C)

	--identify which data can be linked with our tables from DB
		--TransactionDate, TransactionType, Quantity where SafetyStock = '''' and Products

	--create final join and output required results
	SELECT	 a.Item_product as XML_product
			,a.Item_safety as XML_safety
			,c.TransactionDate
			,c.TransactionType
			,c.Quantity
	FROM #temp_xml a
	JOIN Production.Product b ON b.ProductNumber = a.Item_product AND a.Item_safety = b.SafetyStockLevel
	JOIN Production.TransactionHistory c ON c.ProductID = b.ProductID

	--drop temp table
	DROP TABLE #temp_xml

END
GO

EXEC XML_filter '
<root>
	<Item ProductNumber="CA-5965" SafetyStock="500"></Item>
	<Item ProductNumber="CB-2903" SafetyStock="1000"></Item>
	<Item ProductNumber="BE-2349" SafetyStock="800"></Item>
	<Item ProductNumber="AR-5381" SafetyStock="1000"></Item>
</root>'