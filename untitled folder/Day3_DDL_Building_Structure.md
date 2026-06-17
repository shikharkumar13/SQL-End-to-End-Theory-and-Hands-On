# Day 3: DDL — Building the Structure of Our Database

*A beginner's guide to databases for aspiring data analysts and data scientists*

Welcome to Day 3 — the day you write your first real SQL. So far we've built intuition (Day 1) and mapped out the language and our example database (Day 2). Today we use **DDL, the Data Definition Language**, to turn the `online_store` blueprint into an actual, working structure. By the end of this article you'll have created the database and all five of its tables, complete with the rules that keep the data trustworthy.

Every query here is written for **MySQL**, so you can run them exactly as shown in MySQL Workbench, the MySQL command line, or any online MySQL playground.

Let's build.

---

## 1. What DDL does

**DDL (Data Definition Language)** is the family of SQL commands that define and change the *structure* of a database — the tables, their columns, their data types, and the rules connecting them. DDL is about the **container**, not the contents. (Putting data *into* the container is DML, which is tomorrow.)

There are four DDL commands, and we'll use all of them today:

| Command | What it does |
|---------|--------------|
| `CREATE` | Makes a new database or table |
| `ALTER` | Changes the structure of an existing table |
| `DROP` | Permanently deletes a database or table |
| `TRUNCATE` | Empties a table of all rows, keeping its structure |

A quick habit worth forming now: SQL keywords (`CREATE`, `TABLE`, `INT`…) are **not case-sensitive** — `create table` works the same as `CREATE TABLE` — but by convention we write keywords in UPPERCASE and our own names (tables, columns) in lowercase. This makes queries far easier to read. Also, every SQL statement ends with a **semicolon** `;`.

---

## 2. Creating the database

Before we can create tables, we need a database to hold them. In MySQL, that's two short commands:

```sql
CREATE DATABASE online_store;

USE online_store;
```

The first line creates an empty database named `online_store`. The second, `USE`, tells MySQL "from now on, run my commands inside this database" — so every table we create next lands in the right place. You only need to run `USE` once per session.

If you want to confirm it exists, you can list all databases:

```sql
SHOW DATABASES;
```

> **A note on the storage engine.** MySQL tables use a storage engine, and the modern default is **InnoDB**. This matters because InnoDB is the engine that actually enforces foreign keys — the links between our tables. Since it's the default in modern MySQL, you don't need to do anything special, but it's good to know *why* our relationships will work.

---

## 3. The anatomy of `CREATE TABLE`

The `CREATE TABLE` command builds a table by listing its columns, each with a name and a data type, plus any rules. The general shape looks like this:

```sql
CREATE TABLE table_name (
    column_name   data_type   [constraints],
    column_name   data_type   [constraints],
    ...
);
```

Let's make this concrete with the simplest table in our database — **`categories`**, which has just two columns:

```sql
CREATE TABLE categories (
    category_id   INT          AUTO_INCREMENT,
    category_name VARCHAR(50)  NOT NULL UNIQUE,
    PRIMARY KEY (category_id)
);
```

Reading this line by line:

- `category_id INT AUTO_INCREMENT` — an integer column that MySQL fills in automatically. **`AUTO_INCREMENT`** is a handy MySQL feature: each new row gets the next number (1, 2, 3, …) without you supplying it. Perfect for ID columns.
- `category_name VARCHAR(50) NOT NULL UNIQUE` — text up to 50 characters that must always have a value (`NOT NULL`) and can't be repeated (`UNIQUE`). Two categories can't both be named "Electronics."
- `PRIMARY KEY (category_id)` — declares `category_id` as the primary key: the column that uniquely identifies each row.

That's a complete, valid table. The words like `NOT NULL`, `UNIQUE`, and `PRIMARY KEY` are **constraints** — rules that protect your data. They're so central to good design that they deserve their own section.

---

## 4. Constraints: the rules that protect your data

A **constraint** is a rule attached to a column or table that the database enforces automatically. Constraints are what make a database *trustworthy* — they stop bad data from ever getting in. Here are the ones you'll use constantly:

| Constraint | What it guarantees |
|-----------|---------------------|
| `PRIMARY KEY` | Uniquely identifies each row; cannot be NULL or duplicated |
| `FOREIGN KEY` | Links to a primary key in another table; enforces valid relationships |
| `NOT NULL` | The column must always have a value |
| `UNIQUE` | No two rows can share the same value in this column |
| `DEFAULT` | Supplies a value automatically when none is given |
| `CHECK` | The value must satisfy a condition (e.g. price ≥ 0) |
| `AUTO_INCREMENT` | (MySQL) Auto-generates the next number for a column |

Let's see several of these in action by creating the **`customers`** table:

```sql
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
```

Notice the design decisions encoded here:

- `first_name`, `last_name`, and `signup_date` are **`NOT NULL`** — we never want a nameless or date-less customer.
- `email` is **`NOT NULL UNIQUE`** — every customer must have an email, and no two customers can share one.
- `city` and `country` have *no* `NOT NULL`, so they're **optional**. If we don't know a customer's city, that column simply holds `NULL` ("no value").

This is the real job of constraints: they let you write down your business rules *in the structure itself*, so the database guards them on every single insert — no human discipline required.

### A note on DEFAULT

The `DEFAULT` constraint supplies a value automatically when you don't provide one. We'll use it on the `orders` table in a moment, where a new order's `status` should start as `'Pending'` unless told otherwise. That way, an order created without an explicit status isn't left blank — it sensibly defaults.

---

## 5. FOREIGN KEY: the relational glue

Now the most important constraint for a *relational* database — the **foreign key**, which links one table to another. This is what turns a pile of separate tables into a connected, relational database.

A crucial rule comes with foreign keys: **the table you reference must already exist.** A foreign key in `products` that points to `categories` requires `categories` to be created first. This is why we build our tables in **dependency order**: tables with no foreign keys first, then the tables that depend on them.

Our order is: `categories` and `customers` first (done), then `products`, then `orders`, then `order_items` last.

Here's **`products`**, which references `categories`:

```sql
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
```

The new pieces:

- `FOREIGN KEY (category_id) REFERENCES categories(category_id)` — this says the `category_id` in `products` must match a real `category_id` over in `categories`. MySQL will now *reject* any product that points to a category that doesn't exist. That's **referential integrity** — the database guaranteeing your relationships stay valid.
- `price DECIMAL(10,2)` — exact decimal for money, as we discussed on Day 2.
- `CHECK (price >= 0)` — a price can never be negative.
- `stock_quantity INT NOT NULL DEFAULT 0` — if no stock is specified, it starts at zero.

Next, **`orders`**, which references `customers` and shows `DEFAULT` doing real work:

```sql
CREATE TABLE orders (
    order_id    INT          AUTO_INCREMENT,
    customer_id INT          NOT NULL,
    order_date  DATE         NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'Pending',
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

Here `status` defaults to `'Pending'`, and `customer_id` is both `NOT NULL` (every order must belong to someone) and a foreign key (that someone must be a real customer).

Finally, **`order_items`** — the bridge table from Day 2. It carries *two* foreign keys, linking each purchase line to both its order and its product:

```sql
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
```

With this, all five tables are defined and fully connected.

> **MySQL `CHECK` caveat.** MySQL only began *enforcing* `CHECK` constraints in **version 8.0.16**. Older versions accept the syntax but silently ignore it. If you're on MySQL 8.0.16 or newer (very common today), your `CHECK` rules will be enforced. On older versions they're harmless but inactive — your other constraints still work perfectly.

---

## 6. The complete setup script

Here is everything from above in one runnable block, in the correct dependency order. Running this from top to bottom creates the entire `online_store` structure from scratch:

```sql
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
```

The lines beginning with `--` are **comments** — SQL ignores them, but they make a script readable. Get into the habit of commenting your scripts.

---

## 7. Verifying your work

After running the script, confirm the structure is there. These MySQL commands let you inspect what you built:

```sql
SHOW TABLES;
```

This lists all five tables. To inspect a single table's columns, types, and keys, use `DESCRIBE` (or its short form `DESC`):

```sql
DESCRIBE customers;
```

You'll see each column with its type, whether it allows `NULL`, and its key role. And to see the exact statement MySQL stored for a table — useful for checking your constraints landed correctly:

```sql
SHOW CREATE TABLE products;
```

---

## 8. ALTER: changing a table after creation

Real databases evolve. `ALTER TABLE` lets you change a table's structure *after* it exists, without rebuilding it. Here are the operations you'll reach for most, in MySQL syntax.

**Add a new column** — say we want to store a customer's phone number:

```sql
ALTER TABLE customers ADD COLUMN phone VARCHAR(20);
```

**Change an existing column's definition** — MySQL uses `MODIFY COLUMN`:

```sql
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(15);
```

**Rename a column** (MySQL 8.0+):

```sql
ALTER TABLE customers RENAME COLUMN phone TO phone_number;
```

**Drop a column** you no longer need:

```sql
ALTER TABLE customers DROP COLUMN phone_number;
```

**Add a constraint to an existing table** — for example, adding a foreign key after the fact:

```sql
ALTER TABLE products
ADD CONSTRAINT fk_product_category
FOREIGN KEY (category_id) REFERENCES categories(category_id);
```

(We named the constraint `fk_product_category`. Naming constraints is optional but makes them easy to find and remove later.)

`ALTER` is powerful, so make changes thoughtfully on a database that already holds data — some changes can affect existing rows.

---

## 9. DROP and TRUNCATE: removing structure and data

The last two DDL commands *remove* things. Use them with care — both are difficult to undo.

**`DROP TABLE`** deletes an entire table — its structure *and* all its data — permanently:

```sql
DROP TABLE order_items;
```

Because of foreign keys, you must drop tables in *reverse* dependency order: a table being referenced by another can't be dropped first. So you'd drop `order_items` before `orders` and `products`. To avoid an error if the table might not exist, add `IF EXISTS`:

```sql
DROP TABLE IF EXISTS order_items;
```

**`DROP DATABASE`** removes an entire database and everything in it:

```sql
DROP DATABASE online_store;
```

**`TRUNCATE TABLE`** keeps the table's structure but instantly removes *all* its rows:

```sql
TRUNCATE TABLE order_items;
```

`TRUNCATE` is useful when you want to wipe a table clean and start fresh — it also resets `AUTO_INCREMENT` back to 1.

> **DROP vs TRUNCATE vs DELETE — a common confusion.** `DROP` removes the whole table (structure + data). `TRUNCATE` removes all data but keeps the empty table. `DELETE` (which is *DML*, covered tomorrow) also removes rows but lets you target *specific* rows with a `WHERE` condition, and can be undone inside a transaction. Rule of thumb: `TRUNCATE` to empty everything fast; `DELETE` when you want control over *which* rows go.

---

## 10. Where we're headed

You've now done something real: the `online_store` database exists, with five connected tables and a full set of constraints quietly standing guard over your data quality. The structure is built — but it's empty.

Tomorrow, **Day 4 (DML)**, we bring it to life. You'll use `INSERT` to populate every table with realistic sample data — customers, categories, products, orders, and order items — and learn `UPDATE` and `DELETE` to modify it. That sample data is what we'll spend Days 5 through 9 querying, so Day 4 sets the stage for all the analysis to come.

---

### Quick recap of Day 3

- **DDL** defines structure. Its four commands: `CREATE`, `ALTER`, `DROP`, `TRUNCATE`.
- `CREATE DATABASE` + `USE` set up the database; `CREATE TABLE` defines each table's columns, types, and rules.
- **Constraints** enforce data quality: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`, plus MySQL's `AUTO_INCREMENT`.
- **Foreign keys** create relationships and require referenced tables to exist first, so tables are built in dependency order.
- `ALTER TABLE` changes structure later (`ADD`/`MODIFY`/`RENAME`/`DROP COLUMN`, `ADD CONSTRAINT`).
- `DROP` deletes structure + data; `TRUNCATE` empties a table; `DELETE` (DML) removes chosen rows.
- MySQL specifics: `AUTO_INCREMENT`, the `InnoDB` engine enforces foreign keys, and `CHECK` is enforced from version **8.0.16+**.

> **Try this before Day 4:** Run the complete setup script in your MySQL environment, then run `SHOW TABLES;` and `DESCRIBE order_items;`. Can you spot the two foreign keys in the output? As a small challenge, use `ALTER TABLE` to add an optional `discount DECIMAL(5,2)` column to `order_items`, then `DESCRIBE` it again to confirm the change — and drop the column afterward to restore the original design.

*See you on Day 4, where the database finally fills with data.*
