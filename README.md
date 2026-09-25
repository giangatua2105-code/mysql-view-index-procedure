# mysql-view-index-procedure
# [Bài tập] View, Index, Store Procedure

## Mô tả
Thực hành tạo Index, View và Store Procedure trên bảng `Products`.

## Cấu trúc
- `view_index_procedure.sql` — Toàn bộ bài thực hành

## Nội dung thực hành

### Bước 1 + 2: Tạo CSDL và bảng Products
Bảng gồm 7 cột: Id, productCode, productName, productPrice, productAmount, productDescription, productStatus.

### Bước 3: Index

**Tạo Unique Index trên `productCode`:**
```sql
CREATE UNIQUE INDEX idx_product_code ON Products(productCode);
