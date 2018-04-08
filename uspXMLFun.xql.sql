SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE	dbo.XMLFun
AS
BEGIN
	SET NOCOUNT ON;

	/* Insert XML into temp table */
	DECLARE	@Breakfast XML
		SET	@Breakfast = 
					'<?xml version="1.0" encoding="UTF-8"?>
						<breakfast_menu>
							<food id="1">
								<name>Belgian Waffles</name>
								<price>$5.95</price>
								<description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
								<calories>650</calories>
							</food>
							<food id="2">
								<name>Strawberry Belgian Waffles</name>
								<price>$7.95</price>
								<description>Light Belgian waffles covered with strawberries and whipped cream</description>
								<calories>900</calories>
							</food>
							<food id="3">
								<name>Berry-Berry Belgian Waffles</name>
								<price>$8.95</price>
								<description>Belgian waffles covered with assorted fresh berries and whipped cream</description>
								<calories>900</calories>
							</food>
							<food id="4">
								<name>French Toast</name>
								<price>$4.50</price>
								<description>Thick slices made from our homemade sourdough bread</description>
								<calories>600</calories>
							</food>
							<food id="5">
								<name>Homestyle Breakfast</name>
								<price>$6.95</price>
								<description>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</description>
								<calories>950</calories>
							</food>
						</breakfast_menu>'

	SELECT
		 T.C.value('(@id)[1]','INT') AS FoodID
		,T.C.value('(name)[1]','NVARCHAR(30)') AS Name
		,T.C.value('(price)[1]','MONEY') AS Price
		,T.C.value('(description)[1]','NVARCHAR(255)') AS Description
		,T.C.value('(calories)[1]','INT') AS Calories
	INTO #BreakfastTable
	FROM @Breakfast.nodes('breakfast_menu/food') AS T(C)

	SELECT * FROM #BreakfastTable


	/* Convert to XML */
	DECLARE @xml NVARCHAR(MAX)
		SET @xml = (
					SELECT	
						 ISNULL(CONVERT(int, b.FoodID), '') as '@id'
						,ISNULL(CONVERT(nvarchar, b.Name), '') name 
						,ISNULL(CONVERT(money, b.Price), '') price
						,ISNULL(CONVERT(nvarchar(255), b.Description), '') description
						,ISNULL(CONVERT(nvarchar, b.Calories), '') calories
					FROM #BreakfastTable b
					FOR XML PATH('food')
					)
	SELECT CONVERT(XML, '<breakfast_menu>' + @xml + '</breakfast_menu>') Breakfast_Menu


	/* Convert a list of a single column to a comma separated value */
	SELECT Stuffed = STUFF((
							SELECT
								', ' + NAME
							FROM #BreakfastTable
							FOR XML PATH('')
							), 1, 1, '')
	FROM #BreakfastTable


	/* Drop Table */
	DROP TABLE #BreakfastTable

END
GO

EXEC dbo.XMLFun