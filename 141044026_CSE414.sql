USE [master]
GO
/****** Object:  Database [build_pc]    Script Date: 14.06.2021 15:17:49 ******/
CREATE DATABASE [build_pc]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'build_pc', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\build_pc.mdf' , SIZE = 30720KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'build_pc_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\build_pc_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [build_pc] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [build_pc].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [build_pc] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [build_pc] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [build_pc] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [build_pc] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [build_pc] SET ARITHABORT OFF 
GO
ALTER DATABASE [build_pc] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [build_pc] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [build_pc] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [build_pc] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [build_pc] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [build_pc] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [build_pc] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [build_pc] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [build_pc] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [build_pc] SET  DISABLE_BROKER 
GO
ALTER DATABASE [build_pc] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [build_pc] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [build_pc] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [build_pc] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [build_pc] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [build_pc] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [build_pc] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [build_pc] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [build_pc] SET  MULTI_USER 
GO
ALTER DATABASE [build_pc] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [build_pc] SET DB_CHAINING OFF 
GO
ALTER DATABASE [build_pc] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [build_pc] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [build_pc] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [build_pc] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [build_pc] SET QUERY_STORE = OFF
GO
USE [build_pc]
GO
/****** Object:  Table [dbo].[seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seller](
	[sellerID] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](50) NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sellerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[brand]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[brand](
	[brandID] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](50) NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[brandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ram]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ram](
	[ramID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[capacity] [int] NOT NULL,
	[latency] [int] NOT NULL,
	[speed] [int] NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ramID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ram_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ram_seller](
	[sellerID] [int] NULL,
	[ramID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_ram]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc


create view [dbo].[view_ram] as

select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating,
	   rs.ramID, r.title as ram_name,  r.rating as ram_rating, r.capacity, r.latency, r.warranty,
	   rs.price
from 
ram_seller as rs
LEFT OUTER JOIN seller as s ON s.sellerID = rs.sellerID
LEFT OUTER JOIN ram as r ON r.ramID = rs.ramID
LEFT OUTER JOIN brand as b ON r.brandID = b.brandID

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/
GO
/****** Object:  Table [dbo].[hard_disk]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hard_disk](
	[diskID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[capacity] [int] NOT NULL,
	[speed] [int] NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[diskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[disk_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[disk_seller](
	[sellerID] [int] NULL,
	[diskID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_disk]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc


create view [dbo].[view_disk] as

select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating, 
	   ds.diskID, hd.title as disk_name, hd.rating as disk_rating, hd.capacity, hd.speed, hd.warranty,
	   ds.price
from 
disk_seller as ds
LEFT OUTER JOIN seller as s ON s.sellerID = ds.sellerID
LEFT OUTER JOIN hard_disk as hd ON hd.diskID = ds.diskID
LEFT OUTER JOIN brand as b ON hd.brandID = b.brandID

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/
GO
/****** Object:  Table [dbo].[cpu]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cpu](
	[cpuID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[benchmark] [int] NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cpuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cpu_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cpu_seller](
	[sellerID] [int] NULL,
	[cpuID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_cpu]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc


create view [dbo].[view_cpu] as

select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating,
	   c.cpuID, c.title as cpu_name, c.rating as cpu_rating, c.benchmark, c.warranty,
	   cs.price
from 
cpu_seller as cs
LEFT OUTER JOIN seller as s ON s.sellerID = cs.sellerID
LEFT OUTER JOIN cpu as c ON c.cpuID = cs.cpuID
LEFT OUTER JOIN brand as b ON c.brandID = b.brandID

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/
GO
/****** Object:  Table [dbo].[gpu]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gpu](
	[gpuID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[benchmark] [int] NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[gpuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gpu_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gpu_seller](
	[sellerID] [int] NULL,
	[gpuID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_gpu]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc


create view [dbo].[view_gpu] as

select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating,
	   g.gpuID, g.title as gpu_name, g.rating as gpu_rating, g.benchmark, g.warranty,
	   gs.price
from 
gpu_seller as gs
LEFT OUTER JOIN seller as s ON s.sellerID = gs.sellerID
LEFT OUTER JOIN gpu as g ON g.gpuID = gs.gpuID
LEFT OUTER JOIN brand as b ON g.brandID = b.brandID

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/
GO
/****** Object:  Table [dbo].[motherboard]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[motherboard](
	[motherboardID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[speed] [int] NOT NULL,
	[connections] [int] NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[motherboardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[motherboard_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[motherboard_seller](
	[sellerID] [int] NULL,
	[motherboardID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_motherboard]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc


create view [dbo].[view_motherboard] as

select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating,
	   m.motherboardID, m.title as mb_name, m.rating as mb_rating, m.speed, m.connections,m.warranty,
	   ms.price
from 
motherboard_seller as ms
LEFT OUTER JOIN seller as s ON s.sellerID = ms.sellerID
LEFT OUTER JOIN motherboard as m ON m.motherboardID = ms.motherboardID
LEFT OUTER JOIN brand as b ON m.brandID = b.brandID

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/
GO
/****** Object:  Table [dbo].[psu]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[psu](
	[psuID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[watt] [int] NOT NULL,
	[efficiency] [numeric](3, 1) NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[psuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[psu_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[psu_seller](
	[sellerID] [int] NULL,
	[psuID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_psu]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc


create view [dbo].[view_psu] as

select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating,
	   p.psuID, p.title as psu_name, p.rating as psu_rating, p.watt, p.efficiency, p.warranty,
	   ps.price
from 
psu_seller as ps
LEFT OUTER JOIN seller as s ON s.sellerID = ps.sellerID
LEFT OUTER JOIN psu as p ON p.psuID = ps.psuID
LEFT OUTER JOIN brand as b ON p.brandID = b.brandID

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/
GO
/****** Object:  Table [dbo].[monitor]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[monitor](
	[monitorID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[ppi] [numeric](5, 2) NOT NULL,
	[inches] [numeric](3, 1) NOT NULL,
	[refresh_rate] [int] NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[monitorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[monitor_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[monitor_seller](
	[sellerID] [int] NULL,
	[monitorID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_monitor]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc

--select * from view_psu

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/

/*
create procedure best_monitor @seller_rating numeric(2,1), @brand_rating numeric(2,1), @monitor_rating numeric(2,1), @price int, @warranty int
as


select top 1 * from [view_monitor]
where price <= @price and seller_rating >= @seller_rating and monitor_rating >= @monitor_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by ppi * inches * (cast(refresh_rate as numeric(6,3)) / 3.0) desc, monitor_rating desc, price asc


go
*/

create view [dbo].[view_monitor]
as

select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating,
	   m.monitorID, m.title as monitor_name, m.rating as monitor_rating, m.ppi, m.refresh_rate, m.inches, m.warranty,
	   ms.price
from 
monitor_seller as ms
LEFT OUTER JOIN seller as s ON s.sellerID = ms.sellerID
LEFT OUTER JOIN monitor as m ON m.monitorID = ms.monitorID
LEFT OUTER JOIN brand as b ON m.brandID = b.brandID
GO
/****** Object:  Table [dbo].[c_case]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c_case](
	[caseID] [int] IDENTITY(1,1) NOT NULL,
	[brandID] [int] NULL,
	[title] [varchar](50) NULL,
	[n_ports] [int] NOT NULL,
	[fans] [int] NOT NULL,
	[warranty] [int] NOT NULL,
	[rating] [numeric](2, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[caseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[case_seller]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[case_seller](
	[sellerID] [int] NULL,
	[caseID] [int] NULL,
	[price] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_case]    Script Date: 14.06.2021 15:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc

--select * from view_psu

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/


/*
exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 10000, @warranty = 1
exec best_disk @seller_rating = 1, @brand_rating=1, @disk_rating = 1, @price = 10000, @warranty = 1
exec best_cpu @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1
exec best_gpu @seller_rating = 1, @brand_rating=1, @gpu_rating = 1, @price = 10000, @warranty = 1
exec best_psu @seller_rating = 1, @brand_rating=1, @psu_rating = 1, @price = 10000, @warranty = 1
exec best_case @seller_rating = 1, @brand_rating=1, @case_rating = 1, @price = 10000, @warranty = 1
exec best_monitor @seller_rating = 1, @brand_rating=1, @monitor_rating = 1, @price = 10000, @warranty = 1
exec best_motherboard @seller_rating = 1, @brand_rating=1, @mb_rating = 1, @price = 10000, @warranty = 1

*/
/*
create procedure best_case @seller_rating numeric(2,1), @brand_rating numeric(2,1), @case_rating numeric(2,1), @price int, @warranty int
as


select top 1 * from [view_case]
where price <= @price and seller_rating >= @seller_rating and case_rating >= @case_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by (fans * 2) + n_ports desc, case_rating desc, price asc


go
*/

create view [dbo].[view_case]
as
select s.sellerID, s.title as seller_name, s.rating as seller_rating,
	   b.brandID, b.title as brand_name, b.rating as brand_rating,
	   c.caseID, c.title as case_name, c.rating as case_rating, c.n_ports, c.fans, c.warranty,
	   cs.price
from 
case_seller as cs
LEFT OUTER JOIN seller as s ON s.sellerID = cs.sellerID
LEFT OUTER JOIN c_case as c ON c.caseID = cs.caseID
LEFT OUTER JOIN brand as b ON c.brandID = b.brandID
GO
SET IDENTITY_INSERT [dbo].[brand] ON 

INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (1, N'hypery', CAST(7.3 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (2, N'corpair', CAST(8.8 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (3, N'princeton', CAST(9.3 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (4, N'srucial', CAST(6.1 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (5, N'lakegate', CAST(6.3 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (6, N'easterndigital', CAST(7.5 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (7, N'doshiba', CAST(9.3 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (8, N'and', CAST(9.2 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (9, N'bintel', CAST(7.4 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (10, N'nsi', CAST(9.2 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (11, N'usus', CAST(8.1 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (12, N'popstar', CAST(5.4 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (13, N'ecer', CAST(7.0 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (14, N'şharkoon', CAST(7.1 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (15, N'yhermaltake', CAST(9.2 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (16, N'minibyte', CAST(8.3 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (17, N'malzan', CAST(9.1 AS Numeric(2, 1)))
INSERT [dbo].[brand] ([brandID], [title], [rating]) VALUES (18, N'heater master', CAST(8.1 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[brand] OFF
GO
SET IDENTITY_INSERT [dbo].[c_case] ON 

INSERT [dbo].[c_case] ([caseID], [brandID], [title], [n_ports], [fans], [warranty], [rating]) VALUES (1, 17, N'z300', 8, 3, 5, CAST(8.6 AS Numeric(2, 1)))
INSERT [dbo].[c_case] ([caseID], [brandID], [title], [n_ports], [fans], [warranty], [rating]) VALUES (2, 18, N'h510', 12, 1, 5, CAST(6.4 AS Numeric(2, 1)))
INSERT [dbo].[c_case] ([caseID], [brandID], [title], [n_ports], [fans], [warranty], [rating]) VALUES (3, 16, N'td500', 24, 4, 2, CAST(9.3 AS Numeric(2, 1)))
INSERT [dbo].[c_case] ([caseID], [brandID], [title], [n_ports], [fans], [warranty], [rating]) VALUES (4, 11, N'helios', 32, 8, 2, CAST(7.7 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[c_case] OFF
GO
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (1, 2, 250)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (2, 2, 250)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (3, 2, 261)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (4, 2, 247)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (5, 2, 270)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (1, 1, 350)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (2, 1, 340)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (5, 1, 330)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (3, 3, 1400)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (4, 3, 1370)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (5, 3, 1407)
INSERT [dbo].[case_seller] ([sellerID], [caseID], [price]) VALUES (5, 4, 3000)
GO
SET IDENTITY_INSERT [dbo].[cpu] ON 

INSERT [dbo].[cpu] ([cpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (1, 8, N'ryzen 5 3600', 17000, 2, CAST(9.0 AS Numeric(2, 1)))
INSERT [dbo].[cpu] ([cpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (2, 9, N'11400kf', 9800, 5, CAST(8.8 AS Numeric(2, 1)))
INSERT [dbo].[cpu] ([cpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (3, 8, N'5700x', 28000, 2, CAST(8.0 AS Numeric(2, 1)))
INSERT [dbo].[cpu] ([cpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (4, 9, N'11900k', 24000, 5, CAST(7.7 AS Numeric(2, 1)))
INSERT [dbo].[cpu] ([cpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (5, 9, N'celeron', 400, 2, CAST(8.2 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[cpu] OFF
GO
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (1, 1, 2000)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (2, 1, 2100)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (3, 1, 2087)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (5, 1, 1983)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (1, 2, 2400)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (3, 2, 2272)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (4, 2, 2136)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (5, 2, 2498)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (1, 3, 4523)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (2, 3, 4675)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (3, 3, 4888)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (4, 3, 4444)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (3, 4, 8000)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (4, 4, 8888)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (5, 4, 8555)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (1, 5, 512)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (2, 5, 575)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (3, 5, 500)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (4, 5, 487)
INSERT [dbo].[cpu_seller] ([sellerID], [cpuID], [price]) VALUES (5, 5, 613)
GO
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (1, 1, 650)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (1, 2, 1220)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (1, 3, 2400)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (1, 4, 652)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (2, 1, 600)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (2, 2, 1223)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (2, 3, 2375)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (2, 4, 667)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (3, 1, 700)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (3, 2, 1187)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (3, 3, 2500)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (3, 4, 713)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (4, 1, 631)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (4, 2, 1300)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (4, 3, 2611)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (4, 4, 644)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (5, 1, 673)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (5, 2, 1173)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (5, 3, 2400)
INSERT [dbo].[disk_seller] ([sellerID], [diskID], [price]) VALUES (5, 4, 666)
GO
SET IDENTITY_INSERT [dbo].[gpu] ON 

INSERT [dbo].[gpu] ([gpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (1, 8, N'6700xt', 12000, 2, CAST(6.7 AS Numeric(2, 1)))
INSERT [dbo].[gpu] ([gpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (2, 9, N'1050 ti', 2000, 5, CAST(9.6 AS Numeric(2, 1)))
INSERT [dbo].[gpu] ([gpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (3, 8, N'rx 580', 5000, 2, CAST(8.0 AS Numeric(2, 1)))
INSERT [dbo].[gpu] ([gpuID], [brandID], [title], [benchmark], [warranty], [rating]) VALUES (4, 9, N'1660 super', 6000, 2, CAST(8.7 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[gpu] OFF
GO
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (1, 4, 5715)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (2, 4, 5555)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (3, 4, 6125)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (3, 3, 4878)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (4, 3, 4912)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (5, 3, 4850)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (1, 2, 1512)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (2, 2, 1500)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (4, 1, 11716)
INSERT [dbo].[gpu_seller] ([sellerID], [gpuID], [price]) VALUES (5, 1, 12779)
GO
SET IDENTITY_INSERT [dbo].[hard_disk] ON 

INSERT [dbo].[hard_disk] ([diskID], [brandID], [title], [capacity], [speed], [warranty], [rating]) VALUES (1, 5, N'barracuda 256', 2000, 100, 2, CAST(8.0 AS Numeric(2, 1)))
INSERT [dbo].[hard_disk] ([diskID], [brandID], [title], [capacity], [speed], [warranty], [rating]) VALUES (2, 6, N'blue', 4000, 75, 5, CAST(6.8 AS Numeric(2, 1)))
INSERT [dbo].[hard_disk] ([diskID], [brandID], [title], [capacity], [speed], [warranty], [rating]) VALUES (3, 7, N's300', 6000, 100, 2, CAST(9.6 AS Numeric(2, 1)))
INSERT [dbo].[hard_disk] ([diskID], [brandID], [title], [capacity], [speed], [warranty], [rating]) VALUES (4, 3, N'a2000', 500, 2000, 5, CAST(9.1 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[hard_disk] OFF
GO
SET IDENTITY_INSERT [dbo].[monitor] ON 

INSERT [dbo].[monitor] ([monitorID], [brandID], [title], [ppi], [inches], [refresh_rate], [warranty], [rating]) VALUES (1, 10, N'pro hd sharpen', CAST(100.22 AS Numeric(5, 2)), CAST(15.6 AS Numeric(3, 1)), 60, 2, CAST(6.8 AS Numeric(2, 1)))
INSERT [dbo].[monitor] ([monitorID], [brandID], [title], [ppi], [inches], [refresh_rate], [warranty], [rating]) VALUES (2, 11, N'curved ultra', CAST(130.23 AS Numeric(5, 2)), CAST(23.6 AS Numeric(3, 1)), 144, 5, CAST(9.0 AS Numeric(2, 1)))
INSERT [dbo].[monitor] ([monitorID], [brandID], [title], [ppi], [inches], [refresh_rate], [warranty], [rating]) VALUES (3, 13, N'tureview deluxe', CAST(212.25 AS Numeric(5, 2)), CAST(24.0 AS Numeric(3, 1)), 60, 2, CAST(8.1 AS Numeric(2, 1)))
INSERT [dbo].[monitor] ([monitorID], [brandID], [title], [ppi], [inches], [refresh_rate], [warranty], [rating]) VALUES (4, 10, N'the one', CAST(150.00 AS Numeric(5, 2)), CAST(23.6 AS Numeric(3, 1)), 240, 2, CAST(7.7 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[monitor] OFF
GO
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (1, 4, 4000)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (2, 4, 4100)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (3, 4, 4200)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (4, 4, 4300)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (5, 4, 4000)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (1, 3, 2000)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (2, 3, 1900)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (3, 3, 1950)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (1, 2, 987)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (2, 2, 1000)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (3, 2, 999)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (4, 2, 1000)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (5, 2, 992)
INSERT [dbo].[monitor_seller] ([sellerID], [monitorID], [price]) VALUES (1, 1, 600)
GO
SET IDENTITY_INSERT [dbo].[motherboard] ON 

INSERT [dbo].[motherboard] ([motherboardID], [brandID], [title], [speed], [connections], [warranty], [rating]) VALUES (5, 10, N'tomahawk', 3600, 16, 2, CAST(7.9 AS Numeric(2, 1)))
INSERT [dbo].[motherboard] ([motherboardID], [brandID], [title], [speed], [connections], [warranty], [rating]) VALUES (6, 11, N'x570', 3200, 20, 5, CAST(9.3 AS Numeric(2, 1)))
INSERT [dbo].[motherboard] ([motherboardID], [brandID], [title], [speed], [connections], [warranty], [rating]) VALUES (7, 12, N'0x675', 2666, 12, 2, CAST(6.0 AS Numeric(2, 1)))
INSERT [dbo].[motherboard] ([motherboardID], [brandID], [title], [speed], [connections], [warranty], [rating]) VALUES (8, 11, N'ks712', 2966, 13, 2, CAST(8.7 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[motherboard] OFF
GO
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (1, 5, 900)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (2, 5, 912)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (3, 5, 1075)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (4, 5, 1099)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (5, 5, 888)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (3, 6, 700)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (4, 6, 621)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (5, 6, 644)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (2, 7, 500)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (3, 7, 400)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (5, 8, 612)
INSERT [dbo].[motherboard_seller] ([sellerID], [motherboardID], [price]) VALUES (1, 8, 647)
GO
SET IDENTITY_INSERT [dbo].[psu] ON 

INSERT [dbo].[psu] ([psuID], [brandID], [title], [watt], [efficiency], [warranty], [rating]) VALUES (1, 14, N'shp bronze', 600, CAST(82.1 AS Numeric(3, 1)), 2, CAST(7.9 AS Numeric(2, 1)))
INSERT [dbo].[psu] ([psuID], [brandID], [title], [watt], [efficiency], [warranty], [rating]) VALUES (2, 15, N'toughpower', 650, CAST(87.8 AS Numeric(3, 1)), 5, CAST(8.8 AS Numeric(2, 1)))
INSERT [dbo].[psu] ([psuID], [brandID], [title], [watt], [efficiency], [warranty], [rating]) VALUES (3, 16, N'p750gm', 750, CAST(88.0 AS Numeric(3, 1)), 2, CAST(9.3 AS Numeric(2, 1)))
INSERT [dbo].[psu] ([psuID], [brandID], [title], [watt], [efficiency], [warranty], [rating]) VALUES (4, 16, N'p1000', 1000, CAST(89.4 AS Numeric(3, 1)), 2, CAST(7.7 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[psu] OFF
GO
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (1, 1, 300)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (2, 1, 322)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (3, 1, 333)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (4, 1, 347)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (5, 1, 333)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (2, 3, 912)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (3, 3, 900)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (4, 3, 888)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (5, 3, 900)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (1, 4, 1000)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (2, 4, 1000)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (3, 4, 1000)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (4, 4, 1000)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (5, 4, 1000)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (1, 2, 600)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (2, 2, 598)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (3, 2, 605)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (4, 2, 610)
INSERT [dbo].[psu_seller] ([sellerID], [psuID], [price]) VALUES (5, 2, 610)
GO
SET IDENTITY_INSERT [dbo].[ram] ON 

INSERT [dbo].[ram] ([ramID], [brandID], [title], [capacity], [latency], [speed], [warranty], [rating]) VALUES (5, 4, N'vengeance lpx', 16, 16, 3600, 2, CAST(8.3 AS Numeric(2, 1)))
INSERT [dbo].[ram] ([ramID], [brandID], [title], [capacity], [latency], [speed], [warranty], [rating]) VALUES (6, 3, N'Fury', 16, 16, 3600, 5, CAST(7.9 AS Numeric(2, 1)))
INSERT [dbo].[ram] ([ramID], [brandID], [title], [capacity], [latency], [speed], [warranty], [rating]) VALUES (7, 2, N'1rx16', 4, 17, 2400, 2, CAST(8.6 AS Numeric(2, 1)))
INSERT [dbo].[ram] ([ramID], [brandID], [title], [capacity], [latency], [speed], [warranty], [rating]) VALUES (8, 1, N'CT87349274', 8, 19, 2666, 2, CAST(9.1 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[ram] OFF
GO
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (1, 5, 1200)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (1, 6, 1220)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (1, 7, 250)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (1, 8, 726)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (2, 5, 1270)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (2, 6, 1113)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (2, 7, 251)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (2, 8, 662)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (3, 5, 1188)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (3, 6, 1177)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (3, 7, 245)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (3, 8, 677)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (4, 5, 1300)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (4, 6, 1200)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (4, 7, 272)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (4, 8, 660)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (5, 5, 1243)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (5, 6, 1095)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (5, 7, 300)
INSERT [dbo].[ram_seller] ([sellerID], [ramID], [price]) VALUES (5, 8, 637)
GO
SET IDENTITY_INSERT [dbo].[seller] ON 

INSERT [dbo].[seller] ([sellerID], [title], [rating]) VALUES (1, N'hepsişurada', CAST(8.3 AS Numeric(2, 1)))
INSERT [dbo].[seller] ([sellerID], [title], [rating]) VALUES (2, N'n22', CAST(7.5 AS Numeric(2, 1)))
INSERT [dbo].[seller] ([sellerID], [title], [rating]) VALUES (3, N'amason', CAST(9.0 AS Numeric(2, 1)))
INSERT [dbo].[seller] ([sellerID], [title], [rating]) VALUES (4, N'newbegg', CAST(6.7 AS Numeric(2, 1)))
INSERT [dbo].[seller] ([sellerID], [title], [rating]) VALUES (5, N'geldigeliyor', CAST(5.2 AS Numeric(2, 1)))
SET IDENTITY_INSERT [dbo].[seller] OFF
GO
ALTER TABLE [dbo].[c_case]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[case_seller]  WITH CHECK ADD FOREIGN KEY([caseID])
REFERENCES [dbo].[c_case] ([caseID])
GO
ALTER TABLE [dbo].[case_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
ALTER TABLE [dbo].[cpu]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[cpu_seller]  WITH CHECK ADD FOREIGN KEY([cpuID])
REFERENCES [dbo].[cpu] ([cpuID])
GO
ALTER TABLE [dbo].[cpu_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
ALTER TABLE [dbo].[disk_seller]  WITH CHECK ADD FOREIGN KEY([diskID])
REFERENCES [dbo].[hard_disk] ([diskID])
GO
ALTER TABLE [dbo].[disk_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
ALTER TABLE [dbo].[gpu]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[gpu_seller]  WITH CHECK ADD FOREIGN KEY([gpuID])
REFERENCES [dbo].[gpu] ([gpuID])
GO
ALTER TABLE [dbo].[gpu_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
ALTER TABLE [dbo].[hard_disk]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[monitor]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[monitor_seller]  WITH CHECK ADD FOREIGN KEY([monitorID])
REFERENCES [dbo].[monitor] ([monitorID])
GO
ALTER TABLE [dbo].[monitor_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
ALTER TABLE [dbo].[motherboard]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[motherboard_seller]  WITH CHECK ADD FOREIGN KEY([motherboardID])
REFERENCES [dbo].[motherboard] ([motherboardID])
GO
ALTER TABLE [dbo].[motherboard_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
ALTER TABLE [dbo].[psu]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[psu_seller]  WITH CHECK ADD FOREIGN KEY([psuID])
REFERENCES [dbo].[psu] ([psuID])
GO
ALTER TABLE [dbo].[psu_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
ALTER TABLE [dbo].[ram]  WITH CHECK ADD FOREIGN KEY([brandID])
REFERENCES [dbo].[brand] ([brandID])
GO
ALTER TABLE [dbo].[ram_seller]  WITH CHECK ADD FOREIGN KEY([ramID])
REFERENCES [dbo].[ram] ([ramID])
GO
ALTER TABLE [dbo].[ram_seller]  WITH CHECK ADD FOREIGN KEY([sellerID])
REFERENCES [dbo].[seller] ([sellerID])
GO
/****** Object:  StoredProcedure [dbo].[get_brands]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use build_pc

--select * from view_psu

/*

select top 1 * from [test_ram]
where price <= 1000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) desc, ram_rating desc, price asc

exec best_ram @seller_rating = 1, @brand_rating=1, @ram_rating = 1, @price = 1000, @warranty = 1
*/

create procedure [dbo].[get_brands]
as
select b.brandID, b.title as brand_name, b.rating as brand_rating
from brand as b
order by b.rating desc

GO
/****** Object:  StoredProcedure [dbo].[get_sellers]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
insert into seller
values('hepsişurada',8.3)
insert into seller
values('n22',7.5)
insert into seller
values('amason',9)
insert into seller
values('newbegg',6.7)
insert into seller
values('geldigeliyor',5.2)

select * from seller order by rating desc
*/


/*
insert into brand
values('hypery',7.3)
insert into brand
values('corpair',8.8)
insert into brand
values('princeton',9.3)
insert into brand
values('srucial',6.1)

select * from brand order by rating desc
*/

/*
insert into ram 
values(4,'vengeance lpx', 16, 16, 3600, 2, 8.3)
insert into ram 
values(3,'Fury', 16, 16, 3600, 5, 7.9)
insert into ram 
values(2,'1rx16', 4, 17, 2400, 2,8.6)
insert into ram 
values(1,'CT87349274', 8, 19, 2666, 2, 9.1)

select * from ram

*/


/*
insert into ram_seller
values(1,5,1200)
insert into ram_seller
values(1,6,1220)
insert into ram_seller
values(1,7,250)
insert into ram_seller
values(1,8,726)

insert into ram_seller
values(2,5,1270)
insert into ram_seller
values(2,6,1113)
insert into ram_seller
values(2,7,251)
insert into ram_seller
values(2,8,662)

insert into ram_seller
values(3,5,1188)
insert into ram_seller
values(3,6,1177)
insert into ram_seller
values(3,7,245)
insert into ram_seller
values(3,8,677)

insert into ram_seller
values(4,5,1300)
insert into ram_seller
values(4,6,1200)
insert into ram_seller
values(4,7,272)
insert into ram_seller
values(4,8,660)

insert into ram_seller
values(5,5,1243)
insert into ram_seller
values(5,6,1095)
insert into ram_seller
values(5,7,300)
insert into ram_seller
values(5,8,637)


select * from ram_seller
*/

/*
insert into brand
values('lakegate',6.3)
insert into brand
values('easterndigital',7.5)
insert into brand
values('doshiba',9.3)

select * from brand order by rating desc
*/

/*
insert into hard_disk
values(5,'barracuda 256', 2000, 100, 2, 8.0)
insert into hard_disk
values(6,'blue', 4000, 75, 5, 6.8)
insert into hard_disk
values(7,'s300', 6000, 100, 2, 9.6)
insert into hard_disk
values(3,'a2000', 500, 2000, 5, 9.1)

select * from hard_disk
*/

/*
insert into disk_seller
values(1,1,650)
insert into disk_seller
values(1,2,1220)
insert into disk_seller
values(1,3,2400)
insert into disk_seller
values(1,4,652)

insert into disk_seller
values(2,1,600)
insert into disk_seller
values(2,2,1223)
insert into disk_seller
values(2,3,2375)
insert into disk_seller
values(2,4,667)

insert into disk_seller
values(3,1,700)
insert into disk_seller
values(3,2,1187)
insert into disk_seller
values(3,3,2500)
insert into disk_seller
values(3,4,713)

insert into disk_seller
values(4,1,631)
insert into disk_seller
values(4,2,1300)
insert into disk_seller
values(4,3,2611)
insert into disk_seller
values(4,4,644)

insert into disk_seller
values(5,1,673)
insert into disk_seller
values(5,2,1173)
insert into disk_seller
values(5,3,2400)
insert into disk_seller
values(5,4,666)


select * from disk_seller

exec best_disk @seller_rating = 4, @brand_rating=7, @ram_rating = 7, @price = 2000, @warranty = 2
*/


/*
insert into brand
values('and',9.2)
insert into brand
values('bintel',7.4)
*/

/*
insert into cpu
values(8,'ryzen 5 3600', 17000, 2, 9.0)
insert into cpu
values(9,'11400kf', 9800, 5, 8.8)
insert into cpu
values(8,'5700x', 28000, 2, 8.0)
insert into cpu
values(9,'11900k', 24000, 5, 7.7)
*/


/*
insert into cpu_seller
values(1,1,2000)
insert into cpu_seller
values(2,1,2100)
insert into cpu_seller
values(3,1,2087)
insert into cpu_seller
values(5,1,1983)

insert into cpu_seller
values(1,2,2400)
insert into cpu_seller
values(3,2,2272)
insert into cpu_seller
values(4,2,2136)
insert into cpu_seller
values(5,2,2498)

insert into cpu_seller
values(1,3,4523)
insert into cpu_seller
values(2,3,4675)
insert into cpu_seller
values(3,3,4888)
insert into cpu_seller
values(4,3,4444)



insert into cpu_seller
values(3,4,8000)
insert into cpu_seller
values(4,4,8888)
insert into cpu_seller
values(5,4,8555)


select * from cpu_seller

*/



/*
insert into cpu
values(9,'celeron', 400, 2, 8.2)
*/
/*
insert into cpu_seller
values(1,5,512)
insert into cpu_seller
values(2,5,575)
insert into cpu_seller
values(3,5,500)
insert into cpu_seller
values(4,5,487)
insert into cpu_seller
values(5,5,613)
*/
--use build_pc
/*
insert into gpu
values(8,'6700xt', 12000, 2, 6.7)
insert into gpu
values(9,'1050 ti', 2000, 5, 9.6)
insert into gpu
values(8,'rx 580', 5000, 2, 8.0)
insert into gpu
values(9,'1660 super', 6000, 2, 8.7)
*/

/*
insert into gpu_seller
values(1,4,5715)
insert into gpu_seller
values(2,4,5555)
insert into gpu_seller
values(3,4,6125)


insert into gpu_seller
values(3,3,4878)
insert into gpu_seller
values(4,3,4912)
insert into gpu_seller
values(5,3,4850)

insert into gpu_seller
values(1,2,1512)
insert into gpu_seller
values(2,2,1500)

insert into gpu_seller
values(4,1,11716)
insert into gpu_seller
values(5,1,12779)
*/

/*
insert into brand
values('nsi',9.2)
insert into brand
values('usus',8.1)
insert into brand
values('popstar',5.4)
*/

/*
insert into motherboard
values(10,'tomahawk', 3600, 16, 2, 7.9)
insert into motherboard
values(11,'x570', 3200, 20, 5, 9.3)
insert into motherboard
values(12,'0x675', 2666, 12, 2, 6.0)
insert into motherboard
values(11,'ks712', 2966, 13, 2, 8.7)
*/
/*
insert into motherboard_seller
values(1,5,900)
insert into motherboard_seller
values(2,5,912)
insert into motherboard_seller
values(3,5,1075)
insert into motherboard_seller
values(4,5,1099)
insert into motherboard_seller
values(5,5,888)

insert into motherboard_seller
values(3,6,700)
insert into motherboard_seller
values(4,6,621)
insert into motherboard_seller
values(5,6,644)


insert into motherboard_seller
values(2,7,500)
insert into motherboard_seller
values(3,7,400)

insert into motherboard_seller
values(5,8,612)
insert into motherboard_seller
values(1,8,647)
*/

/*
insert into brand
values('ecer',7.0)
*/

/*
insert into monitor
values(10,'pro hd sharpen', 100.22, 15.6, 60, 2, 6.8)
insert into monitor
values(11,'curved ultra', 130.23, 23.6, 144, 2, 9.0)
insert into monitor
values(13,'tureview deluxe', 212.25, 24.0, 60, 2, 8.1)
insert into monitor
values(10,'the one',150.00, 23.6,240, 2, 7.7)
*/

/*
insert into monitor_seller
values(1,4,4000)
insert into monitor_seller
values(2,4,4100)
insert into monitor_seller
values(3,4,4200)
insert into monitor_seller
values(4,4,4300)
insert into monitor_seller
values(5,4,4000)

insert into monitor_seller
values(1,3,2000)
insert into monitor_seller
values(2,3,1900)
insert into monitor_seller
values(3,3,1950)

insert into monitor_seller
values(1,2,987)
insert into monitor_seller
values(2,2,1000)
insert into monitor_seller
values(3,2,999)
insert into monitor_seller
values(4,2,1000)
insert into monitor_seller
values(5,2,992)


insert into monitor_seller
values(1,1,600)

*/

/*
insert into brand
values('şharkoon',7.1)

insert into brand
values('yhermaltake',9.2)

insert into brand
values('minibyte',8.3)
*/

/*
insert into psu
values(14,'shp bronze', 600, 82.1, 2, 7.9)
insert into psu
values(15,'toughpower', 650, 87.8, 5, 8.8)
insert into psu
values(16,'p750gm', 750, 88.0, 2, 9.3)
insert into psu
values(16,'p1000', 1000, 89.4, 2, 7.7)
*/

/*
insert into psu_seller
values(1,1,300)
insert into psu_seller
values(2,1,322)
insert into psu_seller
values(3,1,333)
insert into psu_seller
values(4,1,347)
insert into psu_seller
values(5,1,333)


insert into psu_seller
values(2,3,912)
insert into psu_seller
values(3,3,900)
insert into psu_seller
values(4,3,888)
insert into psu_seller
values(5,3,900)


insert into psu_seller
values(1,4,1000)
insert into psu_seller
values(2,4,1000)
insert into psu_seller
values(3,4,1000)
insert into psu_seller
values(4,4,1000)
insert into psu_seller
values(5,4,1000)

insert into psu_seller
values(1,2,600)
insert into psu_seller
values(2,2,598)
insert into psu_seller
values(3,2,605)
insert into psu_seller
values(4,2,610)
insert into psu_seller
values(5,2,610)

*/
/*
insert into brand
values('malzan',9.1)
insert into brand
values('heater master',8.1)
*/
--select * from brand

/*
insert into c_case
values(17,'z300', 8, 3, 5, 8.6)
insert into c_case
values(18,'h510', 12, 1, 5, 6.4)
insert into c_case
values(16,'td500', 24, 4, 2, 9.3)
insert into c_case
values(11,'helios', 32, 8, 2, 7.7)
*/



/*

insert into case_seller
values(1,2,250)
insert into case_seller
values(2,2,250)
insert into case_seller
values(3,2,261)
insert into case_seller
values(4,2,247)
insert into case_seller
values(5,2,270)

insert into case_seller
values(1,1,350)
insert into case_seller
values(2,1,340)
insert into case_seller
values(5,1,330)


insert into case_seller
values(3,3,1400)
insert into case_seller
values(4,3,1370)
insert into case_seller
values(5,3,1407)


insert into case_seller
values(5,4,3000)

*/

--exec best_ram @seller_rating = 7.0, @brand_rating=7.0, @ram_rating = 7.0, @price = 440, @warranty = 2


create procedure [dbo].[get_sellers]
as

select s.sellerID, s.title as seller_name, s.rating as seller_rating
from seller as s
order by s.rating desc

GO
/****** Object:  StoredProcedure [dbo].[possible_cases]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_cases] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @case_rating numeric(2,1), @price int, @warranty int
as


select * from [view_case]
where price <= @price and seller_rating >= @seller_rating and case_rating >= @case_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by (fans * 2) + n_ports asc, price desc, case_rating asc, seller_rating asc


GO
/****** Object:  StoredProcedure [dbo].[possible_cpus]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_cpus] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @cpu_rating numeric(2,1), @price int, @warranty int
as


select * from [view_cpu]
where price <= @price and seller_rating >= @seller_rating and cpu_rating >= @cpu_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc


GO
/****** Object:  StoredProcedure [dbo].[possible_disks]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_disks] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @disk_rating numeric(2,1), @price int, @warranty int
as


select * from [view_disk]
where price <= @price and seller_rating >= @seller_rating and disk_rating >= @disk_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by capacity * (cast(speed as numeric(8,3)) / 4) asc, price desc, disk_rating asc, seller_rating asc


GO
/****** Object:  StoredProcedure [dbo].[possible_gpus]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_gpus] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @gpu_rating numeric(2,1), @price int, @warranty int
as


select * from [view_gpu]
where price <= @price and seller_rating >= @seller_rating and gpu_rating >= @gpu_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by benchmark asc, price desc, gpu_rating asc, seller_rating asc


GO
/****** Object:  StoredProcedure [dbo].[possible_monitors]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_monitors] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @monitor_rating numeric(2,1), @price int, @warranty int
as


select * from [view_monitor]
where price <= @price and seller_rating >= @seller_rating and monitor_rating >= @monitor_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by ppi * inches * (cast(refresh_rate as numeric(6,3)) / 3.0) asc, price desc, monitor_rating asc, seller_rating asc


GO
/****** Object:  StoredProcedure [dbo].[possible_motherboards]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_motherboards] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @mb_rating numeric(2,1), @price int, @warranty int
as


select * from [view_motherboard]
where price <= @price and seller_rating >= @seller_rating and mb_rating >= @mb_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by speed * connections asc, price desc, mb_rating asc, seller_rating asc


GO
/****** Object:  StoredProcedure [dbo].[possible_psus]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_psus] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @psu_rating numeric(2,1), @price int, @warranty int
as


select * from [view_psu]
where price <= @price and seller_rating >= @seller_rating and psu_rating >= @psu_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by watt * efficiency asc, price desc, psu_rating asc, seller_rating asc


GO
/****** Object:  StoredProcedure [dbo].[possible_rams]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [view_ram]
where price <= 50000 and seller_rating >= 1 and ram_rating >= 1 and brand_rating >= 1 and warranty >= 2
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, ram_rating asc, price desc, seller_rating asc
*/

--exec possible_cpus @seller_rating = 1, @brand_rating=1, @cpu_rating = 1, @price = 10000, @warranty = 1

/*
select * from [view_cpu]
where price <= 20000 and seller_rating >= 1 and cpu_rating >= 1 and brand_rating >= 1 and warranty >= 1
order by benchmark asc, price desc, cpu_rating asc, seller_rating asc
*/

create procedure [dbo].[possible_rams] @seller_rating numeric(2,1), @brand_rating numeric(2,1), @ram_rating numeric(2,1), @price int, @warranty int
as


select * from [view_ram]
where price <= @price and seller_rating >= @seller_rating and ram_rating >= @ram_rating and brand_rating >= @brand_rating and warranty >= @warranty
order by cast(capacity as numeric(6,3)) / cast(latency as numeric(6,3)) asc, price desc, ram_rating asc, seller_rating asc


GO
/****** Object:  Trigger [dbo].[case_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[case_del] on [dbo].[case_seller]
after delete
as

delete from [dbo].[c_case] where caseID not in 
(select distinct caseID from case_seller)

GO
ALTER TABLE [dbo].[case_seller] ENABLE TRIGGER [case_del]
GO
/****** Object:  Trigger [dbo].[cpu_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[cpu_del] on [dbo].[cpu_seller]
after delete
as

delete from [dbo].[cpu] where cpuID not in 
(select distinct cpuID from cpu_seller)

GO
ALTER TABLE [dbo].[cpu_seller] ENABLE TRIGGER [cpu_del]
GO
/****** Object:  Trigger [dbo].[disk_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[disk_del] on [dbo].[disk_seller]
after delete
as

delete from [dbo].[hard_disk] where diskID not in 
(select distinct diskID from disk_seller)

GO
ALTER TABLE [dbo].[disk_seller] ENABLE TRIGGER [disk_del]
GO
/****** Object:  Trigger [dbo].[gpu_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[gpu_del] on [dbo].[gpu_seller]
after delete
as

delete from [dbo].[gpu] where gpuID not in 
(select distinct gpuID from gpu_seller)

GO
ALTER TABLE [dbo].[gpu_seller] ENABLE TRIGGER [gpu_del]
GO
/****** Object:  Trigger [dbo].[monitor_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[monitor_del] on [dbo].[monitor_seller]
after delete
as

delete from [dbo].[monitor] where monitorID not in 
(select distinct monitorID from monitor_seller)

GO
ALTER TABLE [dbo].[monitor_seller] ENABLE TRIGGER [monitor_del]
GO
/****** Object:  Trigger [dbo].[motherboard_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[motherboard_del] on [dbo].[motherboard_seller]
after delete
as

delete from [dbo].[motherboard] where motherboardID not in 
(select distinct motherboardID from motherboard_seller)

GO
ALTER TABLE [dbo].[motherboard_seller] ENABLE TRIGGER [motherboard_del]
GO
/****** Object:  Trigger [dbo].[psu_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[psu_del] on [dbo].[psu_seller]
after delete
as

delete from [dbo].[psu] where psuID not in 
(select distinct psuID from psu_seller)

GO
ALTER TABLE [dbo].[psu_seller] ENABLE TRIGGER [psu_del]
GO
/****** Object:  Trigger [dbo].[ram_del]    Script Date: 14.06.2021 15:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[ram_del] on [dbo].[ram_seller]
after delete
as

delete from [dbo].[ram] where ramID not in 
(select distinct ramID from ram_seller)

GO
ALTER TABLE [dbo].[ram_seller] ENABLE TRIGGER [ram_del]
GO
USE [master]
GO
ALTER DATABASE [build_pc] SET  READ_WRITE 
GO
