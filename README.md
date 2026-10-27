# Databases & SQL for Analysts

### A 23-day series, from your first database to real analyst case studies

![Days](https://img.shields.io/badge/Days-23-0B8A7A?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-8.0.16%2B-F2A900?style=flat-square&logo=mysql&logoColor=white)
![Level](https://img.shields.io/badge/Level-Beginner%20to%20job--ready-3D3A9E?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-6B7280?style=flat-square)

A free, step-by-step SQL course for people who want to work as **data analysts** or **data scientists**. It is written in simple English, with lots of everyday examples, and it is built to work as one resource for both **learning SQL** and **preparing for SQL interviews**.

Every lesson uses the same example database, a small online shop called `online_store`. You build it, fill it with data, and then answer real business questions with it, the same way an analyst does at work.

**Read online:** [Start with Day 1](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/1_Understanding_Databases.html)

---

## Table of contents

- [How the series is organized](#how-the-series-is-organized)
- [Where you can stop](#where-you-can-stop)
- [Series plan](#series-plan)
- [What every day includes](#what-every-day-includes)
- [The example database](#the-example-database)
- [Getting started](#getting-started)
- [Topics covered in detail](#topics-covered-in-detail)
- [Repository files](#repository-files)
- [Who this is for](#who-this-is-for)
- [License](#license)

---

## How the series is organized

The 23 days are split into four parts. The order is planned so that you can stop at the end of any part and still use what you learned on real work.

| Part | Days | What you learn |
|------|------|----------------|
| **1. Foundations** | 1 to 4 | What databases are, the SQL language, building tables, and filling them with data |
| **2. Must-haves** | 5 to 15 | Querying, joins, window functions, cleaning messy data, dates, common analyses, and interview basics |
| **3. Good-to-haves** | 16 to 20 | Advanced analysis patterns, database design, query speed, and harder interview questions |
| **4. Case studies** | 21 to 23 | Three full projects, done the way an analyst does them at work |

---

## Where you can stop

| If you finish | You can |
|---------------|---------|
| **Day 4** | Design a database and fill it with data |
| **Day 9** (Checkpoint 1) | Answer most business questions on clean data, and build a first portfolio project on a public dataset |
| **Day 15** (Checkpoint 2) | Take messy real data from question to answer, and handle a typical SQL interview. This is the job-ready core. |
| **Day 20** | Talk confidently about database design and performance, and handle harder interview rounds |
| **Day 23** | Show three complete case studies in your portfolio |

---

## Series plan

### Part 1: Foundations

| Day | Article | Topics |
|-----|---------|--------|
| 1 | [What is a database?](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/1_Understanding_Databases.html) | Database vs DBMS vs RDBMS, ACID, why analysts need SQL, SQL vs NoSQL, tables, rows, columns, primary and foreign keys, natural vs surrogate keys, normalization |
| 2 | [The SQL language and our example database](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/2_SQL_Language_and_Database.html) | What SQL is, dialects, the five command families (DDL, DML, DQL, DCL, TCL), data types, NULL and three-valued logic, practice setup, the `online_store` schema, relationship types |
| 3 | [DDL: building the structure](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/3_DDL_Building_Structure.html) | `CREATE DATABASE`, `CREATE TABLE`, constraints (PK, FK, NOT NULL, UNIQUE, DEFAULT, CHECK, AUTO_INCREMENT), indexes, `ALTER`, `DROP`, `TRUNCATE` |
| 4 | [DML: bringing the database to life](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/4_DML_Bringing_Data_to_Life.html) | `INSERT`, upserts, `LOAD DATA INFILE`, `UPDATE`, `DELETE`, soft deletes, referential integrity, transactions |

### Part 2: Must-haves

| Day | Article | Topics |
|-----|---------|--------|
| 5 | [SELECT, filtering and sorting](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/5_DQL_Commands_1.html) | `SELECT`, aliases, string functions, `DISTINCT`, `WHERE` operators, `LIKE`, `REGEXP`, `IS NULL`, `ORDER BY`, `LIMIT` |
| 6 | [Aggregation and grouping](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/6_DQL_Aggregation_Grouping.html) | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY`, `GROUP_CONCAT`, `WITH ROLLUP`, `HAVING`, WHERE vs HAVING |
| 7 | [Joining tables](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/7_DQL_Joins.html) | `INNER`, `LEFT`, `RIGHT`, self and cross joins, `USING`, the ON vs WHERE trap, joins with `GROUP BY`, `UNION` |
| 8 | [Subqueries, CTEs and CASE](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/8_DQL_Subqueries_CTEs_CASE.html) | Scalar, multi-row and correlated subqueries, `ANY` / `ALL`, `EXISTS` / `NOT EXISTS`, CTEs, `CASE`, `COALESCE`, conditional aggregation |
| 9 | [Window functions + Checkpoint 1](https://shikharkumar13.github.io/SQL-End-to-End-Theory-and-Hands-On/9_DQL_Window_Functions_Capstone.html) | `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`, `LAG` / `LEAD`, `FIRST_VALUE` / `LAST_VALUE`, running totals, moving averages, views, 8-question capstone |
| 10 | The real dataset | A large, messy `online_store_full` database, loading data, and how to explore a database you have never seen |
| 11 | Data cleaning in SQL | Fixing text and types, `STR_TO_DATE`, handling NULLs, removing duplicates, data quality checks |
| 12 | Dates and time | Date maths, week, month and quarter grouping, year-over-year comparisons, filling empty months |
| 13 | Core analysis patterns | Cohort retention, conversion funnels, RFM segmentation, repeat purchase, customer lifetime value |
| 14 | SQL in the real workflow | Running SQL from Python (pandas, SQLAlchemy), reading and fixing common MySQL errors, MySQL vs PostgreSQL vs BigQuery vs Snowflake |
| 15 | Interview prep I + Checkpoint 2 | About 60 concept questions with answers, plus the classic coding problems |

### Part 3: Good-to-haves

| Day | Article | Topics |
|-----|---------|--------|
| 16 | Advanced analysis patterns | Pivoting, median and percentiles, Pareto / ABC analysis, streaks (gaps and islands), recursive CTEs |
| 17 | Database design and warehousing | Normal forms (1NF to 3NF), ER diagrams, OLTP vs OLAP, star schema, fact and dimension tables |
| 18 | Query performance | How indexes work, composite and covering indexes, `EXPLAIN`, writing index-friendly filters |
| 19 | Beyond SELECT | Stored procedures, functions, triggers, users and permissions, isolation levels |
| 20 | Interview prep II | Hard problems, a step-by-step way to solve any SQL question, common mistakes, a timed mock interview |

### Part 4: Case studies

| Day | Case study | What you do |
|-----|------------|-------------|
| 21 | Monthly business review | Build the monthly report a leadership team reads |
| 22 | Customer retention and churn | Find who keeps buying, who stops, and why |
| 23 | Product and funnel performance | Find what sells, what doesn't, and where website visitors drop off |

Each case study follows the real analyst loop: understand the question, check assumptions, explore the data, write the SQL, check the numbers, and write a short recommendation.

---

## What every day includes

- **The lesson**, in simple English, with everyday examples and analogies
- **Runnable MySQL code** in boxes with a Copy button, and the expected result
- **Try this**: a short exercise, with a sample answer you can open when you're done
- **Interview corner**: questions you are likely to be asked on that day's topic, with short model answers and practical questions
- **Quick recap** of the key points

So even if you only finish part of the series, you are ready for the interview questions on everything you have covered.

---

## The example database

Days 1 to 9 use a small database called **`online_store`**, small enough that you can check every answer by eye.

```
customers ──< orders ──< order_items >── products >── categories
```

```sql
customers     (customer_id PK, first_name, last_name, email, city, country, signup_date)
categories    (category_id PK, category_name)
products      (product_id PK, product_name, category_id FK, price, stock_quantity)
orders        (order_id PK, customer_id FK, order_date, status)
order_items   (order_item_id PK, order_id FK, product_id FK, quantity, unit_price)
```

- One customer places many orders.
- One order has many order lines (`order_items`), and each line is one product.
- One category has many products.
- `order_items` is a bridge table: it links orders and products, which have a many-to-many relationship.

| Table | Rows | Useful quirks for practice |
|-------|------|----------------------------|
| `customers` | 10 | One customer has no city (`NULL`), and one has never ordered |
| `categories` | 5 | Electronics, Books, Clothing, Home & Kitchen, Sports |
| `products` | 15 | One product is out of stock, and one has never been ordered |
| `orders` | 15 | Completed, Pending and Cancelled orders from January to June 2024 |
| `order_items` | 25 | Total revenue across all orders is ₹48,463 |

**From Day 10**, the series adds a second, much larger database called **`online_store_full`**. It has many more rows, deliberately messy data (duplicates, inconsistent text, missing values, badly formatted dates), and extra tables for employees, website events, payments, returns and product reviews. The small `online_store` stays exactly as it is, so every answer in Days 1 to 9 still matches.

---

## Getting started

### 1. Get the files

```bash
git clone https://github.com/shikharkumar13/SQL-End-to-End-Theory-and-Hands-On.git
cd SQL-End-to-End-Theory-and-Hands-On
```

You can also just read the lessons online and copy the code from each page.

### 2. Install MySQL 8

- **Windows:** download the MySQL Installer from [dev.mysql.com/downloads/installer](https://dev.mysql.com/downloads/installer/) and install MySQL Server and MySQL Workbench.
- **macOS:** `brew install mysql`, then `brew services start mysql`
- **Ubuntu / Debian:** `sudo apt update && sudo apt install mysql-server`

No install? Any online MySQL 8 playground works for Days 1 to 9.

### 3. Create the database and load the sample data

```bash
mysql -u root -p < complete_setup.sql
```

`complete_setup.sql` creates `online_store`, builds all five tables, and inserts the sample data. If you only want the empty tables (for example, to type the inserts yourself on Day 4), run `schema.sql` instead.

### 4. Check that it worked

```sql
USE online_store;
SHOW TABLES;                        -- 5 tables

SELECT COUNT(*) FROM customers;     -- 10
SELECT COUNT(*) FROM products;      -- 15
SELECT COUNT(*) FROM orders;        -- 15
SELECT COUNT(*) FROM order_items;   -- 25
```

### 5. Read the days in order

Start with Day 1 and follow the "Coming up next" link at the end of each page.

---

## Topics covered in detail

<details>
<summary><strong>Part 1: Foundations (Days 1 to 4)</strong></summary>

**Day 1: What is a database?**
- Database vs DBMS vs RDBMS
- ACID properties (atomicity, consistency, isolation, durability)
- Why analysts and data scientists need SQL
- Relational vs NoSQL databases
- Tables, rows, columns and schema
- Primary keys, composite keys and foreign keys
- Natural vs surrogate keys
- Normalization and why repeated data causes problems

**Day 2: The SQL language and our example database**
- What SQL is, and why it is called declarative
- SQL dialects (MySQL, SQL Server, PostgreSQL)
- The five command families: DDL, DML, DQL, DCL, TCL
- Data types: `INT`, `BIGINT`, `DECIMAL`, `FLOAT`, `VARCHAR`, `CHAR`, `TEXT`, `DATE`, `DATETIME`, `TIMESTAMP`, `BOOLEAN`
- Why money is never stored as `FLOAT`
- `NULL`, and SQL's three answers: TRUE, FALSE and UNKNOWN
- Setting up MySQL (online or installed)
- The `online_store` schema, naming habits, and one-to-one, one-to-many and many-to-many relationships

**Day 3: DDL, building the structure**
- `CREATE DATABASE`, `USE`, `CREATE TABLE`
- Constraints: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`, `AUTO_INCREMENT`
- Indexes and why they make queries fast
- Creating tables in the right order
- `ALTER TABLE`, `DROP`, `TRUNCATE`
- `SHOW TABLES`, `DESCRIBE`, `SHOW CREATE TABLE`

**Day 4: DML, bringing the database to life**
- `INSERT` (one row and many rows)
- Upserts with `INSERT ... ON DUPLICATE KEY UPDATE`
- Loading CSV files with `LOAD DATA INFILE`
- `UPDATE` and `DELETE`, and the danger of a missing `WHERE`
- Soft deletes
- How foreign keys block bad deletes
- Transactions: `START TRANSACTION`, `COMMIT`, `ROLLBACK`

</details>

<details>
<summary><strong>Part 2: Must-haves (Days 5 to 15)</strong></summary>

**Day 5: SELECT, filtering and sorting**
- `SELECT`, column aliases, `DISTINCT`
- String functions: `CONCAT`, `UPPER`, `LOWER`, `LENGTH`, `TRIM`, `SUBSTRING`
- `WHERE` with comparisons, `AND` / `OR` / `NOT`, `BETWEEN`, `IN`, `LIKE`, `REGEXP`
- `IS NULL` and the `NOT IN` trap
- `ORDER BY`, `LIMIT`, `OFFSET`
- The order SQL actually runs a query in

**Day 6: Aggregation and grouping**
- `COUNT(*)` vs `COUNT(column)` vs `COUNT(DISTINCT column)`
- `SUM`, `AVG`, `MIN`, `MAX`, `ROUND`
- `GROUP BY` with one or more columns, and grouping by month or year
- `GROUP_CONCAT` and `WITH ROLLUP`
- `HAVING`, and WHERE vs HAVING

**Day 7: Joining tables**
- `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, self join, cross join
- The `USING` shortcut
- Finding rows with no match (`LEFT JOIN ... IS NULL`)
- The ON vs WHERE trap with `LEFT JOIN`
- Joining three or more tables, and joins with `GROUP BY`
- `UNION` vs `UNION ALL`

**Day 8: Subqueries, CTEs and CASE**
- Scalar, multi-row and correlated subqueries
- `ANY`, `ALL`, `EXISTS`, `NOT EXISTS`
- Derived tables and CTEs (`WITH`)
- `CASE`, including custom sort orders
- `COALESCE` and conditional aggregation

**Day 9: Window functions + Checkpoint 1**
- `OVER`, `PARTITION BY`, frames
- `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`
- `LAG`, `LEAD`, `FIRST_VALUE`, `LAST_VALUE`
- Running totals, moving averages, share of total
- Top N per group, views, query best practices
- Capstone: 8 business questions

**Day 10: The real dataset**
- Loading `online_store_full`
- Profiling a new database: row counts, missing values, ranges, distinct values

**Day 11: Data cleaning**
- `TRIM`, `REPLACE`, `CAST`, `STR_TO_DATE`, `NULLIF`, `COALESCE`
- Finding and removing duplicates
- Data quality checks

**Day 12: Dates and time**
- `DATEDIFF`, `DATE_ADD`, `DATE_SUB`, `CURDATE`, `NOW`
- Week, month and quarter grouping
- Year-over-year comparisons
- Filling months with no orders (date spine)

**Day 13: Core analysis patterns**
- Cohort retention
- Conversion funnels
- RFM segmentation
- First vs repeat purchases, customer lifetime value

**Day 14: SQL in the real workflow**
- Running SQL from Python with pandas and SQLAlchemy
- Reading and fixing common MySQL errors
- How MySQL differs from PostgreSQL, BigQuery and Snowflake

**Day 15: Interview prep I + Checkpoint 2**
- About 60 concept questions with model answers
- Classic coding problems: Nth highest salary, duplicates, top N per group, employees earning more than their manager, customers with no orders

</details>

<details>
<summary><strong>Part 3: Good-to-haves (Days 16 to 20)</strong></summary>

- **Day 16:** pivoting, median and percentiles, Pareto / ABC analysis, streaks (gaps and islands), recursive CTEs for hierarchies
- **Day 17:** normal forms 1NF to 3NF, ER diagrams, OLTP vs OLAP, star schema, fact and dimension tables, denormalization
- **Day 18:** how indexes work, composite and covering indexes, `EXPLAIN`, index-friendly filters
- **Day 19:** stored procedures, functions, triggers, users and permissions (`GRANT`, `REVOKE`), isolation levels
- **Day 20:** hard interview problems, a step-by-step way to solve SQL questions, common mistakes, a timed mock interview

</details>

<details>
<summary><strong>Part 4: Case studies (Days 21 to 23)</strong></summary>

- **Day 21:** monthly business review for leadership
- **Day 22:** customer retention and churn analysis
- **Day 23:** product, category and website funnel performance

</details>

---

## Repository files

| File | What it is |
|------|------------|
| `1_Understanding_Databases.html` to `9_DQL_Window_Functions_Capstone.html` | The lessons, as styled web pages |
| `complete_setup.sql` | Creates `online_store` and loads all the sample data |
| `schema.sql` | Creates the five empty tables only |
| `LICENSE` | MIT license |

New lessons and the `online_store_full` setup files will be added here as each day is published.

---

## Who this is for

**A good fit if you:**
- Want to become a data analyst or data scientist and need SQL as a core skill
- Know some Excel or Python but have never written SQL
- Have used SQL a little and want to understand it properly
- Are preparing for SQL interview rounds

**Not covered:** running database servers as a database administrator, replication and backups, and NoSQL databases.

---

## License

Released under the [MIT License](LICENSE). You are free to use, adapt and share this material, for learning, teaching or training, with credit.
