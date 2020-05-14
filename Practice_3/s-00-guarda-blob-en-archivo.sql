--@Author Hernández Arrieta Carlos Alberto
--Procedimiento empleado para exportar el contenido de una columna BLOB a
--un archivo. Se emplea el valor de la llave primaria para localizar el registro.
--Instrucciones:
-- 1. Como SYS crear un directorio virtual en el que se guardará el archivo.
-- Por ejemplo:
-- create or replace directory tmp_dir as '/tmp/bdd';
-- 2. Como SYS otorgar permisos de lectura y escritura al usuario que va
-- ejecutar el script.
-- grant read,write on directory tmp_dir to <my_user>;
-- 3. Suponer que se desea leer el contenido de la columna pdf de la tabla:
-- create table my_table(
-- id number(2,0) ,
-- pdf blob
-- );
-- 4. Invocar el procedimiento:
--
-- exec save_file_from_blob('TMP_DIR','revista3.pdf','my_table','pdf','id','5');
--
-- parámetro 1: nombre del directorio virtual creado anteriormente
-- parámetro 2: nombre del archivo dentro del directorio configurado
-- parámetro 3: nombre de la tabla que contiene la columna a leer
-- parámetro 4: nombre de la columna tipo blob.
-- parámetro 5: nombre de la primer columna que actua como PK.
-- parámetro 6: valor de la primer PK que se emplea para localizar al registro cuyo
-- valor de la columna de tipo blob se va a leer.
-- parámetro 7: nombre de la segunda columna que actua como PK.
-- parámetro 8: valor de la segunda PK que se emplea para localizar al
-- registro cuyo valor de la columna de tipo blob se va a leer.
-- Si la PK solo está formada por una columna,
-- los parámetros 7 y 8 deberán tener un valor nulo.

CREATE OR REPLACE PROCEDURE guarda_blob_en_archivo (
  v_directory_name      IN VARCHAR2,
  v_dest_file_name      IN VARCHAR2,
  v_table_name          IN VARCHAR2,
  v_blob_column_name    IN VARCHAR2,
  v_pk1_column_name     IN VARCHAR2,
  v_pk1_column_value    IN VARCHAR2,
  v_pk2_column_name     IN VARCHAR2,
  v_pk2_column_value    IN VARCHAR2) IS

  v_file UTL_FILE.FILE_TYPE;
  v_buffer_size number := 32767; -- tamaño del buffer en bytes
  v_buffer RAW(32767); -- variable para guardar la información binaria
  v_blob BLOB; -- variable para guardar el blob a leer
  v_blob_length NUMBER; -- variable para guarfar el tamaño del blob en bytes
  v_position NUMBER; -- variable para indiciar el offset del blob
  v_query VARCHAR2(2000); -- variable para almacenar la query a leer
  v_valid_table_name VARCHAR2(30);
  v_valid_blob_column_name VARCHAR2(30);
  v_valid_pk1_column_name VARCHAR2(30);
  v_valid_pk2_column_name VARCHAR2(30);
BEGIN
  -- Verificación de que las variables que guardan los nombres de las tablas
  -- y columnas sean cadena válidas. Ayuda para evitar la inyección de SQL.
  v_valid_table_name := DBMS_ASSERT.SIMPLE_SQL_NAME(v_table_name);
  v_valid_blob_column_name := DBMS_ASSERT.SIMPLE_SQL_NAME(v_blob_column_name);
  v_valid_pk1_column_name := DBMS_ASSERT.SIMPLE_SQL_NAME(v_pk1_column_name);

  if v_pk2_column_name is not null then
    v_valid_pk2_column_name := DBMS_ASSERT.SIMPLE_SQL_NAME(v_pk2_column_name);
  end if;

  v_query := 'select '
      || v_blob_column_name
      || ' into :ph_blob '
      || ' from '
      || v_table_name
      || ' where '
      || v_valid_pk1_column_name
      || ' = :ph_pk1_column_value';

  if v_pk2_column_name is not null then
    v_query := v_query
      || ' and '
      || v_valid_pk2_column_name
      || ' = :ph_pk2_column_value';
  end if;

  -- ejecuta la consulta dinámica
  if v_pk2_column_name is not null then
    EXECUTE IMMEDIATE v_query INTO v_blob
    USING v_pk1_column_value, v_pk2_column_value;
  else
    EXECUTE IMMEDIATE v_query INTO v_blob
    USING v_pk1_column_value;
  end if;

  -- obtenemos el tamaño del objeto blob
  v_blob_length := DBMS_LOB.GETLENGTH(v_blob);
  v_position := 1;
  v_file := UTL_FILE.FOPEN(v_directory_name, v_dest_file_name, 'wb', v_buffer_size);

  -- leer el archivo por partes hasta completar
  while v_position < v_blob_length loop
    DBMS_LOB.READ(v_blob, v_buffer_size, v_position, v_buffer);
    UTL_FILE.PUT_RAW(v_file, v_buffer, TRUE);
    v_position := v_position + v_buffer_size;
  end loop;

  -- cierra el archivo en caso de error y relanza la excepción.
  exception when others then
  --cerrar v_file en caso de error.
    if utl_file.is_open(v_file) then
      utl_file.fclose(v_file);
    end if;
  raise;
END guarda_blob_en_archivo;
/
show errors
