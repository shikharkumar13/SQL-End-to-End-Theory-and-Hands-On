# Day 2: The SQL Language and Our Example Database

*A beginner's guide to databases for aspiring data analysts and data scientists*

Welcome to Day 2. Yesterday we built a mental model: a database is organized data, an RDBMS stores it in linked tables, and concepts like keys and normalization keep that data clean and connected. Today we meet the tool we use to actually talk to that data — **SQL** — and we get acquainted with the example database we'll build and query for the rest of this series.

This article is still mostly conceptual, with just a light taste of syntax. We won't run real commands yet — that begins tomorrow on Day 3. Think of today as learning the map before the road trip.

Let's begin.

---

## 1. What is SQL?

**SQL** stands for **Structured Query Language**. It is the standard language used to communicate with relational databases — to create their structure, put data in, change it, and most importantly for us, *ask questions of it*.

You'll hear it pronounced two ways: as the letters "S-Q-L," or as the word "sequel." Both are correct and widely used, so pick whichever you like.

The way SQL works is wonderfully simple in spirit. You write a **statement** (also called a **query** when you're retrieving data) describing *what* you want, and the DBMS figures out *how* to get it and returns the result. For example, a query that means "give me the names of all customers in Jaipur" looks remarkably close to that plain-English sentence. You describe the goal; the database does the heavy lifting.

This is what makes SQL approachable: it is **declarative**. Unlike languages where you must spell out every step, in SQL you mostly state the result you want and let the database work out the procedure.

One practical note before we go further. SQL is an official standard, but every database engine (MySQL, PostgreSQL, SQL Server, Oracle, SQLite) adds its own small variations — these are called **dialects**. The good news: the core — the parts you'll use 95% of the time — is nearly identical across all of them. In this series we'll teach standard, widely-portable SQL and use **MySQL / SQLite-style syntax** by default, calling out dialect differences whenever they actually matter. Whatever you learn here will transfer to any engine with only minor adjustments.

---

## 2. The five families of SQL commands

Every SQL command belongs to one of five families, grouped by *what kind of job it does*. Knowing these families gives you a filing system for every command you'll ever learn — when you meet a new command, you'll instantly know where it fits and what it's for.

Here is the full map:

| Family | Stands for | Job | Example commands |
|--------|-----------|-----|------------------|
| **DDL** | Data Definition Language | Define and change the *structure* of the database | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML** | Data Manipulation Language | Add, change, and remove the *data* inside tables | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** | Data Query Language | *Retrieve and read* data — ask questions | `SELECT` |
| **DCL** | Data Control Language | Manage *permissions* — who can do what | `GRANT`, `REVOKE` |
| **TCL** | Transaction Control Language | Manage *transactions* — save or undo groups of changes | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

Let's walk through each one briefly.

**DDL — Data Definition Language.** These commands define the *skeleton* of your database: the tables, their columns, their data types, and their rules. `CREATE` makes a new table, `ALTER` changes an existing one, `DROP` deletes a table entirely, and `TRUNCATE` empties a table of all its rows while keeping the structure. DDL is about the *container*, not the contents. **We cover this on Day 3**, where you'll build all the tables of our example database.

**DML — Data Manipulation Language.** Once the structure exists, DML puts data into it and changes it. `INSERT` adds new rows, `UPDATE` modifies existing rows, and `DELETE` removes rows. DML is about the *contents* sitting inside the structure. **We cover this on Day 4**, where you'll fill the database with sample data.

**DQL — Data Query Language.** This is the family we care about most, because reading data is the core of analysis. It contains essentially one command — `SELECT` — but that single command is extraordinarily powerful, with filtering, grouping, joining, and analytical features layered on top. **DQL is the heart of this series, spanning Days 5 through 9.** Almost everything a data analyst does begins with a `SELECT`.

**DCL — Data Control Language.** These commands manage *who is allowed to do what*. `GRANT` gives a user permission, and `REVOKE` takes it away. As an analyst you'll mostly *use* permissions that a database administrator sets up rather than configure them yourself, so we'll mention DCL only briefly.

**TCL — Transaction Control Language.** A *transaction* is a group of changes treated as a single unit — either all of them succeed together, or none of them do. `COMMIT` permanently saves the changes in a transaction, `ROLLBACK` undoes them, and `SAVEPOINT` sets a marker you can roll back to. This matters enormously for data integrity (imagine a bank transfer where money leaves one account but never arrives in another). We'll touch on TCL where it's relevant, especially around DML.

The takeaway: **structure (DDL), data (DML), reading (DQL), permissions (DCL), transactions (TCL).** Keep this map in your head and every command will have a home.

---

## 3. Common data types

When we define a table, every column must have a **data type** — a declaration of what *kind* of value it will hold. This is important: the data type controls what can be stored, how much space it uses, and what operations make sense (you can do math on numbers, but not on a name). Choosing the right type is part of good database design.

Here are the types you'll meet most often, grouped by category.

**Numeric types** — for numbers you may want to calculate with.

| Type | Holds | Example use |
|------|-------|-------------|
| `INT` (or `INTEGER`) | Whole numbers | An ID, a quantity, a stock count |
| `DECIMAL(p, s)` | Exact decimal numbers | Money — e.g. `DECIMAL(10,2)` stores values like `1499.00` |
| `FLOAT` / `DOUBLE` | Approximate decimals | Scientific measurements |

A quick tip you'll thank yourself for later: **use `DECIMAL` for money, never `FLOAT`.** Floating-point types are approximate and can introduce tiny rounding errors — fine for science, dangerous for prices and totals.

**Text (string) types** — for words and characters. Text values are written inside single quotes, like `'Mumbai'`.

| Type | Holds | Example use |
|------|-------|-------------|
| `VARCHAR(n)` | Text up to *n* characters | Names, emails, cities |
| `CHAR(n)` | Fixed-length text of exactly *n* characters | Short codes like a 2-letter country code |
| `TEXT` | Long, free-form text | Product descriptions, reviews |

`VARCHAR` is the everyday workhorse — flexible and space-efficient. The number in `VARCHAR(100)` simply sets the maximum length.

**Date and time types** — for points in time, which are essential for analysis (trends over months, signups by year, and so on).

| Type | Holds | Example |
|------|-------|---------|
| `DATE` | A calendar date | `2025-03-14` |
| `DATETIME` / `TIMESTAMP` | A date *and* a time | `2025-03-14 09:30:00` |
| `TIME` | A time of day | `09:30:00` |

Dates are written in the international `YYYY-MM-DD` format, which sorts correctly and avoids the confusion of day-vs-month ordering.

**Boolean type** — for true/false values.

| Type | Holds | Example |
|------|-------|---------|
| `BOOLEAN` | `TRUE` or `FALSE` | Is an account active? |

A small dialect note: some databases (like MySQL) store booleans internally as a tiny integer where `1` means true and `0` means false. You usually don't need to worry about this as a beginner.

> **One more idea — NULL.** Any column can also hold a special marker called `NULL`, which means "no value / unknown." `NULL` is *not* zero and *not* an empty string — it represents the *absence* of data, like a customer who hasn't given their phone number. We'll handle `NULL` carefully when we reach filtering, because it behaves in some surprising ways.

---

## 4. Setting up your practice environment

To follow along from Day 3 onward, you'll want a place to actually run SQL. You have two paths — pick whichever removes the most friction for you.

**Option A — An online SQL playground (zero installation, recommended to start).** Several free websites let you write and run SQL right in your browser with nothing to install. Search for terms like "online SQL playground" or "SQL fiddle." This is the fastest way to begin: open a tab, paste a command, see the result. Perfect for learning.

**Option B — Install a database on your computer (closer to real-world work).** When you're ready for a more realistic setup, install a database engine and a tool to interact with it visually:

- **SQLite** with *DB Browser for SQLite* — the simplest real database; a single file, almost no setup. Excellent for learners.
- **MySQL** with *MySQL Workbench* — extremely popular in industry; a great default choice.
- **PostgreSQL** with *pgAdmin* — powerful and standards-friendly, loved in data work.

Any of these will run everything in this series. If you're undecided, start with an **online playground** today, and install **MySQL** or **SQLite** once you're comfortable. Don't let the choice stall you — the SQL you write is nearly the same across all of them, and you can switch later.

> You don't need to install anything to read along. Set up your environment whenever you're ready to start typing commands on Day 3.

---

## 5. Meet our example database: `online_store`

For the rest of this series we'll work with a single, consistent example: a small e-commerce database called **`online_store`**. Using one database throughout means you'll watch it grow from empty structure (Day 3) to full of data (Day 4) to a source of real business insights (Days 5–9) — an end-to-end journey on one familiar dataset.

Our `online_store` models the essentials of any online shop. It has **five tables**:

| Table | What it stores |
|-------|----------------|
| `customers` | People who have signed up to buy |
| `categories` | The product categories (e.g. Electronics, Books) |
| `products` | Items for sale, each belonging to a category |
| `orders` | Orders placed by customers |
| `order_items` | The individual product lines within each order |

This is deliberately small enough to understand at a glance, yet rich enough to demonstrate everything — filtering, grouping, joins across multiple tables, subqueries, and analytical queries like "top-selling products" or "revenue by month." It also reflects the normalization lesson from Day 1: instead of one giant table, the data is split into focused tables connected by keys.

Let's look at each table in detail.

---

## 6. The five tables in detail

Below is the **schema** — the blueprint — for each table. For now, just read these to get familiar; you'll create them for real on Day 3. The 🔑 marks a **primary key**, and 🔗 marks a **foreign key** (a link to another table).

**`customers`** — one row per registered customer.

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| `customer_id` | `INT` | 🔑 PK | Unique ID for each customer |
| `first_name` | `VARCHAR(50)` | | Customer's first name |
| `last_name` | `VARCHAR(50)` | | Customer's last name |
| `email` | `VARCHAR(100)` | | Email address (unique per customer) |
| `city` | `VARCHAR(50)` | | City they live in |
| `country` | `VARCHAR(50)` | | Country they live in |
| `signup_date` | `DATE` | | The date they registered |

**`categories`** — one row per product category.

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| `category_id` | `INT` | 🔑 PK | Unique ID for each category |
| `category_name` | `VARCHAR(50)` | | Name of the category (e.g. Electronics) |

**`products`** — one row per item for sale.

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| `product_id` | `INT` | 🔑 PK | Unique ID for each product |
| `product_name` | `VARCHAR(100)` | | Name of the product |
| `category_id` | `INT` | 🔗 FK → categories | Which category this product belongs to |
| `price` | `DECIMAL(10,2)` | | Selling price of the product |
| `stock_quantity` | `INT` | | How many units are currently in stock |

**`orders`** — one row per order placed.

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| `order_id` | `INT` | 🔑 PK | Unique ID for each order |
| `customer_id` | `INT` | 🔗 FK → customers | Which customer placed the order |
| `order_date` | `DATE` | | The date the order was placed |
| `status` | `VARCHAR(20)` | | Order status (e.g. Completed, Pending, Cancelled) |

**`order_items`** — one row per product line within an order. (An order can contain several products; each product on an order is one row here.)

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| `order_item_id` | `INT` | 🔑 PK | Unique ID for each order line |
| `order_id` | `INT` | 🔗 FK → orders | Which order this line belongs to |
| `product_id` | `INT` | 🔗 FK → products | Which product was bought |
| `quantity` | `INT` | | How many units of the product |
| `unit_price` | `DECIMAL(10,2)` | | Price per unit at the time of the order |

One subtle but important detail: `order_items` stores `unit_price` even though `products` already has a `price`. Why duplicate it? Because product prices change over time, and an order must remember the price *as it was when the purchase happened*. Storing it captures a historical fact — a small example of designing tables to reflect the real world.

---

## 7. How the tables connect

The real power of this design is in the **relationships** between the tables. Let's trace them, because understanding this map now will make joins (Day 7) far easier.

Here is the structure in words:

```
categories ──< products ──< order_items >── orders >── customers
                                │
              (a product can appear on many order lines)
```

Reading the connections one by one:

- **One category has many products.** Each product carries a `category_id` foreign key pointing to its category. (Electronics → Laptop, Phone, Headphones…)
- **One customer places many orders.** Each order carries a `customer_id` foreign key pointing to the customer who placed it.
- **One order contains many order items.** Each row in `order_items` carries an `order_id` foreign key pointing to its parent order.
- **One product can appear on many order items.** Each row in `order_items` also carries a `product_id` foreign key pointing to the product that was bought.

Notice that `order_items` sits in the middle, holding *two* foreign keys — one to `orders` and one to `products`. This kind of table is called a **bridge** or **junction table**, and it elegantly solves a common situation: an order can contain many products, and a product can appear in many orders. That "many-to-many" relationship can't be stored directly in either table, so we use `order_items` in between to record each individual purchase line. You'll see this pattern constantly in real databases.

These relationships are exactly what let us answer cross-table questions later, such as: *"Which product category generated the most revenue last month?"* — a question that requires walking from `categories` to `products` to `order_items`, then summing it all up. By the end of this series, you'll write that query comfortably.

---

## 8. Where we're headed

You now have the full picture: the SQL language and its five command families, the data types you'll use, a place to practice, and the complete blueprint of the `online_store` database we'll build and explore together.

From here, the series becomes hands-on:

- **Day 3 (DDL)** — you'll *create* all five tables, turning the blueprint above into a real, empty database.
- **Day 4 (DML)** — you'll *fill* those tables with sample data, bringing the database to life.
- **Days 5–9 (DQL)** — you'll *query* that data, growing from simple `SELECT`s to full analytical questions.

The map is in your hands. Tomorrow, we start building.

---

### Quick recap of Day 2

- **SQL** is the declarative, standard language for relational databases; engines have small dialect differences but a near-identical core.
- SQL commands fall into five families: **DDL** (structure), **DML** (data), **DQL** (reading — our main focus), **DCL** (permissions), and **TCL** (transactions).
- Every column has a **data type** — numeric (`INT`, `DECIMAL`), text (`VARCHAR`, `TEXT`), date/time (`DATE`, `DATETIME`), and boolean. Use `DECIMAL` for money, and remember `NULL` means "no value."
- You can practice in a **free online SQL playground** (no install) or install **MySQL / SQLite / PostgreSQL** locally.
- Our example database, **`online_store`**, has five connected tables: `customers`, `categories`, `products`, `orders`, and `order_items`, linked by primary and foreign keys — with `order_items` acting as a bridge between orders and products.

> **Try this before Day 3:** Look back at the five-table schema and trace one journey yourself — pick a single product and, using only the foreign keys, describe the path from that product all the way to the customer who bought it. Which tables and which key columns do you pass through? Doing this on paper will make tomorrow's table-building feel obvious.

*See you on Day 3, where we finally start writing SQL.*
