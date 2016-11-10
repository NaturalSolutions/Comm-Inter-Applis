

DELETE FROM [SourceTarget_Table]
DELETE FROM [TableACopier]
DELETE FROM [SourceTarget]

INSERT INTO [dbo].[SourceTarget]
           ([SourceDatabase]
           ,[TargetDatabase]
		   ,[Instance])
		   SELECT 'NARC_TRACK_MACQ_New.dbo.','NARC_TRACK_MACQ.dbo.',i.TIns_PK_ID
		   from securite.dbo.TInstance I where i.TIns_Database = 'NARC_TRACK_MACQ' and TIns_ReadOnly=0




INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TProtocole'
           ,'TPro_pk_id'
		   ,'ProtocoleTrack'
		   ,'TPro_pk_id'
           ,5)


INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TObservation'
           ,'TObs_pk_id'
		   ,'ProtocoleTrack'
		   ,'TObs_FK_TProID'
           ,10)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TType'
           ,'TTyp_pk_id'
		   ,'TypeTrack'
		   ,'TTyp_pk_id'
           ,1)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TTTypeBase'
           ,'TTBse_pk_id'
		   ,'TTypeBaseTrack'
		   ,'TTBse_pk_id'
           ,0)
		
INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('Tunite'
           ,'TUni_pk_id'
		   ,'UniteTrack'
		   ,'TUni_pk_id'
           ,0)


INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TTProtocole'
           ,'TTpro_PK_ID'
		   ,'TypeProtocoleTrack'
		   ,'TTpro_PK_ID'
           ,0)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TTFrequence'
           ,'TTFre_PK_ID'
		   ,'FrequenceTrack'
		   ,'TTFre_PK_ID'
           ,0)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TChampLie'
           ,'TCLie_PK_ID'
		   ,'ChampLieTrack'
		   ,'TCLie_PK_ID'
           ,0)
		   


INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TActivite'
           ,'TAct_PK_ID'
		   ,'ActiviteTrack'
		   ,'TAct_PK_ID'
           ,0)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject],idObject
           ,[OrdreExecution])
     VALUES
           ('TAsyncProcessList'
           ,'TAPL_PK_ID'
		   ,'RegleImportTrack'
		   ,'TAPL_PK_ID'
           ,0)


 INSERT INTO [dbo].[SourceTarget_Table]
           ([fk_SourceTarget]
           ,[fk_TableACopier])
		   SELECT s.ID,t.ID FROM TableACopier T JOIN SourceTarget S ON s.SourceDatabase='NARC_TRACK_MACQ_New.dbo.'
		   WHErE t.name in ('TProtocole','TObservation','TType','TTTypeBase','TTProtocole','TTFrequence','TChampLie','TActivite','TAsyncProcessList','Tunite')

		   
 		   
