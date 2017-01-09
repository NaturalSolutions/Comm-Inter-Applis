
DECLARE @ID INT

select @ID=ID FROM _Centralisation_SourceTarget where SourceDatabase='Referentiel_EcoReleve.dbo.'

exec _Centralisation_UpdateDBFromReferentiel @ID
