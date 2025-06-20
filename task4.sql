--базовое создание и наполнение таблицы данными для проверки корректности запросов
CREATE TABLE transactions (
id INT,
transaction_date DATE,
client_id INT,
currency VARCHAR,
amount NUMERIC
);
INSERT INTO transactions VALUES
(1, '2022-05-23', 33, 'EURO', 259),
(2, '2022-05-24', 34, 'USD', 300),
(3, '2022-05-24', 34, 'RUB', 5000),
(4, '2022-05-22', 33, 'USD', 150),
(5, '2022-05-21', 35, 'EURO', 100);
CREATE TABLE currency (
id INT,
currency_date DATE,
currency VARCHAR,
value NUMERIC
);
INSERT INTO currency VALUES
(1, '2022-05-20', 'EURO', 69.0),
(2, '2022-05-20', 'USD', 60.0),
(3, '2022-05-23', 'EURO', 69.0),
(4, '2022-05-23', 'USD', 60.0),
(5, '2022-05-24', 'EURO', 70.0),
(6, '2022-05-24', 'USD', 59.5);
--1 запрос
SELECT
t.client_id,
SUM(
CASE
WHEN t.currency = 'RUB' THEN t.amount
ELSE t.amount * c.value
END
) AS total_rub
FROM transactions t
LEFT JOIN currency c
ON t.currency = c.currency
AND t.transaction_date = c.currency_date
GROUP BY t.client_id;
--2 запрос
SELECT
t.client_id,
SUM(
CASE
WHEN t.currency = 'RUB' THEN t.amount
ELSE t.amount * (
SELECT c.value
FROM currency c
WHERE c.currency = t.currency
AND c.currency_date <= t.transaction_date
ORDER BY c.currency_date DESC
LIMIT 1
)
END
) AS total_rub
FROM transactions t
GROUP BY t.client_id;