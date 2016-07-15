pr_MessageExportProtoEntomo


--select * from TMessageSend S JOIN TMessageSendDetail D on S.pk_MessageSend = D.fk_MessageSend
--where S.ObjectType='Entomo_Pop_Census' 
--order by S.pk_MessageSend,PropName


MessageSendDataToDest


exec [ECollectionEntomo].dbo.MessageEcolImportFromERD


select * from observation where id=1086006





