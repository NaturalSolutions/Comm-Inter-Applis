CREATE TABLE TMessageTransfertLog
(fk_MessageSend		BIGINT NOT NULL
,fk_ConfDest		BIGINT NOT NULL
,Statut				INT NOT NULL
,SendMessage		VARCHAR(MAX) NULL
,CONSTRAINT pk_MessageTransfertLog PRIMARY KEY CLUSTERED (fk_MessageSend,fk_ConfDest)
,CONSTRAINT fk_MessageTransfertLog_MessageSend FOREIGN KEY (fk_MessageSend) REFERENCES TMessageSend(pk_MessageSend)
,CONSTRAINT fk_MessageTransfertLog_ConfDest FOREIGN KEY (fk_ConfDest) REFERENCES TMessageToSendConf(pk_MessageToSendConf)
)