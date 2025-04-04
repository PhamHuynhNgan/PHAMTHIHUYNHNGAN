-- 1. 
SELECT ProductID, ProductName, UnitPrice
FROM [OrderDetails]
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM [OrderDetails]);

-- 2. .
SELECT ProductID, ProductName, UnitPrice
FROM [OrderDetails]
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM [OrderDetails] WHERE ProductName LIKE 'N%');

-- 3. 
SELECT ProductID, ProductName, UnitPrice
FROM [OrderDetails]
WHERE ProductName LIKE 'N%' AND UnitPrice > (SELECT UnitPrice FROM [OrderDetails] WHERE ProductID != [OrderDetails].ProductID);

-- 4.
SELECT DISTINCT ProductID, ProductName, UnitPrice
FROM [OrderDetails];

-- 5. 
SELECT ProductID, ProductName, UnitPrice
FROM [Products]
WHERE UnitPrice > (SELECT MIN(UnitPrice) FROM [Products]);

-- 6. 
SELECT OrderID, CustomerID, OrderDate
FROM [Orders]
WHERE CustomerID IN (SELECT CustomerID FROM [Customers] WHERE City IN ('London', 'Madrid'));

-- 7. Danh sách các sản phẩm có đơn vị tính có chữ 'Box' và có đơn giá mua nhỏ hơn đơn giá bán trung bình của tất cả các sản phẩm.
SELECT ProductID, ProductName, UnitPrice
FROM [Products]
WHERE UnitPrice < (SELECT AVG(UnitPrice) FROM [Products]) AND UnitMeasure LIKE '%Box%';

-- 8. Danh sách các sản phẩm có số lượng bán được lớn nhất.
SELECT ProductID, ProductName, SUM(Quantity) AS TotalQuantity
FROM [OrderDetails]
GROUP BY ProductID, ProductName
ORDER BY TotalQuantity DESC
LIMIT 1;

-- 9.

SELECT c.CustomerID, c.CustomerName
FROM [Customers] c
LEFT
-- 1. 
SELECT 
    c.CustomerID AS CodeID,
    c.CompanyName + ' ' + c.ContactName AS Name,
    c.Address,
    c.Phone
FROM Customers c
UNION
SELECT 
    e.EmployeeID AS CodeID,
    e.LastName + ' ' + e.FirstName AS Name,
    e.Address,
    e.HomePhone AS Phone
FROM Employees e;

-- 2. 
SELECT 
    o.CustomerID,
    c.CompanyName,
    c.Address,
    SUM(od.Quantity * od.UnitPrice) AS Total
INTO HDKH_71997
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate BETWEEN '1997-07-01' AND '1997-07-31'
GROUP BY o.CustomerID, c.CompanyName, c.Address;

-- 3. 
    e.EmployeeID,
    e.LastName + ' ' + e.FirstName AS Name,
    e.Address,
    SUM(od.Quantity * od.UnitPrice) AS Total
INTO LuongNV
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-12-01' AND '1996-12-31'
GROUP BY e.EmployeeID, e.LastName, e.FirstName, e.Address;

-- 4.
SELECT 
    o.CustomerID,
    c.CompanyName,
    SUM(od.Quantity * od.UnitPrice) AS Total
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE s.CompanyName = 'Speedy Express' 
    AND o.ShipCountry IN ('Germany', 'USA')
    AND o.OrderDate BETWEEN '1998-01-01' AND '1998-03-31'
GROUP BY o.CustomerID, c.CompanyName;

-- 5. Pivot Query

-- a) 
SELECT empid, custid, SUM(qty) AS TotalQty
FROM dbo.HoaDonBanHang
GROUP BY empid, custid;

-- b) 
SELECT empid, A, B, C, D
FROM (
    SELECT empid, custid, qty
    FROM dbo.HoaDonBanHang
) AS D
PIVOT (
    SUM(qty)
    FOR custid IN (A, B, C, D)
) AS P;

-- c) 
SELECT empid, YEAR(orderdate) AS Year, COUNT(orderid) AS OrderCount
FROM dbo.HoaDonBanHang
GROUP BY empid, YEAR(orderdate);

-- d) 
SELECT empid, [164], [198], [223], [231], [233]
FROM (
    SELECT empid, YEAR(orderdate) AS Year, COUNT(orderid) AS OrderCount
    FROM dbo.HoaDonBanHang
    WHERE empid IN (164, 198, 223, 231, 233)
    GROUP BY empid, YEAR(orderdate)
) AS D
PIVOT (
    SUM(OrderCount)
    FOR empid IN ([164], [198], [223], [231], [233])
) AS P;
