--базовое создание и наполнение таблицы данными для проверки
корректности запросов
CREATE TABLE "Table" (
client_id INT,
amount NUMERIC,
date DATE
);
INSERT INTO "Table" VALUES
(1, 100, '2022-12-15'),
(1, 100, '2023-01-05'),
(1, 150, '2023-01-10'),
(1, 200, '2023-01-20'),
(1, 300, '2023-02-01'),
(2, 120, '2023-01-12'),
(2, 80, '2023-03-03'),
(3, 60, '2022-11-11'),
(3, 90, '2022-12-01'),
(4, 300, '2023-01-02'),
(4, 200, '2023-01-15'),
(4, 100, '2023-01-25'),
(4, 50, '2023-01-28'),
(5, 500, '2023-02-10'),
(5, 250, '2023-02-14'),
(5, 150, '2023-02-20'),
(5, 100, '2023-02-28'),
(6, 75, '2023-01-15'),
(6, 125, '2023-01-16'),
(6, 175, '2023-01-17');
--1 запрос
SELECT COUNT(DISTINCT client_id) AS client_count FROM "Table";
--2 запрос
SELECT
client_id,
SUM(amount) AS total_amount,
AVG(amount) AS avg_amount,
MAX(amount) AS max_amount
FROM "Table"
WHERE date >= '2023-01-01' AND date < '2023-02-01'
GROUP BY client_id;
--3 запрос
SELECT
client_id,
COUNT(*) AS purchases_count
FROM "Table"
GROUP BY client_id
HAVING COUNT(*) > 2
ORDER BY purchases_count DESC;