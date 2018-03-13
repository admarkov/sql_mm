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
--11. Найдите фигуры, которые стоят на возможном пути движения ладьи (rock) (Любой
--ладьи любого цвета). (Ладья может двигаться по горизонтали или по вертикали
--относительно своего положения на доске в любом направлении.).
--12. У каких игроков (цвета) еще остались ВСЕ пешки (pawn)?
