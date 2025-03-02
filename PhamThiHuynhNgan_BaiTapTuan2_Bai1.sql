--Bai 1:
CREATE DATABASE QLBH002

GO

USE QLBH002

GO

CREATE TABLE NhomSanPham 
(   MaNhom INT PRIMARY KEY NOT NULL,
    TenNhom NVARCHAR(15) );

CREATE TABLE NhaCungCap 
(   MaNCC INT PRIMARY KEY,
    TenNCC NVARCHAR(50) NOT NULL,
    DiaChi NVARCHAR(100),
    Phone NVARCHAR(15),
    SoFax NVARCHAR(15),
    DCMail NVARCHAR(50));

CREATE TABLE SanPham 
(   MASP INT PRIMARY KEY NOT NULL,
    TENSP NVARCHAR(40) NOT NULL,
	MaNCC INT,
    MoTa NVARCHAR(50),
    MANHOM INT,
    DONVITINH NVARCHAR(20),
    Giagoc MONEY CHECK (Giagoc > 0),
    SLTON INT CHECK (SLTON > 0),    
    FOREIGN KEY (MANHOM) REFERENCES NhomSanPham(MANHOM),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC));

CREATE TABLE HOADON
(	MAHD INT PRIMARY KEY NOT NULL,
	NgayLapHD Datetime default getdate() check (NgayLapHD >= Getdate()),
	ngaygiao datetime,
	Noichuyen NVarchar(60) not null,
	MaKh nchar(05)
	FOREIGN KEY (MaKh) REFERENCES KhachHang(MaKH));

CREATE TABLE CT_HoaDon
(	MaHD INT  NOT NULL,
	MaSP INT NOT NULL,
	Soluong smallint check (Soluong > 0),
	Dongia money,
	ChietKhau Money check (ChietKhau >=0),
	primary key ( MaHD, MaSP),
	foreign key (MaHD) REFERENCES HOADON (MaHD),
	foreign key (MaSP) references SanPham(MaSP));


CREATE TABLE KhachHang
(	MaKH Nchar(5) primary key not null,
	TenKH Nvarchar(40) not null,
	LoaiKH Nvarchar(3) Check (LoaiKH in ('VIP','TV','VL')),
	Diachi nvarchar(60),
	Phone nvarchar(24),
	SoFax nvarchar(24),
	DcMail nvarchar (50),
	DiemTL Int check (DiemTL >= 0));

CREATE TABLE NhanVien 
(
    MaNV INT PRIMARY KEY NOT NULL,
    TenNV NVARCHAR(50) NOT NULL,
    DiaChi NVARCHAR(100),
    DienThoai NVARCHAR(15));

ALTER TABLE HOADON 
ADD MaNV INT,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV);
GO