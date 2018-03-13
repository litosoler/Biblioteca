--Creando tabla GenerosLiterarios
create table GenerosLiterarios(
	idGenero int identity (1,1) not null primary key,
	genero varchar(45)
	)

--Creando tabla Editoriales
create table Editoriales(
	idEditorial int identity (1,1) not null primary key,
	nombreEditorial varchar(45)
	)

--creando tabla Libros
create table Libros(
	idLibro int identity (1,1) not null primary key,
	idEditorial int not null,
	nombreLibro varchar(100) not null,
	ISBN varchar(45) not null,
	paginas int not null,
	sinopsis varchar(500),
	fechaIngreso date not null,
	precioCompra money not null,
	precioVenta money not null,
	cantidad int not null
	--llaves foraneas--
	constraint FK_Libros_idEditorial foreign key (idEditorial) references Editoriales(idEditorial)
	)

--creando tabla LibrosXCategorias
create table LibrosXCategorias(
	idLibro int,
	idCategoria int,
	constraint PK_idLibro_idCategoria primary key(idLibro,idCategoria),
	constraint FK_LibrosXCategoria_idLibro foreign key(idLibro) references Libros(idLibro),
	constraint FK_LibrosXCategoria_idCategoria foreign key(idCategoria) references GenerosLiterarios(idGenero)
	)

