--базовое создание и наполнение таблицы данными для проверки
корректности запросов
CREATE TABLE credit (
credit_id INT,
issued_date DATE
);
CREATE TABLE credit_calculations (
credit_id INT,
calculation_date DATE,
status VARCHAR
);
INSERT INTO credit VALUES
(1, '2025-01-10'),
(2, '2025-02-01'),
(3, '2025-03-15'),
(4, '2024-12-20'),
(5, '2025-04-05');
INSERT INTO credit_calculations VALUES
(1, '2025-01-10', 'ACTIVE'),
(1, '2025-02-10', 'EXPIRED'),
(1, '2025-03-10', 'COMPLETED'),
(2, '2025-02-01', 'ACTIVE'),
(2, '2025-02-15', 'COMPLETED'),
(3, '2025-04-01', NULL),
(3, '2025-04-15', NULL),
(4, '2024-12-20', NULL),
(4, '2025-01-01', NULL),
(5, '2025-04-05', 'ACTIVE'),
(5, '2025-05-01', 'EXPIRED'),
(5, '2025-05-10', 'EXPIRED'),
(5, '2025-06-01', 'ACTIVE');
-- 1 запрос
SELECT
c.credit_id,
COALESCE(SUM((cc.status = 'EXPIRED')::INT), 0) AS overdue_days
FROM credit c
LEFT JOIN credit_calculations cc
ON c.credit_id = cc.credit_id
AND cc.status = 'EXPIRED'
WHERE c.issued_date >= date_trunc('year', CURRENT_DATE)
AND c.issued_date < date_trunc('year', CURRENT_DATE) + INTERVAL
'1 year'
GROUP BY c.credit_id;
-- 2 запрос (с оконной функцией)
SELECT DISTINCT
credit_id,
FIRST_VALUE(status) OVER (
PARTITION BY credit_id
ORDER BY calculation_date DESC
) AS current_status
FROM credit_calculations;
-- 2 запрос (без оконной функции)
SELECT
cc.credit_id,
cc.status AS current_status
FROM credit_calculations cc
JOIN (
SELECT
credit_id,
MAX(calculation_date) AS max_date
FROM credit_calculations
GROUP BY credit_id
) t ON cc.credit_id = t.credit_id
AND cc.calculation_date = t.max_date;
-- 3 запрос
SELECT
COUNT(*)
FROM (
SELECT
credit_id
FROM credit_calculations
GROUP BY credit_id
HAVING COUNT(status) = 0
) t;