CREATE DATABASE global_electronics;
USE global_electronics;
SHOW DATABASES;
CREATE TABLE customers (
    CustomerKey INT PRIMARY KEY,
    Gender VARCHAR(20),
    Name VARCHAR(100),
    City VARCHAR(100),
    State_Code VARCHAR(20),
    State VARCHAR(100),
    Zip_Code VARCHAR(20),
    Country VARCHAR(100),
    Continent VARCHAR(100),
    Birthday DATE
);

CREATE TABLE products (
    ProductKey INT PRIMARY KEY,
    Product_Name VARCHAR(255),
    Brand VARCHAR(100),
    Color VARCHAR(100),
    Unit_Cost_USD DECIMAL(10,2),
    Unit_Price_USD DECIMAL(10,2),
    SubcategoryKey INT,
    Subcategory VARCHAR(100),
    CategoryKey INT,
    Category VARCHAR(100)
);

CREATE TABLE stores (
    StoreKey INT PRIMARY KEY,
    Country VARCHAR(100),
    State VARCHAR(100),
    Square_Meters DECIMAL(10,2),
    Open_Date DATE
);

CREATE TABLE exchange_rates (
    Rate_Date DATE,
    Currency VARCHAR(10),
    Exchange DECIMAL(15,6)
);

CREATE TABLE sales (
    Order_Number VARCHAR(50),
    Line_Item INT,
    Order_Date DATE,
    Delivery_Date DATE,
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,
    Currency_Code VARCHAR(10),
    PRIMARY KEY (Order_Number, Line_Item)
);

SHOW TABLES;

DESCRIBE customers;
DESCRIBE products;
DESCRIBE stores;
DESCRIBE exchange_rates;
DESCRIBE sales;

SHOW TABLES;
SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

USE global_electronics;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_customers
FROM customers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    CustomerKey,
    Gender,
    Name,
    City,
    State_Code,
    State,
    Zip_Code,
    Country,
    Continent,
    @Birthday
)
SET Birthday = STR_TO_DATE(@Birthday, '%c/%e/%Y');

USE global_electronics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE customers
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    CustomerKey,
    Gender,
    Name,
    City,
    State_Code,
    State,
    Zip_Code,
    Country,
    Continent,
    @Birthday
)
SET Birthday = STR_TO_DATE(TRIM(TRAILING '\r' FROM @Birthday), '%c/%e/%Y');

USE global_electronics;

ALTER TABLE customers 
MODIFY COLUMN State_Code VARCHAR(50);

SELECT CustomerKey, Name, Birthday
FROM customers
LIMIT 10;

SELECT *
FROM customers
LIMIT 10;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

USE global_electronics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Products.csv'
INTO TABLE products
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    ProductKey,
    Product_Name,
    Brand,
    Color,
    @Unit_Cost_USD,
    @Unit_Price_USD,
    SubcategoryKey,
    Subcategory,
    CategoryKey,
    Category
)
SET 
    Unit_Cost_USD  = REPLACE(REPLACE(TRIM(@Unit_Cost_USD), '$', ''), ',', ''),
    Unit_Price_USD = REPLACE(REPLACE(TRIM(@Unit_Price_USD), '$', ''), ',', '');
    
    SELECT COUNT(*) FROM products;
    
    SELECT ProductKey, Product_Name, Unit_Cost_USD, Unit_Price_USD 
    
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Stores.csv'
INTO TABLE stores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
FROM products 
LIMIT 5;

USE global_electronics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Stores.csv'
INTO TABLE stores
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    StoreKey,
    Country,
    State,
    @Square_Meters,
    @Open_Date
)
SET 
    Square_Meters = NULLIF(TRIM(@Square_Meters), ''),
    Open_Date     = STR_TO_DATE(TRIM(TRAILING '\r' FROM TRIM(@Open_Date)), '%c/%e/%Y');
    
    Select count(*) from Stores;
     Select * from Stores LIMIT 5;
     
     LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Exchange_Rates.csv'
INTO TABLE exchange_rates
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
    
    USE global_electronics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Exchange_Rates.csv'
INTO TABLE exchange_rates
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @Date,
    Currency,
    Exchange
)
SET 
    Rate_Date = STR_TO_DATE(TRIM(TRAILING '\r' FROM TRIM(@Date)), '%c/%e/%Y');
    
    SELECT COUNT(*) FROM exchange_rates;
    SELECT * FROM exchange_rates LIMIT 5;
    
    SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'stores', COUNT(*)
FROM stores

UNION ALL

SELECT 'exchange_rates', COUNT(*)
FROM exchange_rates;

SELECT COUNT(*) AS sales_before_import

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sales.csv'
INTO TABLE sales
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    Order_Number,
    Line_Item,
    @Order_Date,
    @Delivery_Date,
    CustomerKey,
    StoreKey,
    ProductKey,
    Quantity,
    Currency_Code
)
SET
    Order_Date = STR_TO_DATE(
        TRIM(TRAILING '\r' FROM @Order_Date),
        '%c/%e/%Y'
    ),
    Delivery_Date = CASE
        WHEN TRIM(TRAILING '\r' FROM @Delivery_Date) = ''
        THEN NULL
        ELSE STR_TO_DATE(
            TRIM(TRAILING '\r' FROM @Delivery_Date),
            '%c/%e/%Y'
        )
    END;
    
    SELECT COUNT(*) AS total_sales_rows
FROM sales;

SELECT
    MIN(Order_Date) AS first_order_date,
    MAX(Order_Date) AS last_order_date
FROM sales;

SELECT COUNT(*) AS missing_delivery_dates
FROM sales
WHERE Delivery_Date IS NULL;

SELECT
    Currency_Code,
    COUNT(*) AS sales_rows
FROM sales
GROUP BY Currency_Code
ORDER BY sales_rows DESC;

SELECT
    MIN(Quantity) AS minimum_quantity,
    MAX(Quantity) AS maximum_quantity,
    SUM(Quantity) AS total_quantity
FROM sales;

SELECT
    COUNT(DISTINCT Order_Number) AS unique_orders,
    COUNT(*) AS sales_rows
FROM sales;

SELECT COUNT(*) AS unmatched_customers
FROM sales s
LEFT JOIN customers c
    ON s.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL;

SELECT COUNT(*) AS unmatched_products
FROM sales s
LEFT JOIN products p
    ON s.ProductKey = p.ProductKey
WHERE p.ProductKey IS NULL;

SELECT COUNT(*) AS unmatched_stores
FROM sales s
LEFT JOIN stores st
    ON s.StoreKey = st.StoreKey
WHERE st.StoreKey IS NULL;

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'stores', COUNT(*)
FROM stores

UNION ALL

SELECT 'exchange_rates', COUNT(*)
FROM exchange_rates

UNION ALL

SELECT 'sales', COUNT(*)
FROM sales;

SELECT
    YEAR(Order_Date) AS Sales_Year,
    COUNT(DISTINCT Order_Number) AS Total_Orders
FROM sales
GROUP BY YEAR(Order_Date)
ORDER BY Sales_Year;

SELECT
    st.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM sales s
JOIN stores st
    ON s.StoreKey = st.StoreKey
GROUP BY st.Country
ORDER BY Total_Orders DESC;