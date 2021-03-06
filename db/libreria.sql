USE [master]
GO
/****** Object:  Database [libreria]    Script Date: 01/05/18 21:53:12 ******/
CREATE DATABASE [libreria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'libreria', FILENAME = N'c:\databases\libreria\libreria.mdf' , SIZE = 6400KB , MAXSIZE = 20971520KB , FILEGROWTH = 10%)
 LOG ON 
( NAME = N'libreria_log', FILENAME = N'c:\databases\libreria\libreria_log.ldf' , SIZE = 76736KB , MAXSIZE = 1048576KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [libreria] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [libreria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [libreria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [libreria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [libreria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [libreria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [libreria] SET ARITHABORT OFF 
GO
ALTER DATABASE [libreria] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [libreria] SET AUTO_SHRINK ON 
GO
ALTER DATABASE [libreria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [libreria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [libreria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [libreria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [libreria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [libreria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [libreria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [libreria] SET  DISABLE_BROKER 
GO
ALTER DATABASE [libreria] SET AUTO_UPDATE_STATISTICS_ASYNC ON 
GO
ALTER DATABASE [libreria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [libreria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [libreria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [libreria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [libreria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [libreria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [libreria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [libreria] SET  MULTI_USER 
GO
ALTER DATABASE [libreria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [libreria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [libreria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [libreria] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [libreria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [libreria] SET QUERY_STORE = OFF
GO
USE [libreria]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [libreria]
GO
/****** Object:  User [GEAR\Domain Admins]    Script Date: 01/05/18 21:53:15 ******/
CREATE USER [GEAR\Domain Admins] FOR LOGIN [GEAR\Domain Admins]
GO
ALTER ROLE [db_owner] ADD MEMBER [GEAR\Domain Admins]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_MontoActual]    Script Date: 01/05/18 21:53:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_MontoActual](@fnidCliente int)
 returns money
 as
 BEGIN
	declare @vfresultado money;
	declare @vfAcreditar money;
	declare @vfextraer money;

	set @vfresultado=0;
	set @vfAcreditar=0;
	set @vfextraer =0;

	select @vfAcreditar= sum(monto)  from Movimientos 
	where idTarjetaAcumulacion=@fnidCliente
	group by idTipoMovimiento
	having idTipoMovimiento=1;

	select @vfextraer=sum(monto)  from Movimientos 
	where idTarjetaAcumulacion=@fnidCliente
	group by idTipoMovimiento
	having idTipoMovimiento=2;

	set @vfresultado=@vfAcreditar-@vfextraer;

	RETURN @vfresultado;
end;
GO
/****** Object:  Table [dbo].[Salidas]    Script Date: 01/05/18 21:53:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Salidas](
	[idSalida] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idBiblioteca] [int] NOT NULL,
	[date] [date] NULL,
 CONSTRAINT [PK_Salidas] PRIMARY KEY CLUSTERED 
(
	[idSalida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleados]    Script Date: 01/05/18 21:53:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleados](
	[idCargo] [int] NOT NULL,
	[fechaContratacion] [date] NOT NULL,
	[idBiblioteca] [int] NOT NULL,
	[idPersona] [int] NOT NULL,
 CONSTRAINT [PK_idPersona] PRIMARY KEY CLUSTERED 
(
	[idPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_salidasXEmpleado]    Script Date: 01/05/18 21:53:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_salidasXEmpleado](idEmpleado,Cantidad)as(
select sal.idEmpleado,count(*) Cantidad from Empleados emp
inner join Salidas sal on emp.idPersona=sal.idEmpleado
group by sal.idEmpleado
)
GO
/****** Object:  Table [dbo].[Entradas]    Script Date: 01/05/18 21:53:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Entradas](
	[idEntrada] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[fecha] [date] NOT NULL,
 CONSTRAINT [PK_Entradas] PRIMARY KEY CLUSTERED 
(
	[idEntrada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_entradasXEmpleado]    Script Date: 01/05/18 21:53:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_entradasXEmpleado](idEmpleado,Cantidad)as(
select ent.idEmpleado,count(*) Cantidad from Empleados emp
inner join Entradas ent on emp.idPersona=ent.idEmpleado
group by ent.idEmpleado
)
GO
/****** Object:  Table [dbo].[Personas]    Script Date: 01/05/18 21:53:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personas](
	[idPersona] [int] IDENTITY(1,1) NOT NULL,
	[idGenero] [int] NOT NULL,
	[idDireccion] [int] NOT NULL,
	[pNombre] [varchar](20) NOT NULL,
	[sNombre] [varchar](20) NULL,
	[pApellido] [varchar](20) NOT NULL,
	[sApellido] [varchar](20) NULL,
	[fechaNacimiento] [date] NOT NULL,
	[identidad] [varchar](20) NOT NULL,
	[correoElectronico] [varchar](30) NULL,
	[contrasena] [varchar](20) NULL,
 CONSTRAINT [PK_Personas] PRIMARY KEY CLUSTERED 
(
	[idPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 01/05/18 21:53:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[fechaRegistro] [date] NOT NULL,
	[idPersona] [int] NOT NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[idPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prestamos]    Script Date: 01/05/18 21:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prestamos](
	[idPrestamo] [int] IDENTITY(1,1) NOT NULL,
	[idLibro] [int] NOT NULL,
	[idCliente] [int] NOT NULL,
	[fechaInicio] [date] NOT NULL,
	[fechaFin] [date] NOT NULL,
 CONSTRAINT [PK_Prestamos] PRIMARY KEY CLUSTERED 
(
	[idPrestamo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_prestamosXCliente]    Script Date: 01/05/18 21:53:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_prestamosXCliente](idCliente,Cantidad) as(
select cli.idPersona,count(*) cantidad from Personas per
inner join clientes cli on per.idPersona=cli.idPersona
inner join Prestamos pre on cli.idPersona=pre.idCliente
group by cli.idPersona
)
GO
/****** Object:  Table [dbo].[LibrosXEstantes]    Script Date: 01/05/18 21:53:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LibrosXEstantes](
	[idLibro] [int] NOT NULL,
	[idEstante] [int] NOT NULL,
	[idEstadoLibro] [int] NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_LibrosXEstantes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Libros]    Script Date: 01/05/18 21:53:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Libros](
	[idLibro] [int] IDENTITY(1,1) NOT NULL,
	[idEditorial] [int] NOT NULL,
	[nombreLibro] [varchar](100) NOT NULL,
	[ISBN] [varchar](45) NOT NULL,
	[paginas] [int] NOT NULL,
	[sinopsis] [varchar](500) NULL,
	[fechaIngreso] [date] NOT NULL,
	[precioCompra] [money] NOT NULL,
	[precioVenta] [money] NOT NULL,
	[cantidad] [int] NOT NULL,
 CONSTRAINT [PK_Libros] PRIMARY KEY CLUSTERED 
(
	[idLibro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_librosDisponibles]    Script Date: 01/05/18 21:53:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_librosDisponibles](idLibro,nombreLibro)as(
SELECT lib.idLibro,l.nombreLibro FROM LibrosXEstantes lib
inner join Libros l on lib.idLibro=l.idLibro
where lib.idEstadoLibro=3)
GO
/****** Object:  Table [dbo].[Estantes]    Script Date: 01/05/18 21:53:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estantes](
	[idEstante] [int] IDENTITY(1,1) NOT NULL,
	[idBiblioteca] [int] NOT NULL,
	[identificador] [varchar](45) NULL,
	[descripcion] [varchar](80) NULL,
 CONSTRAINT [PK_Estantes] PRIMARY KEY CLUSTERED 
(
	[idEstante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Facturas]    Script Date: 01/05/18 21:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Facturas](
	[idFactura] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idCliente] [int] NULL,
	[idFormaPago] [int] NOT NULL,
	[fecha] [date] NOT NULL,
	[observacion] [varchar](100) NULL,
	[idImpuesto] [int] NULL,
 CONSTRAINT [PK_Facturas] PRIMARY KEY CLUSTERED 
(
	[idFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallesFacturas]    Script Date: 01/05/18 21:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallesFacturas](
	[idLibro] [int] NOT NULL,
	[idFactura] [int] NOT NULL,
 CONSTRAINT [PK_DetallesFacturas] PRIMARY KEY CLUSTERED 
(
	[idLibro] ASC,
	[idFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_Seleccion]    Script Date: 01/05/18 21:53:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_Seleccion](@pnidCliente int,@pnidEstante int,@pnidBiblioteca int)
RETURNS TABLE  
AS  
RETURN   
(  
    select fact.fecha ,lib.nombreLibro,lib.precioVenta from Libros lib
	inner join DetallesFacturas det on lib.idLibro=det.idLibro
	inner join Facturas fact on det.idFactura=fact.idFactura
	where lib.idLibro in (
	select det.idLibro from Facturas fact
	inner join DetallesFacturas det on fact.idFactura=det.idFactura
	inner join Libros lib on det.idLibro=lib.idLibro
	inner join LibrosXEstantes lest on lib.idLibro=lest.idLibro
	inner join Estantes est on lest.idEstante=est.idEstante
	where fact.idCliente=4 and lest.idEstante=45 and est.idBiblioteca=1
	group by det.idLibro) 
);
GO
/****** Object:  Table [dbo].[GenerosPersonas]    Script Date: 01/05/18 21:53:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GenerosPersonas](
	[idGenero] [int] IDENTITY(1,1) NOT NULL,
	[genero] [varchar](45) NULL,
 CONSTRAINT [PK_GenerosPersonas] PRIMARY KEY CLUSTERED 
(
	[idGenero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Continentes]    Script Date: 01/05/18 21:53:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Continentes](
	[idContinente] [int] IDENTITY(1,1) NOT NULL,
	[nombreContinente] [varchar](45) NULL,
 CONSTRAINT [PK_Continentes] PRIMARY KEY CLUSTERED 
(
	[idContinente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paises]    Script Date: 01/05/18 21:53:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Paises](
	[idPais] [int] IDENTITY(1,1) NOT NULL,
	[idContinente] [int] NOT NULL,
	[nombrePais] [varchar](45) NULL,
 CONSTRAINT [PK_Paises] PRIMARY KEY CLUSTERED 
(
	[idPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ciudades]    Script Date: 01/05/18 21:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ciudades](
	[idCiudad] [int] IDENTITY(1,1) NOT NULL,
	[idPais] [int] NOT NULL,
	[nombreCiudad] [varchar](60) NOT NULL,
 CONSTRAINT [PK_Ciudades] PRIMARY KEY CLUSTERED 
(
	[idCiudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Direcciones]    Script Date: 01/05/18 21:53:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Direcciones](
	[idDireccion] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
	[idCiudad] [int] NOT NULL,
 CONSTRAINT [PK_Direccione] PRIMARY KEY CLUSTERED 
(
	[idDireccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Telefonos]    Script Date: 01/05/18 21:53:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Telefonos](
	[idTelefono] [int] IDENTITY(1,1) NOT NULL,
	[idPersona] [int] NULL,
	[idBiblioteca] [int] NULL,
	[numeroTelefonico] [varchar](45) NULL,
 CONSTRAINT [PK_Telefonos] PRIMARY KEY CLUSTERED 
(
	[idTelefono] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_InformacionCliente]    Script Date: 01/05/18 21:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_InformacionCliente](@pnidCliente int)
RETURNS TABLE  
AS  
RETURN   
(  
select per.pNombre,per.sNombre,per.pApellido,per.sApellido,per.fechaNacimiento,per.identidad,per.correoElectronico,gen.genero,
		cli.fechaRegistro,tel.numeroTelefonico,dir.descripcion,ciu.nombreCiudad,pai.nombrePais,cont.nombreContinente from Personas per
inner join Clientes cli on per.idPersona=cli.idPersona
inner join GenerosPersonas gen on per.idGenero=gen.idGenero
inner join Direcciones dir on per.idDireccion=dir.idDireccion
inner join Ciudades ciu on dir.idCiudad=ciu.idCiudad
inner join Paises pai on ciu.idPais=pai.idPais
inner join Continentes cont on pai.idContinente=cont.idContinente
inner join Telefonos tel on per.idPersona=tel.idPersona
where cli.idPersona=@pnidCliente
);
GO
/****** Object:  Table [dbo].[Bibliotecas]    Script Date: 01/05/18 21:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bibliotecas](
	[idBiblioteca] [int] IDENTITY(1,1) NOT NULL,
	[idDireccion] [int] NOT NULL,
	[nombre] [varchar](50) NULL,
	[fechaCreacion] [date] NULL,
 CONSTRAINT [PK_Bibliotecas] PRIMARY KEY CLUSTERED 
(
	[idBiblioteca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_InformacionEmpleado]    Script Date: 01/05/18 21:53:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_InformacionEmpleado](@pnidEmpleado int,@pnidBiblioteca int)
RETURNS TABLE  
AS  
RETURN   
( 
select per.pNombre,per.sNombre,per.pApellido,per.sApellido,per.fechaNacimiento,per.identidad,per.correoElectronico,gen.genero,
		bib.nombre 'Nombre de la biblioteca',emp.fechaContratacion,dir.descripcion,ciu.nombreCiudad,pai.nombrePais,cont.nombreContinente from Personas per
inner join Empleados emp on per.idPersona=emp.idPersona
inner join GenerosPersonas gen on per.idGenero=gen.idGenero
inner join Direcciones dir on per.idDireccion=dir.idDireccion
inner join Ciudades ciu on dir.idCiudad=ciu.idCiudad
inner join Paises pai on ciu.idPais=pai.idPais
inner join Continentes cont on pai.idContinente=cont.idContinente
inner join Bibliotecas bib on emp.idBiblioteca=bib.idBiblioteca
where emp.idPersona=@pnidEmpleado and bib.idBiblioteca=@pnidBiblioteca
);
GO
/****** Object:  Table [dbo].[GenerosLiterarios]    Script Date: 01/05/18 21:53:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GenerosLiterarios](
	[idGenero] [int] IDENTITY(1,1) NOT NULL,
	[genero] [varchar](45) NULL,
 CONSTRAINT [PK_GenerosLiterarios] PRIMARY KEY CLUSTERED 
(
	[idGenero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LibrosXGeneros]    Script Date: 01/05/18 21:53:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LibrosXGeneros](
	[idLibro] [int] NOT NULL,
	[idGenero] [int] NOT NULL,
 CONSTRAINT [PK_idLibro_idCategoria] PRIMARY KEY CLUSTERED 
(
	[idLibro] ASC,
	[idGenero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_librosXgenero]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_librosXgenero](nombreLibro, genero) as
select nombreLibro, genero from librosxgeneros lg
inner join GenerosLiterarios g on g.idGenero = lg.idGenero
inner join Libros l on l.idlibro = lg.idlibro;
GO
/****** Object:  Table [dbo].[Autores]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Autores](
	[idAutor] [int] IDENTITY(1,1) NOT NULL,
	[pNombre] [varchar](20) NOT NULL,
	[sNombre] [varchar](20) NULL,
	[pApellido] [varchar](20) NULL,
	[sApellido] [varchar](20) NULL,
	[biografia] [varchar](100) NULL,
	[idGenero] [int] NULL,
 CONSTRAINT [PK_Autores] PRIMARY KEY CLUSTERED 
(
	[idAutor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LibrosXAutores]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LibrosXAutores](
	[idLibro] [int] NOT NULL,
	[idAutor] [int] NOT NULL,
 CONSTRAINT [PK_librosXautores] PRIMARY KEY CLUSTERED 
(
	[idLibro] ASC,
	[idAutor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_LibrosXAutor]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[vw_LibrosXAutor](Nombre_Completo, nombreLibro ) 
as
Select CONCAT(a.pNombre,' ', a.pApellido)Nombre, l.nombreLibro from Libros l
inner join LibrosXAutores la on la.idLibro = l.idLibro
inner join Autores a  on a.idAutor = la.idAutor
GO
/****** Object:  View [dbo].[vw_totalComprasXCliente]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_totalComprasXCliente] (idPersona,pNombre,pApellido,Cantidad) as
select cli.idPersona,per.pNombre,per.pApellido,sum(det.cantidad) 'Cantidad' from DetallesFacturas det
inner join Facturas fact on det.idFactura=fact.idfactura
inner join clientes cli on fact.idCliente=cli.idPersona
inner join Personas per on cli.idPersona=per.idPersona
group by cli.idPersona, per.pNombre,per.pApellido
GO
/****** Object:  View [dbo].[vw_totalLibrosXestantes]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_totalLibrosXestantes](idEstante, totalLibrosEstantes) as
select idEstante, count(*) total_libros from LibrosXEstantes
group by idEstante;
GO
/****** Object:  View [dbo].[vw_totalesXfacturas]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_totalesXfacturas](Factura, Total) as
select df.idFactura, SUM(lib.precioVenta * df.cantidad) from DetallesFacturas df
inner join libros lib on df.idLibro=lib.idLibro
group by df.idFactura;
GO
/****** Object:  View [dbo].[vw_totalClientes]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_totalClientes](Cantidad)as
select COUNT(cli.idPersona) 'Total' from Clientes cli
GO
/****** Object:  View [dbo].[vw_bibliotecasXUbicacion]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_bibliotecasXUbicacion](idBiblioteca,Nombre,Descripcion,nombreCiudad,nombrePais,nombreContinente)as(
select bib.idBiblioteca,bib.nombre,dic.descripcion,ciu.nombreCiudad,pai.nombrePais,cont.nombreContinente from Bibliotecas bib
inner join Direcciones dic on bib.idDireccion=dic.idDireccion
inner join Ciudades ciu on dic.idCiudad=ciu.idCiudad
inner join Paises pai on ciu.idPais=pai.idPais
inner join Continentes cont on pai.idContinente=cont.idContinente
)
GO
/****** Object:  Table [dbo].[Cargos]    Script Date: 01/05/18 21:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cargos](
	[idCargo] [int] IDENTITY(1,1) NOT NULL,
	[cargo] [varchar](45) NOT NULL,
	[sueldo] [money] NOT NULL,
	[descripcion] [varchar](100) NULL,
 CONSTRAINT [PK_Cargos] PRIMARY KEY CLUSTERED 
(
	[idCargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_EmpleadosXCargo]    Script Date: 01/05/18 21:53:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_EmpleadosXCargo](idEmpleado,cargo,sueldo,fechaContratacion) as(
select emp.idPersona,car.cargo,car.sueldo,emp.fechaContratacion from Empleados emp
inner join Cargos car on emp.idCargo=car.idCargo
)
GO
/****** Object:  Table [dbo].[Descuentos]    Script Date: 01/05/18 21:53:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Descuentos](
	[idDescuento] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](45) NOT NULL,
	[valor] [money] NULL,
	[estado] [bit] NOT NULL,
 CONSTRAINT [PK_Descuentos] PRIMARY KEY CLUSTERED 
(
	[idDescuento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DescuentosXFacturas]    Script Date: 01/05/18 21:53:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DescuentosXFacturas](
	[idFactura] [int] NOT NULL,
	[idDescuento] [int] NOT NULL,
 CONSTRAINT [PK_DescuentosXFacturas] PRIMARY KEY CLUSTERED 
(
	[idFactura] ASC,
	[idDescuento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ediciones]    Script Date: 01/05/18 21:53:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ediciones](
	[idEdicion] [int] IDENTITY(1,1) NOT NULL,
	[idLibro] [int] NOT NULL,
	[numeroEdicion] [varchar](30) NULL,
	[fechaEdicion] [varchar](10) NULL,
 CONSTRAINT [PK_Ediciones] PRIMARY KEY CLUSTERED 
(
	[idEdicion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Editoriales]    Script Date: 01/05/18 21:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Editoriales](
	[idEditorial] [int] IDENTITY(1,1) NOT NULL,
	[nombreEditorial] [varchar](45) NULL,
 CONSTRAINT [PK_Editoriales] PRIMARY KEY CLUSTERED 
(
	[idEditorial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosLibros]    Script Date: 01/05/18 21:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosLibros](
	[idEstadoLibro] [int] IDENTITY(1,1) NOT NULL,
	[nombreEstado] [varchar](40) NOT NULL,
 CONSTRAINT [EstadoLibros] PRIMARY KEY CLUSTERED 
(
	[idEstadoLibro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormasPago]    Script Date: 01/05/18 21:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormasPago](
	[idFormaPago] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](45) NOT NULL,
	[estado] [bit] NOT NULL,
 CONSTRAINT [PK_FormasPago] PRIMARY KEY CLUSTERED 
(
	[idFormaPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Impuestos]    Script Date: 01/05/18 21:53:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Impuestos](
	[idImpuesto] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](45) NULL,
	[porcentaje] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[idImpuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LibrosXEntradas]    Script Date: 01/05/18 21:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LibrosXEntradas](
	[idLibro] [int] NOT NULL,
	[idEntrada] [int] NOT NULL,
	[cantidad] [int] NOT NULL,
 CONSTRAINT [PK_LibrosXEntradas] PRIMARY KEY CLUSTERED 
(
	[idLibro] ASC,
	[idEntrada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LibrosXSalidas]    Script Date: 01/05/18 21:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LibrosXSalidas](
	[idLibro] [int] NOT NULL,
	[idSalida] [int] NOT NULL,
	[cantidad] [int] NOT NULL,
 CONSTRAINT [PK_LibrosXSalidas] PRIMARY KEY CLUSTERED 
(
	[idLibro] ASC,
	[idSalida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movimientos]    Script Date: 01/05/18 21:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movimientos](
	[idMovimiento] [int] IDENTITY(1,1) NOT NULL,
	[idTipoMovimiento] [int] NOT NULL,
	[idTarjetaAcumulacion] [int] NOT NULL,
	[fecha] [date] NULL,
	[monto] [money] NULL,
 CONSTRAINT [PK_Movimientos] PRIMARY KEY CLUSTERED 
(
	[idMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TarjetasAcumulacion]    Script Date: 01/05/18 21:53:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarjetasAcumulacion](
	[idTarjetaAcumulacion] [int] IDENTITY(1,1) NOT NULL,
	[idCliente] [int] NOT NULL,
	[fechaRegistro] [date] NOT NULL,
 CONSTRAINT [PK_TarjetasAcumulaciones] PRIMARY KEY CLUSTERED 
(
	[idTarjetaAcumulacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposMovimientos]    Script Date: 01/05/18 21:53:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposMovimientos](
	[idTipoMovimiento] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](45) NULL,
 CONSTRAINT [PK_TipoMovimiento] PRIMARY KEY CLUSTERED 
(
	[idTipoMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Autores]  WITH CHECK ADD  CONSTRAINT [FK_Autores_idGenero] FOREIGN KEY([idGenero])
REFERENCES [dbo].[GenerosPersonas] ([idGenero])
GO
ALTER TABLE [dbo].[Autores] CHECK CONSTRAINT [FK_Autores_idGenero]
GO
ALTER TABLE [dbo].[Bibliotecas]  WITH CHECK ADD  CONSTRAINT [FK_Bibliotecas_idDireccion] FOREIGN KEY([idDireccion])
REFERENCES [dbo].[Direcciones] ([idDireccion])
GO
ALTER TABLE [dbo].[Bibliotecas] CHECK CONSTRAINT [FK_Bibliotecas_idDireccion]
GO
ALTER TABLE [dbo].[Ciudades]  WITH CHECK ADD  CONSTRAINT [FK_Ciudades_idPais] FOREIGN KEY([idPais])
REFERENCES [dbo].[Paises] ([idPais])
GO
ALTER TABLE [dbo].[Ciudades] CHECK CONSTRAINT [FK_Ciudades_idPais]
GO
ALTER TABLE [dbo].[DescuentosXFacturas]  WITH CHECK ADD  CONSTRAINT [FK_DescuentosXFacturas_idDescuento] FOREIGN KEY([idDescuento])
REFERENCES [dbo].[Descuentos] ([idDescuento])
GO
ALTER TABLE [dbo].[DescuentosXFacturas] CHECK CONSTRAINT [FK_DescuentosXFacturas_idDescuento]
GO
ALTER TABLE [dbo].[DescuentosXFacturas]  WITH CHECK ADD  CONSTRAINT [FK_DescuentosXFacturas_idFactura] FOREIGN KEY([idFactura])
REFERENCES [dbo].[Facturas] ([idFactura])
GO
ALTER TABLE [dbo].[DescuentosXFacturas] CHECK CONSTRAINT [FK_DescuentosXFacturas_idFactura]
GO
ALTER TABLE [dbo].[DetallesFacturas]  WITH CHECK ADD  CONSTRAINT [FK_DestallesFacturas_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[LibrosXEstantes] ([id])
GO
ALTER TABLE [dbo].[DetallesFacturas] CHECK CONSTRAINT [FK_DestallesFacturas_idLibro]
GO
ALTER TABLE [dbo].[DetallesFacturas]  WITH CHECK ADD  CONSTRAINT [FK_DetallesFacturas_Factura] FOREIGN KEY([idFactura])
REFERENCES [dbo].[Facturas] ([idFactura])
GO
ALTER TABLE [dbo].[DetallesFacturas] CHECK CONSTRAINT [FK_DetallesFacturas_Factura]
GO
ALTER TABLE [dbo].[Direcciones]  WITH CHECK ADD  CONSTRAINT [FK_Direcciones_idCiudad] FOREIGN KEY([idCiudad])
REFERENCES [dbo].[Ciudades] ([idCiudad])
GO
ALTER TABLE [dbo].[Direcciones] CHECK CONSTRAINT [FK_Direcciones_idCiudad]
GO
ALTER TABLE [dbo].[Ediciones]  WITH CHECK ADD  CONSTRAINT [FK_Libros_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[Libros] ([idLibro])
GO
ALTER TABLE [dbo].[Ediciones] CHECK CONSTRAINT [FK_Libros_idLibro]
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD  CONSTRAINT [FK_Cargos_idCargo] FOREIGN KEY([idCargo])
REFERENCES [dbo].[Cargos] ([idCargo])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Cargos_idCargo]
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD  CONSTRAINT [FK_Empleados_idBiblioteca] FOREIGN KEY([idBiblioteca])
REFERENCES [dbo].[Bibliotecas] ([idBiblioteca])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Empleados_idBiblioteca]
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD  CONSTRAINT [FK_Empleados_idPersona] FOREIGN KEY([idPersona])
REFERENCES [dbo].[Personas] ([idPersona])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Empleados_idPersona]
GO
ALTER TABLE [dbo].[Entradas]  WITH CHECK ADD  CONSTRAINT [FK_Entradas_idEmpleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleados] ([idPersona])
GO
ALTER TABLE [dbo].[Entradas] CHECK CONSTRAINT [FK_Entradas_idEmpleado]
GO
ALTER TABLE [dbo].[Estantes]  WITH CHECK ADD  CONSTRAINT [FK_Estantes_idBiblioteca] FOREIGN KEY([idBiblioteca])
REFERENCES [dbo].[Bibliotecas] ([idBiblioteca])
GO
ALTER TABLE [dbo].[Estantes] CHECK CONSTRAINT [FK_Estantes_idBiblioteca]
GO
ALTER TABLE [dbo].[Facturas]  WITH CHECK ADD  CONSTRAINT [FK_Factura_idCliente] FOREIGN KEY([idCliente])
REFERENCES [dbo].[Clientes] ([idPersona])
GO
ALTER TABLE [dbo].[Facturas] CHECK CONSTRAINT [FK_Factura_idCliente]
GO
ALTER TABLE [dbo].[Facturas]  WITH CHECK ADD  CONSTRAINT [FK_Facturas_idEmpleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleados] ([idPersona])
GO
ALTER TABLE [dbo].[Facturas] CHECK CONSTRAINT [FK_Facturas_idEmpleado]
GO
ALTER TABLE [dbo].[Facturas]  WITH CHECK ADD  CONSTRAINT [FK_Facturas_idFormaPago] FOREIGN KEY([idFormaPago])
REFERENCES [dbo].[FormasPago] ([idFormaPago])
GO
ALTER TABLE [dbo].[Facturas] CHECK CONSTRAINT [FK_Facturas_idFormaPago]
GO
ALTER TABLE [dbo].[Facturas]  WITH CHECK ADD  CONSTRAINT [FK_Impuestos] FOREIGN KEY([idImpuesto])
REFERENCES [dbo].[Impuestos] ([idImpuesto])
GO
ALTER TABLE [dbo].[Facturas] CHECK CONSTRAINT [FK_Impuestos]
GO
ALTER TABLE [dbo].[Libros]  WITH CHECK ADD  CONSTRAINT [FK_Libros_idEditorial] FOREIGN KEY([idEditorial])
REFERENCES [dbo].[Editoriales] ([idEditorial])
GO
ALTER TABLE [dbo].[Libros] CHECK CONSTRAINT [FK_Libros_idEditorial]
GO
ALTER TABLE [dbo].[LibrosXAutores]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXAutores_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[Libros] ([idLibro])
GO
ALTER TABLE [dbo].[LibrosXAutores] CHECK CONSTRAINT [FK_LibrosXAutores_idLibro]
GO
ALTER TABLE [dbo].[LibrosXEntradas]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXEntradas_idEntrada] FOREIGN KEY([idEntrada])
REFERENCES [dbo].[Entradas] ([idEntrada])
GO
ALTER TABLE [dbo].[LibrosXEntradas] CHECK CONSTRAINT [FK_LibrosXEntradas_idEntrada]
GO
ALTER TABLE [dbo].[LibrosXEntradas]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXEntradas_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[Libros] ([idLibro])
GO
ALTER TABLE [dbo].[LibrosXEntradas] CHECK CONSTRAINT [FK_LibrosXEntradas_idLibro]
GO
ALTER TABLE [dbo].[LibrosXEstantes]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXEstantes_idEstadoLibro] FOREIGN KEY([idEstadoLibro])
REFERENCES [dbo].[EstadosLibros] ([idEstadoLibro])
GO
ALTER TABLE [dbo].[LibrosXEstantes] CHECK CONSTRAINT [FK_LibrosXEstantes_idEstadoLibro]
GO
ALTER TABLE [dbo].[LibrosXEstantes]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXEstantes_idEstante] FOREIGN KEY([idEstante])
REFERENCES [dbo].[Estantes] ([idEstante])
GO
ALTER TABLE [dbo].[LibrosXEstantes] CHECK CONSTRAINT [FK_LibrosXEstantes_idEstante]
GO
ALTER TABLE [dbo].[LibrosXEstantes]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXEstantes_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[Libros] ([idLibro])
GO
ALTER TABLE [dbo].[LibrosXEstantes] CHECK CONSTRAINT [FK_LibrosXEstantes_idLibro]
GO
ALTER TABLE [dbo].[LibrosXGeneros]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXCategoria_idCategoria] FOREIGN KEY([idGenero])
REFERENCES [dbo].[GenerosLiterarios] ([idGenero])
GO
ALTER TABLE [dbo].[LibrosXGeneros] CHECK CONSTRAINT [FK_LibrosXCategoria_idCategoria]
GO
ALTER TABLE [dbo].[LibrosXGeneros]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXCategoria_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[Libros] ([idLibro])
GO
ALTER TABLE [dbo].[LibrosXGeneros] CHECK CONSTRAINT [FK_LibrosXCategoria_idLibro]
GO
ALTER TABLE [dbo].[LibrosXSalidas]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXSalidas_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[Libros] ([idLibro])
GO
ALTER TABLE [dbo].[LibrosXSalidas] CHECK CONSTRAINT [FK_LibrosXSalidas_idLibro]
GO
ALTER TABLE [dbo].[LibrosXSalidas]  WITH CHECK ADD  CONSTRAINT [FK_LibrosXSalidas_idSalida] FOREIGN KEY([idSalida])
REFERENCES [dbo].[Salidas] ([idSalida])
GO
ALTER TABLE [dbo].[LibrosXSalidas] CHECK CONSTRAINT [FK_LibrosXSalidas_idSalida]
GO
ALTER TABLE [dbo].[Movimientos]  WITH CHECK ADD  CONSTRAINT [FK_Movimientos_idTarjetaAcumulacion] FOREIGN KEY([idTarjetaAcumulacion])
REFERENCES [dbo].[TarjetasAcumulacion] ([idTarjetaAcumulacion])
GO
ALTER TABLE [dbo].[Movimientos] CHECK CONSTRAINT [FK_Movimientos_idTarjetaAcumulacion]
GO
ALTER TABLE [dbo].[Movimientos]  WITH CHECK ADD  CONSTRAINT [FK_Movimientos_idTipoMovimiento] FOREIGN KEY([idTipoMovimiento])
REFERENCES [dbo].[TiposMovimientos] ([idTipoMovimiento])
GO
ALTER TABLE [dbo].[Movimientos] CHECK CONSTRAINT [FK_Movimientos_idTipoMovimiento]
GO
ALTER TABLE [dbo].[Paises]  WITH CHECK ADD  CONSTRAINT [FK_Paises_idContinente] FOREIGN KEY([idContinente])
REFERENCES [dbo].[Continentes] ([idContinente])
GO
ALTER TABLE [dbo].[Paises] CHECK CONSTRAINT [FK_Paises_idContinente]
GO
ALTER TABLE [dbo].[Personas]  WITH CHECK ADD  CONSTRAINT [FK_Personas_idDireccion] FOREIGN KEY([idDireccion])
REFERENCES [dbo].[Direcciones] ([idDireccion])
GO
ALTER TABLE [dbo].[Personas] CHECK CONSTRAINT [FK_Personas_idDireccion]
GO
ALTER TABLE [dbo].[Personas]  WITH CHECK ADD  CONSTRAINT [FK_Personas_idGenero] FOREIGN KEY([idGenero])
REFERENCES [dbo].[GenerosPersonas] ([idGenero])
GO
ALTER TABLE [dbo].[Personas] CHECK CONSTRAINT [FK_Personas_idGenero]
GO
ALTER TABLE [dbo].[Prestamos]  WITH CHECK ADD  CONSTRAINT [FK_Prestamos_idLibro] FOREIGN KEY([idLibro])
REFERENCES [dbo].[LibrosXEstantes] ([id])
GO
ALTER TABLE [dbo].[Prestamos] CHECK CONSTRAINT [FK_Prestamos_idLibro]
GO
ALTER TABLE [dbo].[Prestamos]  WITH CHECK ADD  CONSTRAINT [FK_Prestamos_idPersona] FOREIGN KEY([idCliente])
REFERENCES [dbo].[Clientes] ([idPersona])
GO
ALTER TABLE [dbo].[Prestamos] CHECK CONSTRAINT [FK_Prestamos_idPersona]
GO
ALTER TABLE [dbo].[Salidas]  WITH CHECK ADD  CONSTRAINT [FK_Salidas_idBiblioteca] FOREIGN KEY([idBiblioteca])
REFERENCES [dbo].[Bibliotecas] ([idBiblioteca])
GO
ALTER TABLE [dbo].[Salidas] CHECK CONSTRAINT [FK_Salidas_idBiblioteca]
GO
ALTER TABLE [dbo].[Salidas]  WITH CHECK ADD  CONSTRAINT [FK_Salidas_idEmpleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleados] ([idPersona])
GO
ALTER TABLE [dbo].[Salidas] CHECK CONSTRAINT [FK_Salidas_idEmpleado]
GO
ALTER TABLE [dbo].[TarjetasAcumulacion]  WITH CHECK ADD  CONSTRAINT [FK_TarjetasAcumulacion_idClente] FOREIGN KEY([idCliente])
REFERENCES [dbo].[Clientes] ([idPersona])
GO
ALTER TABLE [dbo].[TarjetasAcumulacion] CHECK CONSTRAINT [FK_TarjetasAcumulacion_idClente]
GO
ALTER TABLE [dbo].[Telefonos]  WITH CHECK ADD  CONSTRAINT [FK_Telefonos_idBiblioteca] FOREIGN KEY([idBiblioteca])
REFERENCES [dbo].[Bibliotecas] ([idBiblioteca])
GO
ALTER TABLE [dbo].[Telefonos] CHECK CONSTRAINT [FK_Telefonos_idBiblioteca]
GO
ALTER TABLE [dbo].[Telefonos]  WITH CHECK ADD  CONSTRAINT [FK_Telefonos_idPersona] FOREIGN KEY([idPersona])
REFERENCES [dbo].[Personas] ([idPersona])
GO
ALTER TABLE [dbo].[Telefonos] CHECK CONSTRAINT [FK_Telefonos_idPersona]
GO
/****** Object:  StoredProcedure [dbo].[SP_actualizarCliente]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_actualizarCliente](

	@pnidPersona            int,
	@pcpNombre				varchar(20),
	@pcsNombre				varchar(20),
	@pcpApellido			varchar(20),
	@pcsApellido			varchar(20),
	@pcIdentidad			varchar(20),
	@pcCorreoElectronico	varchar(30),
	@pcTelefono			    varchar(45),
	@pnidGenero				int,
	@pcDireccion			varchar(100),
	@pnidCiudad				INT,
	@pdfechaNacimiento		date,
	@pcMensaje				VARCHAR (100) OUTPUT,
	@pbOcurrioError			int OUTPUT)

AS
BEGIN
-- inicializacion de variable--
	DECLARE @vcMensaje             varchar(100);
	DECLARE @vnConteo              int;

--inicializar parametros de salida --
	SET @pcMensaje='';
	SET @pbOcurrioError=1;
	SET @vcMensaje='';

	BEGIN TRAN actualizar_cliente
	BEGIN TRY

-- VALIDAR DATOS INGRESADOS--
--VERIFICAR QUE LOS DATOS NO SEA NULOS --
		if @pcpNombre='' or @pcpNombre is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'primer nombre,');
		END
		if @pcpApellido='' or @pcpApellido is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'primer apellido');
		END
		if @pcIdentidad	='' or @pcIdentidad is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'identidad');
		END
		if @pcCorreoElectronico='' or @pcCorreoElectronico is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'correo electronico');
		END
		if @pcTelefono='' or @pcTelefono is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'contraseña');
		END
		if @pnidGenero='' or @pnidGenero is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'genero,');
		END
		if @pcDireccion='' or @pcDireccion is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'');
		END
		if @pnidCiudad	='' or @pnidCiudad is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'id de la ciudad,');
		END
		if @pdfechaNacimiento='' or @pdfechaNacimiento is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'fecha de nacimiento.');
		END

--SI HAY DATOS NULOS ALMACENA EL MENSAJE --
		if @vcMensaje <> '' begin
			set @pcMensaje='Campos requeridos para realizar el registro:'+@vcMensaje;
			return;
		end

--COMPROBAR SI EXISTEN LOS DATOS INGRESADOS --

--COMPROBAR SI EXISTE EL ID GENERO--
		SELECT @vnConteo=count(*) FROM GenerosPersonas where idGenero=@pnidGenero;

		if @vnConteo=0 begin
			set @pcMensaje=@pcmensaje +'El id de genero no existe';
			return;
		end

-- COMPROBAR SI EXISTE EL ID DE CIUDAD --
		SELECT @vnConteo=count(*) FROM Ciudades where idCiudad=@pnidCiudad;

		if @vnConteo=0 begin
			set @pcMensaje=@pcmensaje +'El id de ciudad no existe';
			return;
		end
-- COMPROBAR QUE ESTE REGISTRADO EN CLIENTES --
		select @vnConteo=count(*) from Clientes where idPersona=@pnidPersona
		if @vnConteo=0 begin
			set @pcMensaje=@pcMensaje +'El cliente no esta registrado';
			return;
		END

-- INSERTAR LOS DATOS A LAS TABLAS CORRESPONDIENTES--
		ELSE 
		BEGIN
			
			update Personas
			set pNombre=@pcpNombre,sNombre=@pcsNombre,pApellido=@pcpApellido,sApellido=@pcsApellido,identidad=@pcIdentidad,correoElectronico=@pcCorreoElectronico,idGenero=@pnidGenero,fechaNacimiento=@pdfechaNacimiento
			where idPersona=@pnidPersona

			update Telefonos
			set numeroTelefonico=@pcTelefono
			where idPersona=@pnidPersona

			update Direcciones
			set descripcion=@pcDireccion,idCiudad=@pnidCiudad
			where idDireccion=( select dir.idDireccion from Direcciones dir
								inner join Personas per on dir.idDireccion=per.idDireccion
								where per.idPersona=@pnidPersona)

			set @pcMensaje=@pcMensaje+'Datos actualizados correctamente';
			set @pbOcurrioError=0;
			COMMIT TRAN actualizar_cliente
		END
	END TRY
	BEGIN CATCH
		
        SET @pcMensaje = 'Ocurrio un Error: ' + ERROR_MESSAGE() + ' en la línea ' + CONVERT(NVARCHAR(255), ERROR_LINE() ) + '.'
		ROLLBACK TRAN actualizar_cliente
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_actualizarConstrasena]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_actualizarConstrasena](
				@pnIdPersona int,
				@pcContrasenaVieja varchar(50),
				@pcContrasenaNueva varchar(50),
				@pcMensaje varchar(100) output,
				@pnOcurrioError int output
)
AS
BEGIN

DECLARE @vcMensaje varchar(100);
DECLARE @vnConteo int;

SET @pcMensaje = '';
SET @vcMensaje = '';
SET @vnConteo = 0;
SET @pnOcurrioError = 1;


	IF @pnIdPersona = '' or @pnIdPersona is null
		BEGIN 
			SET @vcMensaje = @vcMensaje + CONVERT(VARCHAR,' Cliente no registrado,');
		END
	
	IF @pcContrasenaVieja = '' or @pcContrasenaVieja is null
		BEGIN
			SET @vcMensaje = @vcMensaje + CONVERT(VARCHAR,' CONTRASEÑA Vieja Vacia, ');
		END

	IF @pcContrasenaNueva = '' or @pcContrasenaNueva is null
		BEGIN
			SET @vcMensaje = @vcMensaje + CONVERT(VARCHAR,' CONTRASEÑA Nueva Vacia, ');
		END

	IF @vcMensaje<> ''
		BEGIN
			SET @pcMensaje =@pcMensaje + 'HUBO ERROR EN LOS SIGUIENTES CAMPOS: ' + @vcMensaje;
		END

	
	SELECT @vnConteo = COUNT(*) FROM Personas
		where contrasena = @pcContrasenaVieja;
		IF @vnConteo = 0
			BEGIN 
				SET @pcMensaje = @pcMensaje + 'La contraseña no coincide';
				RETURN;
			END

	UPDATE Personas set contrasena=@pcContrasenaNueva
	where idPersona = @pnIdPersona
	set @pcMensaje=@pcMensaje+'Nombre Busqueda ingresado correctamente';
	set @pnOcurrioError=0;

END

GO
/****** Object:  StoredProcedure [dbo].[SP_buscarPorNombre]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_buscarPorNombre](
				@pnTipo			int,
				@pcNombreBusqueda varchar(50) = Null,
				@pcMensaje  varchar(50) output,
				@pnOcurrioError int output
)

AS
BEGIN
	--INICIALIZAMOS VARIABLES
	DECLARE		@vcMensaje	varchar(100);
	
	--INICIALIZAMOS PARAMETROS DE SALIDA
	SET @pcMensaje = '';
	SET @vcMensaje = '';
	set @pnOcurrioError=1;

	IF  @pnTipo = null 
		BEGIN
			SET @pcMensaje = @pcMensaje + CONVERT(varchar,'Tipo está nulo');
			return;
		END

	IF (@pnTipo = 0)
		BEGIN
			Select * from Libros l
			SET @pnOcurrioError = 0
			RETURN;
	END

	IF (@pnTipo = 1)
		BEGIN
			IF @pcNombreBusqueda = '' or @pcNombreBusqueda is null
				BEGIN
				SET @vcMensaje = @vcMensaje + CONVERT(varchar,'Nombre de la Busqueda');
	
		END

			IF @vcMensaje<> ''
				BEGIN
					SET @pcMensaje ='Campos Requeridos: ' + @vcMensaje;
					return;
				END

		
				Select * from libros l
				where l.nombreLibro like '%'+@pcNombreBusqueda+'%'
				set @pcMensaje=@pcMensaje+'Nombre Busqueda ingresado correctamente';
				set @pnOcurrioError=0;

		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_busquedaFiltro]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_busquedaFiltro](
					@pnTipo int,
					@pcMensaje	varchar(100) output,
					@pnOcurrioError int output
)

AS
BEGIN

DECLARE @vcMensaje	varchar(100);


SET @vcMensaje = '';
SET	@pcMensaje = '';
SET @pnOcurrioError = 1;

	IF @pnTipo is null 
		BEGIN
			
			SET @pcMensaje = @pcMensaje + Convert(varchar,'El Tipo está vació');
			RETURN;
		END
	-- TIPO = 0 ES IGUAL A AUTOR
	IF @pnTipo = 0
		BEGIN
			SELECT idAutor, a.pNombre+ ' ' + a.pApellido as Nombre FROM AUTORES a
			order by a.pNombre
			set @pcMensaje=@pcMensaje+' Todo es Correcto';
			SET @pnOcurrioError = 0;
			RETURN;
		END

	-- TIPO = 1 ES IGUAL A GENERO
	IF @pnTipo = 1
		BEGIN
			SELECT idGenero,g.genero as Nombre FROM GenerosLiterarios g
			order by g.genero
			set @pcMensaje=@pcMensaje+' Todo es Correcto';
			SET @pnOcurrioError = 0;
			RETURN;
		END
	
	-- TIPO = 2 ES IGUAL A BIBLIOTECA
	IF @pnTipo = 2
		BEGIN
			SELECT idBiblioteca as Numero FROM Bibliotecas 
			order by idBiblioteca
			set @pcMensaje=@pcMensaje+' Todo es Correcto';
			SET @pnOcurrioError = 0;
			RETURN;
		END

	ELSE
		BEGIN
			set @pcMensaje=@pcMensaje+' HUBO ERROR';
		END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_busquedaLibro]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_busquedaLibro](
					@pnTipo int,
					@pnidEleccion int,
					@pcMensaje	varchar(100) output,
					@pnOcurrioError int output
)

AS
BEGIN

DECLARE @vcMensaje	varchar(100);


SET @vcMensaje = '';
SET	@pcMensaje = '';
SET @pnOcurrioError = 1;

	IF @pnTipo is null 
		BEGIN
			SET @pcMensaje = @pcMensaje + Convert(varchar,'El Tipo está vació');
			RETURN;
		END

	IF @pnidEleccion='' or @pnidEleccion is null 
		BEGIN
			SET @pcMensaje = @pcMensaje + Convert(varchar,'El idEleccion está vació');
			RETURN;
		END
	-- TIPO = 0 ES IGUAL A AUTOR
	IF @pnTipo = 0
		BEGIN
			SELECT l.idLibro,l.nombreLibro,l.ISBN,l.paginas,l.sinopsis,l.precioVenta  FROM LibrosXAutores la
				inner join libros l on l.idLibro = la.idLibro
				where idAutor = @pnidEleccion
			set @pcMensaje=@pcMensaje+' Todo es Correcto';
			SET @pnOcurrioError = 0;
			RETURN;
		END

	-- TIPO = 1 ES IGUAL A GENERO
	IF @pnTipo = 1
		BEGIN
			SELECT l.idLibro,l.nombreLibro,l.ISBN,l.paginas,l.sinopsis,l.precioVenta  FROM Libros l
						inner join LibrosXGeneros lg on lg.idLibro = l.idLibro
						where lg.idGenero = @pnidEleccion
			set @pcMensaje=@pcMensaje+' Todo es Correcto';
			SET @pnOcurrioError = 0;
			RETURN;
		END
	
	-- TIPO = 2 ES IGUAL A BIBLIOTECA
	IF @pnTipo = 2
		BEGIN
			SELECT l.idLibro,l.nombreLibro,l.ISBN,l.paginas,l.sinopsis,l.precioVenta  FROM Libros l
				inner join LibrosXEstantes le on le.idLibro = l.idLibro
				where le.idEstante in (Select idEstante from Estantes where idBiblioteca =  @pnidEleccion) 
			set @pcMensaje=@pcMensaje+' Todo es Correcto';
			SET @pnOcurrioError = 0;
			RETURN;
		END

	ELSE
		BEGIN
			set @pcMensaje=@pcMensaje+' HUBO ERROR';
		END
END


GO
/****** Object:  StoredProcedure [dbo].[SP_crearFactura]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[SP_crearFactura](
			@pnidEmpleado	int,
			@pnidCliente	int = null,
			@pnFormaPago	int,
			@pcObservacion	varchar(50) = null,
			@pnidImpuesto	int,
			@pnidDescuento	int = null,
			--@pnidLibro		int, -- Poner una condicion que sean del estante 45
			@pnidFactura	int output,
			@pcMensaje		varchar(100) output,
			@pnOcurrioError	int output
)
AS
BEGIN
	DECLARE @vcMensaje varchar(100);
	DECLARE @vnConteo	int;
	DECLARE @vnUltimaFactura int;
	DECLARE @vnMinimoId int;

	SET @pcMensaje = '';
	SET @pnOcurrioError = 0;
	SET @vcMensaje = '';
	SET @vnConteo = 0;
	SET @vnUltimaFactura =0;
	SET @vnMinimoId = 0;
	SET @pnidFactura = 0;

	IF	@pnidCliente = '' or @pnidCliente is null
		BEGIN
			SET @vcMensaje = @vcMensaje + CONVERT(varchar,' El ID Cliente, ');
		END
	
	IF	@pnidEmpleado = '' or @pnidEmpleado is null
		BEGIN
			SET @vcMensaje = @vcMensaje + CONVERT(varchar,' El ID Empleado, ');
		END

	IF	@pnFormaPago = '' or @pnFormaPago is null
		BEGIN
			SET @vcMensaje = @vcMensaje + CONVERT(varchar,' Forma de Pago, ');
		END

	IF	@pnidImpuesto = '' or @pnidImpuesto is null
		BEGIN
			SET @vcMensaje = @vcMensaje + CONVERT(varchar,' El ID Impuesto, ');
		END

	--IF	@pnidLibro = '' or @pnidLibro is null
	--	BEGIN
	--		SET @vcMensaje = @vcMensaje + CONVERT(varchar,' El ID Libro, ');
	--	END

	IF @vcMensaje <> ''
		BEGIN
			SET @pcMensaje = 'Los Campos Vacios son: ' + @vcMensaje;
			RETURN;
		END
	-----------------------------------------------
	IF @pnidCliente<> null 
		BEGIN
			Select @vnConteo = COUNT(*) From Personas where idPersona = @pnidCliente;
			If @vnConteo = 0
				BEGIN
					SET @pcMensaje = 'EL CLiente no está registrado-';
					RETURN;
				END
		END
	

	Select @vnConteo = COUNT(*) From FormasPago fp where fp.idFormaPago = @pnFormaPago and fp.estado = 1;
	IF @vnConteo = 0
		BEGIN
			SET @pcMensaje = 'La forma de Pago es incorrecta.';
			RETURN;
		END

	Select @vnConteo = COUNT(*) From Impuestos i where i.idImpuesto = @pnidImpuesto 
	IF @vnConteo = 0
		BEGIN
			SET @pcMensaje = 'El tipo de Impuesto es incorrecta.';
			RETURN;
		END

	--Select @vnConteo = COUNT(*) from LibrosXEstantes where id = @pnidLibro 
	--IF @vnConteo = 0
	--	BEGIN
	--		SET @pcMensaje = 'El Id  no es válido';
	--		RETURN;
	--	END

	ELSE

		BEGIN
			Insert into Facturas (idEmpleado,idCliente,idFormaPago,fecha,observacion,idImpuesto)
			values (@pnidEmpleado,@pnidCliente,@pnFormaPago,GETDATE(),@pcObservacion,@pnidImpuesto);
			Select @vnUltimaFactura = Max(idFactura) from Facturas	
			SET @pnidFactura = @vnUltimaFactura;
			SET @pcMensaje = 'Todo ocurrió con éxito.';
			SET @pnOcurrioError = 0;
		END		
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insertarCliente]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_insertarCliente](

	@pcpNombre				varchar(20),
	@pcsNombre				varchar(20),
	@pcpApellido			varchar(20),
	@pcsApellido			varchar(20),
	@pcIdentidad			varchar(20),
	@pcCorreoElectronico	varchar(30),
	@pcTelefono				varchar(45),
	@pcContraseña			varchar(20),
	@pnidGenero				int,
	@pcDireccion			varchar(100),
	@pnidCiudad				INT,
	@pdfechaNacimiento		date,
	@pcMensaje				VARCHAR (100) OUTPUT,
	@pbOcurrioError			int OUTPUT)

AS
BEGIN
-- inicializacion de variable--
	DECLARE @vcMensaje             varchar(100);
	DECLARE @vnConteo              int;
	DECLARE @vnUltimaDireccion     int;
	DECLARE @vnUltimaPersona       int;

--inicializar parametros de salida --
	SET @pcMensaje='';
	SET @pbOcurrioError=1;
	SET @vcMensaje='';

	BEGIN TRAN registro_cliente
	BEGIN TRY

-- VALIDAR DATOS INGRESADOS--
--VERIFICAR QUE LOS DATOS NO SEA NULOS --
		if @pcpNombre='' or @pcpNombre is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'primer nombre,');
		END
		if @pcpApellido='' or @pcpApellido is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'primer apellido');
		END
		if @pcIdentidad	='' or @pcIdentidad is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'identidad');
		END
		if @pcCorreoElectronico='' or @pcCorreoElectronico is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'correo electronico');
		END
		if @pcTelefono='' or @pcTelefono is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'telefono');
		END
		if @pcContraseña='' or @pcContraseña is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'contraseña,');
		END
		if @pnidGenero='' or @pnidGenero is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'genero,');
		END
		if @pcDireccion='' or @pcDireccion is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'');
		END
		if @pnidCiudad	='' or @pnidCiudad is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'id de la ciudad,');
		END
		if @pdfechaNacimiento='' or @pdfechaNacimiento is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'fecha de nacimiento.');
		END

--SI HAY DATOS NULOS ALMACENA EL MENSAJE --
		if @vcMensaje <> '' begin
			set @pcMensaje='Campos requeridos para realizar el registro:'+@vcMensaje;
			return;
		end

--COMPROBAR SI EXISTEN LOS DATOS INGRESADOS --

--COMPROBAR SI EXISTE EL ID GENERO--
		SELECT @vnConteo=count(*) FROM GenerosPersonas where idGenero=@pnidGenero;

		if @vnConteo=0 begin
			set @pcMensaje=@pcmensaje +'El id de genero no existe';
			return;
		end

-- COMPROBAR SI YA EXISTE EL NUMERO DE TELEFONO--
		SELECT @vnConteo=COUNT(*) FROM Telefonos where numeroTelefonico=@pcTelefono;

		if @vnConteo>0 begin
			set @pcMensaje=@pcMensaje + 'ya existe el numero telefonico';
			return;
		end

-- COMPROBAR SI EXISTE EL ID DE CIUDAD --
		SELECT @vnConteo=count(*) FROM Ciudades where idCiudad=@pnidCiudad;

		if @vnConteo=0 begin
			set @pcMensaje=@pcmensaje +'El id de ciudad no existe';
			return;
		end

--COMPROBAR SI EXISTE EL CORREO ELECTRONICO--
		SELECT @vnConteo=COUNT(*) FROM Personas where correoElectronico=@pcCorreoElectronico;

		if @vnConteo>0 begin
			set @pcMensaje=@pcmensaje +'El correo eletronico ya existe';
			return;
		end
-- COMPROBAR QUE NO ESTE REGISTRADO EN CLIENTES --
		select @vnConteo=count(*) from Clientes where idPersona=(select idPersona from Personas where identidad=@pcIdentidad);

		if @vnConteo=1 begin
			set @pcMensaje=@pcMensaje +'El cliente ya esta registrado';
			return;
		END

-- INSERTAR LOS DATOS A LAS TABLAS CORRESPONDIENTES--
		ELSE 
		BEGIN
			
			insert into Direcciones(descripcion,idCiudad)
			values(@pcDireccion,@pnidCiudad);
			select @vnUltimaDireccion =max(idDireccion) from Direcciones;
			insert into Personas(idGenero,idDireccion,pNombre,sNombre,pApellido,sApellido,fechaNacimiento,identidad,correoElectronico,contrasena)
			values(@pnidGenero,@vnUltimaDireccion,@pcpNombre,@pcsNombre,@pcpApellido,@pcsApellido,@pdfechaNacimiento,@pcIdentidad,@pcCorreoElectronico,@pcContraseña);
			select @vnUltimaPersona =max(idPersona)from Personas;
			insert into Clientes(fechaRegistro,idPersona)
			values(getdate(),@vnUltimaPersona);
			insert into Telefonos(idPersona,numeroTelefonico)
			values(@vnUltimaPersona,@pcTelefono);
			set @pcMensaje=@pcMensaje+'Cliente ingresado correctamente';
			set @pbOcurrioError=0;
			COMMIT TRAN registro_cliente
		END
	END TRY
	BEGIN CATCH
		
        SET @pcMensaje = 'Ocurrio un Error: ' + ERROR_MESSAGE() + ' en la línea ' + CONVERT(NVARCHAR(255), ERROR_LINE() ) + '.'
		ROLLBACK TRAN registro_cliente
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insertarDetallesFacturas]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[SP_insertarDetallesFacturas](
			@pnId int,
			@pnidCliente int,
			@pnidFactura int,
			@pcMensaje varchar(100) output,
			@pnOcurrioError int output
)
AS
BEGIN
	
	DECLARE @vcMensaje varchar(100);
	DECLARE @vnConteo int;
	DECLARE @vnidEstante int;
	DECLARE @vnidEstadoLibro int;

	SET @pcMensaje = '';
	SET @pnOcurrioError = 1;
	SET @vcMensaje = '';
	SET @vnConteo = 0;
	SET @vnidEstante = 0;
	SET @vnidEstadoLibro = 0;

	IF @pnId = '' or @pnId is null
		Begin
			SET @vcMensaje = @vcMensaje + CONVERT(varchar, ' ID de LibrosXEstantes, ');
		END

	IF @pnidCliente = '' or @pnidCliente is null
		Begin
			SET @vcMensaje = @vcMensaje + CONVERT(varchar, ' ID Cliente , ');
		END

	IF @pnidFactura = '' or @pnidFactura is null
		Begin
			SET @vcMensaje = @vcMensaje + CONVERT(varchar, ' ID Factura, ');
		END

	IF @vcMensaje<> ''
		BEGIN
			SET @pcMensaje = 'Hubo Error en los siguientes Campos: ' + @vcMensaje;
			RETURN;
		END

	Select @vnConteo = COUNT(*) from LibrosXEstantes where id = @pnId
	IF @vnConteo = 0
		BEGIN
			SET @pcMensaje = 'el ID LibrosXEstantes no existe';
			RETURN;
		END

	Select @vnConteo = COUNT(*) from Clientes where idPersona = @pnidCliente
	IF @vnConteo = 0
		BEGIN
			SET @pcMensaje = 'el ID Cliente no existe';
			RETURN;
		END

	Select @vnConteo = COUNT(*) from Facturas where idFactura = @pnidFactura
	IF @vnConteo = 0
		BEGIN
			SET @pcMensaje = 'el ID LibrosXEstantes no existe';
			RETURN;
		END

	ELSE
		BEGIN
			Select @vnidEstante = idEstante from LibrosXEstantes where id= @pnId
			Select @vnidEstadoLibro = idEstadoLibro from LibrosXEstantes where id= @pnId
			--Insert DetallesFacturas values(@pnId,@pnidFactura)
			IF @vnidEstante = 45 and @vnidEstadoLibro = 3
				BEGIN
					Insert DetallesFacturas values(@pnId,@pnidFactura)
					Update LibrosXEstantes set idEstadoLibro = 5
					where id = @pnId
					SET @pcMensaje ='Se compró el libro con éxito';
				END
			IF @vnidEstante<> 45 and @vnidEstadoLibro=3
				BEGIN
					Insert DetallesFacturas values(@pnId,@pnidFactura)
					Update LibrosXEstantes set idEstadoLibro = 1
					where id = @pnId
					Insert Prestamos (idLibro,idCliente,fechaInicio,fechaFin)
					values(@pnId,@pnidCliente,GETDATE(),'2018-05-13')
					SET @pcMensaje ='Se prestó el libro con éxito';
				END
			IF @vnidEstadoLibro<> 3 
				BEGIN
					SET @pcMensaje = 'El libro no está disponible';
					RETURN;
				END

				SET @pnOcurrioError = 0;
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insertarEmpleado]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_insertarEmpleado](
				@pcpNombre				varchar(20),
				@pcsNombre				varchar(20),
				@pcpApellido			varchar(20),
				@pcsApellido			varchar(20),
				@pcIdentidad			varchar(20),
				@pcCorreoElectronico	varchar(30),
				@pcContrasena			varchar(20),
				@pnidGenero				int,
				@pcDireccion			varchar(100),
				@pnidCiudad				INT,
				@pdfechaNacimiento		date,
				@pnCargo				int,
				@pdfechaContratacion	date,
				@pnidBiblioteca			int,
				@pcMensaje				VARCHAR (100) OUTPUT,
				@pbOcurrioError			int OUTPUT)
AS
BEGIN
-- inicializacion de variable--
	DECLARE @vcMensaje             varchar(100);
	DECLARE @vnConteo              int;
	DECLARE @vnUltimaDireccion     int;
	DECLARE @vnUltimaPersona       int;

--inicializar parametros de salida --
	SET @pcMensaje='';
	SET @pbOcurrioError=1;
	SET @vcMensaje='';

	BEGIN TRAN registro_empleado
	BEGIN TRY

	
-- VALIDAR DATOS INGRESADOS--
--VERIFICAR QUE LOS DATOS NO SEA NULOS --
		if @pcpNombre='' or @pcpNombre is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'primer nombre,');
		END
		if @pcpApellido='' or @pcpApellido is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'primer apellido');
		END
		if @pcIdentidad	='' or @pcIdentidad is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'identidad');
		END
		if @pcCorreoElectronico='' or @pcCorreoElectronico is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'correo electronico');
		END
		if @pcContrasena='' or @pcContrasena is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'contraseña');
		END
		if @pnidGenero='' or @pnidGenero is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'genero,');
		END
		if @pcDireccion='' or @pcDireccion is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'');
		END
		if @pnidCiudad	='' or @pnidCiudad is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR,'id de la ciudad,');
		END
		if @pdfechaNacimiento='' or @pdfechaNacimiento is null begin
			set @vcMensaje=@vcMensaje+convert(VARCHAR, ' fecha de nacimiento');
		END
		if @pnCargo ='' or @pnCargo is null begin
			set @vcMensaje = @vcMensaje + convert(varchar, 'Cargo del empleado, ')
		END
		if @pdfechaContratacion ='' or @pdfechaContratacion is null begin
			set @vcMensaje = @vcMensaje + convert(varchar, 'Fecha de Contratacion, ')
		END
		if @pnidBiblioteca ='' or @pnidBiblioteca is null begin
			set @vcMensaje = @vcMensaje + convert(varchar, ' Biblioteca.')
		END
		--SI HAY DATOS NULOS ALMACENA EL MENSAJE --
		if @vcMensaje <> '' begin
			set @pcMensaje='Campos requeridos para realizar el registro:'+@vcMensaje;
			return;
		end
		--COMPROBAR SI EXISTEN LOS DATOS INGRESADOS --

		--COMPROBAR SI EXISTE EL ID GENERO--
		SELECT @vnConteo=count(*) FROM GenerosPersonas where idGenero=@pnidGenero;

		if @vnConteo=0 begin
			set @pcMensaje=@pcmensaje +'El id de genero no existe';
			return;
		end
-- COMPROBAR SI EXISTE EL ID DE CIUDAD --
		SELECT @vnConteo=count(*) FROM Ciudades where idCiudad=@pnidCiudad;

		if @vnConteo=0 begin
			set @pcMensaje=@pcmensaje +'El id de ciudad no existe';
			return;
		end
-- COMPROBAR SI EXISTE EL ID DE CARGO --
		SELECT @vnConteo= count(*) From Cargos where idCargo=@pnCargo

		if @vnConteo = 0 begin
			set @pcMensaje=@pcMensaje + 'El id de Cargo no existe';
			return;
		end
-- COMPROBAR SI EXISTE EL ID DE Biblioteca --
		SELECT @vnConteo= count(*) From Bibliotecas where idBiblioteca=@pnidBiblioteca	

		if @vnConteo = 0 begin
			set @pcMensaje=@pcMensaje + 'El id de Biblioteca no existe';
			return;
		end
-- COMPROBAR QUE NO ESTE REGISTRADO EN EMPLEADOS --
		select @vnConteo=count(*) from Empleados where idPersona=(select idPersona from Personas where identidad=@pcIdentidad);
		if @vnConteo=1 begin
			set @pcMensaje=@pcMensaje +'El Empleado ya esta registrado';
			return;
		END

-- INSERTAR LOS DATOS A LAS TABLAS CORRESPONDIENTES--
		ELSE 
		BEGIN
			
			insert into Direcciones(descripcion,idCiudad)
			values(@pcDireccion,@pnidCiudad);
			select @vnUltimaDireccion =max(idDireccion) from Direcciones;
			insert into Personas(idGenero,idDireccion,pNombre,sNombre,pApellido,sApellido,fechaNacimiento,identidad,correoElectronico,contrasena)
			values(@pnidGenero,@vnUltimaDireccion,@pcpNombre,@pcsNombre,@pcpApellido,@pcsApellido,@pdfechaNacimiento,@pcIdentidad,@pcCorreoElectronico,@pcContrasena);
			select @vnUltimaPersona =max(idPersona)from Personas;
			insert into Empleados(idCargo,fechaContratacion,idBiblioteca,idPersona)
			values(@pnCargo,@pdfechaContratacion,@pnidBiblioteca,@vnUltimaPersona);
			set @pbOcurrioError=0;
			COMMIT TRAN registro_empleado
		END
	END TRY
	BEGIN CATCH
		
        SET @pcMensaje = 'Ocurrio un Error: ' + ERROR_MESSAGE() + ' en la línea ' + CONVERT(NVARCHAR(255), ERROR_LINE() ) + '.'
		ROLLBACK TRAN registro_empleado
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insertarLibro]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_insertarLibro](

	@pnidAutor        INT,
	@pnidEditorial    INT,
	@pnidGenero       INT,
	@pnPaginas        INT,
	@pnCantidad       INT,
	@pnidEstante	  INT,
	@pnidEstadoLibro  INT,
	@pcNumeroEdicion  varchar(30),
	@pcfechaEdicion   varchar(10),
	@pcNombreLibro    VARCHAR(100),
	@pcSinopsis       VARCHAR(500),
	@pnPrecioCompra   MONEY,
	@pnPrecioVenta    MONEY,
	@pcISBN           VARCHAR(50),
	@pcMensaje        VARCHAR (100) OUTPUT,
	@pbOcurrioError   int OUTPUT)


AS
BEGIN
--BEGIN TRY
--	BEGIN TRAN
-- creacion de variables --
    DECLARE @vcMensaje             varchar(100);
	DECLARE @vnConteo              int;
	DECLARE @vnidLibro             int;

--inicializar parametros de salida --
	SET @pcMensaje='';
	SET @pbOcurrioError=1;
	SET @vcMensaje='';

-- VALIDACION DE DATOS --

-- comprobar si los datos son null --
	if @pnidGenero='' or @pnidGenero is null begin
		 set @vcMensaje= @vcMensaje + convert(varchar,'idLibro,');
	end
	if @pncantidad='' or @pncantidad is null begin
		set @vcMensaje=@vcMensaje + CONVERT(varchar,'cantidad,');
	end
	if @pnidEditorial='' or @pnidEditorial is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'idEditorial,');
	end
	if @pnPaginas='' or @pnPaginas=0 or @pnPaginas is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'paginas,'); 
	end
	if @pnPrecioCompra='' or @pnPrecioCompra is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'precio de Compra,');
	end
	if @pnprecioVenta='' or @pnprecioVenta is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'precio de venta,');
	end
	if @pnidEstante=''or @pnidEstante is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'idEstante,');
	end
	if @pnidEstadoLibro=''or @pnidEstadoLibro is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'idEstado,');
	end
	if @pnidAutor=''or @pnidAutor is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'Autor,');
	end
	if @pcNombreLibro=''or @pcNombreLibro is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'nombre del libro,');
	end
	if @pcSinopsis=''or @pcSinopsis is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'sinopsis,');
	end
	if @pcISBN=''or @pcISBN is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'ISBN');
	end
	if @pcNumeroEdicion=''or @pcNumeroedicion is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'numero de edicion,');
	end
	if @pcfechaEdicion=''or @pcfechaEdicion is null begin
		set @vcMensaje=@vcMensaje+ CONVERT(varchar,'fecha de edicion');
	end

--SI HAY DATOS NULOS ALMACENA EL MENSAJE --
	if @vcMensaje <> '' begin
		set @pcMensaje='Campos requeridos para realizar la matricula:'+@vcMensaje;
		return;
	end
-- COMPROBAR SI EXISTE EL ID DE AUTOR --
	select @vnConteo=COUNT(*) from Autores where idAutor=@pnidAutor;

	if @vnConteo=0 begin
		set @pcMensaje=@pcMensaje+'El autor con id '+ convert(varchar,@pnidAutor)+'no esta registrado';
		return;
	end

-- COMPROBAR SI EXISTE ID EDITORIAL --
	SELECT @vnConteo=count(*) from Editoriales where idEditorial=@pnidEditorial;

	if @vnConteo=0 begin
		set @pcMensaje=@pcMensaje+'La editorial con id '+ convert(varchar,@pnidEditorial)+' no esta registrada';
		return;
	end
-- COMPROBAR SI EXISTE ID GENERO --
	SELECT @vnConteo= COUNT(*) from GenerosLiterarios where idGenero=@pnidGenero;

	if @vnConteo=0 begin
		set @pcMensaje=@pcMensaje+'El id del genero '+ CONVERT(varchar,@pnidGenero)+' no existe';
		return;
	end

--COMPROBAR SI EXISTE EL NOMBRE DEL LIBRO DE ESA EDICION--
	SELECT @vnConteo=count(*) FROM Ediciones ed 
	inner join Libros lib on ed.idLibro=lib.idLibro 
	where lib.nombreLibro=@pcNombreLibro AND ed.numeroEdicion=@pcNumeroEdicion;

	if @vnConteo<>0 begin
		set @pcMensaje=@pcMensaje+'El libro ya esta registrado';
		return;
	end
	ELSE
		begin 
		
		insert into Libros(idEditorial,nombreLibro,ISBN,paginas,sinopsis,fechaIngreso,precioCompra,precioVenta,cantidad)
		values(@pnidEditorial,@pcNombreLibro,@pcISBN,@pnPaginas,@pcSinopsis,convert(varchar,GETDATE()),@pnprecioCompra,@pnprecioVenta,@pnCantidad);
		select @vnidLibro =max(idLibro) from Libros;
		insert into Ediciones(idLibro,numeroEdicion,fechaEdicion)
		values(@vnidlibro,@pcNumeroEdicion,@pcFechaEdicion);
		insert into LibrosXAutores (idLibro,idAutor)
		values(@vnidLibro,@pnidAutor);
		insert into LibrosXGeneros (idLibro,idGenero)
		values(@vnidLibro,@pnidGenero);
		insert into LibrosXEstantes (idLibro,idEstante,idEstadoLibro)
		values(@vnidLibro,@pnidEstante,@pnidEstadoLibro);
		set @pcMensaje=@pcMensaje+'Libro ingresado correctamente';
		SET @pbOcurrioError=0;
		COMMIT;
	end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_TarjetasAcumulacion]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_TarjetasAcumulacion](
	@pnidTipoMovimiento			int,
	@pnidCliente				int,
	@pfMonto					money,
	@pbocurrioError				int output,
	@pcMensaje					varchar(100) output)
AS
BEGIN
	--DECLARAR VARIABLES- 
	DECLARE @vnConteo			int;
	DECLARE @vfPorcentaje       float;
	DECLARE @vcMensaje			varchar(100);
	DECLARE @vnidTarjeta        int;
	DECLARE @vfMontoActual      money;

	-- INICIALIZAR VARIABLES--
	set @pbOcurrioError=1
	set @pcMensaje=''
	--set @vcMensaje=''
	set @vfPorcentaje=0.1
	set @vcMensaje=0

	-- VALIDACION DE DATOS
	if @pnidTipoMovimiento='' or @pnidTipoMovimiento is null begin
		set @vcMensaje=@vcMensaje+convert(varchar,'tipo de movimiento,');
	end
	if @pnidCliente='' or @pnidCliente is null begin
		set @vcMensaje=@vcMensaje+convert(varchar,'id cliente, ');
	end
	if @pfMonto='' or @pfMonto is null begin
		set @vcMensaje=@vcMensaje+convert(varchar,'monto.');
	end
		-- MOSTRAR MENSAJE DE ERROR --
	if @vcMensaje is null begin
		set @pcMensaje='Campos requeridos:'+@vcMensaje;
		return;
	end

	--COMPROBAR QUE EXISTAN LOS DATOS INGRESADOS --
	--COMPROBAR QUE EL CLIENTE ESTE REGISTRADO--

	 select @vnConteo=count(*) from Clientes where idPersona=@pnidCliente;

	 if @vnConteo=0 begin
		set @pcMensaje=@pcMensaje+'El cliente no esta registrado';
		return;
	 end

		 -- COMPROBAR QUE EL CLIENTE POSEA TARJETA DE ACUMULACION DE PUNTOS--
	 SELECT @vnConteo=COUNT(*) from TarjetasAcumulacion where idCliente=@pnidCliente;

	 if @vnConteo=0 begin
		set @pcMensaje=@pcMensaje+'El cliente no posee tarjeta de acumulacion';
		return;
	 end

		 -- COMPROBAR QUE EXISTA EL TIPO DE MOVIMIENTO --
	 select @vnConteo=count(*) from TiposMovimientos where idTipoMovimiento=@pnidTipoMovimiento

	 if @vnConteo=0 begin
		set @pcMensaje=@pcMensaje+'El id de tipo movimiento no esta registrado';
		return;
	 end

	 --else
	 --begin

	if @pnidTipoMovimiento=1 begin
		 set @vfPorcentaje=@vfPorcentaje*@pfMonto;
		 select @vnidTarjeta=idTarjetaAcumulacion from TarjetasAcumulacion where idCliente=@pnidCliente;
		 insert into Movimientos(idTipoMovimiento,idTarjetaAcumulacion,fecha,monto)
		 values(@pnidTipoMovimiento,@vnidTarjeta,GETDATE(),@vfPorcentaje);
		 set @pcMensaje=@pcMensaje+' Entrada correcta';
	end
	
	if @pnidTipoMovimiento=2 begin
		set @vfMontoActual=dbo.FN_MontoActual (@pnidCliente);
				
		if @vfMontoActual >= @pfMonto begin
			select @vnidTarjeta=idTarjetaAcumulacion from TarjetasAcumulacion where idCliente=@pnidCliente;
			insert into Movimientos(idTipoMovimiento,idTarjetaAcumulacion,fecha,monto)
			values(@pnidTipoMovimiento,@vnidTarjeta,GETDATE(),@pfMonto);
			set @pcMensaje=@pcMensaje+' salida correcta';
		end
		else
		begin
			set @pcMensaje=@pcMensaje+' LA TARJETA NO TIENE LOS FONDOS REQUERIDOS PARA LA COMPRA';
			RETURN;
		end	
	end
	set @pbocurrioError=0;
	COMMIT 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_validarInicioSesion]    Script Date: 01/05/18 21:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_validarInicioSesion](@correo varchar(55), @password varchar(55), @tipoSesion varchar(100) output, @codigoPersona int output) as
begin
	--inicializacion de variables--
	declare @contador int
	declare @pwdCorrecta varchar(50)
	--init parametros de salida--
	--tipoSesion puede ser: 0:no valida, 1:empleado, 2:cliente
	set @tipoSesion = 0


	select @contador = count(*) from Personas p
	inner join Clientes c on p.idPersona = c.idPersona
	where p.correoElectronico = @correo

	if @contador <> 0 begin
			select @codigoPersona = c.idPersona, @pwdCorrecta = p.contrasena from Personas p
			inner join Clientes c on p.idPersona = c.idPersona
			where p.correoElectronico = @correo

			if @pwdCorrecta = @password begin
				set @tipoSesion = 2
			end else begin
				set @tipoSesion = 0
			end
		return;		
	end


	select @contador = count(*) from Personas p
	inner join Empleados e on p.idPersona = e.idPersona
	where p.correoElectronico = @correo

	if @contador <> 0 begin
			select @codigoPersona = e.idPersona, @pwdCorrecta = p.contrasena from Personas p
			inner join Empleados e on p.idPersona = e.idPersona
			where p.correoElectronico = @correo

			if @pwdCorrecta = @password begin
				set @tipoSesion = 1
			end else begin
				set @tipoSesion = 0
			end
		return;		
	end
end
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Bibliotecas', @level2type=N'COLUMN',@level2name=N'idBiblioteca'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'llave primaria en Direcciones' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Bibliotecas', @level2type=N'COLUMN',@level2name=N'idDireccion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'nombre de la biblioteca' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Bibliotecas', @level2type=N'COLUMN',@level2name=N'nombre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha en que fue creada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Bibliotecas', @level2type=N'COLUMN',@level2name=N'fechaCreacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cargos', @level2type=N'COLUMN',@level2name=N'idCargo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'nombre del cargo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cargos', @level2type=N'COLUMN',@level2name=N'cargo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cantidad que se gana en el cargo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cargos', @level2type=N'COLUMN',@level2name=N'sueldo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'proposito del cargo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cargos', @level2type=N'COLUMN',@level2name=N'descripcion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ciudades', @level2type=N'COLUMN',@level2name=N'idCiudad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'llave primaria en Paises' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ciudades', @level2type=N'COLUMN',@level2name=N'idPais'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'es el nombre de la ciudad' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ciudades', @level2type=N'COLUMN',@level2name=N'nombreCiudad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha en que se creó la cuenta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clientes', @level2type=N'COLUMN',@level2name=N'fechaRegistro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Continentes', @level2type=N'COLUMN',@level2name=N'idContinente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'nombre del continente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Continentes', @level2type=N'COLUMN',@level2name=N'nombreContinente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Descuentos', @level2type=N'COLUMN',@level2name=N'idDescuento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ejem: Tercera Edad' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Descuentos', @level2type=N'COLUMN',@level2name=N'descripcion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'El porcentaje a aplicar' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Descuentos', @level2type=N'COLUMN',@level2name=N'valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'si está activo o no.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Descuentos', @level2type=N'COLUMN',@level2name=N'estado'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Factura a la que se aplica el descu.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DescuentosXFacturas', @level2type=N'COLUMN',@level2name=N'idFactura'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ejem: Tercera Edad' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DescuentosXFacturas', @level2type=N'COLUMN',@level2name=N'idDescuento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'libro vendido' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DetallesFacturas', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'factura en la que se vendió' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DetallesFacturas', @level2type=N'COLUMN',@level2name=N'idFactura'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Direcciones', @level2type=N'COLUMN',@level2name=N'idDireccion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'es la direccion detallada dentro de la colonia' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Direcciones', @level2type=N'COLUMN',@level2name=N'descripcion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ediciones', @level2type=N'COLUMN',@level2name=N'idEdicion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'llave primaria en Libros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ediciones', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Edición del libro.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ediciones', @level2type=N'COLUMN',@level2name=N'numeroEdicion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha en que fue publicada la edición' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ediciones', @level2type=N'COLUMN',@level2name=N'fechaEdicion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Editoriales', @level2type=N'COLUMN',@level2name=N'idEditorial'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'nombre del editorial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Editoriales', @level2type=N'COLUMN',@level2name=N'nombreEditorial'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en cargos' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Empleados', @level2type=N'COLUMN',@level2name=N'idCargo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha en que empezo en la empresa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Empleados', @level2type=N'COLUMN',@level2name=N'fechaContratacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto oncremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Entradas', @level2type=N'COLUMN',@level2name=N'idEntrada'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'empleado que recibe los medicamentos' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Entradas', @level2type=N'COLUMN',@level2name=N'idEmpleado'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha de llegada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Entradas', @level2type=N'COLUMN',@level2name=N'fecha'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EstadosLibros', @level2type=N'COLUMN',@level2name=N'idEstadoLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ejemp: prestado, alquilado etc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EstadosLibros', @level2type=N'COLUMN',@level2name=N'nombreEstado'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Estantes', @level2type=N'COLUMN',@level2name=N'idEstante'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'biblioteca a la que pertenece el libro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Estantes', @level2type=N'COLUMN',@level2name=N'idBiblioteca'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'codigo escogido para acceder a el libro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Estantes', @level2type=N'COLUMN',@level2name=N'identificador'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Facturas', @level2type=N'COLUMN',@level2name=N'idFactura'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'empleado que hace la venta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Facturas', @level2type=N'COLUMN',@level2name=N'idEmpleado'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cliente que realiza la compra' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Facturas', @level2type=N'COLUMN',@level2name=N'idCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ejem. tarjeta de credito' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Facturas', @level2type=N'COLUMN',@level2name=N'idFormaPago'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha en que se lleva a cabo la venta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Facturas', @level2type=N'COLUMN',@level2name=N'fecha'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'alguna descripcion opcional' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Facturas', @level2type=N'COLUMN',@level2name=N'observacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FormasPago', @level2type=N'COLUMN',@level2name=N'idFormaPago'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ejem. tarjeta de credito' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FormasPago', @level2type=N'COLUMN',@level2name=N'descripcion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'activa/Desactiva' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FormasPago', @level2type=N'COLUMN',@level2name=N'estado'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GenerosLiterarios', @level2type=N'COLUMN',@level2name=N'idGenero'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'genero de los libros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GenerosLiterarios', @level2type=N'COLUMN',@level2name=N'genero'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GenerosPersonas', @level2type=N'COLUMN',@level2name=N'idGenero'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'femenino/masculino/otros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GenerosPersonas', @level2type=N'COLUMN',@level2name=N'genero'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'autoincremental, llave primaria,no null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Impuestos', @level2type=N'COLUMN',@level2name=N'idImpuesto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'tipo de impuesto aplicado' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Impuestos', @level2type=N'COLUMN',@level2name=N'descripcion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'porcentaje del impuesto,float' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Impuestos', @level2type=N'COLUMN',@level2name=N'porcentaje'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en editoriales' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'idEditorial'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'nombre o titulo del libro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'nombreLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'es un codigo unico que cada libro posee' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'ISBN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'total de paginas del libro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'paginas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'breve resumen del libro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'sinopsis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha en la que fue adquirido por la biblioteca' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'fechaIngreso'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'precio por el que fue adquirido' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'precioCompra'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'precio en el que se vendera' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'precioVenta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cantidad total del libro determinado' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Libros', @level2type=N'COLUMN',@level2name=N'cantidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria de libros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXAutores', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave prmaria de autor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXAutores', @level2type=N'COLUMN',@level2name=N'idAutor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave pprimaria de libros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXEntradas', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'claveprimaria de entradas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXEntradas', @level2type=N'COLUMN',@level2name=N'idEntrada'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'numero total del libro determinado' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXEntradas', @level2type=N'COLUMN',@level2name=N'cantidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en Libros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXEstantes', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en Estantes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXEstantes', @level2type=N'COLUMN',@level2name=N'idEstante'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en EstadosLibros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXEstantes', @level2type=N'COLUMN',@level2name=N'idEstadoLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en Libros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXGeneros', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en Generos' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXGeneros', @level2type=N'COLUMN',@level2name=N'idGenero'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en Libros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXSalidas', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en Salidas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXSalidas', @level2type=N'COLUMN',@level2name=N'idSalida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'número total de determinado libro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LibrosXSalidas', @level2type=N'COLUMN',@level2name=N'cantidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Movimientos', @level2type=N'COLUMN',@level2name=N'idMovimiento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en tipo movimientos' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Movimientos', @level2type=N'COLUMN',@level2name=N'idTipoMovimiento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en acumulaciones' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Movimientos', @level2type=N'COLUMN',@level2name=N'idTarjetaAcumulacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha en que se lleva a cabo el movimiento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Movimientos', @level2type=N'COLUMN',@level2name=N'fecha'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'monto del movimiento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Movimientos', @level2type=N'COLUMN',@level2name=N'monto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Paises', @level2type=N'COLUMN',@level2name=N'idPais'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en continentes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Paises', @level2type=N'COLUMN',@level2name=N'idContinente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'nombre del paìs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Paises', @level2type=N'COLUMN',@level2name=N'nombrePais'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'autores incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'idPersona'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en generoPersonas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'idGenero'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave nombre de la persona' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'idDireccion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'primer nombre de la persona' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'pNombre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'del 2* nombre e adelante de la persona' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'sNombre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'primer apellido de la persona' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'pApellido'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'del 2* apellido en adelate de la persona' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'sApellido'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha que naciò segùn partida de nacimiento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'fechaNacimiento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'documento legal de registro ejem: vista, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'identidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cualquier correo de cualquier tipo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Personas', @level2type=N'COLUMN',@level2name=N'correoElectronico'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Llave primaria autoincremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Prestamos', @level2type=N'COLUMN',@level2name=N'idPrestamo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Llave foranea relacionada con el id de LibrosXEstantes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Prestamos', @level2type=N'COLUMN',@level2name=N'idLibro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Llave foranea relacionada con el idCliente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Prestamos', @level2type=N'COLUMN',@level2name=N'idCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Especifica la fecha que se realizó el préstamo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Prestamos', @level2type=N'COLUMN',@level2name=N'fechaInicio'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Especifica la fecha que se entrego el préstamo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Prestamos', @level2type=N'COLUMN',@level2name=N'fechaFin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Salidas', @level2type=N'COLUMN',@level2name=N'idSalida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'empleado que está a cargo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Salidas', @level2type=N'COLUMN',@level2name=N'idEmpleado'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'clave primaria en Bibliotecas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Salidas', @level2type=N'COLUMN',@level2name=N'idBiblioteca'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'fecha de salida de los medicamentos' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Salidas', @level2type=N'COLUMN',@level2name=N'date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TarjetasAcumulacion', @level2type=N'COLUMN',@level2name=N'idTarjetaAcumulacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cliente al que pertenece la tarjeta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TarjetasAcumulacion', @level2type=N'COLUMN',@level2name=N'idCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'primer fecha en que se otorgó  el servicio' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TarjetasAcumulacion', @level2type=N'COLUMN',@level2name=N'fechaRegistro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Telefonos', @level2type=N'COLUMN',@level2name=N'idTelefono'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'si el numero pertenece a una persona' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Telefonos', @level2type=N'COLUMN',@level2name=N'idPersona'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'si el numero pertenece a una biblioteca' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Telefonos', @level2type=N'COLUMN',@level2name=N'idBiblioteca'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'teléfono sin guiones ejem: 95688778' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Telefonos', @level2type=N'COLUMN',@level2name=N'numeroTelefonico'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'auto incremental' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TiposMovimientos', @level2type=N'COLUMN',@level2name=N'idTipoMovimiento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ejem: ingreso/egreso' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TiposMovimientos', @level2type=N'COLUMN',@level2name=N'descripcion'
GO
USE [master]
GO
ALTER DATABASE [libreria] SET  READ_WRITE 
GO
