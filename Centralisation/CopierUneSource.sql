
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopierUneSource]') AND type in (N'P', N'PC'))
DROP PROCEDURE CopierUneSource
GO

CREATE PROCEDURE CopierUneSource(
	@IDSourceTarget INT
)
AS
BEGIN
	DECLARE 
	@SourceDatabase VARCHAR(250)
	,@TargetDatabase VARCHAR(250)

	-- TODO Prendre en compte la table TPropagation

	SELECT @SourceDatabase = [SourceDatabase],@TargetDatabase=TargetDatabase
	FROM SourceTarget
	WHERE ID=@IDSourceTarget


	

	DECLARE @cur_SQL NVARCHAR(MAX)
	SET @cur_SQL = 'IF EXISTS (SELECT * FROM sys.synonyms WHERE name = ''SysColonne'')  drop synonym SysColonne ; CREATE SYNONYM SysColonne FOR ' + replace(@SourceDatabase,'dbo.','sys.') + 'columns'
	print @cur_SQL
	exec sp_executesql @cur_SQL

	SET @cur_SQL = 'IF EXISTS (SELECT * FROM sys.synonyms WHERE name = ''SysObject'')  drop synonym SysObject ; CREATE SYNONYM SysObject FOR ' + replace(@SourceDatabase,'dbo.','sys.') + 'objects'
	print @cur_SQL
	exec sp_executesql @cur_SQL

	DECLARE @TableName VARCHAR(250)
	,@TabidName VARCHAR(250)

	DECLARE c_table CURSOR FOR
		select [Name] ,[IdNamere] 
		FROM TableACopier T JOIN [SourceTarget_Table] S ON t.ID = S.fk_TableACopier
		WHERE S.[fk_SourceTarget] = @IDSourceTarget
		ORDER by [OrdreExecution]


	OPEN c_table   
	FETCH NEXT FROM c_table INTO @TableName, @TabidName  

	WHILE @@FETCH_STATUS = 0   
	BEGIN   

		

		print 'Traitement de la table '+ @TableName

		IF OBJECT_ID('tempdb..#IdToUpdate') IS NOT NULL
		DROP TABLE #IdToUpdate

		CREATE TABLE #IdToUpdate(
		ID INT )

		DECLARE @SQLOld nvarchar(max)
		,@SQLNew nvarchar(max)
		,@SQLFinal nvarchar(max)

		SET @SQLOld='SELECT '
		SET @SQLNew='SELECT '
		SET @SQLFinal='UPDATE OLd SET '


		SELECT @SQLOld = @SQLOld + c.name + ',' ,@SQLNew=@SQLNew+c.name + ',' ,@SQLFinal=CASE WHEN c.name = @TabidName THEN @SQLFinal ELSE @SQLFinal + c.name + ' = New.' + c.name + ','    END
		FROM SysColonne c JOIN SysObject o ON c.object_id = o.object_id 
		WHERE o.name = @TableName and o.type='U'
		and c.system_type_id not in (35)


		SET @SQLOld = @SQLOld +'#FROM ' + @TargetDatabase +  @TableName 
		SET @SQLOld = replace(@SQLOld,',#FROM',' FROM')

		SET @SQLNew = @SQLNew +'#FROM ' + @SourceDatabase +  @TableName 
		SET @SQLNew = replace(@SQLNew,',#FROM',' FROM')


		SET @cur_SQL = 'SELECT ' + @TabidName + '  FROM (' + @SQLOld + ' EXCEPT ' + @SQLNew + ') E'
		INSERT INTO #IdToUpdate
		exec sp_executesql @cur_SQL


		--TODO Prendre en compte la table Tpropagation

		SET @SQLFinal = @SQLFinal + '#FROM  ' + @TargetDatabase +  @TableName + ' Old  JOIN ' + @SourceDatabase +  @TableName + ' New ON Old.' +  @TabidName + '= New.' +  @TabidName
		SET @SQLFinal = @SQLFinal + ' WHERE Old.' + @TabidName + ' IN (SELECT  ID FROM #IdToUpdate) '

		SET @SQLFinal = replace(@SQLFinal,',#FROM',' FROM')

		--print @SQLFinal

		exec sp_executesql @SQLFinal

		FETCH NEXT FROM c_table INTO @TableName, @TabidName  

	END

	CLOSE c_table   
	DEALLOCATE c_table
END

