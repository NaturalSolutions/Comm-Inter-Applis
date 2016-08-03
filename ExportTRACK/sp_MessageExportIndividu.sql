
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***** sp to alter in all track DB instance **/


CREATE PROCEDURE [dbo].[pr_MessageExportIndividu](
@IndividuList ListOfIDs READONLY,
@operation	VARCHAR(200) ='Creation'
)
AS
BEGIN
	DECLARE @MessageIDs TABLE(
		ID BIGINT
	)


	BEGIN TRY
	BEGIN TRAN
	
		INSERT INTO [dbo].[TMessageSend]
				   ([ObjectType]
				   ,[ObjectId]
				   ,[ObjectOriginalID]
				   ,[Operation]
				   ,[CreationDate]
				   ,[SendDate]
				   ,[Comment])           
		OUTPUT INSERTED.pk_MessageSend INTO @MessageIDs			   
		select 'individu',TInd_PK_ID,TInd_PK_ID,@operation,GETDATE(),NULL,NULL
		from TIndividus
		where TInd_PK_ID IN		(SELECT ID FROM @IndividuList)

		INSERT INTO [dbo].[TMessageSendDetail]
				   ([fk_MessageSend]
				   ,[PropName]
				   ,[PropValue]
				   ,[Parametre])
		select m.pk_MessageSend,C.PropName,PropValue,NULL
		from TIndividus I JOIN [TMessageSend]  M on m.[ObjectId] = I.TInd_PK_ID
		CROSS APPLY
		(
			values	
			('TInd_DateNaissance',CONVERT(varchar,TInd_DateNaissance,120))
			,('TInd_BagueID',TInd_BagueID)
			,('TInd_OeufID',TInd_OeufID)
			,('TInd_DateSortie',CONVERT(varchar,TInd_DateSortie,120))
			,('TInd_StatusElevage',TInd_StatusElevage)
			,('TInd_Espece',TInd_Espece)
			,('TInd_Puce',TInd_Puce)
			,('TInd_BagueIDRelacher',TInd_BagueIDRelacher)
			,('TInd_Sexe',CASE WHEN TInd_Sexe = '1' THEN 'Male' WHEN TInd_Sexe = '2' THEN 'Female' ELSE 'UnKnown' END )
			,('TInd_Poids', convert(varchar,TInd_Poids))
		) C (PropName,PropValue)
		WHERE M.pk_MessageSend IN (SELECT ID FROM @MessageIDs)



		IF @operation='Relach�'
		BEGIN
			INSERT INTO [dbo].[TMessageSendDetail]
				   ([fk_MessageSend]
				   ,[PropName]
				   ,[PropValue]
				   ,[Parametre])

			select M.pk_MessageSend,o.TObs_Titre,
			Case WHEN TObs_Titre='Bague d''�levage conserv�e apr�s sortie' and Ch.TDCh_Valeur='Oui' THEN '1' 
			WHEN TObs_Titre='Bague d''�levage conserv�e apr�s sortie' and Ch.TDCh_Valeur='Non' THEN '0'
			WHEN TObs_Titre='Bague d''�levage conserv�e apr�s sortie' and Ch.TDCh_Valeur not in ('Non','Oui') THEN NULL
			ELSE  Ch.TDCh_Valeur  END,NULL
			--DISTINCT m.ObjectId,o.TObs_Titre,C.TDCh_Valeur,NULL,o.TObs_Titre
			from [TMessageSend]  M 
			JOIN Tsaisie S ON S.TSai_FK_TInd_ID = M.[ObjectId]
			JOIN TProtocole P on p.TPro_Titre  in ('Pose de bague de rel�cher','sortie') and S.TSai_FK_TPro_ID = P.TPro_PK_ID
			JOIN TObservation o ON o.TObs_FK_TProID = p.TPro_PK_ID 
					and o.TObs_Titre in ('Bague d''�levage conserv�e apr�s sortie','code de marque 1','position de marque 1','couleur de marque 1','code de marque 2','position de marque 2','couleur de marque 2','Boite de transport')
			LEFT JOIN TDChar Ch on Ch.TDCh_FK_TObs_ID = o.TObs_PK_ID and Ch.TDCh_FK_TSai_ID = S.TSai_PK_ID
			WHERE M.pk_MessageSend  in (SELECT ID FROM @MessageIDs)
			  --FROM TDChar ch
			  --JOIN [TSaisie] s 
					--ON ch.TDCh_FK_TSai_ID = s.TSai_PK_ID
			  --JOIN [TMessageSend]  M   
					--ON S.TSai_FK_TInd_ID = M.[ObjectId]
			  --JOIN TProtocole p 
					--on p.TPro_PK_ID = s.TSai_FK_TPro_ID 
					--	and p.TPro_Titre_LabelFr in ('Pose de bague de rel�cher','sortie')
			  --JOIN TObservation o 
					--ON ch.TDCh_FK_TObs_ID = o.TObs_PK_ID 
					--	and o.TObs_FK_TProID = p.TPro_PK_ID 
					--	and o.TObs_Titre in ('Bague d''�levage conserv�e apr�s sortie','code de marque 1','position de marque 1','couleur de marque 1','code de marque 2','position de marque 2','couleur de marque 2')
			--WHERE M.pk_MessageSend  in (SELECT ID FROM @MessageIDs)
		END


		print 'COMMIT TRAN'
				IF @@TRANCOUNT > 0 COMMIT TRAN
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






GO


