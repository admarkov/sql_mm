ALTER PROCEDURE changeGroup(@stid int, @from int, @to int)
	AS BEGIN
		declare @total int, @new int
		select @total = COUNT(*) from Exams where groupid = @to and isrequired = 1
		SELECT @new = COUNT(*) from Exams where groupid = @to and isrequired = 1 and subject + ' ' + type not in (SELECT subject + ' ' + type from Exams where groupid = @from)
		declare @ratio real
		if (@total > 0)
			SET @ratio = CAST(@new as real) / @total
		else
			SET @ratio = 0
		if (@ratio > 0.1)
			print('Слишком большая разница в программе (' + cast(@ratio * 100 as varchar) + '%)')
		else
			BEGIN
				UPDATE Students SET groupid = @to where id = @stid
				SELECT * from Exams where groupid = @to and isrequired = 1 and subject + ' ' + type not in (SELECT subject + ' ' + type from Exams where groupid = @from)
			END
	END