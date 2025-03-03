--1. Dùng T-SQL tạo CSDL Movies với các tham số sau:
--▪ Tập tin Datafile có: Name: Movies_data; pathname: 
--C:\Movies\Movies_data.mdf; Size: 25 MB; Maxsize: 40 MB; FileGrowth: 1 MB. 
--▪ Tập tin Log file có: Name: Movies_log; pathname: C:\Movies\Movies_log.ldf; Size: 6 MB; Maxsize: 8 MB; FileGrowth: 1 MB
CREATE DATABASE Movies
ON PRIMARY
(
    NAME = Movies_data,
    FILENAME = 'D:\CSDL\Movies\Movies_data.mdf',
    SIZE = 25MB,
    MAXSIZE = 40MB,
    FILEGROWTH = 1MB
)
LOG ON
(
    NAME = Movies_log,
    FILENAME = 'D:\CSDL\Movies\Movies_log.ldf',
    SIZE = 6MB,
    MAXSIZE = 8MB,
    FILEGROWTH = 1MB
);
--2. Thực hiện, kiểm tra kết quả sau mỗi lần thực hiện: 
--▪ Thêm một Datafile thứ 2 có Name: Movies_data2; pathname: C:\Movies\Movies_data2.ndf; Size: 10 MB; thông số khác không cần chỉ định. 
--▪ Lần lược cấu hình CSDL Movies với chế độ single_user, restricted user, multi user. Sau đó cài đặt lại là multi_user. Nhớ dùng lệnh để kiểm tra lại.
--▪ Tăng kích cỡ của data file thứ 2 từ 10 MB lên 15 MB. Kiểm tra lại.
--▪ Cấu hình CSDL về chế độ tự động SHRINK
--▪ Phát sinh tập tin Script từ CSDL Movies, tạo script cho tất cả các đối tượng kể cả database. Lưu vào đĩa với tên là Movies.SQL.
--▪ Xoá CSDL Movies
-- Thêm data file thứ 2
ALTER DATABASE Movies
ADD FILE (
    NAME = Movies_data2,
    FILENAME = 'D:\CSDL\Movies\Movies_data2.ndf',
    SIZE = 10MB
);

-- Chuyển chế độ Single User
ALTER DATABASE Movies SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
SELECT name, user_access_desc FROM sys.databases WHERE name = 'Movies';

-- Chuyển chế độ Restricted User
ALTER DATABASE Movies SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE;
SELECT name, user_access_desc FROM sys.databases WHERE name = 'Movies';

-- Chuyển chế độ Multi User
ALTER DATABASE Movies SET MULTI_USER WITH ROLLBACK IMMEDIATE;
SELECT name, user_access_desc FROM sys.databases WHERE name = 'Movies';


-- Tăng kích thước của data file thứ 2 lên 15MB
ALTER DATABASE Movies  
MODIFY FILE (  
    NAME = Movies_data2,  
    SIZE = 15MB  
);

EXEC sp_helpdb Movies;

-- Cấu hình tự động SHRINK
ALTER DATABASE Movies  
SET AUTO_SHRINK ON;

SELECT name, is_auto_shrink_on  
FROM sys.databases  
WHERE name = 'Movies';

-- Phát sinh tập tin Script
--Mở SSMS.
--Click chuột phải vào database Movies → Tasks → Generate Scripts.
--Chọn Script entire database and all database objects.
--Chọn Save to file, đặt tên là Movies.SQL và lưu vào ổ đĩa.

-- Xoá CSDL Movies
USE master;
DROP DATABASE Movies;
--3. Mở tập tin Movies.SQL. Thực hiện: 
--▪ Bổ sung thêm câu lệnh tạo một filegroup tên là Data.
ALTER DATABASE Movies ADD FILEGROUP Data;

--▪ Hiệu chỉnh maxsize của tập tin transaction log thành 10 MB
ALTER DATABASE Movies  
MODIFY FILE (  
    NAME = Movies_log,  
    MAXSIZE = 10MB  
);

--▪ Size của tập tin datafile thứ 2 thành 10 MB.
--▪ Cho datafile thứ 2 nằm trong filegroup có tên là Data.
ALTER DATABASE Movies 
ADD FILE (
    NAME = Movies_data22,
    FILENAME = 'D:\CSDL\Movies\Movies_data22.ndf',
    SIZE = 10MB,
    FILEGROWTH = 5MB,
    MAXSIZE = UNLIMITED
) TO FILEGROUP Data;


--▪ Lưu tập tin script
--▪ Cho thực thi toàn bộ tập tin script.
--mở file trong SSMS và nhấn Execute.
--▪ Dùng sp_helpDB để kiểm tra sự tồn tại của Movies và các thông số của nó.
EXEC sp_helpdb Movies;
--4)
--Bảng Movie
-- + movie_id: Kiểu dữ liệu INT, Khóa chính
-- + title: Kiểu dữ liệu VARCHAR
-- + release_year: Kiểu dữ liệu INT
-- + category_id: Kiểu dữ liệu INT, Khóa ngoại liên kết với category.category_id
-- + director: Kiểu dữ liệu VARCHAR
-- + rating: Kiểu dữ liệu VARCHAR
-- Bảng Customer
-- + customer_id: Kiểu dữ liệu INT, Khóa chính
-- + first_name: Kiểu dữ liệu VARCHAR
-- + last_name: Kiểu dữ liệu VARCHAR
-- + email: Kiểu dữ liệu VARCHAR
-- + phone_number: Kiểu dữ liệu VARCHAR
-- + address: Kiểu dữ liệu VARCHAR
-- Bảng Category
-- + category_id: Kiểu dữ liệu INT, Khóa chính
-- + name: Kiểu dữ liệu VARCHAR
-- + description: Kiểu dữ liệu TEXT
-- Bảng Rental
-- + rental_id: Kiểu dữ liệu INT, Khóa chính
-- + customer_id: Kiểu dữ liệu INT, Khóa ngoại liên kết với customer.customer_id
-- + rental_date: Kiểu dữ liệu DATETIME
-- + return_date: Kiểu dữ liệu DATETIME
-- + total_amount: Kiểu dữ liệu DECIMAL
-- Bảng Rental_detail
-- + rental_detail_id: Kiểu dữ liệu INT, Khóa chính
-- + rental_id: Kiểu dữ liệu INT, Khóa ngoại liên kết với rental.rental_id
-- + movie_id: Kiểu dữ liệu INT, Khóa ngoại liên kết với movie.movie_id
-- + quantity: Kiểu dữ liệu INT
-- + amount: Kiểu dữ liệu DECIMAL
-- Mối quan hệ giữa các bảng và ràng buộc toàn vẹn:
-- + Movie liên kết với Category qua cột category_id.
-- + Rental liên kết với Customer qua cột customer_id.
-- + Rental_detail liên kết với Rental qua cột rental_id.
-- + Rental_detail liên kết với Movie qua cột movie_id.
--Các ràng buộc toàn vẹn:
-- + Khóa ngoại category_id trong bảng Movie phải tồn tại trong bảng Category.
-- + Khóa ngoại customer_id trong bảng Rental phải tồn tại trong bảng Customer.
-- + Khóa ngoại rental_id trong bảng Rental_detail phải tồn tại trong bảng Rental.
-- + Khóa ngoại movie_id trong bảng Rental_detail phải tồn tại trong bảng Movie.
--5)
-- Movie_num: Int, not null
EXEC sp_addtype 'Movie_num', 'int', 'NOT NULL';

-- Category_num: Int, not null
EXEC sp_addtype 'Category_num', 'int', 'NOT NULL';

-- Cust_num: Int, not null
EXEC sp_addtype 'Cust_num', 'int', 'NOT NULL';

-- Invoice_num: Int, not null
EXEC sp_addtype 'Invoice_num', 'int', 'NOT NULL';

-- Checking the created user-defined data types
SELECT *
FROM sys.types
WHERE is_user_defined = 1;


--6) 
CREATE TABLE Customer (
    Cust_num Cust_num IDENTITY(300,1) PRIMARY KEY,
    Lname VARCHAR(20) NOT NULL,
    Fname VARCHAR(20) NOT NULL,
    Address1 VARCHAR(30) NULL,
    Address2 VARCHAR(20) NULL,
    City VARCHAR(20) NULL,
    State CHAR(2) NULL,
    Zip CHAR(10) NULL,
    Phone VARCHAR(10) NOT NULL,
    Join_date SMALLDATETIME NOT NULL
);

CREATE TABLE Category (
    Category_num Category_num IDENTITY(1,1) PRIMARY KEY,
    Description VARCHAR(20) NOT NULL
);

CREATE TABLE Movie (
    Movie_num Movie_num PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Category_num Category_num NOT NULL,
    Date_purch SMALLDATETIME NULL,
    Rental_price INT NULL,
    Rating CHAR(5) NULL,
    FOREIGN KEY (Category_num) REFERENCES Category(Category_num)
);

CREATE TABLE Rental (
    Invoice_num Invoice_num PRIMARY KEY,
    Cust_num Cust_num NOT NULL,
    Rental_date SMALLDATETIME NOT NULL,
    Due_date SMALLDATETIME NOT NULL,
    FOREIGN KEY (Cust_num) REFERENCES Customer(Cust_num)
);

CREATE TABLE Rental_Detail (
    Invoice_num Invoice_num NOT NULL,
    Line_num INT NOT NULL,
    Movie_num Movie_num NOT NULL,
    Rental_price SMALLMONEY NOT NULL,
    PRIMARY KEY (Invoice_num, Line_num),
    FOREIGN KEY (Invoice_num) REFERENCES Rental(Invoice_num),
    FOREIGN KEY (Movie_num) REFERENCES Movie(Movie_num)
);

EXEC sp_help 'Customer';
EXEC sp_help 'Category';
EXEC sp_help 'Movie';
EXEC sp_help 'Rental';
EXEC sp_help 'Rental_Detail';

--7. Thực hiện phát sinh tập tin script cho CSDL Movies với các lựa chọn sau, lưu với tên Table.sql:
--▪ All Tables, All user-defined data types
--▪ Generate the CREATE <object> command for each object
--▪ Generate the DROP <object> command for each object

--Nhấp chuột phải vào CSDL Movies, chọn Tasks → Generate Scripts....
--Trong cửa sổ Generate and Publish Scripts, chọn Next.
--Chọn Specific database objects, đánh dấu:
--All Tables
--All User-defined Data Types
--Nhấn Next, chọn Advanced và đặt các tùy chọn:
--Generate Script for Dependent Objects → True
--Script DROP and CREATE → Script DROP and CREATE
--Script Data → False (chỉ tạo lệnh CREATE TABLE, không tạo dữ liệu)
--Chọn Save to file, đặt tên là Table.sql, chọn đường dẫn lưu.
--Nhấn Next → Finish để hoàn thành.

--8. Thực hiện tạo Diagram cho các bảng trong Movies. Bạn có tạo được không? Tại sao? Tạm thời lưu diagram với tên là 

--Có tạo được Diagram cho CSDL Movies.

--Tại sao có thể tạo được Diagram?
--Vì: 
--Đã bật tính năng Database Diagrams trong SQL Server.
--Có quyền quản trị (db_owner) hoặc đủ quyền để tạo Diagram.Các bảng (Customer, Category, Movie, Rental, Rental_Detail) đã được tạo và có ràng buộc khóa chính (PK) & khóa ngoại (FK).
--Tạm thời lưu Diagram với tên là Movies
--Nhấn Ctrl + S hoặc bấm Save.
--Đặt tên Movies → Nhấn OK.

--9 
-- Thiết lập Primary Key cho bảng Movie
ALTER TABLE Movie 
ADD CONSTRAINT PK_movie PRIMARY KEY (Movie_num);

-- Thiết lập Primary Key cho bảng Customer
ALTER TABLE Customer 
ADD CONSTRAINT PK_customer PRIMARY KEY (Cust_num);

-- Thiết lập Primary Key cho bảng Category
ALTER TABLE Category 
ADD CONSTRAINT PK_category PRIMARY KEY (Category_num);


-- Thiết lập Primary Key cho bảng Rental
ALTER TABLE Rental 
ADD CONSTRAINT PK_rental PRIMARY KEY (Invoice_num);

-- Kiểm tra Primary Key của từng bảng
EXEC sp_helpconstraint 'Movie';
EXEC sp_helpconstraint 'Customer';
EXEC sp_helpconstraint 'Category';
EXEC sp_helpconstraint 'Rental';

--10
ALTER TABLE Movie 
ADD CONSTRAINT FK_movie FOREIGN KEY (Category_num) 
REFERENCES Category(Category_num);

ALTER TABLE Rental 
ADD CONSTRAINT FK_rental FOREIGN KEY (Cust_num) 
REFERENCES Customer(Cust_num);

ALTER TABLE Rental_Detail 
ADD CONSTRAINT FK_detail_invoice FOREIGN KEY (Invoice_num) 
REFERENCES Rental(Invoice_num) 
ON DELETE CASCADE;

ALTER TABLE Rental_Detail 
ADD CONSTRAINT FK_detail_movie FOREIGN KEY (Movie_num) 
REFERENCES Movie(Movie_num);

-- Kiểm tra ràng buộc khóa ngoại trong từng bảng
EXEC sp_helpconstraint 'Movie';
EXEC sp_helpconstraint 'Rental';
EXEC sp_helpconstraint 'Rental_Detail';
-- 11)
--Khóa chính của các bảng:
-- + Movie: Movie_num
-- + Category: Category_num
-- + Customer: Cust_num
-- + Rental: Invoice_num
-- + Rental_Detail: Invoice_num, Line_num
-- Mối quan hệ giữa các bảng:
-- + Movie - Category: Movie.Category_num là khóa ngoại tham chiếu Category.Category_num.
-- + Rental_Detail - Movie: Rental_Detail.Movie_num là khóa ngoại tham chiếu Movie.Movie_num.
-- + Rental_Detail - Rental: Rental_Detail.Invoice_num là khóa ngoại tham chiếu Rental.Invoice_num.
-- + Rental - Customer: Rental.Cust_num là khóa ngoại tham chiếu Customer.Cust_num.

--12

ALTER TABLE Movie 
ADD CONSTRAINT DK_movie_date_purch 
DEFAULT (GETDATE()) FOR Date_purch;

ALTER TABLE Customer 
ADD CONSTRAINT DK_customer_join_date 
DEFAULT (GETDATE()) FOR Join_date;

ALTER TABLE Rental 
ADD CONSTRAINT DK_rental_rental_date 
DEFAULT (GETDATE()) FOR Rental_date;

ALTER TABLE Rental 
ADD CONSTRAINT DK_rental_due_date 
DEFAULT DATEADD(DAY, 2, GETDATE()) FOR Due_date;

EXEC sp_helpconstraint 'Movie';
EXEC sp_helpconstraint 'Customer';
EXEC sp_helpconstraint 'Rental';

--13
ALTER TABLE Movie 
ADD CONSTRAINT CK_movie 
CHECK (Rating IN ('G', 'PG', 'R', 'NC17', 'NR'));

ALTER TABLE Rental 
ADD CONSTRAINT CK_Due_date 
CHECK (Due_date >= Rental_date);

EXEC sp_helpconstraint 'Movie';
EXEC sp_helpconstraint 'Rental';


