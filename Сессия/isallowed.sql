--ALTER FUNCTION ispassed(@stid int, @exid int)
--	RETURNS int AS
--		BEGIN
--			declare @res int, @cnt int 			
--			SELECT @cnt = cnt from (SELECT COUNT(*) as cnt from Results where stid = @stid and exid = @exid and result = 'passed') as tt
--			if (@cnt > 0)
--				SET @res = 1
--			else
--				SET @res = 0
--			return @res
--		END;

ALTER FUNCTION isallowed(@stid int, @exid int)
	RETURNS int AS
		BEGIN
			DECLARE cur cursor for select depends_of as dexid, isrequired from Dependencies where exid = @exid
			declare @res int, @required_amount int, @passed int
			SET @res = 1
			SET @passed = 0
			SELECT @required_amount = required_amount from Exams where id = @exid
			declare @dexid int, @isrequired tinyint
			open cur
			fetch cur into @dexid, @isrequired
			while (@@FETCH_STATUS = 0) BEGIN
				if (dbo.ispassed(@stid, @dexid) = 1)
					SET @passed = @passed + 1
				else
					if (@isrequired = 1)
						SET @res = 0
				fetch cur into @dexid, @isrequired
			END

			close cur
			deallocate cur
			
			if (@passed < @required_amount)
				SET @res = 0

			return @res
		END