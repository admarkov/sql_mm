--ПРОСТЫЕ ЗАПРОСЫ
--1. Вывести всех продавцов
--2. Вывести всех продавцов, отсортировав их по имени в лексикографическом порядке
--3. Найти всю информацию о продавце по имени Ann
--4. Найти фамилию продавца по имени Ann
--5. Определить самый большой номер [EmployeeID] продавца (упорядочить по полю
--[EmployeeID] по убыванию и взять TOP 1)
--6. Найти продукты, которые стоят меньше 10$
--7. Найти один самый дорогой продукт
--8. Найти все самые дорогие продукты (с самой большой ценой)
--9. Найти продукты, название которых начинается на Metal Plate
--10. Найти продукты, в названии которых встречается слово silver
--11. Найдите покупателей, которых зовут Alicia
--12. У кого их них определена буква отчества?
--13. А у кого не определена буква отчества?
--14. Вывести все различные имена покупателей
--15. Найти однофамильцев среди продавцов
--16. Найти продажи продавца по имени Ann
--17. Вывести названия товаров, которые продает Ann
--АНАЛИТИЧЕСКИЕ ЗАПРОСЫ
--1. Вывести количество продавцов
select count(*) from Employees
--2. Сколько продуктов стоят меньше 10$
select count(*) from Products where Price < 10
--3. Найти цену самого дорогого продукта
select top 1 Price from Products ORDER BY Price DESC
--4. Найти все самые дорогие продукты (с самой большой ценой)
select top 1 with ties * from Products ORDER BY Price DESC
--5. Найти количество продуктов, название которых начинается на Metal Plate
select * from Products where Name like 'Metal Plate%'
--6. Найти среднюю цену продукта, в названии которых встречается слово silver
select AVG(Price) from Products where Name like '%silver%'
--7. Сколько покупателей, которых зовут Alicia?
select * from Customers where FirstName = 'Alicia'
--8. Сколько есть уникальных имен покупателей?
select count(distinct FirstName) from Customers
--9. У какого количества покупателей определена буква отчества?
select count(*) from Customers where MiddleInitial is not null
--10. Какая буква отчества самая популярная?
select top 1 MiddleInitial from (select MiddleInitial, count(*) as cnt from Customers where MiddleInitial is not null Group by MiddleInitial) as cntable order by cnt desc
--11. У какого количества покупателей не определена буква отчества?
select count (*) from Customers where MiddleInitial is null
--12. У какого количества покупателей совпали имена? Вывести статистику для каждого имени.
select FirstName, count (*) as cnt from Customers group by FirstName
--13. У какого количества покупателей совпали имена и отчества? Вывести статистику для
--каждого имени и отчества.
select FirstName + ' ' + MiddleInitial, count (*) as cnt from Customers group by FirstName + ' ' + MiddleInitial
--14. Сколько однофамильцев среди продавцов
select LastName, count (*) as cnt from Employees group by LastName
--15. Найти количество продаж продавца по имени Ann
select count(*) from sales join Employees on sales.SalesPersonID = Employees.EmployeeID where Employees.FirstName = 'Ann'
--16. Вывести количество различных товаров, которые продает Ann
select count(distinct sales.ProductID) from sales join Employees on sales.SalesPersonID = Employees.EmployeeID where Employees.FirstName = 'Ann'
--17. Сколько продаж есть у каждого продавца?
select Employees.FirstName + ' ' + Employees.MiddleInitial + ' ' + Employees.LastName,  count(*) from sales join Employees on sales.SalesPersonID = Employees.EmployeeID group by Employees.FirstName + ' ' + Employees.MiddleInitial + ' ' + Employees.LastName
--18. Сколько покупок у каждого покупателя?
select Customers.CustomerID, count(*) from sales join Customers on sales.CustomerID = Customers.CustomerID group by Customers.CustomerID
--19. Скольким покупателям продавал товары каждый продавец?

--20. Какова средняя цена каждой продажи во всем продажам?
--21. Какова сумма продаж у каждого продавца?
--22. Для каждого товара найти мат.ожидание количества в каждой продаже и среднее
--квадратичное отклонение.
--23. Вывести информацию о продажах, в котором будут фамилии и имена продавцов,
--покупателей, название товаров, количество товаров, цена за единицу и общая сумма
--продажи.
