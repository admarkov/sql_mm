ALTER TRIGGER delDep on Dependencies Instead of delete as
	BEGIN
		declare @exid int, @semCNT int, @required int, @depends_of int
		SELECT @exid = exid from deleted
		SELECT @depends_of = depends_of from deleted
		SELECT @required = required_amount from Exams where id = @exid
		SELECT @semCNT = COUNT(*) from Dependencies where exid = @exid
		if (@semCNT <= @required)
			BEGIN
				print('Нельзя удалить')
				rollback
				return
			END
		else
			delete from Dependencies where exid = @exid and depends_of = @depends_of
	END