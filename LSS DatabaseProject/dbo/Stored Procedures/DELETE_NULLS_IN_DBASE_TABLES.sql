CREATE PROCEDURE [dbo].[DELETE_NULLS_IN_DBASE_TABLES] AS 

DECLARE @ColumnName NVARCHAR(256), @Sql NVARCHAR(MAX)

DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Sample_Run' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Sample_Run SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


---------------------------------



DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_CLI' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_CLI SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor





--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Lab_Metrics_Waste_Mgt' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Lab_Metrics_Waste_Mgt SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor



--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_LIMS_Functionality' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_LIMS_Functionality SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Power_Outage' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Power_Outage SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Referred_Samples' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Referred_Samples SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor

--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Testing_Capacity' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Testing_Capacity SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_This_week_Rec_Samples' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_This_week_Rec_Samples SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor



--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Specimen_Transport' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Specimen_Transport SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''null'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''%null%'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor





DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Sample_Run' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Sample_Run SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


---------------------------------



DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_CLI' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_CLI SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor





--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Lab_Metrics_Waste_Mgt' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Lab_Metrics_Waste_Mgt SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor



--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_LIMS_Functionality' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_LIMS_Functionality SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Power_Outage' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Power_Outage SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Referred_Samples' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Referred_Samples SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor

--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Testing_Capacity' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Testing_Capacity SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor


--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_This_week_Rec_Samples' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_This_week_Rec_Samples SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor



--------------------------------------------------


DECLARE column_cursor CURSOR FOR 
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Dash_Lab_Metrics_Waste_Mgt' AND DATA_TYPE IN ('nvarchar', 'varchar', 'text')

OPEN column_cursor  
FETCH NEXT FROM column_cursor INTO @ColumnName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @Sql = 'UPDATE Dash_Lab_Metrics_Waste_Mgt SET ' + QUOTENAME(@ColumnName) + ' = REPLACE(' + QUOTENAME(@ColumnName) + ', ''undefined'', '''') WHERE ' + QUOTENAME(@ColumnName) + ' IS NOT NULL AND ' + QUOTENAME(@ColumnName) + ' LIKE ''undefined'''
    EXEC sp_executesql @Sql

    FETCH NEXT FROM column_cursor INTO @ColumnName  
END 

CLOSE column_cursor  
DEALLOCATE column_cursor