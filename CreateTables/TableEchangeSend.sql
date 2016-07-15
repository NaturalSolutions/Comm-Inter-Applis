
/* Partie emission */

CREATE TABLE TMessageSend
(
pk_MessageSend		BIGINT identity(1,1) NOT NULL,
ObjectType			VARCHAR(200)	NOT NULL,
ObjectId			BIGINT			NOT NULL,
ObjectOriginalID	VARCHAR(200)			NULL,
Operation			VARCHAR(30)		NOT NULL,
CreationDate		DateTime		NOT NULL,
SendDate			DateTime		NULL,
Comment				VARCHAR(5000)	NULL
CONSTRAINT pk_ExchangeSend PRIMARY KEY CLUSTERED(pk_MessageSend) 
)

--ALTER TABLE [dbo].[TMessageSend] ALTER COLUMN ObjectOriginalID	VARCHAR(200)

CREATE TABLE TMessageSendDestination
(
fk_MessageSend		BIGINT NOT NULL,
Dest				VARCHAR(10) NOT NULL,
TreatmentDate		DATETIME NOT NULL,
CONSTRAINT pk_TMessageSendDestination PRIMARY KEY CLUSTERED (fk_MessageSend,Dest),
CONSTRAINT TMessageSendDestination_fk_MessageSend FOREIGN KEY(fk_MessageSend) REFERENCES TMessageSend(pk_MessageSend)
)



Create Table TMessageSendDetail(
pk_MessageSendDetail		BIGINT identity(1,1) NOT NULL,
fk_MessageSend				BIGINT NOT NULL,
PropName					VARCHAR(500) NOT NULL,
PropValue					VARCHAR(2000)  NULL,
Parametre					VARCHAR(2000)  NULL,
CONSTRAINT pk_MessageSendDetail PRIMARY KEY CLUSTERED (pk_MessageSendDetail),
CONSTRAINT TMessageSendDetail_TMessageSendDetail FOREIGN KEY (fk_MessageSend) REFERENCES TMessageSend(pk_MessageSend)
)
CREATE UNIQUE INDEX UQ_TMessageSendDetail_fk_MessageSend_PropName ON TMessageSendDetail(fk_MessageSend,PropName)

