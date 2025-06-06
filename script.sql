USE [master]
GO
/****** Object:  Database [BenzinskaPumpa]    Script Date: 14.4.2025. 13:12:31 ******/
CREATE DATABASE [BenzinskaPumpa]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BenzinskaPumpa', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BenzinskaPumpa.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BenzinskaPumpa_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BenzinskaPumpa_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BenzinskaPumpa] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BenzinskaPumpa].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BenzinskaPumpa] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET ARITHABORT OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BenzinskaPumpa] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BenzinskaPumpa] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BenzinskaPumpa] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BenzinskaPumpa] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET RECOVERY FULL 
GO
ALTER DATABASE [BenzinskaPumpa] SET  MULTI_USER 
GO
ALTER DATABASE [BenzinskaPumpa] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BenzinskaPumpa] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BenzinskaPumpa] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BenzinskaPumpa] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BenzinskaPumpa] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BenzinskaPumpa] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BenzinskaPumpa', N'ON'
GO
ALTER DATABASE [BenzinskaPumpa] SET QUERY_STORE = ON
GO
ALTER DATABASE [BenzinskaPumpa] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BenzinskaPumpa]
GO
/****** Object:  Table [dbo].[Usluga]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usluga](
	[UslugaID] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [nvarchar](100) NOT NULL,
	[Cena] [int] NOT NULL,
	[Opis] [nvarchar](255) NULL,
	[KategorijaID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UslugaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StavkaTransakcije]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StavkaTransakcije](
	[StavkaID] [int] IDENTITY(1,1) NOT NULL,
	[TransakcijaID] [int] NOT NULL,
	[UslugaID] [int] NOT NULL,
	[Kolicina] [int] NOT NULL,
	[Cena] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StavkaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_NajprodavanijeUsluge]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_NajprodavanijeUsluge] AS
SELECT 
    u.UslugaID,
    u.Naziv,
    SUM(st.Kolicina) AS UkupnoProdato,
    SUM(st.Kolicina * st.Cena) AS UkupnaZarada
FROM Usluga u
JOIN StavkaTransakcije st ON u.UslugaID = st.UslugaID
GROUP BY u.UslugaID, u.Naziv;
GO
/****** Object:  Table [dbo].[Transakcija]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transakcija](
	[TransakcijaID] [int] IDENTITY(1,1) NOT NULL,
	[Datum] [datetime] NOT NULL,
	[ZaposleniID] [int] NOT NULL,
	[KorisnikID] [int] NULL,
	[UkupanIznos] [decimal](12, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TransakcijaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_DnevniPromet]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DnevniPromet] AS
SELECT 
    CAST(Datum AS DATE) AS Dan,
    COUNT(*) AS BrojTransakcija,
    SUM(UkupanIznos) AS UkupanPromet
FROM Transakcija
GROUP BY CAST(Datum AS DATE);
GO
/****** Object:  Table [dbo].[Kategorija]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kategorija](
	[KategorijaID] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [nvarchar](100) NOT NULL,
	[Opis] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[KategorijaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Korisnik]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Korisnik](
	[KorisnikID] [int] IDENTITY(1,1) NOT NULL,
	[Ime] [nvarchar](50) NOT NULL,
	[Prezime] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Telefon] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[KorisnikID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Zaposleni]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Zaposleni](
	[ZaposleniID] [int] IDENTITY(1,1) NOT NULL,
	[Ime] [nvarchar](50) NOT NULL,
	[Prezime] [nvarchar](50) NOT NULL,
	[Pozicija] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ZaposleniID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Transakcija] ADD  DEFAULT (getdate()) FOR [Datum]
GO
ALTER TABLE [dbo].[StavkaTransakcije]  WITH CHECK ADD FOREIGN KEY([TransakcijaID])
REFERENCES [dbo].[Transakcija] ([TransakcijaID])
GO
ALTER TABLE [dbo].[StavkaTransakcije]  WITH CHECK ADD FOREIGN KEY([UslugaID])
REFERENCES [dbo].[Usluga] ([UslugaID])
GO
ALTER TABLE [dbo].[StavkaTransakcije]  WITH CHECK ADD  CONSTRAINT [FK_Stavka_Transakcija] FOREIGN KEY([TransakcijaID])
REFERENCES [dbo].[Transakcija] ([TransakcijaID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StavkaTransakcije] CHECK CONSTRAINT [FK_Stavka_Transakcija]
GO
ALTER TABLE [dbo].[StavkaTransakcije]  WITH CHECK ADD  CONSTRAINT [FK_Stavka_Usluga] FOREIGN KEY([UslugaID])
REFERENCES [dbo].[Usluga] ([UslugaID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StavkaTransakcije] CHECK CONSTRAINT [FK_Stavka_Usluga]
GO
ALTER TABLE [dbo].[Transakcija]  WITH CHECK ADD FOREIGN KEY([KorisnikID])
REFERENCES [dbo].[Korisnik] ([KorisnikID])
GO
ALTER TABLE [dbo].[Transakcija]  WITH CHECK ADD FOREIGN KEY([ZaposleniID])
REFERENCES [dbo].[Zaposleni] ([ZaposleniID])
GO
ALTER TABLE [dbo].[Transakcija]  WITH CHECK ADD  CONSTRAINT [FK_Transakcija_Korisnik] FOREIGN KEY([KorisnikID])
REFERENCES [dbo].[Korisnik] ([KorisnikID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Transakcija] CHECK CONSTRAINT [FK_Transakcija_Korisnik]
GO
ALTER TABLE [dbo].[Transakcija]  WITH CHECK ADD  CONSTRAINT [FK_Transakcija_Zaposleni] FOREIGN KEY([ZaposleniID])
REFERENCES [dbo].[Zaposleni] ([ZaposleniID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Transakcija] CHECK CONSTRAINT [FK_Transakcija_Zaposleni]
GO
ALTER TABLE [dbo].[Usluga]  WITH CHECK ADD FOREIGN KEY([KategorijaID])
REFERENCES [dbo].[Kategorija] ([KategorijaID])
GO
ALTER TABLE [dbo].[Usluga]  WITH CHECK ADD  CONSTRAINT [FK_Usluga_Kategorija] FOREIGN KEY([KategorijaID])
REFERENCES [dbo].[Kategorija] ([KategorijaID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Usluga] CHECK CONSTRAINT [FK_Usluga_Kategorija]
GO
ALTER TABLE [dbo].[StavkaTransakcije]  WITH CHECK ADD CHECK  (([Kolicina]>(0)))
GO
/****** Object:  StoredProcedure [dbo].[InsertUsluga]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertUsluga]
    @Naziv NVARCHAR(100),
    @Cena DECIMAL(10,2),
    @Opis NVARCHAR(255),
    @KategorijaID INT
AS
BEGIN
    INSERT INTO Usluga (Naziv, Cena, Opis, KategorijaID)
    VALUES (@Naziv, @Cena, @Opis, @KategorijaID);
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUsluga]    Script Date: 14.4.2025. 13:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUsluga]
    @UslugaID INT,
    @Naziv NVARCHAR(100),
    @Cena DECIMAL(10,2),
    @Opis NVARCHAR(255),
    @KategorijaID INT
AS
BEGIN
    UPDATE Usluga
    SET Naziv = @Naziv, Cena = @Cena, Opis = @Opis, KategorijaID = @KategorijaID
    WHERE UslugaID = @UslugaID;
END
GO
USE [master]
GO
ALTER DATABASE [BenzinskaPumpa] SET  READ_WRITE 
GO
