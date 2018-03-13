use Escuela
go
--Creando tabla Asignatura
CREATE TABLE Asignatura(
Id int not null PRIMARY KEY,
Nombre VARCHAR(50)
)

--Creando tabla Inscripcion
CREATE TABLE Inscripcion(
Id int identity (1,1) not null PRIMARY KEY,
IdAsignatura INT,
IdAlumno BIGINT,
IdProfesor BIGINT,
Fecha DATE,
-------Estableciendo llaves foraneas
CONSTRAINT FK_Inscripcion_IdAsignatura FOREIGN KEY (IdAsignatura) REFERENCES Asignatura(Id),
CONSTRAINT FK_Inscripcion_IdAlumno FOREIGN KEY (IdAlumno) REFERENCES Alumnos(Id)
)


--Establecer llave primaria a tablas ya creadas
ALTER TABLE Alumnos ADD CONSTRAINT pk_alumnos_Id PRIMARY KEY (Id)

ALTER TABLE Profesor ADD CONSTRAINT pk_aProfesor_Id PRIMARY KEY (Id)


--establecer llave foranea a tablas creadas

ALTER TABLE Inscripcion ADD CONSTRAINT FK_Inscripcion_IdProfesor FOREIGN KEY (IdProfesor) REFERENCES Profesor(Id)
