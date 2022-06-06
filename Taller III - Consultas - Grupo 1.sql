/*
Integrantes: 
José Alexander Robless Romero, n° Carné: 00052121
Ricardo ALexander Rivas Martínez, n° Carné: 00133221
Luis Andrée Hernández Mlatez, n° Carné: 00012321
*/


/* 1. Mostrar la lista de clientes que han contratado el plan "Premium". Ordenar el resultado con respecto al id del cliente en orden ascendente.
Almacenar el resultado en una nueva tabla llamada "CLIENTES_PREMIUM”.*/

CREATE TABLE CLIENTES_PREMIUM(
id INT PRIMARY KEY not null,
	nombre VARCHAR(50),
	direccion VARCHAR(50),
	tipo VARCHAR(15) null
);

INSERT INTO CLIENTES_PREMIUM (id, nombre, direccion, tipo)
SELECT id, nombre, direccion,id_tipo_plan FROM CLIENTE
WHERE id_tipo_plan = 4
ORDER BY id asc;

UPDATE CLIENTES_PREMIUM
SET tipo = 'Premium'
/*En este caso la tabla CLIENTES_PREMIUM posee todos los datos con tipo como 4 por lo que cambiamos con el UPDATE tipo a Premium*/

SELECT *
FROM CLIENTES_PREMIUM

/* 2. Mostrar las 2 clínicas más populares. El parámetro de popularidad se define en base al número de
citas registradas por cada clínica. Mostrar el id de la clínica, el nombre, su dirección y email, además
mostrar la cantidad de citas registradas. Ordenar el resultado en base a la cantidad de citas
registradas. */ --todavia no

SELECT  CL.id, CL.nombre, CL.direccion ,CL.email, COUNT (CT.id_clinica) AS 'CITAS ' 
FROM CLINICA CL
INNER JOIN  CITA CT
ON CT.id_clinica = CL.id
GROUP BY CL.id , CL.nombre , CL.direccion ,CL.email
HAVING COUNT (CT.id) >= 7
ORDER BY CL.id ASC ;

/* 3. Mostrar la información completa de cada cliente, incluir el nombre, dirección, el tipo de plan, los
correos (si es que ha brindado alguno) y los teléfonos (si es que ha brindado alguno). Ordenar el
resultado con respecto al id del cliente en orden ascendente.*/

SELECT C.id, C.nombre, C.direccion, TP.tipo AS 'TIPO',
	TC.telefono, 
	CC.correo
FROM CLIENTE C
INNER JOIN TIPO_PLAN TP
	ON TP.id = C.id_tipo_plan
LEFT JOIN CORREO_CLIENTE CC
	ON CC.id_cliente = C.id
LEFT JOIN TELEFONO_CLIENTE TC
	ON TC.id_cliente = C.id
ORDER BY C.id ASC;


/* 4. Identificar las consultas que han necesitado de un médico asistente, mostrar
el id de la consulta, la fecha, la duración, el id del médico y el nombre del médico asistente.
Ordenar el resultado con respecto al id de la consulta en orden ascendente. */

SELECT id_consulta, fecha, duracion, id_medico, nombre 'medico_asistente'
FROM CONSULTA, MEDICOXCONSULTA, MEDICO
WHERE MEDICOXCONSULTA.rol = 0 AND CONSULTA.id = MEDICOXCONSULTA.id_consulta AND MEDICO.id = MEDICOXCONSULTA.id_medico
ORDER BY id_consulta ASC

/* 5. ¿Cuáles son las clínicas capacitadas para atender emergencias? Mostrar el id
de la clínica, el nombre, la dirección y email. */

SELECT C.id, C.nombre, C.direccion, C.email
FROM CLINICA AS C 
INNER JOIN EMERGENCIA AS E ON E.id_clinica = C.id
GROUP BY  C.id, C.nombre, C.direccion, C.email;

/* 6. Calcular las ganancias de la asociación en la primera quincena de mayo. Mostrar la fecha de la
consulta, el nombre del cliente atendido y el nombre del médico principal. Se debe considerar que
existe la posibilidad de que haya consultas en las que no se recete ningún medicamento. Ordenar el
resultado con respecto al id de la consulta en orden ascendente. Las ganancias de cada consulta se
calculan de la siguiente forma: (Precio de la consulta + Suma de todos los medicamentos recetados) +
13% IVA.*/
 
SELECT CON.id, CON.fecha AS 'Fecha Consulta',C.nombre AS 'Cliente',M.nombre AS 'Medico', (SUM(MED.precio)) 'SUBTOTAL', CON.precio 'Consulta $$',
(((SUM(MED.precio) + CON.precio) * 0.13)+(SUM(MED.precio) + CON.precio)) 'TOTAL'
FROM CONSULTA CON
INNER JOIN CLIENTE C
	ON CON.id_cliente = C.id
INNER JOIN MEDICOXCONSULTA MC
	ON  MC.id_consulta = CON.id
INNER JOIN MEDICO M 
	ON  MC.id_medico = M.id
INNER JOIN RECETA R
	ON R.id_consulta = CON.id
INNER JOIN MEDICAMENTO MED
	ON R.id_medicamento = MED.id
WHERE CON.fecha BETWEEN '2022-05-01' AND '2022-05-15'
GROUP BY CON.fecha ,C.nombre,M.nombre ,CON.id , CON.precio 
ORDER BY CON.id ASC;