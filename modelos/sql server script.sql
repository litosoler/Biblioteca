--Creando tabla GenerosLiterarios
create table GenerosLiterarios(
	idGenero int identity(1,1) not null,
	genero varchar(45) null,
	constraint PK_GenerosLiterarios  primary key(idGenero)
	)

--Creando tabla Editoriales
create table Editoriales(
	idEditorial int identity (1,1) not null,
	nombreEditorial varchar(45),
	constraint PK_Editoriales  primary key(idEditorial)
)

--creando tabla Libros
create table Libros(
	idLibro int identity (1,1) not null,
	idEditorial int not null,
	nombreLibro varchar(100) not null,
	ISBN varchar(45) not null,
	paginas int not null,
	sinopsis varchar(500),
	fechaIngreso date not null,
	precioCompra money not null,
	precioVenta money not null,
	cantidad int not null
	constraint PK_Libros primary key(idLibro),
	constraint FK_Libros_idEditorial foreign key(idEditorial) references Editoriales(idEditorial)
	)

--creando tabla LibrosXCategorias
create table LibrosXGeneros(
	idLibro int,
	idGenero int,
	constraint PK_idLibro_idCategoria primary key(idLibro, idGenero),
	constraint FK_LibrosXCategoria_idLibro foreign key(idLibro) references Libros(idLibro),
	constraint FK_LibrosXCategoria_idCategoria foreign key(idGenero) references GenerosLiterarios(idGenero)
	);


--Genero Personas
create table GenerosPersonas(
	idGenero int identity(1,1) not null,
	genero varchar(45),
	constraint PK_GenerosPersonas primary key(idGenero) 
);

--Continentes
create table Continentes(
	idContinente int identity(1,1) not null,
	nombreContinente varchar(45),
	constraint PK_Continentes primary key(idContinente)
)

--Ciudades
create table Ciudades(
	idCiudad int identity(1,1) not null,
	idPais int not null,
	nombreCiudad int not null,
	constraint PK_Ciudades primary key(idCiudad),
	constraint FK_Ciudades_idPais foreign key(idPais) references Paises(idPais)
);

--Direcciones 
create table Direcciones(
	idDireccion int identity(1,1) not null,
	idColonia int not null,
	descripcion varchar(45),
	constraint PK_Direccione primary key(idDireccion),
	constraint FK_Direcciones_idColonia foreign key(idColonia) references Colonias(idColonia)
);

--Telefonos
create table Telefonos(
	idTelefono int identity(1,1) not null,
	idPersona int  null,
	idBiblioteca int null,
	numeroTelefonico varchar(45),
	constraint PK_Telefonos primary key(idTelefono),
	constraint FK_Telefonos_idPersona foreign key(idPersona) references Personas(idPersona),
	constraint FK_Telefonos_idBiblioteca foreign key(idBiblioteca) references Bibliotecas(idBiblioteca)
)

--Bibliotecas
create table Bibliotecas(
	idBiblioteca int identity(1,1) not null,
	idDireccion int not null,
	nombre varchar(50),
	fechaCreacion date,
	constraint PK_Bibliotecas primary key(idBiblioteca),
	constraint FK_Bibliotecas_idDireccion foreign key(idDireccion) references Direcciones(idDireccion)
);

--Propositos
create table Propositos(
	idProposito int identity(1,1) not null,
	proposito varchar(15),
	constraint PK_Propositos primary key(idProposito)
);

--PropositosXLibros
create table PropositosXLibros(
	idProposito int not null,
	idLibro int not null,
	cantidad int not null,
	constraint PK_PropositosXLibros primary key(IdProposito, idLibro),
	constraint FK_PropositosXLibros_idProposito foreign key(idProposito) references Propositos(idProposito), 
	constraint FK_PropositosXLibros_idLibro foreign key(idLibro) references Libros(idLibro)
);

create table LibrosXEstantes(
	idLibro int not null,
	idEstante int not null,
	idEstadoLibro int not null,
	cantidad int not null,
	direccion varchar(45),
	constraint PK_LibrosXEstantes primary key(idLibro, idEstante),
	constraint FK_LibrosXEstantes_idLibro foreign key(idLibro) references Libros(idLibro),
	constraint FK_LibrosXEstantes_idEstante foreign key(idEstante) references Estantes(idEstante),
	constraint FK_LibrosXEstantes_idEstadoLibro foreign key(idEstadoLibro) references EstadosLibros(idEstadoLibro)
);

create table FormasPago(
	idFormaPago int identity(1,1) not null,
	descripcion varchar(45) not null,
	estado varchar(10) not null,
	constraint PK_FormasPago primary key(idFormaPago)

);

create table Facturas(
	idFactura int identity(1,1) not null,
	idEmpleado int not null,
	idCliente int null,
	idFormaPago int not null,
	fecha date not null,
	observacion varchar(100) null,
	constraint PK_Facturas primary key(idFactura),
	constraint FK_Facturas_idEmpleado foreign key(idEmpleado) references Empleados(idEmpleado),
	constraint FK_Facturas_idCliente foreign key(idCliente) references Clientes(idPersona),
	constraint FK_Facturas_idFormaPago foreign key(idFormaPago) references FormasPago(idFormaPago)
);

create table DetallesFacturas(
	idLibro int not null,
	idFactura int not null,
	cantidad int not null,
	constraint PK_DetallesFacturas primary key(idLibro, idFactura),
	constraint FK_DetallesFacturas_idLibro foreign key(idLibro) references Libros(idLibro),
	constraint FK_DetallesFacturas_Factura foreign key(idFactura) references Facturas(idFactura)
);


--limpiar las tablas
drop table Ediciones; 
drop table Editoriales;
drop table EstadosLibros; 
drop table GenerosLiterarios; 
drop table Libros; 
drop table Propositos;
drop table PropositosXLibros; 
