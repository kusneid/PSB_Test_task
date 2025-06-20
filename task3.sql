--базовое создание и наполнение таблицы данными для проверки корректности запросов
CREATE TABLE employee (
id INT,
hire_date DATE,
chief_id INT,
salary NUMERIC
);
INSERT INTO employee VALUES
(1, '2020-01-10', NULL, 1000),
(2, '2021-03-15', 1, 800),
(3, '2022-05-20', 1, 900),
(4, '2021-01-01', 2, 700),
(5, '2020-12-01', 2, 750),
(6, '2023-02-10', 3, 650),
(3, '2022-05-20', 1, 900);
--1 запрос
SELECT
COUNT(*) AS longer_than_chief
FROM employee e
JOIN employee c ON e.chief_id = c.id
WHERE e.hire_date < c.hire_date;
--2 запрос
SELECT id
FROM employee
GROUP BY id
HAVING COUNT(*) > 1
LIMIT 1;