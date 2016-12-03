IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GestionContrainteReferentiel]') AND type in (N'P', N'PC'))
DROP PROCEDURE GestionContrainteReferentiel
GO

CREATE PROCEDURE GestionContrainteReferentiel(
	@IDSourceTarget INT,
	@ProcessusStage VARCHAR(5),  --Possible values =Start or End
	@ProcessusOk BIT OUTPUT 
)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @SourceDatabase VARCHAR(250)
	DECLARE @TargetDatabase VARCHAR(250)
	DECLARE @Instance INT
	DECLARE @DisableConstraint BIT

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	SET @SQL=''
	BEGIN TRY
		BEGIN TRAN
			SET @ProcessusOk = 'True'
			SELECT @SourceDatabase=[SourceDatabase]
				  ,@TargetDatabase=[TargetDatabase]
				  ,@Instance=[Instance]
				  ,@DisableConstraint=[DisableConstraint]
			FROM [dbo].[SourceTarget]
			WHERE [ID] = @IDSourceTarget

			IF @ProcessusStage = 'Start'
				BEGIN
					SELECT @SQL=@SQL+'ALTER TABLE '+ @TargetDatabase+OBJECT_NAME(SO.parent_obj)+' DROP CONSTRAINT ['+OBJECT_NAME(SO.ID)+']; '
						FROM sysobjects SO 
						LEFT OUTER JOIN sys.default_constraints SDC ON SO.name = SDC.name 
						LEFT OUTER JOIN sysconstraints SC ON SO.id = SC.constid 
						INNER JOIN syscolumns SM ON SC.colid = SM.colid AND SO.parent_obj = SM.id
						LEFT OUTER JOIN sysforeignkeys SFK ON SFK.constid = so.id 
						LEFT OUTER JOIN syscolumns SM2 ON SFK.rkey = SM2.colid AND SFK.rkeyid = SM2.id
					WHERE SO.xtype IN ('F','D') 
					AND OBJECT_NAME(SO.PARENT_OBJ) IN (SELECT DISTINCT [Name] 
															FROM [dbo].[TableACopier] TAC 
															INNER JOIN [dbo].[SourceTarget_Table] STT ON TAC.ID = STT.[fk_TableACopier]
														WHERE [fk_SourceTarget] = @IDSourceTarget)
					EXEC(@SQL)
				END
			ELSE IF @ProcessusStage = 'End'
				BEGIN
					SELECT @SQL=@SQL+STUFF(CASE 
								WHEN SO.xtype='D' THEN 
									'ALTER TABLE '+ @TargetDatabase+OBJECT_NAME(SO.parent_obj)+' ADD CONSTRAINT ['+OBJECT_NAME(SO.ID)+'] DEFAULT '+SDC.definition+' FOR ['+SM.name+']; '--,*,OBJECT_NAME(PARENT_OBJECT_ID)
								WHEN SO.xtype = 'F' THEN 
									'ALTER TABLE '+ @TargetDatabase+OBJECT_NAME(SO.parent_obj)+' WITH CHECK ADD CONSTRAINT ['+OBJECT_NAME(SO.ID)+'] FOREIGN KEY (['+SM.name+']) REFERENCES '+@TargetDatabase+'[dbo].['+OBJECT_NAME(SFK.rkeyid)+'] (['+SM2.name+']); '
							END,1,0,'')
						FROM sysobjects SO 
						LEFT OUTER JOIN sys.default_constraints SDC ON SO.name = SDC.name 
						LEFT OUTER JOIN sysconstraints SC ON SO.id = SC.constid 
						INNER JOIN syscolumns SM ON SC.colid = SM.colid AND SO.parent_obj = SM.id
						LEFT OUTER JOIN sysforeignkeys SFK ON SFK.constid = so.id 
						LEFT OUTER JOIN syscolumns SM2 ON SFK.rkey = SM2.colid AND SFK.rkeyid = SM2.id
					WHERE SO.xtype IN ('F','D') 
					AND OBJECT_NAME(SO.PARENT_OBJ) IN (SELECT DISTINCT [Name] 
															FROM [dbo].[TableACopier] TAC 
															INNER JOIN [dbo].[SourceTarget_Table] STT ON TAC.ID = STT.[fk_TableACopier]
														WHERE [fk_SourceTarget] = @IDSourceTarget)
					EXEC(@SQL)
				END
			ELSE
				BEGIN
					RAISERROR ('Error during constraints management, wrong @ProcessuStage parameters see TLOG_MESSAGES for details' , -- Message text.
										15, -- Severity.
										2 -- State.
										);
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		print 'Erreur Gestion contraintes'
		SET @ProcessusOk = 'False'			
		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();
			SET @ErrorMessage = REPLACE(@ErrorMessage,'''','''''')
			SET @SQL = 'INSERT INTO NSLog.dbo.TLOG_MESSAGES
						VALUES (GETDATE(), 2, ''Centralisation'', ''SP : GestionContrainteReferentiel'', ''No user'', 0,
						'+STR(@ErrorState)+', '''+@ErrorMessage+''', ''Severity: '' + CONVERT(varchar,'+STR(@ErrorSeverity)+')+''  Localisation: Constraints management error. Rollback Tran in catch.''); '
			--print '=Error>'+@SQL
			EXEC(@SQL)
	END CATCH

END
