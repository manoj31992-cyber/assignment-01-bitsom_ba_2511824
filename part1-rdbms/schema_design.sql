-- ============================================================
-- Part 1 — RDBMS Schema Design (3NF)
-- Source: orders_flat.csv
-- ============================================================

CREATE TABLE customers (
    customer_id    VARCHAR(10)  NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL,
    customer_city  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

CREATE TABLE sales_reps (
    sales_rep_id    VARCHAR(10)  NOT NULL,
    sales_rep_name  VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(150) NOT NULL,
    office_address  VARCHAR(250) NOT NULL,
    CONSTRAINT pk_sales_reps PRIMARY KEY (sales_rep_id)
);

CREATE TABLE products (
    product_id   VARCHAR(10)   NOT NULL,
    product_name VARCHAR(100)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

CREATE TABLE orders (
    order_id     VARCHAR(15) NOT NULL,
    customer_id  VARCHAR(10) NOT NULL,
    product_id   VARCHAR(10) NOT NULL,
    quantity     INT         NOT NULL,
    order_date   DATE        NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    CONSTRAINT pk_orders   PRIMARY KEY (order_id),
    CONSTRAINT fk_ord_cust FOREIGN KEY (customer_id)  REFERENCES customers(customer_id),
    CONSTRAINT fk_ord_prod FOREIGN KEY (product_id)   REFERENCES products(product_id),
    CONSTRAINT fk_ord_srep FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- ============================================================
-- INSERTS
-- ============================================================

INSERT INTO customers VALUES
('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi'),
('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore'),
('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi'),
('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore'),
('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');

INSERT INTO sales_reps VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001');

INSERT INTO products VALUES
('P001', 'Laptop',        'Electronics', 55000.00),
('P002', 'Mouse',         'Electronics',   800.00),
('P003', 'Desk Chair',    'Furniture',    8500.00),
('P004', 'Notebook',      'Stationery',    120.00),
('P005', 'Headphones',    'Electronics',  3200.00),
('P006', 'Standing Desk', 'Furniture',   22000.00),
('P007', 'Pen Set',       'Stationery',    250.00),
('P008', 'Webcam',        'Electronics',  2100.00),
('P009', 'Monitor',       'Electronics', 18000.00);

INSERT INTO orders VALUES
('ORD1000', 'C002', 'P001', 2, '2023-05-21', 'SR03'),
('ORD1001', 'C004', 'P002', 5, '2023-02-22', 'SR03'),
('ORD1002', 'C002', 'P005', 1, '2023-01-17', 'SR02'),
('ORD1003', 'C002', 'P002', 5, '2023-09-16', 'SR01'),
('ORD1004', 'C001', 'P005', 5, '2023-11-29', 'SR01'),
('ORD1005', 'C007', 'P002', 3, '2023-10-29', 'SR02'),
('ORD1006', 'C001', 'P007', 4, '2023-12-24', 'SR01'),
('ORD1007', 'C006', 'P003', 3, '2023-04-21', 'SR01'),
('ORD1008', 'C002', 'P001', 3, '2023-02-19', 'SR02'),
('ORD1009', 'C006', 'P005', 4, '2023-01-23', 'SR02'),
('ORD1010', 'C002', 'P004', 3, '2023-10-10', 'SR01'),
('ORD1075', 'C005', 'P003', 3, '2023-04-18', 'SR03'),
('ORD1091', 'C001', 'P006', 3, '2023-07-24', 'SR01'),
('ORD1185', 'C003', 'P008', 1, '2023-06-15', 'SR03'),
('ORD1098', 'C007', 'P001', 2, '2023-10-03', 'SR03');
