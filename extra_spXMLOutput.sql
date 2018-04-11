USE AdventureWorks
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE dbo.OutputXML
	@ProductID INT
AS
BEGIN
	SET NOCOUNT ON;
	-- Assume that latest prices are kept in different table and need to update from there #updateTbl
	SELECT
		 ProductID
		 ,ListPrice
		 ,Color
	INTO #updateTbl
	FROM Production.Product

	-- select info to output as XML #outputXML
	SELECT *
	INTO #outputXML
	FROM Production.Product
	WHERE ProductID = @ProductID

	-- update XML table before we output results
	UPDATE a
		SET a.ListPrice = b.ListPrice,
			a.Color = b.Color
		FROM #outputXML a
			JOIN #updateTbl b ON b.ProductID = a.ProductID

	-- output XML format
	DECLARE @xml NVARCHAR(MAX)
	SET @xml = (
				SELECT	
					ISNULL(CONVERT(nvarchar, a.ProductID), '') ProductID
					,ISNULL(CONVERT(nvarchar, a.Color), '') Color
					,ISNULL(CONVERT(nvarchar, a.ListPrice), '') Price
					,ISNULL(CONVERT(nvarchar, a.Name), '') Name
					,ISNULL(CONVERT(nvarchar, a.ModifiedDate), '') Date
				FROM #outputXML a
				FOR XML PATH
				)

	SELECT CONVERT(XML, '<root>' + @xml + '</root>') TheXML

END
GO

EXEC dbo.OutputXML 512