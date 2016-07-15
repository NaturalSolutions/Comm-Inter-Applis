CREATE TABLE TMessageToSendConf
(
pk_MessageToSendConf	BIGINT IDENTITY(1,1) NOT NULL
,DestDatabase			VARCHAR(250)	NULL
,ObjectType				VARCHAR(200) NULL
,Operation				VARCHAR(30)		NOT NULL
,CONSTRAINT pk_MessageToSendConf PRIMARY KEY CLUSTERED (pk_MessageToSendConf)
)