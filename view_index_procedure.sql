-- =====================================================
-- [Bài tập] View, Index, Store Procedure
-- =====================================================

-- -----------------------------------------------------
-- BƯỚC 1 + 2: Tạo CSDL và bảng Products
-- -----------------------------------------------------
DROP DATABASE IF EXISTS demo_db;
CREATE DATABASE demo_db;
USE demo_db;

CREATE TABLE Products (
    Id                 INT AUTO_INCREMENT PRIMARY KEY,
    productCode        VARCHAR(20)  NOT NULL,
    productName        VARCHAR(100) NOT NULL,
    productPrice       DECIMAL(15,2) NOT NULL,
    productAmount      INT NOT NULL,
    productDescription TEXT,
    productStatus      VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Dữ liệu mẫu
INSERT INTO Products
(productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES
('P001', 'iPhone 15',        25000000, 50,  'Điện thoại Apple', 'ACTIVE'),
('P002', 'Samsung S24',      22000000, 40,  'Điện thoại Samsung', 'ACTIVE'),
('P003', 'Xiaomi 14',        15000000, 100, 'Điện thoại Xiaomi', 'ACTIVE'),
('P004', 'MacBook Pro M3',   45000000, 20,  'Laptop Apple', 'ACTIVE'),
('P005', 'Dell XPS 15',      38000000, 30,  'Laptop Dell', 'INACTIVE'),
('P006', 'iPad Air',         18000000, 60,  'Máy tính bảng Apple', 'ACTIVE');

-- -----------------------------------------------------
-- BƯỚC 3: INDEX
-- -----------------------------------------------------

-- 3.1. Truy vấn TRƯỚC khi tạo Index
EXPLAIN
SELECT * FROM Products WHERE productCode = 'P001';

EXPLAIN
SELECT * FROM Products
WHERE productName = 'iPhone 15' AND productPrice = 25000000;

-- 3.2. Tạo Unique Index trên productCode
CREATE UNIQUE INDEX idx_product_code ON Products(productCode);

-- 3.3. Tạo Composite Index trên (productName, productPrice)
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- 3.4. Truy vấn SAU khi tạo Index
EXPLAIN
SELECT * FROM Products WHERE productCode = 'P001';

EXPLAIN
SELECT * FROM Products
WHERE productName = 'iPhone 15' AND productPrice = 25000000;

-- Xem danh sách Index
SHOW INDEX FROM Products;

-- -----------------------------------------------------
-- BƯỚC 4: VIEW
-- -----------------------------------------------------

-- 4.1. Tạo view
CREATE VIEW product_view AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Truy vấn view
SELECT * FROM product_view;

-- 4.2. Sửa view (thêm cột productAmount)
CREATE OR REPLACE VIEW product_view AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products
WHERE productStatus = 'ACTIVE';

-- Truy vấn view sau khi sửa
SELECT * FROM product_view;

-- 4.3. Xóa view
DROP VIEW product_view;

-- -----------------------------------------------------
-- BƯỚC 5: STORE PROCEDURE
-- -----------------------------------------------------
DELIMITER //

-- 5.1. Lấy tất cả sản phẩm
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

-- 5.2. Thêm sản phẩm mới
CREATE PROCEDURE addProduct(
    IN p_code        VARCHAR(20),
    IN p_name        VARCHAR(100),
    IN p_price       DECIMAL(15,2),
    IN p_amount      INT,
    IN p_description TEXT,
    IN p_status      VARCHAR(20)
)
BEGIN
    INSERT INTO Products
    (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_description, p_status);
END //

-- 5.3. Sửa sản phẩm theo Id
CREATE PROCEDURE updateProduct(
    IN p_id          INT,
    IN p_name        VARCHAR(100),
    IN p_price       DECIMAL(15,2),
    IN p_amount      INT,
    IN p_description TEXT,
    IN p_status      VARCHAR(20)
)
BEGIN
    UPDATE Products
    SET productName        = p_name,
        productPrice       = p_price,
        productAmount      = p_amount,
        productDescription = p_description,
        productStatus      = p_status
    WHERE Id = p_id;
END //

-- 5.4. Xóa sản phẩm theo Id
CREATE PROCEDURE deleteProduct(IN p_id INT)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;

-- -----------------------------------------------------
-- DEMO GỌI STORE PROCEDURE
-- -----------------------------------------------------
CALL getAllProducts();

CALL addProduct('P007', 'OPPO Find X', 20000000, 25, 'Điện thoại OPPO', 'ACTIVE');

CALL updateProduct(1, 'iPhone 15 Pro', 28000000, 45, 'Điện thoại Apple Pro', 'ACTIVE');

CALL deleteProduct(6);

CALL getAllProducts();
