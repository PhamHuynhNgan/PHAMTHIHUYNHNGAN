use QLBH_T6
GO 
-- Chèn dữ liệu vào bảng Suppliers
INSERT INTO Suppliers (SupplierName) VALUES
('CongTyDFR'),
('CongTyGHT'),
('CongTYMTH');

-- Chèn dữ liệu vào bảng Products
INSERT INTO Products (ProductName, SupplierID, UnitPrice, UnitInStock) VALUES
('BanChai', 1, 18.00, 100),
('Bongchuyen', 1, 19.00, 150),
('Kemdanhrang', 1, 10.00, 200),
('Bongban', 2, 21.35, 50),
('Tugo', 3, 25.00, 300);

-- Chèn dữ liệu vào bảng Customers
INSERT INTO Customers (CompanyName, Address, City, Region, Country) VALUES
('Hoang Anh', 'duong 57', 'Berlin', NULL, 'Germany'),
('Kim Huu', ' duong 58', 'Mexico City', NULL, 'Mexico'),
('Thanh Duy', 'duong 37', 'Madrid', NULL, 'Spain'),
('Tuan Khai', 'duong 22', 'Strasbourg', NULL, 'France');

-- Chèn dữ liệu vào bảng Employees
INSERT INTO Employees (LastName, FirstName, BirthDate, City) VALUES
('Nguyen', 'Ngoc', '1948-12-08', 'Seattle'),
('Le', 'Ngan', '1952-02-19', 'Tacoma'),
('Vo', 'Tan', '1963-08-30', 'Kirkland');

-- Chèn dữ liệu vào bảng Orders
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate) VALUES
(9, 9, '1996-07-04'),
(10, 10, '1996-07-05'),
(11, 11, '1996-07-08'),
(12, 12, '1996-07-10');

-- Chèn dữ liệu vào bảng OrdersDetails
INSERT INTO OrdersDetails (OrderID, ProductID, UnitPrice, Quantity, Discount) VALUES
(22, 6, 18.00, 10, 0),
(23, 7, 19.00, 5, 0),
(24, 8, 10.00, 7, 0.1),
(25, 9, 21.35, 12, 0.05);

--tuần 7
-- 1. Danh sách các hóa đơn và tổng tiền của từng hóa đơn
SELECT o.OrderID, o.OrderDate, 
       SUM(od.Quantity * od.UnitPrice) AS TotalAccount
FROM Orders o
JOIN OrdersDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate;

-- 2. Danh sách hóa đơn có ShipCity là 'Madrid' với tổng tiền từng hóa đơn
INSERT INTO Customers (CompanyName, Address, City, Region, Country, ContactTitle, Phone, Fax)
VALUES ('Nhat Ha', 'so 234 duong Truong Chinh' , 'Madrid', 'KH', 'VietNam', 'CEO', '01354672894', '9873645')
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate) VALUES (8, 8, '1997-12-23')
INSERT INTO Employees (LastName, FirstName, BirthDate, City, Phone) VALUES ('Nguyen', 'Anh', '1990-02-03', 'Khanh Hoa', '0198376456')

SELECT O.OrderID, O.OrderDate, SUM(OD.Quantity * OD.UnitPrice) AS TotalAccount
FROM Orders O, OrdersDetails OD, Customers C
WHERE O.OrderID = OD.OrderID 
AND O.CustomerID = C.CustomerID 
AND C.City = 'Madrid'
GROUP BY O.OrderID, O.OrderDate;

-- 3. Sản phẩm có tổng số lượng bán nhiều nhất
SELECT TOP 1 p.ProductID, p.ProductName, 
            SUM(od.Quantity) AS CountOfOrders
FROM OrdersDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY CountOfOrders DESC;

-- 4. Số hóa đơn của mỗi khách hàng
SELECT c.CustomerID, c.CompanyName, 
       COUNT(o.OrderID) AS CountOfOrder
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName;

-- 5. Số hóa đơn và tổng tiền của mỗi nhân viên
SELECT e.EmployeeID, e.LastName, e.FirstName, 
       COUNT(o.OrderID) AS CountOfOrders, 
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrdersDetails od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.LastName, e.FirstName;

-- 6. Bảng lương nhân viên theo từng tháng năm 1996
SELECT e.EmployeeID, e.LastName + ' ' + e.FirstName AS EmployeeName, 
       MONTH(o.OrderDate) AS Month_Salary, 
       SUM(od.Quantity * od.UnitPrice) * 0.1 AS Salary
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrdersDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY e.EmployeeID, e.LastName, e.FirstName, MONTH(o.OrderDate)
ORDER BY Month_Salary, Salary DESC;

-- 7. Khách hàng có tổng tiền hóa đơn từ 31/12/1996 đến 1/1/1998 và tổng tiền > 20000
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate)
VALUES
(8, 11, '1997-01-15'),
(9, 12, '1997-06-20'),
(10, 13, '1997-09-10'),
(11, 14, '1997-07-18');
INSERT INTO OrdersDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES
(26, 7, 100.00, 250, 0),
(27, 8, 200.00, 100, 0),
(28, 9, 150.00, 180, 0),
(29, 10, 120.00, 210, 0);

SELECT c.CustomerID, c.CompanyName, 
       SUM(od.Quantity * od.UnitPrice) AS TotalAccount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrdersDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-12-31' AND '1998-01-01'
GROUP BY c.CustomerID, c.CompanyName
HAVING SUM(od.Quantity * od.UnitPrice) > 20000;

-- 8. Khách hàng với tổng số hóa đơn và tổng tiền hóa đơn trong khoảng thời gian trên
SELECT c.CustomerID, c.CompanyName, 
       COUNT(o.OrderID) AS TotalOrders,
       SUM(od.Quantity * od.UnitPrice) AS TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrdersDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-12-31' AND '1998-01-01'
GROUP BY c.CustomerID, c.CompanyName
HAVING SUM(od.Quantity * od.UnitPrice) > 20000
ORDER BY c.CustomerID, TotalAmount DESC;

-- 9. Danh sách Category có tổng số lượng tồn > 300 và đơn giá trung bình < 25
SELECT p.SupplierID AS CategoryID, s.SupplierName AS CategoryName,
       SUM(p.UnitInStock) AS Total_UnitsInStock,
       AVG(p.UnitPrice) AS Average_UnitPrice
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SuppliersID
GROUP BY p.SupplierID, s.SupplierName
HAVING SUM(p.UnitInStock) > 300 AND AVG(p.UnitPrice) < 25;

-- 10. Loại sản phẩm có tổng số sản phẩm < 10
SELECT p.SupplierID AS CategoryID, s.SupplierName AS CategoryName,
       COUNT(p.ProductID) AS TotalOfProducts
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SuppliersID
GROUP BY p.SupplierID, s.SupplierName
HAVING COUNT(p.ProductID) < 10
ORDER BY CategoryName, TotalOfProducts DESC;

-- 11. Sản phẩm bán trong quý 1 năm 1998 có tổng số lượng > 200
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate)
VALUES
(9, 11, '1998-01-10'),
(10, 12, '1998-02-15'),
(11, 13, '1998-03-20'),
(12, 14, '1998-03-25');

INSERT INTO OrdersDetails (OrderID, ProductID, UnitPrice, Quantity)
VALUES
(30, 7 , 50.00, 220), 
(31, 8, 30.00, 250),  
(32, 9, 40.00, 180),  
(33, 10, 60.00, 300);  

SELECT p.ProductID, p.ProductName, 
       SUM(od.Quantity) AS SumOfQuantity
FROM OrdersDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 1998 AND MONTH(o.OrderDate) BETWEEN 1 AND 3
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 200;

-- 12. Tổng tiền hóa đơn của mỗi khách hàng theo tháng
SELECT c.CustomerID, c.CompanyName, 
       FORMAT(o.OrderDate, 'MM/yyyy') AS Month_Year, 
       SUM(od.Quantity * od.UnitPrice) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrdersDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName, FORMAT(o.OrderDate, 'MM/yyyy');

-- 13. Nhân viên bán được nhiều tiền nhất trong tháng 7 năm 1997
SELECT TOP 1 e.EmployeeID, e.LastName, e.FirstName, 
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrdersDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 7
GROUP BY e.EmployeeID, e.LastName, e.FirstName
ORDER BY TotalSales DESC;

-- 14. Top 3 khách hàng có nhiều đơn hàng nhất năm 1996
SELECT TOP 3 c.CustomerID, c.CompanyName, 
            COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY c.CustomerID, c.CompanyName
ORDER BY OrderCount DESC;

-- 15. Tổng số hóa đơn và tổng tiền của mỗi nhân viên trong tháng 3/1997 có tổng tiền > 4000
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate)
VALUES
(9, 11, '1997-03-05'),
(10, 12, '1997-03-10'),
(11, 13, '1997-03-15'),
(12, 14, '1997-03-20');

INSERT INTO OrdersDetails (OrderID, ProductID, UnitPrice, Quantity)
VALUES
(34, 7, 50.00, 100),  
(35, 8, 30.00, 150),  
(36, 9, 40.00, 50),   
(37, 10, 60.00, 80);   
SELECT e.EmployeeID, e.LastName, e.FirstName, 
       COUNT(o.OrderID) AS CountOfOrderID, 
       SUM(od.Quantity * od.UnitPrice) AS SumOfTotal
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrdersDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 3
GROUP BY e.EmployeeID, e.LastName, e.FirstName
HAVING SUM(od.Quantity * od.UnitPrice) > 4000;

