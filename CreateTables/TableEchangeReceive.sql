
/* Partie Recepetion */

CREATE TABLE TMessageReceived
(
pk_MessageReceived		BIGINT			NOT NULL,
Provenance				VARCHAR(50)		NOT NULL,
ObjectType				VARCHAR(200)	NOT NULL,
ObjectId				BIGINT			NOT NULL,
ObjectOriginalID		VARCHAR(200)			NULL,
Operation				VARCHAR(30)		NOT NULL,
CreationDate			DateTime		NOT NULL,
ImportDate				DateTime		NULL,
Comment					VARCHAR(5000)	NULL,
isMessageComplete		TINYINT NULL,
CONSTRAINT pk_TMessageReceived PRIMARY KEY CLUSTERED(pk_MessageReceived,Provenance) 
)

--ALTER TABLE TMessageReceived ADD  isMessageComplete		TINYINT NULL
-- ALTER TABLE [dbo].TMessageReceived ALTER COLUMN ObjectOriginalID	VARCHAR(200)

Create Table TMessageReceivedDetail(
pk_MessageReceivedDetail		BIGINT NOT NULL,
fk_MessageReceived				BIGINT NOT NULL,
Provenance						VARCHAR(50)		NOT NULL,
PropName						VARCHAR(500) NOT NULL,
PropValue						VARCHAR(2000)  NULL,
Parametre						VARCHAR(2000)  NULL,
CONSTRAINT pk_MessageReceivedDetail PRIMARY KEY CLUSTERED (pk_MessageReceivedDetail,Provenance),
CONSTRAINT TMessageReceivedDetail_fk_MessageReceived_Provenance FOREIGN KEY (fk_MessageReceived,Provenance) REFERENCES TMessageReceived(pk_MessageReceived,Provenance)
)

CREATE UNIQUE INDEX UQ_TMessageReceivedDetail_fk_MessageReceived_Provenance_PropName ON TMessageReceivedDetail(fk_MessageReceived,Provenance,PropName)

