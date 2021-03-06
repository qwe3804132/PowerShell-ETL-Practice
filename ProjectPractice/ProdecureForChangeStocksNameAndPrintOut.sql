USE [ETLCourse]
GO

/****** Object:  StoredProcedure [dbo].[stp_BuildNormalizedTable]    Script Date: 2019-05-08 3:22:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[stp_BuildNormalizedTable] @table NVARCHAR(100)
AS
BEGIN
	DECLARE @cleanTable NVARCHAR(100),
	@s NVARCHAR(MAX)
	 
	SET @cleanTable=Replace(@table, '_Stocks', 'HistoricalData')
	SET @s = 'CREATE TABLE ' + @cleanTable + ' (ID INT IDENTITY(1,1),Price Decimal(13,4),PriceDate DATE)
	Insert into ' + @cleanTable
	+ '(Price,PriceDate) SELECT TRY_CONVERT(DECIMAL(13,4),[Adj Close]),[Date] FROM '
	+ @table + ' ORDER BY Date ASC'
	 
	PRINT @s --- This is if we want to verify our code before we execute
	EXECUTE sp_executesql @s
END
GO


