# 🗄️ Databases & SQL for Analysts
### A 9-Day Series From First Concepts to Advanced Querying

![Articles](https://img.shields.io/badge/Articles-9-1557C0?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-F59E0B?style=flat-square&logo=mysql&logoColor=white)
![SQL Lines](https://img.shields.io/badge/SQL%20Examples-1%2C088%20lines-0A7C4E?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-6B7280?style=flat-square)

A structured, beginner-to-intermediate SQL series written for aspiring **data analysts** and **data scientists**. Every concept is taught through a single, consistent example database, an online store called `online_store` that you build from scratch on Day 3 and query all the way through Day 9. By the end, you can answer real business questions with clean, production-quality SQL.

---

## 📋 Table of Contents

- [What You Will Learn](#-what-you-will-learn)
- [The Example Database](#-the-example-database)
- [Series Contents](#-series-contents)
- [Prerequisites](#-prerequisites)
- [Getting Started](#-getting-started)
- [File Structure](#-file-structure)
- [Sample Queries](#-sample-queries)
- [Topics Covered](#-topics-covered)
- [Who This Is For](#-who-this-is-for)
- [Contributing](#-contributing)
- [License](#-license)

---

## What You Will Learn

By working through all nine articles, you will go from "what is a database?" to writing multi-table analytical queries with window functions and CTEs which is one of the skills listed alongside Python and statistics in data analyst job postings.

| Phase | Days | Focus |
|-------|------|-------|
| **Foundations** | 1 - 2 | Database concepts, relational model, SQL language families, data types |
| **Building** | 3 - 4 | DDL (CREATE / ALTER / DROP), DML (INSERT / UPDATE / DELETE), constraints |
| **Querying** | 5 - 9 | The full DQL toolkit - SELECT, filtering, aggregation, joins, subqueries, CTEs, CASE, window functions |

---

## The Example Database

All nine articles work on a single database: **`online_store`**.

```
customers ──< orders ──< order_items >── products >── categories
```

### Schema

```sql
customers     (customer_id PK, first_name, last_name, email, city, country, signup_date)
categories    (category_id PK, category_name)
products      (product_id PK, product_name, category_id FK, price, stock_quantity)
orders        (order_id PK, customer_id FK, order_date, status)
order_items   (order_item_id PK, order_id FK, product_id FK, quantity, unit_price)
```

### Relationships

- A **customer** places many **orders**.
- An **order** contains many **order items** (line items).
- Each **order item** references one **product**.
- A **product** belongs to one **category**.
- `order_items` is a bridge table that resolves the many-to-many relationship between orders and products.

### Sample Data (loaded on Day 4)

| Table | Rows | Highlights |
|-------|------|------------|
| `customers` | 10 | 1 customer with a `NULL` city; 1 customer with no orders — useful for `IS NULL` and `LEFT JOIN` exercises |
| `categories` | 5 | Electronics, Books, Clothing, Home & Kitchen, Sports |
| `products` | 15 | 1 out-of-stock product; 1 product never ordered — realistic edge cases |
| `orders` | 15 | Statuses: Completed, Pending, Cancelled; dates span Jan–Jun 2024 |
| `order_items` | 25 | Total verified revenue: ₹48,463 across all orders |

---

## 📚 Series Contents

| Day | Article | Topics Covered |
|-----|---------|---------------|
| **1** | Understanding Databases | Database vs DBMS vs RDBMS · relational vs NoSQL · tables, rows, columns · primary & foreign keys · normalization |
| **2** | The SQL Language and Our Example Database | DDL / DML / DQL / DCL / TCL · data types · NULL · practice environment setup · full schema walkthrough |
| **3** | DDL - Building the Structure of Our Database | `CREATE DATABASE` · `CREATE TABLE` · constraints (PK, FK, NOT NULL, UNIQUE, DEFAULT, CHECK, AUTO_INCREMENT) · `ALTER TABLE` · `DROP` · `TRUNCATE` |
| **4** | DML - Bringing the Database to Life | `INSERT` (single & multi-row) · `UPDATE` · `DELETE` · referential integrity · transactions (`COMMIT` / `ROLLBACK`) |
| **5** | DQL I - SELECT, Filtering & Sorting | `SELECT` · column aliases · `DISTINCT` · `WHERE` with `=`, `!=`, `>`, `<`, `AND`, `OR`, `NOT`, `BETWEEN`, `IN`, `LIKE`, `IS NULL` · `ORDER BY` · `LIMIT` / `OFFSET` |
| **6** | DQL II - Aggregation & Grouping | `COUNT` · `SUM` · `AVG` · `MIN` · `MAX` · `ROUND` · `GROUP BY` · `HAVING` · `DATE_FORMAT` · `MONTH` / `YEAR` · WHERE vs HAVING · execution order |
| **7** | DQL III - Joining Tables | Table aliases · `INNER JOIN` · `LEFT JOIN` · `RIGHT JOIN` · multi-table joins · self-join · cross join · FULL OUTER JOIN workaround · `UNION` / `UNION ALL` · ON vs WHERE with LEFT JOIN |
| **8** | DQL IV - Subqueries, CTEs & CASE | Scalar subqueries · multi-row subqueries (`IN` / `NOT IN`) · correlated subqueries · `EXISTS` · derived tables · `WITH` (CTE) · multiple CTEs · `CASE` (simple & searched) · `COALESCE` · conditional aggregation |
| **9** | DQL V - Window Functions & Capstone | `ROW_NUMBER` · `RANK` · `DENSE_RANK` · `LAG` / `LEAD` · `SUM OVER` running totals · `MAX OVER` · percentage share · frame clause · `CREATE VIEW` · best practices · 8-question capstone |

Each article is available as both a **Markdown file** (for reading in any editor or GitHub) and a **styled HTML page** (for a polished, syntax-highlighted reading experience with copy buttons).

---

## 🔧 Prerequisites

- **No prior SQL experience required.** Days 1 and 2 build the foundation from scratch.
- **MySQL 8.0.16 or higher** recommended. MySQL 8.0 introduced proper enforcement of `CHECK` constraints and window function support. All queries in the series target this version.
- Alternatively: **PostgreSQL 13+** or **SQLite 3.35+** work for most queries with very minor syntax adjustments (noted in the articles where relevant).
- A text editor and a MySQL client (MySQL Workbench, DBeaver, DataGrip, TablePlus, or the `mysql` CLI all work).

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/databases-sql-for-analysts.git
cd databases-sql-for-analysts
```

### 2. Install MySQL (if you haven't already)

**macOS (Homebrew):**
```bash
brew install mysql
brew services start mysql
mysql_secure_installation
```

**Ubuntu / Debian:**
```bash
sudo apt update && sudo apt install mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation
```

**Windows:** Download the MySQL Installer from [dev.mysql.com/downloads](https://dev.mysql.com/downloads/installer/) and run the setup wizard.

### 3. Create the database and load the sample data

```bash
mysql -u root -p < sql/complete_setup.sql
```

Or run the two files separately — schema first, then data:

```bash
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_sample_data.sql
```

### 4. Verify the setup

```sql
USE online_store;
SHOW TABLES;

-- Expected output:
-- order_items
-- orders
-- products
-- categories
-- customers

SELECT COUNT(*) FROM customers;    -- 10
SELECT COUNT(*) FROM products;     -- 15
SELECT COUNT(*) FROM orders;       -- 15
SELECT COUNT(*) FROM order_items;  -- 25
```

### 5. Read the articles in order

Start with [Day 1](articles/Day1_Understanding_Databases.md). Each article ends with a "Try this before Day N" exercise that reinforces the concepts before you move on.

---

## 📁 File Structure

```
databases-sql-for-analysts/
│
├── articles/                          # Markdown articles (9 files)
│   ├── Day1_Understanding_Databases.md
│   ├── Day2_SQL_Language_and_Database.md
│   ├── Day3_DDL_Building_Structure.md
│   ├── Day4_DML_Bringing_Data_to_Life.md
│   ├── Day5_DQL_SELECT_Filtering_Sorting.md
│   ├── Day6_DQL_Aggregation_Grouping.md
│   ├── Day7_DQL_Joins.md
│   ├── Day8_DQL_Subqueries_CTEs_CASE.md
│   └── Day9_DQL_Window_Functions_Capstone.md
│
├── html/                              # Styled HTML versions (9 files)
│   ├── Day1_Understanding_Databases.html
│   ├── Day2_SQL_Language_and_Database.html
│   ├── Day3_DDL_Building_Structure.html
│   ├── Day4_DML_Bringing_Data_to_Life.html
│   ├── Day5_DQL_SELECT_Filtering_Sorting.html
│   ├── Day6_DQL_Aggregation_Grouping.html
│   ├── Day7_DQL_Joins.html
│   ├── Day8_DQL_Subqueries_CTEs_CASE.html
│   └── Day9_DQL_Window_Functions_Capstone.html
│
├── sql/                               # Standalone SQL scripts
│   ├── 01_schema.sql                  # CREATE DATABASE + all 5 tables (from Day 3)
│   ├── 02_sample_data.sql             # All INSERT statements (from Day 4)
│   └── complete_setup.sql             # Schema + data in one file
│
└── README.md
```

> **HTML pages** use the IBM Plex type family (Serif / Sans / Mono), syntax-highlighted SQL code blocks with copy buttons, a reading-progress bar, and a 9-dot series-progress indicator in the sticky nav. They require no build step — open any `.html` file directly in a browser.

---

## ✅ Topics Covered

<details>
<summary><strong>Foundations (Days 1–2)</strong></summary>

- What a database is and why analysts need SQL
- Database vs DBMS vs RDBMS
- Relational vs non-relational databases
- Tables, rows, columns, schema
- Primary keys and foreign keys
- Relationships and normalization
- The five SQL command families: DDL, DML, DQL, DCL, TCL
- Data types: INT, DECIMAL, VARCHAR, TEXT, DATE, DATETIME, BOOLEAN
- NULL semantics
- The `online_store` schema walkthrough

</details>

<details>
<summary><strong>DDL - Data Definition Language (Day 3)</strong></summary>

- `CREATE DATABASE` and `USE`
- `CREATE TABLE` with column definitions
- Constraints: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`
- `AUTO_INCREMENT` (MySQL)
- InnoDB and foreign key enforcement
- Dependency order for table creation
- `ALTER TABLE`: `ADD COLUMN`, `MODIFY COLUMN`, `RENAME COLUMN`, `DROP COLUMN`, `ADD CONSTRAINT`
- `DROP TABLE` / `DROP DATABASE` with `IF EXISTS`
- `TRUNCATE TABLE` vs `DELETE`
- Verification: `SHOW TABLES`, `DESCRIBE`, `SHOW CREATE TABLE`

</details>

<details>
<summary><strong>DML - Data Manipulation Language (Day 4)</strong></summary>

- `INSERT INTO ... VALUES` (single and multi-row)
- Inserting with `NULL` for optional columns
- Insert dependency order with foreign keys
- `UPDATE ... SET ... WHERE`
- Calculated updates (`SET price = price * 1.10`)
- The missing-`WHERE` danger — affects all rows
- `DELETE FROM ... WHERE`
- Referential integrity blocking invalid deletes
- Transactions: `START TRANSACTION`, `COMMIT`, `ROLLBACK`

</details>

<details>
<summary><strong>DQL - Data Query Language (Days 5-9)</strong></summary>

**SELECT fundamentals (Day 5)**
- `SELECT` specific columns, `SELECT *`
- Column aliases with `AS`
- `DISTINCT` for unique values
- `WHERE` with all comparison and logical operators
- `BETWEEN`, `IN`, `NOT IN`, `LIKE` (`%` and `_` wildcards)
- `IS NULL`, `IS NOT NULL`
- `ORDER BY` ASC / DESC, multiple columns
- `LIMIT` and `LIMIT ... OFFSET`
- SQL execution order: FROM → WHERE → SELECT → ORDER BY → LIMIT

**Aggregation and grouping (Day 6)**
- `COUNT(*)`, `COUNT(column)`, `COUNT(DISTINCT column)`
- `SUM`, `AVG`, `MIN`, `MAX`
- `ROUND(value, decimals)`
- `GROUP BY` - single and multiple columns
- The SELECT rule with GROUP BY (`ONLY_FULL_GROUP_BY`)
- `HAVING` - filtering groups after aggregation
- WHERE vs HAVING — when to use each
- Date functions: `MONTH()`, `YEAR()`, `DATE_FORMAT()`, `MONTHNAME()`
- Full execution order: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

**Joins (Day 7)**
- Table aliases and dot notation
- `INNER JOIN`
- `LEFT JOIN` and the `LEFT JOIN + IS NULL` pattern for finding non-matches
- `RIGHT JOIN`
- Multi-table joins (chaining 3, 4, 5 tables)
- `JOIN` with `GROUP BY` — the core analytical pattern
- Self join
- `CROSS JOIN`
- FULL OUTER JOIN workaround (LEFT + RIGHT + UNION)
- `UNION` vs `UNION ALL`
- ON vs WHERE placement with LEFT JOIN

**Subqueries, CTEs, CASE (Day 8)**
- Scalar subqueries in `WHERE` and `SELECT`
- Multi-row subqueries with `IN` and `NOT IN`
- Correlated subqueries (per-row computations)
- `EXISTS` vs `IN`
- Derived tables (subqueries in `FROM`)
- Common Table Expressions (`WITH cte AS (...)`)
- Multiple CTEs chained with commas
- Simple `CASE` (value matching)
- Searched `CASE` (condition-based)
- `COALESCE` for NULL defaults
- Conditional aggregation: `COUNT(CASE WHEN ... THEN 1 END)`, `SUM(CASE WHEN ... ELSE 0 END)`

**Window functions (Day 9)**
- `OVER()` clause: `PARTITION BY`, `ORDER BY`, frame specification
- `ROW_NUMBER()` — unique sequential rank
- `RANK()` — rank with gaps for ties
- `DENSE_RANK()` — rank without gaps
- `LAG(column, n)` and `LEAD(column, n)` for period-over-period comparison
- `SUM() OVER (ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` — running totals
- `SUM() OVER ()` — grand total in every row (percentage share pattern)
- `MAX() OVER ()` — maximum across all rows for relative comparisons
- The "top-N per group" pattern: `ROW_NUMBER()` in CTE + `WHERE rn = 1`
- `CREATE VIEW` / `DROP VIEW`
- Query best practices

</details>

---

## 📄 License

This series is released under the [MIT License](LICENSE). You are free to use, adapt, and share it — for personal learning, teaching, corporate training, or any other purpose — with attribution.

*Built with care for everyone who ever stared at a database and didn't know where to begin.*

</div>
