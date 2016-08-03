

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
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TProtocole'
           ,'TPro_pk_id'
		   ,'ProtocoleTrack'
           ,5)


INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TObservation'
           ,'TObs_pk_id'
		   ,'ObservationTrack'
           ,10)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TType'
           ,'TTyp_pk_id'
		   ,'TypeTrack'
           ,1)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TTTypeBase'
           ,'TTBse_pk_id'
		   ,'TTypeBaseTrack'
           ,0)
		
INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('Tunite'
           ,'TUni_pk_id'
		   ,'UniteTrack'
           ,0)


INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TTProtocole'
           ,'TTpro_PK_ID'
		   ,'TypeProtocoleTrack'
           ,0)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TTFrequence'
           ,'TTFre_PK_ID'
		   ,'FrequenceTrack'
           ,0)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TChampLie'
           ,'TCLie_PK_ID'
		   ,'ChampLieTrack'
           ,0)
		   


INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TActivite'
           ,'TAct_PK_ID'
		   ,'ActiviteTrack'
           ,0)

INSERT INTO [dbo].[TableACopier]
           ([Name]
           ,[IdNamere]
		   ,[TypeObject]
           ,[OrdreExecution])
     VALUES
           ('TAsyncProcessList'
           ,'TAPL_PK_ID'
		   ,'RegleImportTrack'
           ,0)


 INSERT INTO [dbo].[SourceTarget_Table]
           ([fk_SourceTarget]
           ,[fk_TableACopier])
		   SELECT s.ID,t.ID FROM TableACopier T JOIN SourceTarget S ON s.SourceDatabase='NARC_TRACK_MACQ_New.dbo.'
		   WHErE t.name in ('TProtocole','TObservation','TType','TTTypeBase','TTProtocole','TTFrequence','TChampLie','TActivite','TAsyncProcessList','Tunite')

		   
 		   
