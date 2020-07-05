--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 11/Abril/2020
--@Descripción: Carga y Export de archivos PDF en el sitio JRCBD_S1

whenever sqlerror exit rollback;

--ruta donde se ubicarán los archivos PDFs
define p_pdf_path='/tmp/bdd/p06'
define p_pdf_origin='./pdf'
set verify off
Prompt Limpiando y creando directorio en /tmp/bdd/p06
!rm -rf &p_pdf_path
!mkdir -p &p_pdf_path
!chmod 777 &p_pdf_path

-- Se asume que los archivos PDF se encuentran en el mismo directorio donde se
-- ejecuta este script.
!cp &p_pdf_origin/m_archivo_*.pdf &p_pdf_path
!chmod 755 &p_pdf_path/m_archivo_*.pdf

-- cahabdd_s1
Prompt conectando a cahabdd_s1 como SYS para crear objetos tipo directory
accept p_sys_password default 'system' prompt 'Password de sys [system]: ' hide
connect sys@cahabdd_s1/&p_sys_password as sysdba
Prompt creando un objeto DIRECTORY para acceder al directorio /tmp/bdd/p06
create or replace directory tmp_dir as '&p_pdf_path';
grant read, write on directory tmp_dir to bancos_bdd;

-- cahabdd_s2
Prompt conectando a cahabdd_s2 como SYS para crear objetos tipo directory
accept p_sys_password default 'system' prompt 'Password de sys [system]: ' hide
connect sys@cahabdd_s2/&p_sys_password as sysdba
Prompt creando un objeto DIRECTORY para acceder al directorio /tmp/bdd/p06
create or replace directory tmp_dir as '&p_pdf_path';
grant read, write on directory tmp_dir to bancos_bdd;

------------------ Cargando datos en cahabdd_s1 ----------------------
Prompt conectando a cahabdd_s1 con usuario bancos_bdd para cargar datos binarios
connect bancos_bdd/bancos_bdd@cahabdd_s1

/*
En este sitio se cargarán los siguientes archivos.
F_CAH_MOVIMIENTO_2

NUM_MOVIMIENTO  CUENTA_ID COMPROBANTE
-------------- ---------- -----------
2                   1     m_archivo_4.pdf

CUENTA_ID COMPROBANTE
--------- -----------
    1     m_archivo_1.pdf
*/
Prompt ejecutando procedimientos para hacer import/export de datos BLOB
@s-00-carga-blob-en-bd.sql
@s-00-guarda-blob-en-archivo.sql

Prompt cargando datos binarios

begin
    carga_blob_en_bd('TMP_DIR', 'm_archivo_4.pdf', 'F_CAH_MOVIMIENTO_2',
    'COMPROBANTE', 'NUM_MOVIMIENTO', '2', 'CUENTA_ID', '1');
end;
/

Prompt mostrando el tamaño de los objetos BLOB en la Base de Datos

Prompt para F_CAH_MOVIMIENTO_2:

select CUENTA_ID, NUM_MOVIMIENTO, DBMS_LOB.GETLENGTH(COMPROBANTE) as longitud
from F_CAH_MOVIMIENTO_2;

Prompt salvando datos BLOB en directorio TMP_DIR

begin
    guarda_blob_en_archivo('TMP_DIR', 'm_export_archivo_4.pdf', 'F_CAH_MOVIMIENTO_2',
    'COMPROBANTE', 'NUM_MOVIMIENTO', '2', 'CUENTA_ID', '1');
end;
/

Prompt mostrando el contenido del directorio para validar la existencia del archivo.
!ls -l &p_pdf_path/m_export_archivo_*.pdf

------------------ Cargando datos en cahabdd_s1 ----------------------
Prompt conectando a cahabdd_s2 con usuario bancos_bdd para cargar datos binarios
connect bancos_bdd/bancos_bdd@cahabdd_s2

/*
En este sitio se cargarán los siguientes archivos.
F_CAH_CUENTA_2

CUENTA_ID  COMPROBANTE
---------- -----------
    1      m_archivo_1.pdf
    2      m_archivo_2.pdf

F_CAH_MOVIMIENTO_1

NUM_MOVIMIENTO  CUENTA_ID COMPROBANTE
-------------- ---------- -----------
1                   1     m_archivo_3.pdf

F_CAH_MOVIMIENTO_3

NUM_MOVIMIENTO  CUENTA_ID COMPROBANTE
-------------- ---------- -----------
3                   2     m_archivo_5.pdf
*/
Prompt ejecutando procedimientos para hacer import/export de datos BLOB
@s-00-carga-blob-en-bd.sql
@s-00-guarda-blob-en-archivo.sql

Prompt cargando datos binarios

begin
    carga_blob_en_bd('TMP_DIR', 'm_archivo_1.pdf', 'F_CAH_CUENTA_2',
    'CONTRATO', 'CUENTA_ID', '1', NULL, NULL);

    carga_blob_en_bd('TMP_DIR', 'm_archivo_2.pdf', 'F_CAH_CUENTA_2',
    'CONTRATO', 'CUENTA_ID', '2', NULL, NULL);

    carga_blob_en_bd('TMP_DIR', 'm_archivo_3.pdf', 'F_CAH_MOVIMIENTO_1',
    'COMPROBANTE', 'NUM_MOVIMIENTO', '1', 'CUENTA_ID', '1');

    carga_blob_en_bd('TMP_DIR', 'm_archivo_5.pdf', 'F_CAH_MOVIMIENTO_3',
    'COMPROBANTE', 'NUM_MOVIMIENTO', '3', 'CUENTA_ID', '2');
end;
/

Prompt mostrando el tamaño de los objetos BLOB en la Base de Datos

Promp para F_CAH_CUENTA_2:

select CUENTA_ID, DBMS_LOB.GETLENGTH(CONTRATO) as longitud
from F_CAH_CUENTA_2;

Prompt para F_CAH_MOVIMIENTO_1:

select CUENTA_ID, NUM_MOVIMIENTO, DBMS_LOB.GETLENGTH(COMPROBANTE) as longitud
from F_CAH_MOVIMIENTO_1;

Prompt para F_CAH_MOVIMIENTO_3:

select CUENTA_ID, NUM_MOVIMIENTO, DBMS_LOB.GETLENGTH(COMPROBANTE) as longitud
from F_CAH_MOVIMIENTO_3;

Prompt salvando datos BLOB en directorio TMP_DIR

begin
    guarda_blob_en_archivo('TMP_DIR', 'm_export_archivo_1.pdf', 'F_CAH_CUENTA_2',
    'CONTRATO', 'CUENTA_ID', '1', NULL,  NULL);

    guarda_blob_en_archivo('TMP_DIR', 'm_export_archivo_2.pdf', 'F_CAH_CUENTA_2',
    'CONTRATO', 'CUENTA_ID', '2', NULL,  NULL);

    guarda_blob_en_archivo('TMP_DIR', 'm_export_archivo_3.pdf', 'F_CAH_MOVIMIENTO_1',
    'COMPROBANTE', 'NUM_MOVIMIENTO', '1', 'CUENTA_ID', '1');

    guarda_blob_en_archivo('TMP_DIR', 'm_export_archivo_5.pdf', 'F_CAH_MOVIMIENTO_3',
    'COMPROBANTE', 'NUM_MOVIMIENTO', '3', 'CUENTA_ID', '2');
end;
/

Prompt mostrando el contenido del directorio para validar la existencia del archivo.
!ls -l &p_pdf_path/m_export_archivo_*.pdf

Prompt Listo!
disconnect
