
-- TODO: Rajouter les foreign Key + primary Key


CREATE TABLE TableACopier(
[ID] [int] IDENTITY(1,1) 
,[Name] [varchar](250) NOT NULL
,[IdNamere] [varchar](250) NOT NULL
,[TypeObject] [varchar](50) NOT NULL
,idObject [varchar](250) NOT NULL
,[OrdreExecution] INT NOT NULL
)




CREATE TABLE SourceTarget(
[ID] [int] IDENTITY(1,1) 
,[SourceDatabase] [varchar](250) NOT NULL
,[TargetDatabase] [varchar](250) NOT NULL
,[Instance] [int] NOT NULL,
)






CREATE TABLE SourceTarget_Table(
fk_SourceTarget INT NULL
,fk_TableACopier INT NULL
)



