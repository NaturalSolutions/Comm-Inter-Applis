
-- TODO: Rajouter les foreign Key + primary Key
DROP TABLE TableACopier
DROP TABLE SourceTarget
DROP TABLE SourceTarget_Table

CREATE TABLE TableACopier(
[ID] [int] IDENTITY(1,1) 
,[Name] [varchar](250) NOT NULL
,[IdNamere] [varchar](250) NOT NULL
,[TypeObject] [varchar](50) NOT NULL
,idObject [varchar](250) NOT NULL
,[OrdreExecution] INT NOT NULL
,AllowDelete BIT NOT NULL

PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
)



CREATE TABLE SourceTarget(
[ID] [int] IDENTITY(1,1) 
,[SourceDatabase] [varchar](250) NOT NULL
,[TargetDatabase] [varchar](250) NOT NULL
,[Instance] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
))





CREATE TABLE SourceTarget_Table(
ID [int] IDENTITY(1,1),
fk_SourceTarget INT NULL
,fk_TableACopier INT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
)

