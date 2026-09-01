-- =============================================================
-- online_store — Schema
-- Databases & SQL for Analysts (Day 3)
-- Compatible with MySQL 8.0.16+
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