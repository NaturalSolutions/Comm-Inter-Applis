DELETE FROM [_Centralisation_SourceTargetTable]
DELETE FROM [_Centralisation_TablesToUpdate]
DELETE FROM [_Centralisation_SourceTarget]

INSERT INTO [dbo].[_Centralisation_SourceTarget]
           ([SourceDatabase]
           ,[TargetDatabase]
	   ,[Instance]
	   ,[DisableConstraint])
		   SELECT 'Referentiel_Track.dbo.','ECWP_TRACK_UNDU.dbo.',i.TIns_PK_ID, True
		   from securite.dbo.TInstance I where i.TIns_Database = 'ECWP_TRACK_UNDU' and TIns_ReadOnly=0




INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		   ,AllowDelete)
     VALUES
           ('TProtocole'
           ,'TPro_pk_id'
		   ,'ProtocoleTrack'
		   ,'TPro_pk_id'
           ,5
		   ,0)


INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('TObservation'
           ,'TObs_pk_id'
		   ,'ProtocoleTrack'
		   ,'TObs_FK_TProID'
           ,10
		   ,0)

INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('TType'
           ,'TTyp_pk_id'
		   ,'TypeTrack'
		   ,'TTyp_pk_id'
           ,1
		   ,0)

INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('TTTypeBase'
           ,'TTBse_pk_id'
		   ,'TTypeBaseTrack'
		   ,'TTBse_pk_id'
           ,0
		   ,0)
		
INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('Tunite'
           ,'TUni_pk_id'
		   ,'UniteTrack'
		   ,'TUni_pk_id'
           ,0
		   ,0)


INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('TTProtocole'
           ,'TTpro_PK_ID'
		   ,'TypeProtocoleTrack'
		   ,'TTpro_PK_ID'
           ,0
		   ,0)

INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('TTFrequence'
           ,'TTFre_PK_ID'
		   ,'FrequenceTrack'
		   ,'TTFre_PK_ID'
           ,0
		   ,0)

INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('TChampLie'
           ,'TCLie_PK_ID'
		   ,'ChampLieTrack'
		   ,'TCLie_PK_ID'
           ,0
		   ,0)
		   


INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete)
     VALUES
           ('TActivite'
           ,'TAct_PK_ID'
		   ,'ActiviteTrack'
		   ,'TAct_PK_ID'
           ,0
		   ,0)

INSERT INTO [dbo].[_Centralisation_TablesToUpdate]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution]
		    ,AllowDelete
		   )
     VALUES
           ('TAsyncProcessList'
           ,'TAPL_PK_ID'
		   ,'RegleImportTrack'
		   ,'TAPL_PK_ID'
           ,0
		   ,0)


 INSERT INTO [dbo].[_Centralisation_SourceTargetTable]
           ([fk_SourceTarget]
           ,[fk_TablesToUpdate])
		   SELECT s.ID,t.ID FROM _Centralisation_TablesToUpdate T JOIN _Centralisation_SourceTarget S ON s.SourceDatabase='ECWP_TRACK_UNDU.dbo.'
		   WHERE t.name in ('TProtocole','TObservation','TType','TTTypeBase','TTProtocole','TTFrequence','TChampLie','TActivite','TAsyncProcessList','Tunite')

		   
 		   
