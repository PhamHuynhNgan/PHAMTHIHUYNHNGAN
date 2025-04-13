CREATE DATABASE QLBH_T9 
ON  PRIMARY  
( NAME = 'QLBH', FILENAME = 'D:\monsodulieu\QLBH.mdf' , SIZE = 4048KB , MAXSIZE = 
10240KB , FILEGROWTH = 20%) 
 LOG ON  
( NAME = 'QLBH_log', FILENAME = 'D:\monsodulieu\QLBH_log.ldf' , SIZE = 1024KB , MAXSIZE = 
10240KB , FILEGROWTH = 10%) 
GO 
 
use QLBH_T9
GO 
--tuần 2:
-- Bảng NHOMSANPHAM
CREATE TABLE NHOMSANPHAM (
    MANHOM INT NOT NULL PRIMARY KEY,
    TENNHOM NVARCHAR(15))

-- Bảng NhaCungCap
CREATE TABLE NhaCungCap (
    MANCC INT NOT NULL PRIMARY KEY,
    TENNCC NVARCHAR(40) NOT NULL,
    DiaChi NVARCHAR(60),
    PHONE NVARCHAR(24),
    SOFAX NVARCHAR(24),
    DCMail NVARCHAR(50))


-- Bảng SANPHAM
CREATE TABLE SANPHAM (
    MASP INT NOT NULL PRIMARY KEY,
    TENSP NVARCHAR(40) NOT NULL,
    MANCC INT FOREIGN KEY REFERENCES NhaCungCap(MaNCC),
    MOTA NVARCHAR(50),
    MANHOM INT FOREIGN KEY REFERENCES NhomSanPham(MaNhom),
    DDONVITINH NVARCHAR(20),
    GIAGOC MONEY CHECK (GiaGoc > 0),
    SLTON INT CHECK (SLTON > 0))


-- Bảng HOADON
CREATE TABLE HOADON (
    MAHD INT NOT NULL,
    NGAYLAPHD DATETIME DEFAULT GETDATE(),
    NGAYGIAO DATETIME,
    NoiChuyen NVARCHAR(60) NOT NULL,
    MAKH NCHAR(5))


-- Bảng CT_HoaDon
CREATE TABLE CT_HoaDon (
    MAHD INT NOT NULL,
    MASP INT NOT NULL,
    SoLuong SMALLINT CHECK (SoLuong > 0),
    DonGia MONEY,
    ChietKhau MONEY CHECK (ChietKhau >= 0))

-- Bảng KhachHang
CREATE TABLE KhachHang (
    MAKH NCHAR(5) NOT NULL,
    TENKH NVARCHAR(40) NOT NULL,
    LoaiKh NVARCHAR(3) CHECK (LoaiKh IN ('VIP', 'TV', 'VL')),
    DIACHI NVARCHAR(60),
    PHONE NVARCHAR(24),
    SOFAX NVARCHAR(24),
    DCMail NVARCHAR(50),
    DIEMTL INT CHECK (DiemTL >= 0))


--B:
ALTER TABLE KhachHang ADD CONSTRAINT PK_KhachHang PRIMARY KEY (MAKH);
ALTER TABLE HOADON ADD CONSTRAINT PK_HoaDon PRIMARY KEY (MAHD);
ALTER TABLE CT_HoaDon ADD CONSTRAINT PK_CT_HoaDon PRIMARY KEY (MAHD, MASP);
--C:
ALTER TABLE HOADON ADD CONSTRAINT FK_HOADON_KhachHang FOREIGN KEY (MAKH) REFERENCES KhachHang(MAKH);
ALTER TABLE CT_HoaDon ADD CONSTRAINT FK_CT_HoaDon_HOADON FOREIGN KEY (MAHD) REFERENCES HoaDon(MAHD);
ALTER TABLE CT_HoaDon ADD CONSTRAINT FK_CT_HoaDon_SANPHAM FOREIGN KEY (MASP) REFERENCES SanPham(MASP);
--D:
ALTER TABLE KhachHang ADD CONSTRAINT CK_LoaiKH CHECK (LoaiKH IN ('VIP', 'TV', 'VL'));
ALTER TABLE KhachHang ADD CONSTRAINT CK_DIEMTL CHECK (DIEMTL >= 0);
ALTER TABLE SANPHAM ADD CONSTRAINT CK_GIAGOC CHECK (GIAGOC > 0);
ALTER TABLE SANPHAM ADD CONSTRAINT CK_SLTON CHECK (SLTON > 0);
ALTER TABLE CT_HoaDon ADD CONSTRAINT CK_SoLuong CHECK (SoLuong > 0);
ALTER TABLE CT_HoaDon ADD CONSTRAINT CK_ChietKhau CHECK (ChietKhau >= 0);
ALTER TABLE HOADON ADD CONSTRAINT CK_NGAYLAPHD CHECK (NGAYLAPHD >= GETDATE());
--E:
ALTER TABLE HOADON ADD LoaiHD CHAR(1) DEFAULT 'N' CHECK (LoaiHD IN ('N', 'X', 'C', 'T'));
--F:
ALTER TABLE HOADON ADD CONSTRAINT CK_HOADON_NGAYGIAO CHECK (NGAYGIAO >= NGAYLAPHD);

--tuần 9:
--bài tập 1:
--câu 1:
DELETE FROM CT_HoaDon;

DELETE FROM HOADON;

DELETE FROM SANPHAM;

DELETE FROM NhaCungCap;

DELETE FROM NHOMSANPHAM;

DELETE FROM KhachHang;

--câu 2:Trường hợp không thể xóa dữ liệu bảng SANPHAM khi chưa xóa dữ liệu bảng con của SANPHAM:
--- Khi bảng CT_HoaDon có khóa ngoại tham chiếu đến SANPHAM, nếu cố gắng xóa một sản phẩm trong SANPHAM 
---mà vẫn còn cgi tiết hóa đơn liên quan trong CT_HoaDon, hệ thống sẽ báo lỗi do vi phạm ràng buộc toàn vẹn. 
---Do đó, cần xóa dữ liệu trong CT_HoaDon trước khi xóa trong SANPHAM.

--câu 3:
---Xóa dữ liệu từ bảng con trước: Thực hiện lệnh DELETE trên bảng con trước khi xóa bảng cha
--Ví Dụ:
-- Xóa các sản phẩm của nhà cung cấp có MANCC = 1 
DELETE FROM SANPHAM WHERE MANCC = 1;

-- Sau đó, xóa nhà cung cấp
DELETE FROM NhaCungCap WHERE MANCC = 1;

--câu4:
INSERT INTO NHOMSANPHAM (MANHOM, TENNHOM) 
VALUES (1, N'Nước giải khát'),
		(2, N'Trái cây'),
		(3, N'Bánh kẹo'),
		(4, N'Rau củ'),
		(5, N'Các loại mì');

-- Bảng NhaCungCap
INSERT INTO NhaCungCap (MANCC, TENNCC, DiaChi, PHONE, SOFAX, DCMail) VALUES
(11, N'Cty ABC', N'Quận 1', '0909123456', '0812345678', 'a@ABC.com'),
(12, N'Cty XYZ', N'Quận 3', '0911223344','0498765432', 'b@XYZ.com'),
(13, N'Cty TNT', N'Quận 5', '0988123456', '0511223344', 'c@TNT.com'),
(14, N'Cty MY', N'Quận 10', '0933456789', '0710334455', 'd@MY.com'),
(15, N'Cty BMH', N'Tân Bình', '0977123456', '0613778899', 'e@BMH.com')
-- Bảng KhachHang
INSERT INTO KhachHang (MAKH, TENKH, LoaiKh, DIACHI, PHONE, SOFAX, DCMail, DIEMTL) VALUES
(21, N'Nguyễn Khánh An', 'VIP', N'Quận 12, TP.HCM', '0909112233', '0833445566', 'an@KhanhAn.com', 150),
(22, N'Trần Thị Tường Vy', 'TV', N'Quận 3, Hà Nội', '0988776655', '0488990011', '@TuongVy.com', 50),
(23, N'Lê Văn Kiệt', 'VL', N'Đường 345, Đà Nẵng', '0912345678', '0511987654', 'Van@Kiet.net', 0),
(24, N'Phạm Hoàng Thiên Ân', 'VIP', N'đường 246, Cần Thơ', '0934567890', '0710123456', 'An@ThienAn.org', 200),
(25, N'Hoàng Văn Nhật Khánh', 'TV', N'Đường 765, Biên Hòa', '0965432109', '0613654321', 'Hoang@NhatKhanh.info', 75);
--Bảng SANPHAM
INSERT INTO SANPHAM (MASP, TENSP, MANCC, MOTA, MANHOM, DDONVITINH, GIAGOC, SLTON) VALUES
(31, N'Coca Cola', 11, N'Ngot',1,  N'Lon',10000, 20 ),
(32, N'Pepsi',11, N'Ngot',1,  N'Lon',9500, 15 ),
(33, N'Mì Hảo Hảo', 15, N'Ngon',5, N'Gói', 3500, 50),
(34, N'Cần Tây', 14, N'Tuoi',4,  N'Kg',45000, 100),
(35, N'Xoài', 12, N'Chua Ngot', 2, N'Trái',55000, 30);
-- Bảng HOADON
INSERT INTO HOADON (MAHD, NGAYLAPHD, NGAYGIAO, NoiChuyen, MAKH, LoaiHD) VALUES
(41, GETDATE(), DATEADD(day, 7, GETDATE()), N'Giao hàng nhanh', 21, 'X'),
(42, GETDATE(), DATEADD(day, 3,GETDATE()), N'Kho HN',22, 'X'),
(43, GETDATE(), DATEADD(day, 5, GETDATE()), N'Nhập kho', 25, 'N'),
(44, GETDATE(), DATEADD(day, 2, GETDATE()), N'Kho DN', 23, 'X'),
(45, GETDATE(), DATEADD(day, 2, GETDATE()), N'Kho CT', 24, 'N');

-- Bảng CT_HoaDon
INSERT INTO CT_HoaDon (MAHD, MASP, SoLuong, DonGia, ChietKhau) VALUES
(41, 31, 1, 5500000, 0),
(44, 34, 2, 280000, 0.05),
(42, 33, 1, 8500000, 0.1),
(45, 35, 5, 16000, 0),
(43, 33, 3, 55000, 0);

--câu 5:
---a:thêm khách  hàng từ bảng Customers trong Northwind vào bảng KhachHang trong QLBH:
INSERT INTO KhachHang (MAKH, TENKH, LoaiKh, DIACHI, PHONE, SOFAX, DCMail, DIEMTL)
SELECT CustomerID, CompanyName, Address, Phone, Fax
FROM Northwind.dbo.Customers;

---b. Thêm sản phẩm có SupplierID từ 4 đến 29 từ bảng Products trong Northwind vào bảng SANPHAM trong QLBH:
INSERT INTO SANPHAM (MASP, TENSP, MANCC, MOTA, MANHOM, DDONVITINH, GIAGOC, SLTON)
SELECT ProductID, ProductName, SupplierID, QuantityPerUnit, CategoryID, Unit, Price, UnitsInStock
FROM Northwind.dbo.Products
WHERE SupplierID BETWEEN 4 AND 29;

---c. Thêm hóa đơn có OrderID từ 10248 đến 10350 từ bảng Orders trong Northwind vào bảng HOADON với LoaiHD là 'X':
INSERT INTO HOADON (MAHD, NGAYLAPHD, NGAYGIAO, NoiChuyen, MAKH, LoaiHD)
SELECT OrderID, OrderDate, ShippedDate, ShipAddress, CustomerID, 'X'
FROM Northwind.dbo.Orders
WHERE OrderID BETWEEN 10248 AND 10350;

---d:Thêm hóa đơn có OrderID từ 10351 đến 10446 từ bảng Orders trong Northwind vào bảng HOADON với LoaiHD là 'N':
INSERT INTO HOADON (MAHD, NGAYLAPHD, NGAYGIAO, NoiChuyen, MAKH, LoaiHD)
SELECT OrderID, OrderDate, ShippedDate, ShipAddress, CustomerID, 'N'
FROM Northwind.dbo.Orders
WHERE OrderID BETWEEN 10351 AND 10446;

---e:Thêm chi tiết hóa đơn có OrderID từ 10248 đến 10270 từ bảng Order Details trong Northwind vào bảng CT_HoaDon:
INSERT INTO CT_HoaDon (MAHD, MASP, SoLuong, DonGia, ChietKhau)
SELECT OrderID, ProductID, Quantity, UnitPrice, Discount
FROM Northwind.dbo.[Order Details]
WHERE OrderID BETWEEN 10248 AND 10270;

--bài tập 2:
---câu 1:Cập nhật đơn giá bán 100000 cho mã sản phẩm có tên bắt đầu bằng chữ T:
INSERT INTO SanPham (MASP, TENSP, MANCC, MOTA, MANHOM, DDONVITINH, GIAGOC, SLTON)
VALUES (36, N'Táo', 12, N'Ngọt', 2, N'Trái', 120000, 50)
UPDATE SanPham
SET GIAGOC = 100000
WHERE TENSP LIKE 'T%';

---câu2:Cập nhật số lượng tồn = 50% số lượng tồn hiện có cho những sản phẩm có đơn vị tính có chữ box:
INSERT INTO SanPham (MASP, TENSP, MANCC, MOTA, MANHOM, DDONVITINH, GIAGOC, SLTON)
VALUES (37, 'Box of chocolates', 14, 'Hộp sô cô la', 3, 'box', 50000, 100)
UPDATE SanPham
SET SLTON = SLTON * 0.5
WHERE DDONVITINH LIKE '%box%';

--câu3:Cập nhật mã nhà cung cấp là 1 trong bảng NHACUNGCAP thành 100? Bạn có cập nhật được hay không? Vì sao?:

---Không thể cập nhật mã nhà cung cấp nếu có các sản phẩm đang sử dụng mã nhà cung cấp đó trong bảng SanPham do ràng buộc khóa ngoại.

--câu4:Tăng điểm tích lũy lên 100 cho những khách hàng mua hàng trong tháng 7 năm 1997:
INSERT INTO KhachHang (MAKH, TENKH, LoaiKh, DIACHI, PHONE, SOFAX, DCMail, DIEMTL)
VALUES (26, N'Nguyễn Nhật Hạ', 'TV', N'đường 777, Hà Nội', '0912345678', '0912345678', 'A@NhatHa.com', 30);

INSERT INTO HoaDon (MAHD, NGAYLAPHD, NGAYGIAO, NoiChuyen, MAKH, LoaiHD)
VALUES (46, '1997-07-20', '1997-07-25', 'Hanoi', 'KH002', 'N');

UPDATE KhachHang
SET DIEMTL = 100
WHERE MAKH IN (SELECT MAKH FROM HoaDon WHERE NGAYLAPHD BETWEEN '1997-07-01' AND '1997-07-31');

--câu 5:Giảm 10% đơn giá bán cho những sản phẩm có số lượng tồn < 10:
INSERT INTO SanPham (MASP, TENSP, MANCC, MOTA, MANHOM, DDONVITINH, GIAGOC, SLTON)
VALUES (38, N'Bánh Gạo', 13, N'Ngon', 3, N'Hộp', 5000, 5)

UPDATE SanPham
SET GIAGOC = GIAGOC * 0.9
WHERE SLTON < 10;

--câu 6:Cập nhật giá bán trong bảng CT_HoaDon bằng với đơn giá mua trong bảng SanPham của các sản phẩm do nhà cung cấp có mã là 4 hay 7:

UPDATE CT_HoaDon
SET DonGia = SP.GIAGOC
FROM CT_HoaDon CHD
JOIN SanPham SP ON CHD.MASP = SP.MASP
WHERE SP.MANCC IN (14, 17);
--bài tập 3:
--câu 1:Xóa các hóa đơn được lập trong tháng 7 năm 1996. Bạn có thể thực hiện được không? Vì sao?:
---Việc xóa các hóa đơn trong tháng 7 năm 1996 sẽ không thực hiện được nếu có các chi tiết hóa đơn (trong bảng CT_HoaDon) liên quan, vì ràng buộc khóa ngoại từ bảng CT_HoaDon tới bảng HoaDon.

--câu2:Xóa các hóa đơn của các khách hàng có loại là VL mua hàng trong năm 1996:

DELETE FROM CT_HoaDon
WHERE MAHD IN (SELECT MAHD FROM HoaDon WHERE MAKH IN (SELECT MAKH FROM KhachHang WHERE LoaiKh = 'VL') AND YEAR(NGAYLAPHD) = 1996);

--câu 3:Xóa các sản phẩm chưa bán được trong năm 1996:
DELETE FROM SanPham
WHERE MASP NOT IN (SELECT MASP FROM CT_HoaDon WHERE MAHD IN (SELECT MAHD FROM HoaDon WHERE YEAR(NGAYLAPHD) = 1996));

--câu 4:Xóa các khách hàng vãng lai. Lưu ý khi xóa xong thì phải xóa luôn các hóa đơn và các chi tiết của các hóa đơn này trong bảng HoaDon và bảng CTHoaDon:
DELETE FROM CT_HoaDon WHERE MAHD IN (SELECT MAHD FROM HoaDon WHERE MAKH IN (SELECT MAKH FROM KhachHang WHERE LoaiKh = 'VL'));
DELETE FROM HoaDon WHERE MAKH IN (SELECT MAKH FROM KhachHang WHERE LoaiKh = 'VL');
DELETE FROM KhachHang WHERE LoaiKh = 'VL';

--câu5:Tạo bảng HoaDon797 chứa các hóa đơn được lập trong tháng 7 năm 1997. Sau đó xóa toàn bộ dữ liệu của bảng này bằng lệnh Truncate:
SELECT * INTO HoaDon797
FROM HoaDon
WHERE MONTH(NGAYLAPHD) = 7 AND YEAR(NGAYLAPHD) = 1997;

TRUNCATE TABLE HoaDon797;