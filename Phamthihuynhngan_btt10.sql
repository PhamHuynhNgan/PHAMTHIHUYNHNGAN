CREATE DATABASE [QLBH_T10]  
ON  PRIMARY  
( NAME = 'QuanlyBH_T10', FILENAME = 'D:\monsodulieu\QLBHT10.mdf' , SIZE = 4048KB , MAXSIZE = 
10240KB , FILEGROWTH = 20%) 
 LOG ON  
( NAME = 'QLBHT10_log', FILENAME = 'D:\monsodulieu\QLBHT10_log.ldf' , SIZE = 1024KB , MAXSIZE = 
10240KB , FILEGROWTH = 10%) 
GO 
 
use QLBH_T10
GO 

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(255))

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    CategoryID INT,
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(10, 2),
    UnitsInStock INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID))

CREATE TABLE Customers (
    CustomerID NVARCHAR(50) PRIMARY KEY,
    CompanyName NVARCHAR(100),
    City NVARCHAR(50))

create table Employees
(EmployeeID int primary key,
LastName nvarchar(255) not null,
FirstName nvarchar(255) not null,
BirthDate Date,
City nvarchar(255))

create table Orders
(OrderID int  primary key,
CustomerID  NVARCHAR(50),
EmployeeID int,
OrderDate Datetime,
ShipCity NVARCHAR(50),
foreign key (CustomerID) references Customers(CustomerID),
foreign key (EmployeeID) references Employees(EmployeeID))

create table OrdersDetails
(OrderID int,
ProductID int,
UnitPrice decimal(18, 2) not null,
Quantity int not null,
Discount decimal(4, 2) default 0,
primary key (OrderID, ProductID),
foreign key (OrderID) references Orders(OrderID),
foreign key (ProductID) references Products(ProductID))

INSERT INTO Categories (CategoryID, CategoryName, Description)
VALUES 
(1, N'Đồ uống', N'Các loại nước giải khát'),
(2, N'Hải sản', N'Các loại cá và hải sản khác'),
(3, N'Hoa quả', N'Các loại hoa quả tươi ngon');


INSERT INTO Products (ProductID, ProductName, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)
VALUES 
(1, N'Trà Chanh', 1, N'10 hộp ', 18.00, 39),
(2, N'Siro', 1, N'12 chai', 10.00, 17),
(3, N'Cá Ngừ', 2, N'10 con', 5.50, 50);

INSERT INTO Customers (CustomerID, CompanyName, City)
VALUES 
(N'C1', N'Cty ABC', N'Londons'),
(N'C2', N'Cty MY', N'Madrid'),
(N'C3', N'Cty BMH', N'Berlin');

INSERT INTO Employees (EmployeeID, LastName, FirstName, BirthDate, City)
VALUES 
(11, N'Nguyễn', N'San', '1980-01-01', N'Londons'),
(12, N'Trần', N'Yến', '1985-02-02', N'Madrid'),
(13, N'Ngô', N'Vân', '1990-03-03', N'Berlin');

INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipCity)
VALUES 
(21, N'C1', 11, '2025-04-07', N'Londons'),
(22, N'C2', 12, '2025-04-07', N'Madrid'),
(23, N'C3', 13, '2025-04-07', N'Berlin');


INSERT INTO OrdersDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES 
(21, 1, 18.00, 2, 0),
(22, 2, 10.00, 3, 0.1),
(23, 3, 5.50, 5, 0);


--câu 1:
CREATE VIEW vw_Products_Info AS
SELECT 
    c.CategoryName, 
    c.Description, 
    p.ProductName, 
    p.QuantityPerUnit, 
    p.UnitPrice, 
    p.UnitsInStock
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID;
---câu 2:
CREATE VIEW List_Product_view AS
SELECT 
    p.ProductID, 
    p.ProductName, 
    p.UnitPrice, 
    p.QuantityPerUnit,
    COUNT(od.OrderID) AS CountOfOrders
FROM 
    Products p
JOIN 
    OrdersDetails od ON p.ProductID = od.ProductID
WHERE 
    p.QuantityPerUnit LIKE '%box%' AND p.UnitPrice > 16
GROUP BY 
    p.ProductID, p.ProductName, p.UnitPrice, p.QuantityPerUnit;

---câu 3:
CREATE VIEW vw_CustomerTotals AS
SELECT 
    o.CustomerID,
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    SUM(od.UnitPrice * od.Quantity) AS TotalAmount
FROM 
    Orders o
JOIN 
    OrdersDetails od ON o.OrderID = od.OrderID
GROUP BY 
    o.CustomerID, YEAR(o.OrderDate), MONTH(o.OrderDate);

---câu 4:
CREATE VIEW vw_Employee_Orders
WITH ENCRYPTION
AS
SELECT 
    o.EmployeeID,
    YEAR(o.OrderDate) AS OrderYear,
    SUM(od.Quantity) AS sumOfOrderQuantity
FROM 
    Orders o
JOIN 
    OrdersDetails  od ON o.OrderID = od.OrderID
GROUP BY 
    o.EmployeeID, YEAR(o.OrderDate);

---câu 5:
CREATE VIEW ListCustomer_view AS
SELECT 
    o.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS CountOfOrders
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    YEAR(o.OrderDate) BETWEEN 1997 AND 1998
GROUP BY 
    o.CustomerID, c.CompanyName
HAVING 
    COUNT(o.OrderID) > 5;

---câu 6:
CREATE VIEW ListProduct_view AS
SELECT 
    c.CategoryName,
    p.ProductName,
    YEAR(o.OrderDate) AS [Year],
    SUM(od.Quantity) AS SumOfOrderQuantity
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
JOIN 
    OrdersDetails  od ON p.ProductID = od.ProductID
JOIN 
    Orders o ON od.OrderID = o.OrderID
WHERE 
    c.CategoryName IN ('Beverages', 'Seafood')
GROUP BY 
    c.CategoryName, p.ProductName, YEAR(o.OrderDate)
HAVING 
    SUM(od.Quantity) > 30;

---câu 7:

CREATE VIEW vw_OrderSummary
WITH ENCRYPTION
AS
SELECT 
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    SUM(UnitPrice * Quantity) AS OrderTotal
FROM 
    Orders o
JOIN 
    OrdersDetails  od ON o.OrderID = od.OrderID
GROUP BY 
    YEAR(OrderDate), MONTH(OrderDate);

---câu 8:
CREATE VIEW dbo.vwProducts
WITH SCHEMABINDING
AS
SELECT 
    p.ProductID, 
    p.ProductName, 
    od.Discount
FROM 
    dbo.Products p
JOIN 
    dbo.OrdersDetails  od ON p.ProductID = od.ProductID;
----Khi dùng WITH SCHEMABINDING, không thể xóa cột Discount trong bảng nếu view này đang tồn tại, vì view đang phụ thuộc vào cấu trúc bảng đó.
---câu 9:
CREATE VIEW vw_Customer
AS
SELECT 
    CustomerID, CompanyName, City
FROM 
    Customers
WHERE 
    City IN ('London', 'Madrid')
WITH CHECK OPTION;
----(a) Nếu bạn chèn khách hàng không thuộc London/Madrid, sẽ bị lỗi.
----(b) Nếu chèn khách hàng ở London/Madrid, thì được phép.
---câu 10:
CREATE TABLE KhachHang_Bac (
    MaKH NVARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100),
    DiaChi NVARCHAR(100),
    KhuVuc NVARCHAR(20) CHECK (KhuVuc = 'Bac Bo'))

CREATE TABLE KhachHang_Trung (
    MaKH NVARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100),
    DiaChi NVARCHAR(100),
    KhuVuc NVARCHAR(20) CHECK (KhuVuc = 'Trung Bo'))

CREATE TABLE KhachHang_Nam (
    MaKH NVARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100),
    DiaChi NVARCHAR(100),
    KhuVuc NVARCHAR(20) CHECK (KhuVuc = 'Nam Bo'))

CREATE VIEW vw_KhachHang_ALL AS
SELECT * FROM KhachHang_Bac
UNION ALL
SELECT * FROM KhachHang_Trung
UNION ALL
SELECT * FROM KhachHang_Nam;

---câu 11:
-- a. Sản phẩm có chữ 'Boxes'
CREATE VIEW vw_Boxes AS
SELECT * FROM Products
WHERE QuantityPerUnit LIKE '%Boxes%';

-- b. Đơn giá < 10
CREATE VIEW vw_PriceUnder10 AS
SELECT * FROM Products
WHERE UnitPrice < 10;

-- c. Đơn giá lớn hơn trung bình
CREATE VIEW vw_PriceAboveAvg AS
SELECT * FROM Products
WHERE UnitPrice >= (SELECT AVG(UnitPrice) FROM Products);

-- d. Khách hàng và hóa đơn
CREATE VIEW View_CustomerOrders AS
SELECT 
    c.CustomerID, 
    c.CompanyName, 
    o.OrderID, 
    od.ProductID, 
    od.Quantity
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrdersDetails od ON o.OrderID = od.OrderID;


----View nào có thể INSERT/UPDATE/DELETE:

---Các view đơn giản như vw_Under10, vw_BoxesProducts có thể thực hiện được.
---View có JOIN, GROUP BY, HAVING hoặc DISTINCT thì không thể chỉnh sửa trực tiếp.
---phần index:
---câu 1:
CREATE CLUSTERED INDEX IX_Orders_CustomerID ON Orders(CustomerID);

---câu 2:
CREATE NONCLUSTERED INDEX IX_Orders_EmployeeID
ON Orders(EmployeeID);

---câu 3:
ALTER TABLE Orders ADD DiemTL INT;
CREATE UNIQUE INDEX IX_Orders_DiemTL ON Orders(DiemTL);
---Nếu nhập 2 hóa đơn có cùng DiemTL → Bị lỗi, vì UNIQUE yêu cầu giá trị duy nhất.
---câu 4:
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON Orders(OrderDate);

---câu 5:
CREATE NONCLUSTERED INDEX IX_Products_ProductID
ON Products(ProductID);


