-- =============================================================
-- online_store — Complete Setup (Schema + Sample Data)
-- Databases & SQL for Analysts
-- Compatible with MySQL 8.0.16+
-- Run this file to create and populate the full database.
-- =============================================================

CREATE DATABASE online_store;
USE online_store;

-- 1. Categories (no dependencies)
CREATE TABLE categories (
    category_id   INT          AUTO_INCREMENT,
    category_name VARCHAR(50)  NOT NULL UNIQUE,
    PRIMARY KEY (category_id)
);

-- 2. Customers (no dependencies)
CREATE TABLE customers (
    customer_id INT          AUTO_INCREMENT,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    city        VARCHAR(50),
    country     VARCHAR(50),
    signup_date DATE         NOT NULL,
    PRIMARY KEY (customer_id)
);

-- 3. Products (depends on categories)
CREATE TABLE products (
    product_id     INT           AUTO_INCREMENT,
    product_name   VARCHAR(100)  NOT NULL,
    category_id    INT,
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INT           NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CHECK (price >= 0)
);

-- 4. Orders (depends on customers)
CREATE TABLE orders (
    order_id    INT          AUTO_INCREMENT,
    customer_id INT          NOT NULL,
    order_date  DATE         NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'Pending',
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 5. Order items (depends on orders AND products)
CREATE TABLE order_items (
    order_item_id INT           AUTO_INCREMENT,
    order_id      INT           NOT NULL,
    product_id    INT           NOT NULL,
    quantity      INT           NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_item_id),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CHECK (quantity > 0)
);


-- =============================================================
-- Sample Data
-- =============================================================

USE online_store;

-- ── 1. Categories ────────────────────────────────────────────
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Books'),
('Clothing'),
('Home & Kitchen'),
('Sports');

-- ── 2. Customers ─────────────────────────────────────────────
INSERT INTO customers (first_name, last_name, email, city, country, signup_date) VALUES
('Aarav',  'Sharma',   'aarav.sharma@email.com',   'Jaipur',    'India',    '2023-01-15'),
('Diya',   'Patel',    'diya.patel@email.com',     'Mumbai',    'India',    '2023-02-20'),
('Rohan',  'Mehta',    'rohan.mehta@email.com',    'Delhi',     'India',    '2023-03-10'),
('Ananya', 'Reddy',    'ananya.reddy@email.com',   'Hyderabad', 'India',    '2023-05-05'),
('Vivaan', 'Singh',    'vivaan.singh@email.com',   'Bengaluru', 'India',    '2023-06-18'),
('Ishaan', 'Gupta',    'ishaan.gupta@email.com',   'Pune',      'India',    '2023-08-22'),
('Saanvi', 'Iyer',     'saanvi.iyer@email.com',    'Chennai',   'India',    '2023-09-30'),
('Kabir',  'Khan',     'kabir.khan@email.com',     'Lahore',    'Pakistan', '2023-11-12'),
('Mia',    'Williams', 'mia.williams@email.com',   'London',    'UK',       '2024-01-08'),
('Noah',   'Brown',    'noah.brown@email.com',     NULL,        'USA',      '2024-02-14');

-- ── 3. Products ──────────────────────────────────────────────
INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Wireless Mouse',                1,  799.00, 150),
('Mechanical Keyboard',           1, 2499.00,  80),
('USB-C Hub',                     1, 1299.00,  60),
('Noise-Cancelling Headphones',   1, 7999.00,  40),
('SQL Fundamentals',              2,  599.00, 200),
('Data Science Handbook',         2, 1199.00, 120),
('The Pragmatic Programmer',      2,  899.00,  90),
('Cotton T-Shirt',                3,  499.00, 300),
('Denim Jeans',                   3, 1799.00, 110),
('Hooded Sweatshirt',             3, 1499.00,  75),
('Stainless Steel Water Bottle',  4,  699.00, 250),
('Ceramic Coffee Mug',            4,  349.00, 180),
('Non-Stick Frying Pan',          4, 1599.00,  50),
('Yoga Mat',                      5,  999.00, 130),
('Resistance Bands Set',          5,  599.00,   0);

-- ── 4. Orders ────────────────────────────────────────────────
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-01-10', 'Completed'),
(2, '2024-01-15', 'Completed'),
(3, '2024-02-03', 'Completed'),
(1, '2024-02-20', 'Completed'),
(4, '2024-02-28', 'Pending'),
(5, '2024-03-05', 'Completed'),
(2, '2024-03-12', 'Cancelled'),
(6, '2024-03-25', 'Completed'),
(7, '2024-04-02', 'Completed'),
(3, '2024-04-18', 'Completed'),
(8, '2024-04-30', 'Pending'),
(1, '2024-05-07', 'Completed'),
(9, '2024-05-19', 'Completed'),
(5, '2024-06-01', 'Cancelled'),
(4, '2024-06-15', 'Completed');

-- ── 5. Order Items ───────────────────────────────────────────
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1, 2,  799.00),
(1,  5, 1,  599.00),
(2,  4, 1, 7999.00),
(3,  8, 3,  499.00),
(3,  9, 1, 1799.00),
(4,  2, 1, 2499.00),
(4,  3, 1, 1299.00),
(5,  6, 2, 1199.00),
(6, 14, 1,  999.00),
(6, 15, 2,  599.00),
(7, 10, 1, 1499.00),
(8, 11, 2,  699.00),
(8, 12, 4,  349.00),
(9,  5, 1,  599.00),
(9,  7, 1,  899.00),
(10, 1, 1,  799.00),
(10, 2, 1, 2499.00),
(11, 9, 2, 1799.00),
(12, 4, 1, 7999.00),
(12, 6, 1, 1199.00),
(13, 8, 2,  499.00),
(14,14, 1,  999.00),
(15, 1, 1,  799.00),
(15, 5, 2,  599.00),
(15,11, 1,  699.00);

-- ── Verification ─────────────────────────────────────────────
SELECT 'customers'   AS tbl, COUNT(*) AS rows FROM customers
UNION ALL SELECT 'categories',  COUNT(*) FROM categories
UNION ALL SELECT 'products',    COUNT(*) FROM products
UNION ALL SELECT 'orders',      COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
-- Expected: 10, 5, 15, 15, 25
