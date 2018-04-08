USE AdventureWorks
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.XMLRow
	@xml XML	
AS
BEGIN
	SET NOCOUNT ON;

	-- Take data from xml and insert into #searchData
	SELECT	 T.C.value('@CategoryID', 'INT') AS CategoryID
			,T.C.value('@Shelf', 'NVARCHAR(2)') AS Shelf
			,T.C.value('@Top', 'INT') AS TopRecords
			,T.C.value('@Criteria', 'NVARCHAR(20)') AS Criteria
	INTO #SearchData
	FROM @xml.nodes('root/Item') AS T(C)

	-- Declare variables out of selecting #searchData
	DECLARE @CategoryID INT
	DECLARE @Shelf NVARCHAR(2)
	DECLARE @topRecords INT
	DECLARE @Criteria NVARCHAR(20)

	-- Assign values
	SELECT	 @CategoryID = CategoryID
			,@Shelf = Shelf
			,@TopRecords = TopRecords
			,@Criteria = Criteria
	FROM #SearchData

	-- Create CTE statment with Row_number applied inside
	IF @Criteria = 'Quantity'
		BEGIN
			;WITH CTE_ROW AS (
								SELECT	 a.Name
										,d.Name AS Category
										,c.Name AS Subcategory
										,a.ProductID
										,IIF(b.Shelf = 'N/A',  'A', b.Shelf) AS Shelf
										,b.Quantity
										,ROW_NUMBER()OVER(PARTITION BY a.ProductID, c.Name ORDER BY b.Quantity DESC ) AS ROW

								FROM Production.Product a
								LEFT JOIN Production.ProductInventory b ON a.ProductID = b.ProductID
								LEFT JOIN Production.ProductSubcategory c ON c.ProductSubcategoryID = a.ProductSubcategoryID
								LEFT JOIN Production.ProductCategory d ON d.ProductCategoryID = c.ProductCategoryID

								WHERE d.ProductCategoryID = @CategoryID
									AND IIF(b.Shelf = 'N/A',  'A', b.Shelf) = '@Shelf'
							)

	-- Make final selection from CTE
			SELECT *
			FROM CTE_ROW
			WHERE ROW = @topRecords
		END

END
GO

EXEC dbo.XMLRow '<root>
					<Item CategoryID="1" Shelf="A" Top="1" Criteria="Quantity" ></Item>
				</root>'