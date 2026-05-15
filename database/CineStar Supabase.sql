-- CineStar Supabase (PostgreSQL) Script - CORREGIDO CONFLICTO NOMBRES

-- Eliminar tablas si existen
DROP VIEW IF EXISTS vCines;
DROP VIEW IF EXISTS vCinePeliculas;
DROP VIEW IF EXISTS vCineTarifas;
DROP VIEW IF EXISTS vDistrito;
DROP VIEW IF EXISTS vGenero;
DROP TABLE IF EXISTS CineTarifa;
DROP TABLE IF EXISTS CinePelicula;
DROP TABLE IF EXISTS Cine;
DROP TABLE IF EXISTS Pelicula;
DROP TABLE IF EXISTS Genero;
DROP TABLE IF EXISTS Distrito;
DROP TABLE IF EXISTS Ciudad;
DROP TABLE IF EXISTS Formato;
DROP TABLE IF EXISTS Usuario;

-- Eliminar funciones si existen
DROP FUNCTION IF EXISTS sp_getcines();
DROP FUNCTION IF EXISTS sp_getcine(INT);
DROP FUNCTION IF EXISTS sp_getcinetarifas(INT);
DROP FUNCTION IF EXISTS sp_getcinepeliculas(INT);
DROP FUNCTION IF EXISTS sp_getpeliculass();
DROP FUNCTION IF EXISTS sp_getpeliculas(INT);
DROP FUNCTION IF EXISTS sp_getpelicula(INT);
DROP FUNCTION IF EXISTS getGenerosDetalle(TEXT);
DROP FUNCTION IF EXISTS getFormatosDetalle(TEXT);
DROP FUNCTION IF EXISTS DateLong(TEXT);

-- Crear tablas
CREATE TABLE Usuario (
  id SERIAL PRIMARY KEY,
  Nombres VARCHAR(30) NOT NULL,
  Apellidos VARCHAR(30) NOT NULL,
  Dni VARCHAR(30) NOT NULL,
  Passwordd VARCHAR(30) NOT NULL,
  Telefono VARCHAR(9) NOT NULL,
  Correo VARCHAR(50) NOT NULL 
);

CREATE TABLE Formato (
  id SERIAL PRIMARY KEY,
  Detalle VARCHAR(30) UNIQUE 
);
  
CREATE TABLE Ciudad (
  id SERIAL PRIMARY KEY,
  Detalle VARCHAR(30) UNIQUE 
);

CREATE TABLE Distrito (
  id SERIAL PRIMARY KEY,
  idCiudad INT REFERENCES Ciudad(id),
  Detalle VARCHAR(30) UNIQUE 
);
  
CREATE TABLE Genero (
  id SERIAL PRIMARY KEY,
  Detalle VARCHAR(30) UNIQUE 
);

CREATE TABLE Pelicula (
  id SERIAL PRIMARY KEY,
  Titulo VARCHAR(80) NOT NULL,
  FechaEstreno VARCHAR(10) NOT NULL,
  Director VARCHAR(50) NOT NULL,
  Generos VARCHAR(10) NOT NULL,
  idClasificacion INT NOT NULL,
  idEstado INT NOT NULL,
  Duracion VARCHAR(3) NOT NULL,
  Link VARCHAR(20),
  Reparto TEXT,
  Sinopsis TEXT 
);  

CREATE TABLE Cine (
  id SERIAL PRIMARY KEY,
  RazonSocial VARCHAR(30) NOT NULL,
  Salas INT NOT NULL,
  idCiudad INT REFERENCES Ciudad(id),
  idDistrito INT REFERENCES Distrito(id),
  Formatos VARCHAR(12) NOT NULL,
  Direccion VARCHAR(100) NOT NULL,
  Telefonos VARCHAR(20) NOT NULL 
);

CREATE TABLE CinePelicula (
  idCine INT REFERENCES Cine(id),
  idPelicula INT REFERENCES Pelicula(id),
  Sala INT NOT NULL,
  Horarios VARCHAR(150) NOT NULL 
);

CREATE TABLE CineTarifa (
  idCine INT REFERENCES Cine(id),
  DiasSemana VARCHAR(80) NOT NULL,
  Precio DECIMAL(5,2) NOT NULL 
);

-- Inserción de Datos Iniciales
INSERT INTO Usuario (Nombres, Apellidos, Dni, Passwordd, Telefono, Correo) VALUES ('Omar','Espinoza', '99887766', '123456', '993217610', 'oaemdl@gmail.com');
INSERT INTO Formato (Detalle) VALUES ('Formato'),('2D'),('3D'),('4X'),('VIP');
INSERT INTO Genero (Detalle) VALUES ('Acción'),('Animación'),('Aventura'),('Biografico'),('Ciencia Ficción'),('Comedia'),('Drama'),('Familiar'),('Fantasía'),('Histórico'),('Musical'),('Romance'),('Suspenso'),('Terror'),('Thriller');
INSERT INTO Ciudad (Detalle) VALUES ('Todas las ciudades'),('Lima'),('Ayacucho'),('Chimbote'),('Huanúco'),('Moquegua'),('Piura'),('Pucallpa'),('Tacna'),('Tarapoto'),('Tumbes');
INSERT INTO Distrito (idCiudad, Detalle) VALUES 
	(2,'Breña'),(2,'Comas'),(2,'Jesús Maria'),(2,'Lima'),(2,'Rímac'),(2,'San Borja'),(2,'San Juan de Lurigancho'),(2,'San Juan de Miraflores'),(2,'Santiago de Surco'),
    (3,'Ayacucho');

INSERT INTO Pelicula (Titulo, FechaEstreno, Director, Generos, idClasificacion, idEstado, Duracion, Link, Reparto, Sinopsis) VALUES
	('Jumanji: En la Selva (Todo Público)','2018/01/11','Jake Kasdan','3,9',1,1,'120','6maujJFcuxA','Dwayne Johnson, Kevin Hart, Jack Black, Karen Gillan','Remake de la película homónima de 1995 adaptado a la época actual, en donde cuatro adolescentes se introducen en un nueva aventura a partir de “Jumanji”, un videojuego que sirve como un portal a través del espacio-tiempo. Absorbidos por el mundo de Jumanji, este juego no se puede abandonar hasta que acaba la partida' ),
	('Django: Sangre de mi Sangre (+18)','2018/01/25','Aldo Salvini','7,1',3,1,'110','faXp0Q3glPU','Melania Urbina, Giovanni Ciccia, Sergio Galliani','Después de cumplir la condena de 15 años en prisión, Orlando Hernández “Django“, sale en libertad sin saber el destino que le aguarda. Un mundo criminal más hostil que el que él conoció en su pasado, plagado de enemigos que harán lo posible por truncar su sueño de volver con su familia y recuperar a sus hijos. La lucha de un hombre por caminar derecho en una ciudad corrompida por el crimen.' ),
	('La Noche del Demonio: La Última Llave (+14)','2018/02/01','Adam Robitel','14',2,1,'110','AlcCJkJCqOM','Javier Botet, Lin Shaye, Tessa Ferrer, Josh Stewart, Spencer Locke, Kirk Acevedo','La parapsicóloga Dra. Elise Rainier debe enfrentar la aparición más terrible y personal hasta el momento: la que se esconde en su propia casa.' ),
	('Paddington 2 (Todo Público)','2018/02/01','Paul King','2,8,3',1,1,'110','U-z9i1tfJjQ','Brendan Gleeson, Sally Hawkins, Hugh Grant, Michael Gambon','El oso Paddington ya está felizmente integrado en casa de la familia Brown. Se ha convertido además en un miembro muy popular de la comunidad de Windsor Gardens. Su tía Lucy cumple 100 años y él tiene el regalo perfecto para ella: un maravilloso libro pop-up de la tienda de antigüedades de Mr. Gruber. Para poder comprar el libro, Paddington decidirá realizar una serie de extraños trabajos. Pero todo se complica cuando el libro es robado.' ),
	('Vikingos (+14)','2018/02/08','Andrey Kravchuk','1,7,10',2,1,'100','Y9M-LfX5td8','Danila Kozlovsky, Svetlana Khodchenkova, Maxim Sukhanov, Aleksandr Ustyugov','Basada en una historia real sucedida en los tiempos precristianos de la Rus y relatada tanto en la ‘Primera Crónica Eslava’, como en ‘Las Sagas de los Reyes’ nórdica, cuando el antiguo pueblo eslavo aún mantenía fuertes lazos culturales y de sangre con los vikingos. Tras la muerte de su padre, Sviatoslav I, el joven príncipe Vladímir se ve obligado a huir de las manos de su hermanastro mayor Yaropolk, quien asesinó a su otro hermano, Oleg, para entronarse en Kiev, capital ancestral de la Rus. Exiliado en Escandinavia, el menor de los tres hermanos reúne a su alrededor fuerzas vikingas, con el fin de vengar a Oleg y ocupar el trono de su padre. Después de su travesía, el nuevo monarca se despide de las sanguinarias tradiciones paganas, llevando el cristianismo a la antigua Rus y convirtiéndose en San Vladímir el Grande.' ),
	('La Maldición de la Casa Winchester (+14)','2018/02/08','Peter Spierig','14',2,1,'100','npU31mqbviA','Helen Mirren, Jason Clarke','Basada en la historia real de Sarah Winchester (Helen Mirren), una millonaria viuda convencida de tener una maldición. Después de la repentina muerte de su marido y su hijo, cree que las almas de todas las personas que murieron por culpa del famoso rifle creado por su familia se dedican a perseguirla. Para intentar despistar a los espíritus en pena, construyó una mansión de casi 200 habitaciones con escaleras que no daban a ninguna parte y puertas que al abrirse descubrían un muro… todo con la intención de esquivar a los seres del otro mundo.' ),
	('Cincuenta Sombras Liberadas (+18) (HD - Doblada)','2018/02/08','James Foley','7',3,1,'120','B1Qdbbo0Tlw','Dakota Johnson, Jamie Dornan, Eric Johnson, Rita Ora, Marcia Gay Harden','Jamie Dornan y Dakota Johnson regresan como Christian Grey y Anastasia Steele en Cincuenta Sombras Liberadas, el tercer capítulo basado en el fenómeno "Cincuenta sombras", best seller a nivel mundial. Ampliando los eventos que se desencadenaron en las películas taquilleras del 2015 y 2017, que recaudaron casi $ 950 millones en todo el mundo, llega la nueva entrega para el Día de los Enamorados' ),
	('Locos de Amor 2 (+14)','2018/02/14','Frank Pérez Garland','6,11',2,1,'110','v3fspveODBI','Johanna San Miguel, Marco Zunino, Vanessa Saba, Bruno Ascenzo, Carlos Alcántara, Érika Villalobos','¡Vuelve la comedia musical del año! Un hombre descorazonado que empieza a salir con una conductora que da consejos de amor en la radio. Una mujer desesperada por ser mamá y un padre soltero en sus cincuentas que solo piensa en ella. Una mujer madura que llega de Miami buscando nuevas experiencias. Una mujer divorciada que solo quiere divertirse y el hombre que no la ha olvidado desde que tenía 23 años. El resultado, una divertida comedia romántica donde los personajes descubren que nunca es tarde para volvernos Locos de Amor.' ),
	('El Despertar de los Muertos Vivientes (+14) (HD - Doblada)','2018/02/15','Héctor Hernández Vicens','14',2,1,'100','xAq_0OIirnE','Jeff Gum, Johnathon Schaech, Marcus Vanco, Sophie Skelton','Un pequeño grupo de servicio militar sufre una gran tragedia, todos los sobrevivientes logran convivir en un búnker subterráneo, pero no se esperan que esto tendría que ser por mucho tiempo. Todos los refugiados buscarán desesperadamente encontrar una cura, ya que todo se ha convertido en un mundo invadido por zombis, el problema será cuando ya no puedan mantenerse a salvo y el tiempo vaya contra su favor. Una película que demuestra que el miedo no se puede controlar.' ),
	('15:17 Tren a París (+14) (HD - Doblada)','2018/02/15','Clint Eastwood','7,10',2,1,'100','bHn-yCw0-VU','Spencer Stone, Anthony Sadler, Alek Skarlatos, Judy Greer, Jenna Fischer, Ray Corasani, Tony Hale, Thomas Lennon, Sinqua Walls','El 21 de agosto de 2015, Ayoub El-Khazzani subió al tren 9364 en Bruselas rumbo a París. No había dudas de sus intenciones: tenía una AK-47, una pistola y suficientes balas para dominar a los pasajeros a bordo. Un nuevo ataque de ISIS estaba por comenzar. Lo que no esperaba encontrar Khazzani en su misión eran tres amigos estadounidenses, Anthony Sadler, Alek Skarlatos y Spencer Stone que estaban dispuestos a deternerlo. Basada en una historia real.' ),
	('Pantera Negra','2018/02/22','Ryan Coogler','3,1',2,1,'150','JcIye2DaZwI','Chadwick Boseman, Michael B. Jordan, Lupita Nyong o, Martin Freeman, Daniel Kaluuya, Forest Whitaker','Tras los acontecimientos ocurridos en CAPITÁN AMÉRICA: CIVIL WAR, T’Challa regresa a Wakanda, su solitaria nación africana de tecnología avanzada, para asumir como rey. Sin embargo, cuando un antiguo enemigo reaparece, el temple y la fortaleza de T’Challa como rey y superhéroe son puestos a prueba al desatarse un conflicto que pone en peligro el destino de Wakanda y del mundo entero.' ),
	('La forma del Agua','2018/02/22','Guillermo del Toro','7,12',2,1,'120','K8xMDEXzX-0','Sally Hawkins, Octavia Spencer, Michael Shannon, Richard Jenkins, Doug Jones','Del maestro de la narrativa Guillermo del Toro, viene LA FORMA DEL AGUA —un cuento de hadas místico, que de fondo tiene la época de la Guerra Fría en los Estados Unidos, cerca de 1962. En el laboratorio secreto de alta seguridad del gobierno donde trabaja, la solitaria Elisa (Sally Hawkins) está atrapada en una vida de retraimiento. La vida de Elisa cambia para siempre cuando ella y su compañera de trabajo, Zelda (Octavia Spencer), descubren un experimento confidencial.' ),
	('El cavernícola','2018/02/22','Nick Park','3,2',1,1,'90','VDvsFizDL9Y','','En el film, Dug, humano y Hognob, jabalí, son los heroes de una aventura en la que dos civilizaciones, la de la Edad de Piedra y la de Bronce, compiten por hacerse hueco en la historia, mientras que, por casualidad, inventan el fútbol. Dug y Hognob tendrán que ayudar a su tribu, sorteando con gracia y astucia múltiples peligros, y derrotando al malvado Lord Nooth para no perder su hogar.' ),
	('Leatherface: La Máscara del Terror','2018/03/01','Alexandre Bustillo, Julien Maury','14,15',2,1,'120','ezk5eepqL_c','Sam Strike, James Bloor, Lili Taylor, Nicole Andrews, Stephen Dorff, Finn Jones, Jessica Madsen, Vanessa Grasse, Simona Williams, Julian Kostov','Precuela de la saga "La Matanza de Texas", centrada en los años de adolescencia de Leatherface, su protagonista. El joven Leatherface escapa de un hospital psiquiátrico con otros tres reclusos y secuestra a una enfermera a la que llevará a un viaje por carretera de pesadilla.' ),
	('Operación Red Sparrow','2018/03/01','Francis Lawrence','13,15',2,1,'120','LL1_H6ePE1o','Jennifer Lawrence, Charlotte Rampling, Jeremy Irons, Joel Edgerton','Dominika Egorova (Jennifer Lawrence) es reclutada contra su voluntad para convertirse en “gorrión”, una mujer seductora entrenada por el servicio de seguridad ruso. Dominika aprende a utilizar su cuerpo como arma, pero lucha por mantener su sentido de identidad durante el deshumanizador proceso de entrenamiento. Al encontrar su poder en un sistema injusto, Dominika emerge como una de las herramientas más eficaces del programa. Su primer objetivo es Nate Nash (Joel Edgerton), un agente de la CIA que, por su lado, está encargado de infiltrarse en los altos mandos de la inteligencia rusa. Los dos agentes jóvenes caen en un espiral de atracción y decepción, que amenaza sus carreras, lealtades y la seguridad de ambos países.' ),
	('Una Jungla de Locura','2018/03/01','David Alaux','3,2',1,1,'100','CWhbu8m5-h4','','Maurice es un pingüino… ¡Pero hay un tigre dentro de él! Y es que, este pingüino fue criado por una tigresa, así que se ha convertido en un profesional del kung-fu. Acompañado por sus amigos, un gorila, un lemur, un pez, dos sapos y una murciélaga, Maurice tratará de hacer reinar el orden y la justicia en la jungla. Claro que el diabólico koala Igor, acompañado por sus secuaces babuinos tiene la intención de destruir la jungla… Será entonces cuando la panda de la selva acudirá al rescate.' ),
	('A tu lado','2018/03/01','Martín Casapía','6,12',2,1,'100','eAFo1okmA4s','Andrés Vílchez, Leslie Shaw, Alessandra Fuller, Joaquín Escobar, Guillermo Castañeda','Sumida en la tristeza, Paz decide aceptar la invitación de su tío Martín y escapar de Lima para pasar unas vacaciones en un exclusivo Resort de Punta Cana. Ahí es donde conoce a Edu, el salvavidas del resort, y a todos sus amigos, con los que compartirá un frenético pero divertido viaje en la paradisíaca República Dominicana.' ),
	('Titanes del Pacífico: La Insurrección','2018/03/22','Steven S. DeKnight','3,1,5',2,2,'90','9GokIVXlVVw','Scott Eastwood, John Boyega , Adria Arjona, Charlie Day, Tian Jing','Debido a la amenaza de invasión de terribles criaturas del océano, el programa Jeager, responsable por la creación de robots gigantes, vuelve a reactivarse. Deberán perfeccionar la construcción de robotos y evitar que estos malévolos seres acuáticos logren tomar control de la Tierra, como casi ocurrió hace años.' ),
	('Mazinger Z: Infinity','2018/04/05','Junji Shimizu','2',2,2,'','MYMXZ7Oba3Y','','Cuando el malvado Doctor Hell ataca la Tierra, el poderoso robot gigante Mazinger Z se decide a detenerlo.' ),
	('Rascacielo: Rescate en las Alturas','2018/07/19','Rawson Marshall Thurber','1',2,2,'','TFWRIO0a4Qs','Dwayne Johnson, Neve Campbell, Pablo Schreiber, Byron Mann, Hannah Quinlivan, Noah Taylor, Roland Moller y Chin Han','La estrella mundial Dwayne Johnson lidera el elenco de esta producción de Legendary Entertainment; Rascacielos, como el ex líder del equipo de rescate de rehenes del FBI y veterano de guerra, Will Ford, quien ahora evalúa la seguridad para diversos rascacielos. En una misión en China, él encuentra al edificio más alto y seguro del mundo completamente en llamas, por lo cual ha sido incriminado. Huyendo de quienes lo buscan, Will debe encontrar a los responsables, limpiar su nombre y de algún modo rescatar a su familia que se encuentra atrapada dentro del edificio…por encima de la línea de fuego.' );

INSERT INTO Cine (RazonSocial, Salas, idCiudad, idDistrito, Formatos, Direccion, Telefonos) VALUES 
	( 'Cinestar Excelsior',8,2,4,'2','Jr. De la Unión 780','714-1865' ),
	( 'Cinestar Sur',8,2,8,'2','Av Los Héroes 240','710-9439' ),
	( 'Cinestar Metro San Juan',7,2,7,'2','Av. Los Proceres de la Independencia 1632','719-1064' ),
	( 'Cinestar Metro UNI',10,2,5,'2','Av. Gerardo Unger s/n cuadra 16','719-5142' ),
	( 'Cinestar Metro Comas',6,2,2,'2','Av. Tupac Amaru cdra 39 sn - La Pascana',' 715-2602' ),
	( 'Cinestar Las Américas',7,2,3,'2','Av. Hermilio Valdizán 121 (altura de la cuadra 18 de la Av. Brasil)','714-1718' ),
	( 'Cinestar Aviación',5,2,6,'2','Calle Tiziano 100 Alt. Cuadra 24 de la Av. Aviación','715-8598' ),
	( 'Cinestar Benavides',6,2,9,'2','Av. Benavides 4981','7141288' ),
	( 'Cinestar Metro Breña',8,2,1,'2,5','Jr. Iquique Nº 315 - Breña Av. Alfonso Ugarte y Venezuela','719-2445' ),
    ( 'Cinestar Ayacucho Premium',8,3,10,'2','Jr.Grau N° 279 esquina con Jirón Calor F. Vivanco','999-9999' );

INSERT INTO CinePelicula (idCine, idPelicula, Sala, Horarios) VALUES
	( 1,  8, 1, '13:30 / 21:30' ), ( 1,  9, 1, '17:30 / 22:00' ), ( 1, 11, 1, '13:30 / 16:00 / 18:45 / 19:15 / 21:20' ), ( 1, 13, 1, '13:30 / 15:15' ), ( 1, 17, 1, '13:15 / 15:15 / 17:15 / 19:15 / 21:15' ), ( 1, 16, 1, '13:00 / 15:00 / 17:00 / 19:00 / 21:00' ),
	( 2,  8, 1, '16:00' ), ( 2,  9, 1, '18:00 / 22:15' ), ( 2, 11, 1, '15:30 / 16:30 / 18:00 / 19:15 / 20:00 / 20:30 / 21:45' ), ( 2, 13, 1, '15:45' ), ( 2, 16, 1, '15:15 / 17:15 / 19:15 / 21:15' ), ( 2, 17, 1, '16:00 / 18:00 / 20:00 / 22:00' ),
	( 3,  8, 1, '15:20 / 17:20 / 19:30 / 21:40' ), ( 3, 11, 1, '15:45 / 16:45 / 18:15 / 19:15 / 20:45 / 21:45' ), ( 3, 16, 1, '15:30 / 17:20 / 19:10 / 21:00' ), ( 3, 17, 1, '16:00 / 17:50 / 19:40 / 21:30' ),
	( 4,  8, 1, '15:45 / 17:45 / 19:45' ), ( 4,  9, 1, '21:30' ), ( 4, 11, 4, '15:30 / 16:30 / 18:15 / 19:15 / 21:00 / 21:50' ), ( 4, 13, 1, '14:45' ), ( 4, 16, 1, '15:15 / 17:15 / 19:15 / 21:15' ), ( 4, 17, 1, '16:00 / 18:00 / 20:00 / 22:00' ),
	( 5, 11, 1, '16:45 / 19:15 / 21:45' ), ( 5, 16, 1, '15:15 / 17:15 / 19:15 / 21:15' ), ( 5, 17, 1, '15:30 / 17:30 / 19:30 / 21:30' ),
	( 6,  8, 1, '18:00 / 22:15' ), ( 6, 11, 1, '15:30 / 16:30 / 18:00 / 19:15 / 20:45 / 22:00' ), ( 6, 15, 1, '16:15 / 19:00 / 21:45' ), ( 6, 16, 1, '15:15 / 17:15 / 19:15 / 21:15' ), ( 6, 17, 1, '16:00 / 18:00 / 20:00 / 22:00' ),
	( 7, 11, 1, '16:15 / 19:00 / 21:35' ), ( 7, 16, 1, '15:45 / 17:45' ), ( 7, 17, 1, '19:45 / 21:45'),
	( 8, 11, 1, '16:45 / 19:20 / 22:00' ), ( 8, 16, 1, '15:15 / 17:00 / 18:45' ), ( 8, 17, 1, '15:45 / 17:45 / 19:45 / 21:45' ),
	( 9,  8, 1, '15:10 / 17:20 ' ), ( 9, 11, 1, '15:30 / 16:30 / 18:15 / 19:15 / 21:00 / 22:00' ), ( 9, 15, 1, '17:00 / 19:40 / 22:20' ), ( 9, 16, 1, '15:15 / 17:15 / 19:15 / 21:15' ), ( 9, 17, 1, '16:00 / 18:00 / 20:00 / 22:00' );

INSERT INTO CineTarifa (idCine, DiasSemana, Precio) VALUES
	( 1, 'Lunes y Miércoles', 5.00 ), ( 1, 'Martes', 4.50 ), ( 1, 'Jueves y Viernes', 7.00 ), ( 1, 'Sábado, Domingo y Feriados', 8.00 ), ( 1, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 6.00 ), ( 1, '3D - Lunes y Miércoles', 7.50 ), ( 1, '3D - Martes', 6.00 ), ( 1, '3D - Jueves a Domingos', 11.00 ),
	( 2, 'Lunes, Martes y Miércoles', 5.00 ), ( 2, 'Jueves y Viernes', 7.00 ), ( 2, 'Sábado y Domingo', 9.00 ), ( 2, 'Feriados', 10.00 ), ( 2, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 6.00 ), ( 2, '3D - Lunes, Martes y Miércoles', 10.00 ), ( 2, '3D - Jueves a Domingo', 12.00 ), ( 2, 'Adulto mayor y niños de 2 hasta 8 años (Sábados y Domingos)', 10.00 ),
	( 3, 'Lunes, Martes y Miércoles', 7.50 ), ( 3, 'Jueves y Viernes', 12.00 ), ( 3, 'Sábados, Domingos y Feriados', 15.00 ), ( 3, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 8.00 ), ( 3, '3D - Lunes y Miércoles', 14.00 ), ( 3, '3D - Martes', 13.50 ), ( 3, '3D - Jueves a Domingos', 17.00 ), ( 3, 'Adulto mayor y niños de 2 hasta 8 años (Sábados y Domingos)', 14.50 ),
	( 4, 'Lunes y Miércoles', 5.00 ), ( 4, 'Martes', 4.50 ), ( 4, 'Jueves y Viernes', 7.50 ), ( 4, 'Sábado, Domingo y Feriados', 10.50 ), ( 4, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 7.00 ), ( 4, '3D - Lunes a Miércoles', 10.50 ), ( 4, '3D - Jueves a Domingo', 15.50 ), ( 4, 'Adulto mayor y niños de 2 hasta 8 años (Sábados y Domingos)', 12.50 ),
	( 5, 'Lunes, Martes y Miércoles', 5.00 ), ( 5, 'Jueves a Domingos y Feriados', 8.00 ), ( 5, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 6.50 ), ( 5, '3D - Lunes, Martes y Miércoles', 10.50 ), ( 5, '3D - Jueves a Domingo y Feriados', 15.50 ), ( 5, 'Adulto mayor y niños de 2 hasta 8 años (Sábados y Domingos)', 12.50 ),
	( 6, 'Lunes y Miércoles', 6.50), ( 6, 'Martes', 6.00 ), ( 6, 'Jueves y Viernes', 8.50 ), ( 6, 'Sábado y Domingo', 11.00 ), ( 6, 'Feriados', 11.50 ), ( 6, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 7.00 ),
	( 7, 'Lunes, Martes y Miércoles', 5.50), ( 7, 'Jueves y Viernes', 8.50), ( 7, 'Sábado, Domingo y Feriados', 10.50), ( 7, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 8.00 ), ( 7, '3D - Lunes, Martes y Miércoles', 10.50), ( 7, '3D - Jueves a Domingo', 15.50), ( 7, 'Adulto mayor y niños de 2 hasta 8 años (Sábados y Domingos)', 12.50 ),
	( 8, 'Lunes, Martes y Miércoles', 7.50), ( 8, 'Jueves y Viernes', 9.00), ( 8, 'Sábado y Domingo', 10.00), ( 8, 'Feriados', 10.50), ( 8, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 7.50 ), ( 8, '3D - Lunes, Martes y Miércoles', 10.50), ( 8, '3D - Jueves a Domingo', 15.50), ( 8, 'Adulto mayor y niños de 2 hasta 8 años (Sábados y Domingos)', 12.50 ),
	( 9, 'Lunes y Miércoles', 6.50), ( 9, 'Martes', 5.50), ( 9, 'Jueves y Viernes', 10.50), ( 9, 'Sábados, Domingos y Feriados', 13.00), ( 9, 'Adulto mayor y niños de 2 hasta 8 años (Jueves a Domingos)', 8.50 ), ( 9, '3D - Lunes, Martes y Miércoles', 11.50), ( 9, '3D - Jueves a Domingo', 16.50), ( 9, 'Adulto mayor y niños de 2 hasta 8 años (Sábados y Domingos)', 13.50 );

-- FUNCIONES DE APOYO (PostgreSQL)

CREATE OR REPLACE FUNCTION getGenerosDetalle(Generos TEXT) RETURNS TEXT AS $$
DECLARE
    _result TEXT := '';
    _id TEXT;
BEGIN
    FOR _id IN SELECT unnest(string_to_array(Generos, ',')) LOOP
        _result := _result || (SELECT COALESCE(TRIM(Detalle), '') FROM Genero WHERE id = CAST(TRIM(_id) AS INT)) || ',';
    END LOOP;
    RETURN TRIM(TRAILING ',' FROM _result);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getFormatosDetalle(Formatos TEXT) RETURNS TEXT AS $$
DECLARE
    _result TEXT := '';
    _id TEXT;
BEGIN
    FOR _id IN SELECT unnest(string_to_array(Formatos, ',')) LOOP
        _result := _result || (SELECT COALESCE(TRIM(Detalle), '') FROM Formato WHERE id = CAST(TRIM(_id) AS INT)) || ',';
    END LOOP;
    RETURN TRIM(TRAILING ',' FROM _result);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION DateLong(fecha TEXT) RETURNS VARCHAR(100) AS $$
DECLARE
    _d DATE;
BEGIN
    _d := CAST(REPLACE(fecha, '/', '-') AS DATE);
    RETURN TO_CHAR(_d, 'TMDay, DD "de" TMMonth "del" YYYY');
END;
$$ LANGUAGE plpgsql;

-- PROCEDIMIENTOS ALMACENADOS (Parámetros renombrados para evitar conflicto con columnas)

CREATE OR REPLACE FUNCTION sp_getcines() 
RETURNS TABLE (
    id INT, "RazonSocial" VARCHAR, "Salas" INT, "idCiudad" INT, "idDistrito" INT, 
    "Formatos" VARCHAR, "Direccion" VARCHAR, "Telefonos" VARCHAR, 
    "Ciudad" VARCHAR, "Detalle" VARCHAR, "Formatoss" TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT c.id, c.RazonSocial, c.Salas, c.idCiudad, c.idDistrito, 
           c.Formatos, c.Direccion, c.Telefonos,
           ci.Detalle as Ciudad, d.Detalle as Detalle, getFormatosDetalle(c.Formatos) as Formatoss
    FROM Cine c
    JOIN Ciudad ci ON c.idCiudad = ci.id
    JOIN Distrito d ON c.idDistrito = d.id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_getcine(p_id INT) 
RETURNS TABLE (
    id INT, "RazonSocial" VARCHAR, "Salas" INT, "idCiudad" INT, "idDistrito" INT, 
    "Formatos" VARCHAR, "Direccion" VARCHAR, "Telefonos" VARCHAR, 
    "Ciudad" VARCHAR, "Detalle" VARCHAR, "Formatoss" TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT c.id, c.RazonSocial, c.Salas, c.idCiudad, c.idDistrito, 
           c.Formatos, c.Direccion, c.Telefonos,
           ci.Detalle as Ciudad, d.Detalle as Detalle, getFormatosDetalle(c.Formatos) as Formatoss
    FROM Cine c
    JOIN Ciudad ci ON c.idCiudad = ci.id
    JOIN Distrito d ON c.idDistrito = d.id
    WHERE c.id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_getcinetarifas(p_id INT) 
RETURNS TABLE ("DiasSemana" VARCHAR, "Precio" TEXT) AS $$
BEGIN
    RETURN QUERY 
    SELECT ct.DiasSemana, 'S/. ' || CAST(ct.Precio AS TEXT) 
    FROM CineTarifa ct WHERE ct.idCine = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_getcinepeliculas(p_idCine INT) 
RETURNS TABLE ("Titulo" VARCHAR, "Horarios" VARCHAR) AS $$
BEGIN
    RETURN QUERY 
    SELECT p.Titulo, cp.Horarios 
    FROM CinePelicula cp
    JOIN Pelicula p ON cp.idPelicula = p.id
    WHERE cp.idCine = p_idCine;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_getpeliculass() 
RETURNS TABLE (
    id INT, "Titulo" VARCHAR, "FechaEstreno" VARCHAR, "Director" VARCHAR, "Generos" VARCHAR,
    "idClasificacion" INT, "idEstado" INT, "Duracion" VARCHAR, "Link" VARCHAR, 
    "Reparto" TEXT, "Sinopsis" TEXT, "Geneross" TEXT, "FechaEstrenoss" VARCHAR
) AS $$
BEGIN
    RETURN QUERY 
    SELECT p.id, p.Titulo, p.FechaEstreno, p.Director, p.Generos, 
           p.idClasificacion, p.idEstado, p.Duracion, p.Link, 
           p.Reparto, p.Sinopsis, getGenerosDetalle(p.Generos), DateLong(p.FechaEstreno)
    FROM Pelicula p;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_getpeliculas(p_idEstado INT) 
RETURNS TABLE (id INT, "Titulo" VARCHAR, "Sinopsis" TEXT, "Link" VARCHAR) AS $$
BEGIN
    RETURN QUERY 
    SELECT p.id, p.Titulo, p.Sinopsis, p.Link 
    FROM Pelicula p WHERE p.idEstado = p_idEstado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_getpelicula(p_id INT) 
RETURNS TABLE (
    id INT, "Titulo" VARCHAR, "FechaEstreno" VARCHAR, "Director" VARCHAR, "Generos" VARCHAR,
    "idClasificacion" INT, "idEstado" INT, "Duracion" VARCHAR, "Link" VARCHAR, 
    "Reparto" TEXT, "Sinopsis" TEXT, "Geneross" TEXT, "FechaEstrenoss" VARCHAR
) AS $$
BEGIN
    RETURN QUERY 
    SELECT p.id, p.Titulo, p.FechaEstreno, p.Director, p.Generos, 
           p.idClasificacion, p.idEstado, p.Duracion, p.Link, 
           p.Reparto, p.Sinopsis, getGenerosDetalle(p.Generos), DateLong(p.FechaEstreno)
    FROM Pelicula p WHERE p.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- VISTAS (PostgreSQL)

CREATE OR REPLACE VIEW vGenero AS SELECT * FROM Genero;
CREATE OR REPLACE VIEW vDistrito AS SELECT * FROM Distrito;
CREATE OR REPLACE VIEW vCineTarifas AS SELECT idCine, DiasSemana, 'S/. ' || CAST(Precio AS TEXT) as Precio FROM CineTarifa;
CREATE OR REPLACE VIEW vCinePeliculas AS SELECT cp.idCine, p.Titulo, cp.Horarios FROM CinePelicula cp JOIN Pelicula p ON cp.idPelicula = p.id;
CREATE OR REPLACE VIEW vCines AS 
	SELECT c.*, ci.Detalle as Ciudad, d.Detalle as Detalle, getFormatosDetalle(c.Formatos) as Formatoss
	FROM Cine c
	JOIN Ciudad ci ON c.idCiudad = ci.id
	JOIN Distrito d ON c.idDistrito = d.id;
