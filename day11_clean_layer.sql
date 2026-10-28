-- Day 11: the clean layer for online_store_full
-- Run after loading online_store_full.sql (Day 10). Safe to run again.
-- Raw tables are never changed: this adds 2 small helper tables and 8 views.

USE online_store_full;

-- ----------------------------------------------------------------------
-- Build 1: the city lookup table
-- ----------------------------------------------------------------------
DROP TABLE IF EXISTS city_lookup;

CREATE TABLE city_lookup (
    city_key   VARCHAR(50) PRIMARY KEY,   -- the tidied raw spelling: lower case, no spaces
    clean_city VARCHAR(50) NOT NULL       -- the name we want in reports
);

INSERT INTO city_lookup (city_key, clean_city) VALUES
('abu dhabi','Abu Dhabi'), ('ahmedabad','Ahmedabad'), ('bangalore','Bengaluru'), ('bengaluru','Bengaluru'),
('berlin','Berlin'), ('bhopal','Bhopal'), ('bombay','Mumbai'), ('calcutta','Kolkata'),
('chandigarh','Chandigarh'), ('chennai','Chennai'), ('chicago','Chicago'), ('coimbatore','Coimbatore'),
('delhi','Delhi'), ('dubai','Dubai'), ('gurgaon','Gurugram'), ('gurugram','Gurugram'),
('hyderabad','Hyderabad'), ('indore','Indore'), ('jaipur','Jaipur'), ('kochi','Kochi'),
('kolkata','Kolkata'), ('london','London'), ('lucknow','Lucknow'), ('madras','Chennai'),
('manchester','Manchester'), ('melbourne','Melbourne'), ('mumbai','Mumbai'), ('munich','Munich'),
('nagpur','Nagpur'), ('new delhi','Delhi'), ('new york','New York'), ('noida','Noida'),
('pune','Pune'), ('san francisco','San Francisco'), ('singapore','Singapore'), ('surat','Surat'),
('sydney','Sydney'), ('toronto','Toronto'), ('vancouver','Vancouver'), ('visakhapatnam','Visakhapatnam');

-- ----------------------------------------------------------------------
-- Build 2: the exclusion list
-- ----------------------------------------------------------------------
DROP TABLE IF EXISTS excluded_customers;

CREATE TABLE excluded_customers (
    customer_id INT          PRIMARY KEY,
    reason      VARCHAR(100) NOT NULL
);

INSERT INTO excluded_customers (customer_id, reason)
SELECT customer_id, 'Test account'
FROM customers
WHERE email LIKE '%test%';

-- ----------------------------------------------------------------------
-- Build 3: clean_customers
-- ----------------------------------------------------------------------
CREATE OR REPLACE VIEW clean_customers AS
SELECT c.customer_id,
       MIN(c.customer_id) OVER (PARTITION BY LOWER(TRIM(c.email))) AS master_customer_id,
       CONCAT(UPPER(LEFT(TRIM(c.first_name), 1)),
              LOWER(SUBSTRING(TRIM(c.first_name), 2)))              AS first_name,
       TRIM(c.last_name)                                            AS last_name,
       LOWER(TRIM(c.email))                                         AS email,
       CASE
           WHEN c.phone IS NULL THEN NULL
           WHEN LOWER(TRIM(c.country)) IN ('india', 'in')
                THEN CONCAT('+91', RIGHT(REGEXP_REPLACE(c.phone, '[^0-9]', ''), 10))
           ELSE CONCAT('+', REGEXP_REPLACE(c.phone, '[^0-9]', ''))
       END                                                          AS phone,
       l.clean_city                                                 AS city,
       CASE LOWER(TRIM(c.country))
           WHEN 'india' THEN 'India'   WHEN 'in' THEN 'India'
           WHEN 'uk'    THEN 'UK'      WHEN 'united kingdom' THEN 'UK'
           WHEN 'usa'   THEN 'USA'     WHEN 'us' THEN 'USA'   WHEN 'united states' THEN 'USA'
           ELSE TRIM(c.country)
       END                                                          AS country,
       CASE
           WHEN c.signup_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'    THEN STR_TO_DATE(c.signup_date, '%Y-%m-%d')
           WHEN c.signup_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'    THEN STR_TO_DATE(c.signup_date, '%d/%m/%Y')
           WHEN c.signup_date REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$' THEN STR_TO_DATE(c.signup_date, '%d-%b-%Y')
       END                                                          AS signup_date,
       c.acquisition_channel,
       (x.customer_id IS NOT NULL)                                  AS is_test
FROM customers c
LEFT JOIN city_lookup l        ON l.city_key    = LOWER(TRIM(c.city))
LEFT JOIN excluded_customers x ON x.customer_id = c.customer_id;

-- ----------------------------------------------------------------------
-- Build 4: clean_orders
-- ----------------------------------------------------------------------
CREATE OR REPLACE VIEW clean_orders AS
WITH baskets AS (
    SELECT o.order_id, o.customer_id, o.order_date,
           GROUP_CONCAT(oi.product_id, 'x', oi.quantity ORDER BY oi.product_id) AS basket
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY o.order_id, o.customer_id, o.order_date
),
double_submits AS (
    SELECT DISTINCT b.order_id
    FROM baskets a
    JOIN baskets b ON b.customer_id = a.customer_id
                  AND b.order_id    > a.order_id
                  AND b.basket      = a.basket
                  AND TIMESTAMPDIFF(SECOND, a.order_date, b.order_date) BETWEEN 0 AND 300
)
SELECT o.order_id,
       cc.master_customer_id                  AS customer_id,
       o.customer_id                          AS original_customer_id,
       CASE WHEN o.order_date > '2024-12-31 23:59:59'
            THEN o.order_date - INTERVAL 1 YEAR
            ELSE o.order_date END             AS order_date,
       (o.order_date > '2024-12-31 23:59:59') AS date_was_fixed,
       CASE LOWER(TRIM(o.status))
            WHEN 'completed' THEN 'Completed' WHEN 'complete' THEN 'Completed'
            WHEN 'cancelled' THEN 'Cancelled' WHEN 'canceled' THEN 'Cancelled'
            WHEN 'pending'   THEN 'Pending'   WHEN 'shipped'  THEN 'Shipped'
            ELSE 'Unknown' END                AS status,
       o.channel,
       o.coupon_code,
       o.shipping_fee,
       cc.is_test,
       (d.order_id IS NOT NULL)               AS is_duplicate
FROM orders o
JOIN clean_customers cc    ON cc.customer_id = o.customer_id
LEFT JOIN double_submits d ON d.order_id     = o.order_id;

-- ----------------------------------------------------------------------
-- Build 5: clean_order_items, clean_payments and clean_returns
-- ----------------------------------------------------------------------
CREATE OR REPLACE VIEW clean_order_items AS
SELECT order_item_id, order_id, product_id, quantity, unit_price
FROM order_items
WHERE quantity > 0;

CREATE OR REPLACE VIEW clean_payments AS
SELECT payment_id,
       order_id,
       payment_date,
       CASE LOWER(TRIM(payment_method))
            WHEN 'upi'              THEN 'UPI'
            WHEN 'credit card'      THEN 'Card'
            WHEN 'debit card'       THEN 'Card'
            WHEN 'card'             THEN 'Card'
            WHEN 'cod'              THEN 'COD'
            WHEN 'cash on delivery' THEN 'COD'
            WHEN 'netbanking'       THEN 'NetBanking'
            WHEN 'net banking'      THEN 'NetBanking'
            WHEN 'wallet'           THEN 'Wallet'
            WHEN 'paytm wallet'     THEN 'Wallet'
            ELSE 'Unknown' END AS payment_method,
       amount,
       LOWER(TRIM(payment_status)) AS payment_status
FROM payments;

CREATE OR REPLACE VIEW clean_returns AS
SELECT return_id,
       order_item_id,
       return_date,
       reason AS raw_reason,
       CASE
            WHEN reason IS NULL                         THEN 'Not given'
            WHEN reason LIKE '%size%'                   THEN 'Size problem'
            WHEN reason IN ('Damaged', 'Defective', 'Not working')
                                                        THEN 'Damaged or faulty'
            WHEN reason IN ('Not as described', 'Colour different from photo')
                                                        THEN 'Not as described'
            WHEN reason IN ('Changed mind', 'Ordered by mistake')
                                                        THEN 'Changed mind'
            WHEN reason = 'Late delivery'               THEN 'Late delivery'
            ELSE 'Other'
       END AS reason_group,
       refund_amount,
       processed_by
FROM returns;

-- ----------------------------------------------------------------------
-- Build 6: clean_sales, the one view reports should use
-- ----------------------------------------------------------------------
CREATE OR REPLACE VIEW clean_sales AS
SELECT o.order_id,
       o.order_date,
       o.customer_id,
       o.channel,
       o.coupon_code,
       oi.order_item_id,
       oi.product_id,
       p.product_name,
       COALESCE(cat.category_name, 'Uncategorised') AS category_name,
       oi.quantity,
       oi.unit_price,
       oi.quantity * oi.unit_price AS line_total,
       oi.quantity * p.cost_price  AS line_cost
FROM clean_orders o
JOIN clean_order_items oi ON oi.order_id     = o.order_id
JOIN products p           ON p.product_id    = oi.product_id
LEFT JOIN categories cat  ON cat.category_id = p.category_id
WHERE o.status = 'Completed'
  AND o.is_test = 0
  AND o.is_duplicate = 0;

-- ----------------------------------------------------------------------
-- Build 7: clean_reviews
-- ----------------------------------------------------------------------
CREATE OR REPLACE VIEW clean_reviews AS
WITH numbered AS (
    SELECT r.*,
           ROW_NUMBER() OVER (PARTITION BY product_id, customer_id, rating, review_text, review_date
                              ORDER BY review_id) AS copy_number
    FROM reviews r
)
SELECT review_id, product_id, customer_id, rating, review_text, review_date
FROM numbered
WHERE copy_number = 1;

-- ----------------------------------------------------------------------
-- Build 8: clean_web_events
-- ----------------------------------------------------------------------
CREATE OR REPLACE VIEW clean_web_events AS
SELECT w.event_id,
       w.session_id,
       w.customer_id,
       (c.customer_id IS NOT NULL) AS customer_exists,
       w.event_time,
       w.event_type,
       w.product_id,
       w.order_id,
       LOWER(TRIM(w.device)) AS device,
       CASE
           WHEN w.traffic_source IS NULL                THEN 'unknown'
           WHEN LOWER(TRIM(w.traffic_source)) = '(none)' THEN 'direct'
           ELSE LOWER(TRIM(w.traffic_source))
       END AS traffic_source
FROM web_events w
LEFT JOIN customers c ON c.customer_id = w.customer_id;
