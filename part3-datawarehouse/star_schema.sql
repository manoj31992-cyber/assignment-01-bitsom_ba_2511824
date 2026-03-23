-- ============================================================
-- Part 3 — Data Warehouse Star Schema
-- Source: retail_transactions.csv
-- ============================================================

-- ----------------------------------------------------------------
-- DIMENSION: dim_date
-- Derived from order dates; enables time-based slice-and-dice
-- ----------------------------------------------------------------
CREATE TABLE dim_date (
    date_key     INT         NOT NULL,   -- surrogate key: YYYYMMDD
    full_date    DATE        NOT NULL,
    year         INT         NOT NULL,
    quarter      INT         NOT NULL,
    month        INT         NOT NULL,
    month_name   VARCHAR(20) NOT NULL,
    week         INT         NOT NULL,
    day_of_month INT         NOT NULL,
    day_name     VARCHAR(20) NOT NULL,
    CONSTRAINT pk_dim_date PRIMARY KEY (date_key)
);

-- ----------------------------------------------------------------
-- DIMENSION: dim_store
-- ----------------------------------------------------------------
CREATE TABLE dim_store (
    store_key  INT          NOT NULL,
    store_name VARCHAR(100) NOT NULL,
    store_city VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_dim_store PRIMARY KEY (store_key)
);

-- ----------------------------------------------------------------
-- DIMENSION: dim_product
-- ----------------------------------------------------------------
CREATE TABLE dim_product (
    product_key  INT          NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_dim_product PRIMARY KEY (product_key)
);

-- ----------------------------------------------------------------
-- FACT TABLE: fact_sales
-- Grain: one row per transaction
-- ----------------------------------------------------------------
CREATE TABLE fact_sales (
    sales_key       INT            NOT NULL,
    date_key        INT            NOT NULL,
    store_key       INT            NOT NULL,
    product_key     INT            NOT NULL,
    customer_id     VARCHAR(20),
    units_sold      INT            NOT NULL,
    unit_price      DECIMAL(12,2)  NOT NULL,
    total_revenue   DECIMAL(14,2)  NOT NULL,   -- units_sold * unit_price (computed on load)
    CONSTRAINT pk_fact_sales  PRIMARY KEY (sales_key),
    CONSTRAINT fk_fs_date     FOREIGN KEY (date_key)    REFERENCES dim_date(date_key),
    CONSTRAINT fk_fs_store    FOREIGN KEY (store_key)   REFERENCES dim_store(store_key),
    CONSTRAINT fk_fs_product  FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);

-- ============================================================
-- DIMENSION INSERTS (cleaned / standardised data)
-- ============================================================

INSERT INTO dim_date VALUES
(20230205, '2023-02-05', 2023, 1,  2, 'February', 6,  5, 'Sunday'),
(20230220, '2023-02-20', 2023, 1,  2, 'February', 8, 20, 'Monday'),
(20230331, '2023-03-31', 2023, 1,  3, 'March',   13, 31, 'Friday'),
(20230604, '2023-06-04', 2023, 2,  6, 'June',    22,  4, 'Sunday'),
(20230809, '2023-08-09', 2023, 3,  8, 'August',  32,  9, 'Wednesday'),
(20230829, '2023-08-29', 2023, 3,  8, 'August',  35, 29, 'Tuesday'),
(20231026, '2023-10-26', 2023, 4, 10, 'October', 43, 26, 'Thursday'),
(20231118, '2023-11-18', 2023, 4, 11, 'November',46, 18, 'Saturday'),
(20231208, '2023-12-08', 2023, 4, 12, 'December',49,  8, 'Friday'),
(20231212, '2023-12-12', 2023, 4, 12, 'December',50, 12, 'Tuesday');

INSERT INTO dim_store VALUES
(1, 'Chennai Anna',    'Chennai'),
(2, 'Delhi South',     'Delhi'),
(3, 'Bangalore MG',    'Bangalore'),
(4, 'Pune FC Road',    'Pune'),
(5, 'Mumbai Central',  'Mumbai');

-- Categories standardised to Title Case; all category values normalised
INSERT INTO dim_product VALUES
(1,  'Speaker',       'Electronics'),
(2,  'Tablet',        'Electronics'),
(3,  'Phone',         'Electronics'),
(4,  'Smartwatch',    'Electronics'),
(5,  'Atta 10kg',     'Grocery'),
(6,  'Biscuits',      'Grocery'),
(7,  'Jacket',        'Clothing'),
(8,  'Jeans',         'Clothing'),
(9,  'Milk 1L',       'Grocery'),
(10, 'Saree',         'Clothing'),
(11, 'Laptop',        'Electronics'),
(12, 'Headphones',    'Electronics');

-- ============================================================
-- FACT INSERTS (10+ rows; dates normalised, categories standardised)
-- Raw issues fixed: DD/MM/YYYY → YYYY-MM-DD; 'electronics' → 'Electronics';
--                  'Groceries' → 'Grocery'
-- ============================================================
INSERT INTO fact_sales VALUES
(1,  20230829, 1, 1,  'CUST045', 3,  49262.78, 147788.34),  -- TXN5000
(2,  20231212, 1, 2,  'CUST021',11,  23226.12, 255487.32),  -- TXN5001
(3,  20230205, 1, 3,  'CUST019',20,  48703.39, 974067.80),  -- TXN5002
(4,  20230220, 2, 2,  'CUST007',14,  23226.12, 325165.68),  -- TXN5003
(5,  20230809, 3, 5,  'CUST027',12,  52464.00, 629568.00),  -- TXN5005
(6,  20231026, 4, 8,  'CUST041',16,   2317.47,  37079.52),  -- TXN5007
(7,  20231208, 3, 6,  'CUST030', 9,  27469.99, 247229.91),  -- TXN5008
(8,  20230604, 1, 7,  'CUST031',15,  30187.24, 452808.60),  -- TXN5010
(9,  20231118, 2, 7,  'CUST042', 5,  30187.24, 150936.20),  -- TXN5014
(10, 20230809, 3, 11, 'CUST044',13,  42343.15, 550461.00),  -- TXN5012
(11, 20230331, 4, 4,  'CUST025', 6,  58851.01, 353106.06),  -- TXN5006
(12, 20231212, 5, 8,  'CUST045',13,   2317.47,  30127.11);  -- TXN5011
