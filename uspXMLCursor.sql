SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE XMLCursor
	@xml XML
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dynamic nvarchar(max)
	DECLARE @dynamic_exec nvarchar(max)
	DECLARE @ProductNumber nvarchar(30)
	DECLARE @Operator nvarchar(30)
	DECLARE @Price nvarchar(30)


		-- Create temp table to take data from xml input
		SELECT
			 T.C.value('@ProductNumber','nvarchar(30)') AS ProductNumber
			,T.C.value('@Operator','nvarchar(30)') AS Operator
			,T.C.value('@ListPrice','nvarchar(30)') AS ListPrice
			INTO #xml
		FROM @xml.nodes('root/Item') AS T(C)


		-- create table to collect data from cursor's output and final select
		CREATE TABLE #CollectDataCursor
		(
			ProductNumber nvarchar(30),
			Name nvarchar(30),
			ListPrice nvarchar(30)
		)


		-- create dynamic sql query
		SET @dynamic = N'
					INSERT INTO #CollectDataCursor
						SELECT
							 b.ProductNumber
							,b.Name
							,c.ListPrice
					FROM #xml a
						JOIN Production.Product b
							ON b.ProductNumber = a.ProductNumber
						JOIN Production.ProductListPriceHistory c
							ON c.ProductID = b.ProductID AND c.ListPrice'


		-- create variables for cursor to place values



		-- declare and set up cursor
			-- inside the cursor
	DECLARE xmlCursor CURSOR FOR
		
			SELECT * FROM #xml
			OPEN xmlCursor

	FETCH NEXT FROM xmlCursor
				INTO @ProductNumber
					,@Operator
					,@Price
				WHILE @@FETCH_STATUS = 0
					BEGIN 
						SET @dynamic_exec = @dynamic + @Operator + @Price + 
										' WHERE b.ProductNumber = ' + '''' + @ProductNumber + ''''
						PRINT @dynamic_exec

						EXEC(@dynamic_exec)

						FETCH NEXT FROM xmlCursor
							INTO @ProductNumber, @Operator, @Price
					END

	CLOSE xmlCursor
	DEALLOCATE xmlCursor


	-- make select then DROP all temp tables
	SELECT * FROM #CollectDataCursor

	DROP TABLE #CollectDataCursor
	DROP TABLE #xml

END
GO

EXEC XMLCursor '<root>
				<Item ProductNumber="HL-U509-B" Operator = "&gt;=" ListPrice ="33" ></Item>
				<Item ProductNumber="SO-B909-L" Operator = "&lt;=" ListPrice ="10" ></Item>
				<Item ProductNumber="LJ-0192-S" Operator = "&gt;=" ListPrice ="40" ></Item>
			</root>'