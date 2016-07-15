


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageEcolImportFromERD]') AND type in (N'P', N'PC'))
DROP PROCEDURE MessageEcolImportFromERD
GO


CREATE PROCEDURE MessageEcolImportFromERD
AS
BEGIN
	print 'MessageEcolImportFromERD'

	BEGIN TRY
	BEGIN TRAN
	
		------------------------- GESTION DES SUJETS -------------------------
		print 'SUbject insertion'
		-- Insertion des nouveaux sujets
		INSERT INTO [Subjects]
			   ([Name]
			   ,[Original_Id]
			   ,[Status]
			   ,[Comment]
			   ,[TypeObj_ID])
		SELECT DISTINCT D.PropValue,m.Provenance + '_' + convert(varchar,m.ObjectId),4,'',1 
		FROM 	TMessageReceived M JOIN  TMessageReceivedDetail D ON M.pk_MessageReceived=D.fk_MessageReceived and D.PropName = 'StationName'
		WHERE Importdate IS NULL AND M.ObjectType ='Station' AND m.Provenance like  'EcoReleve%' and m.isMessageComplete = 1
		AND NOT EXISTS (SELECT * FROM [Subjects] S WHERE [TypeObj_ID] =1 and S.Original_Id =  m.ObjectOriginalID)
	

		---- MAJ des sujets existants
		print 'SUbject Updating'
		UPDATE S
		SET Name = D.PropValue
		FROM [Subjects] S
		JOIN TMessageReceived M ON  S.Original_Id = m.ObjectOriginalID and m.isMessageComplete = 1
		JOIN  TMessageReceivedDetail D ON M.pk_MessageReceived=D.fk_MessageReceived and D.PropName = 'StationName'
		WHERE M.ImportDate IS NULL and M.isMessageComplete = 1

	
		print 'Inserting DYnPropValues'
		-- MAJ des propri�t�es dynamiques on prends la valeur r�cup�r�e et on conmpare avec les valeurs existantes, on ins�re si valeurs existante
		INSERT INTO [SubjectDynPropValues]
			   ([StartDate]
			   ,[Parameter]
			   ,[ValueInt]
			   ,[ValueString]
			   ,[ValueDate]
			   ,[ValueFloat]
			   ,[Subject_ID]
			   ,[SubjectDynProp_ID])

		SELECT DISTINCT  GETDATE(),NULL
		,CASE WHEN DP.TypeProp = 'entier' THEN CONVERT(int,D.PropValue) ELSE NULL END
		,CASE WHEN DP.TypeProp = 'string' THEN D.PropValue ELSE NULL END
		,CASE WHEN DP.TypeProp = 'date' THEN CONVERT(DATETIME,D.PropValue,120) ELSE NULL END
		,CASE WHEN DP.TypeProp = 'float' THEN CONVERT(float,D.PropValue) ELSE NULL END
		,S.ID
		,DP.ID
		FROM 	TMessageReceived M 
		JOIN subjects S on S.Original_Id = m.ObjectOriginalID
		JOIN  TMessageReceivedDetail D ON M.pk_MessageReceived=D.fk_MessageReceived
		JOIN TMessageDynPropvsERD CDP ON CDP.ERDName = D.PropName
		JOIN SubjectDynProps DP ON DP.Name = CDP.EColName
		LEFT JOIN SubjectDynPropValuesNow  V ON v.Subject_ID = S.ID and V.name = DP.Name 			
		WHERE Importdate IS NULL AND M.ObjectType ='Station' AND m.Provenance like  'EcoReleve%'
		AND  (CASE WHEN DP.TypeProp = 'entier' THEN 
					CASE WHEN V.ValueInt = CONVERT(int,D.PropValue) OR (V.ValueInt IS NULL AND D.PropValue IS NULL)  THEN 0 
					ELSE 1 END 
			ELSE 1 END) = 1
		AND  (CASE WHEN DP.TypeProp = 'string' THEN CASE WHEN V.ValueString = D.PropValue OR (V.ValueString IS NULL AND D.PropValue IS NULL)  THEN 0 
					ELSE 1 END 
			ELSE 1 END	) = 1
		AND  (CASE WHEN DP.TypeProp = 'date' THEN CASE WHEN V.ValueDate = CONVERT(DATETIME,D.PropValue,120)  OR (V.ValueDate IS NULL AND D.PropValue IS NULL) THEN 0 
					ELSE 1 END 
			ELSE 1 END) = 1
		AND  (CASE WHEN DP.TypeProp = 'float' THEN CASE WHEN V.ValueFloat = CONVERT(float,D.PropValue) OR (V.ValueFloat IS NULL AND D.PropValue IS NULL) THEN 0
			ELSE 1 END 
		ELSE 1 END) = 1
		and m.isMessageComplete = 1
	
	
		UPDATE TMessageReceived
		SET ImportDate=GETDATE()
		WHERE ObjectType ='Station'
		AND ImportDate IS NULL AND Provenance like  'EcoReleve%' and isMessageComplete = 1
	
		IF @@TRANCOUNT >0  BEGIN
			COMMIT TRAN
			BEGIN TRAN
		END
	
		------------------------- GESTION DES SAMPLES -------------------------

		-- CREATION DES SAMPLES AVEC ID

		SET IDENTITY_INSERT [Samples] ON

	
		INSERT INTO [Samples]
			   (ID
			   ,[Original_Id]
			   ,[Status]
			   ,[Name]
			   ,[Tampon]
			   ,[CreationDate]
			   ,[SampleDate]
			   ,[Container]
			   ,[Holder]
			   ,[Position]
			   ,[Comment]
			   ,[ParentSample_ID]
			   ,[Subject_ID]
			   ,[TypeObj_ID]
			   ,Qte)
			   
		SELECT DISTINCT convert(bigint,DID.PropValue) ID,m.Provenance+'_' + m.ObjectID,2,'','',getdate(),SV.ValueDate,NULL,NULL,NULL,DCo.PropValue,NULL,S.ID,ST.ID,convert(INT,DNb.PropValue)
		FROM 	TMessageReceived M 
		JOIN  TMessageReceivedDetail DID ON M.pk_MessageReceived=DID.fk_MessageReceived and DID.PropName = 'ECol_id' and DID.Provenance = m.Provenance and DID.PropValue IS NOT NULL
		JOIN  TMessageReceivedDetail DSta ON M.pk_MessageReceived=DSta.fk_MessageReceived and DSta.PropName = 'FK_Station' and DSta.Provenance = m.Provenance
		JOIN  TMessageReceivedDetail DCo ON M.pk_MessageReceived=DCo.fk_MessageReceived and DCo.PropName = 'Comments' and DCo.Provenance = m.Provenance
		JOIN  TMessageReceivedDetail DNb ON M.pk_MessageReceived=DNb.fk_MessageReceived and DNb.PropName = 'number' and DNb.Provenance = m.Provenance
		JOIN Subjects S ON s.Original_Id = M.Provenance + '_' + DSta.PropValue
		JOIN SampleTypes ST ON ST.Name = CASE WHEN convert(INT,DNb.PropValue) >1 THEN 'Group' ELSE 'Individual' END
		LEFT JOIN SubjectDynPropValuesNow SV ON SV.Subject_ID = s.id and SV.Name ='StationDate'
		WHERE  M.ObjectType ='Entomo_Pop_Census' AND m.Provenance like  'EcoReleve_%'
		AND Importdate IS NULL 
		AND NOT EXISTS (SELECT * FROM Samples ES WHERE ES.original_ID = m.ObjectID)
	

		SET IDENTITY_INSERT [Samples] OFF


		-- CREATION DES SAMPLES SANS ID

		INSERT INTO [Samples]
			   ([Original_Id]
			   ,[Status]
			   ,[Name]
			   ,[Tampon]
			   ,[CreationDate]
			   ,[SampleDate]
			   ,[Container]
			   ,[Holder]
			   ,[Position]
			   ,[Comment]
			   ,[ParentSample_ID]
			   ,[Subject_ID]
			   ,[TypeObj_ID]
			   ,Qte)
		SELECT DISTINCT m.ObjectID,2,'','',getdate(),SV.ValueDate,NULL,NULL,NULL,DCo.PropValue,NULL,S.ID,ST.ID,convert(INT,DNb.PropValue)
		FROM 	TMessageReceived M 
		JOIN  TMessageReceivedDetail DSta ON M.pk_MessageReceived=DSta.fk_MessageReceived and DSta.PropName = 'FK_Station' and DSta.Provenance = m.Provenance
		JOIN  TMessageReceivedDetail DCo ON M.pk_MessageReceived=DCo.fk_MessageReceived and DCo.PropName = 'Comments' and DCo.Provenance = m.Provenance
		JOIN  TMessageReceivedDetail DNb ON M.pk_MessageReceived=DNb.fk_MessageReceived and DNb.PropName = 'number' and DNb.Provenance = m.Provenance
		JOIN Subjects S ON s.Original_Id = M.Provenance + '_' + DSta.PropValue
		JOIN SampleTypes ST ON ST.Name = CASE WHEN convert(INT,DNb.PropValue) >1 THEN 'Group' ELSE 'Individual' END
		LEFT JOIN SubjectDynPropValuesNow SV ON SV.Subject_ID = s.id and SV.Name ='StationDate'
		WHERE  M.ObjectType ='Entomo_Pop_Census' AND m.Provenance like  'EcoReleve_%'
		AND Importdate IS NULL 
		AND NOT EXISTS (SELECT * FROM Samples ES WHERE ES.original_ID = m.ObjectID)



		---- Get originalspecies
		--originalSpecies
		INSERT INTO [SampleDynPropValues]
	           ([StartDate]
	           ,[Parameter]
	           ,[ValueInt]
	           ,[ValueString]
	           ,[ValueDate]
	           ,[ValueFloat]
	           ,[Sample_ID]
	           ,[SampleDynProp_ID])
		SELECT DISTINCT GETDATE(),NULL,NULL,D.PropValue,NULL,NULL,S.ID,DP.ID
		FROM 	TMessageReceived M 
		JOIN Samples S on S.Original_Id = M.ObjectID
		JOIN  TMessageReceivedDetail D ON M.pk_MessageReceived=D.fk_MessageReceived and d.Provenance = m.Provenance
		JOIN SampleDynProps DP ON DP.Name  in ('determinatedSpecies')
		WHERE Importdate IS NULL AND M.ObjectType ='Entomo_Pop_Census' AND m.Provenance like  'EcoReleve_%'
		and d.PropName = 'taxon'
		AND m.isMessageComplete = 1
		order by s.ID,DP.ID

		INSERT INTO [SampleDynPropValues]
	           ([StartDate]
	           ,[Parameter]
	           ,[ValueInt]
	           ,[ValueString]
	           ,[ValueDate]
	           ,[ValueFloat]
	           ,[Sample_ID]
	           ,[SampleDynProp_ID])
		SELECT  DISTINCT GETDATE(),NULL,NULL,D.PropValue,NULL,NULL,S.ID,DP.ID
		FROM 	TMessageReceived M 
		JOIN Samples S on S.Original_Id = M.ObjectID
		JOIN  TMessageReceivedDetail D ON M.pk_MessageReceived=D.fk_MessageReceived and d.Provenance = m.Provenance
		JOIN SampleDynProps DP ON  dp.name = D.PropName
		WHERE --Importdate IS NULL AND 
		M.ObjectType ='Entomo_Pop_Census' AND m.Provenance like  'EcoReleve_%'
		and d.PropName in ('Age','Sex')
		AND m.isMessageComplete = 1
		order by s.ID,DP.ID

		-- TODO Cr�er un Event
		IF OBJECT_ID('tempdb..#EventCreated') IS NOT NULL
		DROP TABLE #EventCreated

		CREATE TABLE #EventCreated
		(
		Event_ID BIGINT
		,Sample_ID BIGINT
		) 


		INSERT INTO [dbo].[EcolEvents]
           ([Status]
           ,[Name]
           ,[EventDate]
           ,[InputOperator]
           ,[User]
           ,[Comment]
           ,[Sample_ID]
           ,[TypeObj_ID]
           ,[SamplePositionHisto_ID])
		   OUTPUT inserted.ID,inserted.sample_id into #EventCreated
		select 2,'',GETDATE(),'',NULL,NULL,S.id,T.ID ,NULL
		FROM 	TMessageReceived M 
		JOIN Samples S on S.Original_Id = M.ObjectID JOIN EcolEventtypes T ON T.Name ='Imported'

		INSERT INTO [dbo].[EcolEventDynPropValues]
           ([StartDate]
           ,[Parameter]
           ,[ValueInt]
           ,[ValueString]
           ,[ValueDate]
           ,[ValueFloat]
           ,[EcolEvent_ID]
           ,[EcolEventDynProp_ID])

		   select getdate(),null,null,D.PropValue,NULL,NULL,C.Event_ID, DP.ID
		   from  #EventCreated C JOIN Samples S on C.Sample_ID = S.ID 
		   JOIN  TMessageReceived M  ON S.Original_Id = M.ObjectID
		   JOIN  TMessageReceivedDetail D ON D.fk_MessageReceived = m.pk_MessageReceived and D.PropName='taxon'
		   JOIN SampleDynProps DP ON DP.Name  in ('species')
	
		UPDATE S
		SET Original_Id = m.ObjectOriginalID
		FROM Samples S JOIN TMessageReceived M ON S.Original_Id = m.ObjectId



		UPDATE TMessageReceived SET ImportDate=GETDATE()
		WHERE (ObjectType ='Entomo_Pop_Census' or ObjectType ='Station') AND Provenance like  'EcoReleve_%'

		IF @@TRANCOUNT >0  COMMIT TRAN;
		
	END TRY
		BEGIN CATCH
			print 'CATCH'
			print @@TRANCOUNT
			IF @@TRANCOUNT >0  ROLLBACK TRAN;
			print @@TRANCOUNT
			
			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;
			
			SELECT 
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();
			
			RAISERROR (@ErrorMessage, -- Message text.
					   @ErrorSeverity, -- Severity.
					   @ErrorState -- State.
					   );
		END CATCH	
END