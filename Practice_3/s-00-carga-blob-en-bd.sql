-- @Author:  Jorge Rodríguez C.
-- Procedimiento empleado para leer datos binarios, por ejemplo, archivos PDF que se encuentran
-- en un directorio para ser cargados en un campo tipo BLOB para un registro existente en una tabla.
-- Para usarlo realizar los siguientes pasos:
-- 1. Como SYS crear un directorio virtual, Por ejemplo:
--
-- create or replace directory tmp_dir as '/tmp/bdd';
--
-- En este ejemplo se hace referencia al directorio /tmp/bdd en el que se encuentra el archivo PDF a cargar
--
-- 2. Como SYS otorgar privilegios de lectura al objeto 'directory' creando en el paso 1
--
-- grant read on directory tmp_dir to <my_user>;
--
-- 3. Suponer que se desea guardar un archivo en la siguiente tabla:
--
-- create table my_table(
--    id number(2,0) ,
--    pdf blob
-- );
--
--  Antes de invocar al procedimiento almacenado, se deberá inicializar el
--  registro donde se va a cargar el archivo.
-- Ejemplo:
--
-- insert into mytable(id,pdf) values(1, empty_blob());
--
--  Observar en el ejemplo anterior, el campo PDF se inicializa con un objeto LOB vacío.
--
-- 4. Invocar al procedimiento almacenado, suponer que se va a guardar el archivo
--    /tmp/bdd/revista.pdf  en el registro con id = 1
--
--    exec  carga_blob_en_bd('TMP_DIR','revista.pdf','my_table','pdf','id','1',null,null);
--
--    En Oracle,   un procedimiento almacenado se ejecuta empleando la instrucción exec.  En este caso recibe
--    los siguientes parámetros:
--
--    parámetro 1:  nombre del directorio virtual creado anteriormente
--    parámetro 2:  nombre del archivo dentro del directorio configurado
--    parámetro 3:  nombre de la tabla donde se hará el update
--    parámetro 4:  nombre de la columna tipo blob.
--    parámetro 5:  nombre de la primer columna que actua como PK.
--    parámetro 6:  valor de la primer columna que actua colo PK  y que se emplea para localizar al registro
--                  que se va a actualizar.
--    parametro 7:  nombre de la segunda columna que forma parte de la PK. Este parámetro debe emplearse
--                  para tablas con una PK compuesta. El script soporta hasta una PK con 2 atributos.
--    parametro 8:  valor para la segunda columna que forma parte de la PK.  Si la PK solo está formada por una
--                  columna, los parámetros 7 y 8 deberán tener un valor nulo.
--
-- 5. Comprobar resultados mostrando el tamaño del archivo que fue cargado en la BD:
--
--    select  dbms_lob.getlength(pdf) longitud from my_table where id = 1;
--
--  Debido a que este procedimiento recibe nombres de tablas y columnas como parámetros,  puede existir el riesgo
--  de  problemas de seguridad, por ejemplo,  inyección de SQL. Para evitar este problema, el código
--  realiza las validaciones necesarias para evitar este problema (se explica más adelante).
--  El procedimiento hace uso extensivo de excepciones como mecanismo principal para reportar errores
-- (se explica su uso más adelante).

create or replace procedure carga_blob_en_bd(
-- Declaración de parámetros del procedimiento. Se emplea el prefijo 'v_' que significa 'variable'
  v_directory_name   in varchar2,
  v_src_file_name    in varchar2,
  v_table_name       in varchar2,
  v_blob_column_name in varchar2,
  v_pk1_column_name  in varchar2,
  v_pk1_column_value in varchar2,
  v_pk2_column_name  in varchar2,
  v_pk2_column_value in varchar2) is

  --variables adicionales  empleadas en el código.
  v_query             varchar2(2000);
  v_src_offset        number := 1;
  v_dest_offset       number := 1;
  v_src_blob_size     number;
  v_src_blob          bfile; 
  v_dest_blob         blob;
  --variables que contienen nombres validos de columnas y tablas
  v_valid_table_name       varchar2(30);
  v_valid_blob_column_name varchar2(30);
  v_valid_pk1_column_name  varchar2(30);
  v_valid_pk2_column_name  varchar2(30);
  
  begin
    --inicializa un objeto bfile apuntando al archivo que se va a leer
    --bfile puede ser visto como un puntero al archivo que se va a leer (archivo binario.)
    v_src_blob := bfilename(v_directory_name, v_src_file_name);

    --Verifica si existe el archivo y lo abre para ser leido. De lo contrario se lanza excepción.
    if dbms_lob.fileexists(v_src_blob) = 1 and not dbms_lob.isopen(v_src_blob) = 1
    then
      v_src_blob_size := dbms_lob.getlength(v_src_blob);
      dbms_lob.open(v_src_blob, dbms_lob.LOB_READONLY);
    else
      -- En oracle las excepciones creadas por un usuario deben tener un código que esté en el rango [-20000 ,-20999]
      -- Pueden ir acompañadas de un mensaje de error. En este ejemplo se seleccionó al azar el 20101
      raise_application_error(-20101, 'Invalid file. It does not exist or it is open:' || v_src_file_name);
    end if;

  --Esta función verifica que los nombres de las tablas y columnas sean cadenas validas. Evita inyección de SQL.
  --Los valores correctos sin riesgo de inyección de SQL se asignan a las variables que inician con vv_
  v_valid_table_name := dbms_assert.simple_sql_name(v_table_name);
  v_valid_blob_column_name := dbms_assert.simple_sql_name(v_blob_column_name);
  v_valid_pk1_column_name := dbms_assert.simple_sql_name(v_pk1_column_name);

  if v_pk2_column_name is not null then 
    v_valid_pk2_column_name := dbms_assert.simple_sql_name(v_pk2_column_name);
  end if;

    -- El siguiente paso es la construcción de una sentencia UPDATE que se encargará de
    -- actualizar el valor de la columna BLOB con base a los  valores de los parámetros.
    -- Observar que se crea una sentencia de forma dinámica empleando una cadena concatenando
    -- los valores de los parámetros. Aquí podría haber inyección de SQL ya que el usuario podría
    -- escribir como valor del nombre de una tabla, por ejemplo:  'drop database ...'
    -- En este caso dicho problema no ocurrirá ya que los valores de los parametros  fueron validados
    -- en pasos anteriores.
    -- observar  que el valor de la PK  es  :ph_pk1_column_value. A esta cadena se le conoce como
    -- placeholder (ph).  Es una especie de variable que será sustituida  por el valor de la PK. En otros
    -- lenguajes como Java, se usa algo asi:   update my_table set nombre = ? where campo = ?
    -- el '?' representa un placeholder y será sustituido por valores reales al ejecutar la sentencia.
    -- En Oracle se usa la sintaxis :<nombre_del_placeholder>. El nombre puede se cualquier cadena.
    -- El uso de estos placeholders protege al código de inyección de SQL ya que sus valores nunca
    -- serán tratados como instrucciones SQL, sino como simples cadenas o números. Sentencias
    -- placeholders se les llama 'sentencias parametrizadas'.

    v_query := 'update ' || v_valid_table_name
               || ' set ' || v_valid_blob_column_name || '= empty_blob() '
               || ' where ' || v_valid_pk1_column_name || '= :ph_pk1_column_value';

    -- si se especifica una segunda columna como parte de la PK,  se debe agregar una condición AND
    -- Es decir:  update my_table set ....  where  pk1 = x and pk2 = y
    if v_pk2_column_name is not null
    then
      v_query := v_query || ' and ' || v_valid_pk2_column_name || '= :ph_pk2_column_value';
    end if;

    --en esta ultima parte la sentencia dinámica regresa una referencia del objeto blob
    --haciendo uso de otro placeholder llamado :ph_blob.
     v_query := v_query || ' returning ' || v_valid_blob_column_name || ' into :ph_blob';

    -- En la sig. instruccion se imprime la consulta dinámica solo para efectos de debugueo.
    -- Hasta este punto, la sentenci dinámica update se vería asi:
    ---
    -- update my_table set pdf = empty_blob()
    -- where  pk1 = :ph_pk1_coluum_value
    -- returning  pdf into :ph_blob
    ---
    -- Si  la PK  fuera compuesta,  la sentencia se vería asi:
    --
    -- update my_table set pdf = empty_blob()
    -- where  pk1 = :ph_pk1_coluum_value
    -- and  pk2 = :ph_pk2_column_value
    -- returning  pdf into :ph_blob
   
    dbms_output.put_line(v_query);

  
    -- En este paso se ejecuta el query dinámico
    -- Observar que aqui se realiza la sustitución de los placeholders antes mencionados. Se usa la clausula
    -- using para asignar el valor de la PK, o de la segunda PK en caso de ser tablas con 2 campos que actuan como PK.
    -- El placeholder :ph_pk1_coluum_value se sustituye con el valor de la variable v_pk1_column_value
    -- El placeholder :ph_pk2_coluum_value se sustituye con el valor de la variable v_pk2_column_value para PK compuesta
    -- El placeholder :ph_blob es un placeholder de retorno, su valor será referenciado por la variable v_dest_blob
    -- Esta variable representa una referencia a un objeto tipo BLOB vacio que será empleado para escribir 
    -- los datos del archivo binario.
    if v_pk2_column_name is null
    then
      execute immediate v_query using v_pk1_column_value returning into v_dest_blob;
    else
      execute immediate v_query using v_pk1_column_value, v_pk2_column_value returning into v_dest_blob;
    end if;

    -- Aquí solo se valida que la sentencia UPDATE se haya ejecutado de forma correcta, solo debió haber actualizado
    -- un único registro. De lo contrario se lanza excepción.
    if sql%rowcount <> 1
    then
      raise_application_error(-20104, 'Invalid number of rows updated: ' || sql%rowcount || ', expected only 1.');
    end if;

    --Ya casi por terminar,  aquí se lee el archivo y escribe en el blob que fue obtenido a través de la variable
    -- de salida v_dest_blob
    dbms_lob.loadblobfromfile(
        dest_lob    => v_dest_blob,
        src_bfile   => v_src_blob,
        amount      => dbms_lob.getlength(v_src_blob),
        dest_offset => v_dest_offset,
        src_offset  => v_src_offset
    );
    --cerrando blob una vez realizada la copia de datos.
    dbms_lob.close(v_src_blob);

    -- Aqui se valida que la longitud de datos cargada en el campo BLOB sea igual a la del archivo.
    if v_src_blob_size = dbms_lob.getlength(v_dest_blob)
    then
      dbms_output.put_line('done ' || v_src_blob_size || ' bytes.');
    else
      raise_application_error(-20104, 'Invalid blob size. Expected: '
                                      || v_src_blob_size || ', actual: ' || dbms_lob.getlength(v_dest_blob));
    end if;
  end carga_blob_en_bd;
  /
-- El caracter '/' significa ejecución. Es importante que todos los scripts de este tipo tengan este caracter
--al final. De otra forma el script  no se ejecuta y no se creará el  procedimiento.

--se recomienda ejecutar esta instrucción para mostrar posibles errores de compilación
show errors