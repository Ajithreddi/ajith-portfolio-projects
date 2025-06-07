-- Task 1: Creating a Database and Table

CREATE DATABASE Product_db;
USE Product_db;

CREATE TABLE products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Category VARCHAR(30) DEFAULT 'General',
    Price DECIMAL(10 , 2 ),
    StockQuantity INT NOT NULL,
    ManufactureDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    SupplierName VARCHAR(50)
);

DROP TABLE products;

SELECT 
    *
FROM
    products;
    
-- Task 2: Modifying the Table with ALTER Command Step 1: Add a Column, Add a column named Description to the Products table.  

ALTER TABLE products ADD COLUMN Description VARCHAR(100);

ALTER TABLE products MODIFY COLUMN SupplierName VARCHAR(70);

ALTER TABLE products MODIFY COLUMN Category VARCHAR(50) DEFAULT 'General';

ALTER TABLE products DROP COLUMN ExpiryDate;

ALTER TABLE products MODIFY COLUMN ProductName VARCHAR(50) unique;

ALTER TABLE products DROP CONSTRAINT ProductName;

describe products;

-- Rename the Rename the Price column to ProductPrice column to ProductPrice

ALTER TABLE products RENAME column Price TO ProductPrice;


INSERT INTO products (ProductName, Category, ProductPrice, StockQuantity, ManufactureDate, SupplierName, Description)
VALUES
-- Bikes
("TVS Apache RTR 160 4V", "Bikes", 129000.00, 5, "2024-08-15", "TVS Motors", "160cc bike with digital console, disc brakes, and aggressive styling"),
("KTM Duke 250", "Bikes", 240000.00, 3, "2025-02-05", "KTM India", "250cc high-performance street bike with slipper clutch and dual-channel ABS"),

-- Cars
("Mahindra XUV700 AX7", "Cars", 2250000.00, 2, "2025-03-01", "Mahindra", "SUV with ADAS, panoramic sunroof, and 7-seater configuration"),
("Honda City ZX Hybrid", "Cars", 1950000.00, 4, "2024-09-12", "Honda Motors", "Petrol-hybrid sedan with advanced safety features and infotainment"),

-- Mobiles
("OnePlus 12R", "Mobiles", 45999.00, 15, "2025-01-25", "OnePlus India", "OnePlus 12R with Snapdragon 8 Gen 2, 120Hz AMOLED, 16 GB RAM"),
("iPhone 15", "Mobiles", 79999.00, 20, "2024-10-10", "Apple Inc.", "iPhone 15 with Dynamic Island, A16 Bionic chip, 128 GB storage"),

-- Accessories
("Sony WH-1000XM5", "Accessories", 29999.00, 25, "2024-07-01", "Sony", "Wireless noise-cancelling over-ear headphones with 30-hour battery"),
("Samsung Galaxy Watch 6", "Accessories", 27999.00, 18, "2024-08-20", "Samsung", "Smartwatch with fitness tracking, AMOLED display, and 2-day battery life");
;

SELECT 
    *
FROM
    products;

UPDATE products 
SET 
    ProductName = 'TVS Apache RTR 160'
WHERE
    ProductID = 1;

DELETE FROM products 
WHERE
    ProductPrice < 100000;

ROLLBACK;