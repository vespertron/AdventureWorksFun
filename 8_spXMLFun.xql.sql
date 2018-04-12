/*	TEST QUESTION 8

		Create a new stored procedure called [dbo].[XMLFun].
		 
			a.	Demonstrate in this stored procedure how XML can be converted to a temp table

			b.	Use the xml in the same folder as these instructions.  Look for XML_BreakfastMenu.

			c.	Be sure to make columns for all elements plus the id attribute for food.

			d.	After you have demonstrated how to parse xml into a data table,
				then show how you can create XML from that table to look like the original XML using the FOR XML syntax.

			e.	Then show how FOR XML can be used with the stuff function to convert a list of a single column
				to a comma separated value.

*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE	dbo.XMLFun
AS
BEGIN
	SET NOCOUNT ON;

	/* Insert XML into temp table */
	/* Learning material: https://www.udemy.com/ms-sql-server-t-sql-concepts-raise-above-beginner-level/learn/v4/t/lecture/9512528?start=0 */
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
	/*	Learning material: https://www.udemy.com/ms-sql-server-t-sql-concepts-raise-above-beginner-level/learn/v4/t/lecture/9513076?start=0 */
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
	/* Adapted from: https://stackoverflow.com/questions/21760969/multiple-rows-to-one-comma-separated-value?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa */
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