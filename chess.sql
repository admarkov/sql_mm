--1. Сколько фигур стоит на доске? Вывести количество.
SELECT COUNT(*) FROM CHESSBOARD
--2. Вывести id фигур, чьи названия начинаются на букву k.
SELECT cid FROM chessman WHERE ftype LIKE 'k%'
--3. Какие типы фигур бывают и по сколько штук? Вывести тип и количество.
SELECT ftype, COUNT(ftype) FROM chessman GROUP BY ftype
--4. Вывести id белых пешек , стоящих на доске?
SELECT cid FROM chessman WHERE ftype = 'pawn' and fcolor = 'white'
--5. Какие фигуры стоят на главной диагонали? Вывести их тип и цвет.
SELECT ftype, fcolor from chessman, chessboard where chessboard.cid = chessman.cid and (ASCII(X) - 65) = (ASCII(Y) - 49)
--6. Найдите общее количество фигур, оставшихся у каждого игрока. Вывести цвет и
--количество.
SELECT fcolor, COUNT(*) as amount from chessboard, chessman where chessman.cid = chessboard.cid GROUP BY chessman.fcolor
SELECT fcolor, COUNT(*) as amount from chessboard join chessman on chessman.cid = chessboard.cid GROUP BY chessman.fcolor
--7. Какие фигуры черных имеются на доске? Вывести тип.
SELECT DISTINCT ftype from chessboard join chessman on chessman.cid = chessboard.cid where chessman.fcolor = 'black'
--8. Какие фигуры черных имеются на доске? Вывести тип и количество.
SELECT ftype, COUNT(*) from chessboard join chessman on chessman.cid = chessboard.cid where chessman.fcolor = 'black' GROUP BY ftype
--9. Найдите типы фигур (любого цвета), которых осталось, по крайней мере, не
--меньше двух на доске.
SELECT ftype from (select ftype, count(*) as amount from chessboard join chessman on chessman.cid = chessboard.cid group by ftype) as cntable where amount > 1
--10. Вывести цвет фигур, которых на доске больше.
SELECT fcolor from (select fcolor, COUNT(*) as amount from chessboard join chessman on chessman.cid = chessboard.cid group by fcolor) as cntable where amount = (select MAX(amount) from (select fcolor, COUNT(*) as amount from chessboard join chessman on chessman.cid = chessboard.cid group by fcolor) as cntable)
SELECT fcolor from (select fcolor, COUNT(*) as amount from chessboard join chessman on chessman.cid = chessboard.cid group by fcolor) as cntable ORDER BY amount DESC LIMIT 1
--11. Найдите фигуры, которые стоят на возможном пути движения ладьи (rock) (Любой
--ладьи любого цвета). (Ладья может двигаться по горизонтали или по вертикали
--относительно своего положения на доске в любом направлении.).

--12. У каких игроков (цвета) еще остались ВСЕ пешки (pawn)?
SELECT fcolor, amount, ftype from (select ftype, fcolor, COUNT(*) as amount from chessboard join chessman on chessman.cid = chessboard.cid where ftype='pawn' group by ftype, fcolor) as cntable where amount = 8
--13. Пусть отношения board1 и board2 представляют собой два последовательных
--состояние игры (Chessboard). Какие фигуры (cid) изменили свою позицию (за один
--ход это может быть передвигаемая фигура и возможно еще фигура, которая была
--“съедена”)?
--В отношение Chessboard2 надо скопировать все строки отношения Chessboard. Из
--Chessboard2 надо одну фигуру удалить, а другую фигуру поставить на место
--удаленной («съесть фигуру»).
SELECT * INTO chessboard2 from chessboard
--Задание надо выполнить двумя способами:
--a) через JOIN
SELECT chessboard.cid, chessboard.x, chessboard.y from chessboard full join chessboard2 on chessboard.cid = chessboard2.cid where chessboard.x!=chessboard2.x or chessboard.y!=chesboard2.y or chessboard2.cid is null
--b) через UNION/INTERSECT/EXCEPT
SELECT * FROM CHESSBOARD EXCEPT SELECT * FROM CHESSBOARD INTERSECT SELECT * FROM CHESSBOARD2
--14. Вывести id фигуры, если она стоит в «опасной близости» от черного короля?
--«опасной близостью» будем считать квадрат 5х5 с королем в центре.
select c2.cid from (select ftype, fcolor, x, y from chessboard join chessman ON chessman.cid = chessboard.cid) as c1, (select chessman.cid, x, y from chessboard join chessman ON chessman.cid = chessboard.cid) as c2 where c1.ftype = 'king' and c1.fcolor = 'black' and abs(ASCII(c1.x)-ASCII(c2.x)) <6 and abs(ASCII(c1.y)-ASCII(c2.y)) < 6
--15. Найти фигуру, ближе всех стоящую к белому королю (расстояние считаем по
--метрике L1 – разница координат по X + разница координат по Y.

--16. Найти фигуры, которые может съесть ладья (Cid ладьи задан). Помните, что
--«своих» есть нельзя!

--17. Сделайте сводную таблицу, показывающую, сколько фигур каждого типа есть у
--каждого игрока (при помощи функции PIVOT). Столбцы должны соответствовать
--цветам, а строки – типам фигур.
