--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 18/Marzo/2019
--@Descripción: Código DDL para el nodo 1

-- 
-- TABLE: F_CAH_BANCO_1 
--

CREATE TABLE F_CAH_BANCO_1(
    BANCO_ID    NUMBER(5, 0)    NOT NULL,
    CLAVE       VARCHAR2(10)    NOT NULL,
    NOMBRE      VARCHAR2(40)    NOT NULL,
    CONSTRAINT F_CAH_BANCO_1_PK PRIMARY KEY (BANCO_ID)
);

-- 
-- TABLE: F_CAH_CUENTA_1 
--

CREATE TABLE F_CAH_CUENTA_1(
    CUENTA_ID    NUMBER(10, 0)    NOT NULL,
    NIP          NUMBER(4, 0)     NOT NULL,
    SALDO        NUMBER(18, 2)    NOT NULL,
    CONSTRAINT F_CAH_CUENTA_1_PK PRIMARY KEY (CUENTA_ID)
);

-- 
-- TABLE: F_CAH_SUCURSAL_1 
--

CREATE TABLE F_CAH_SUCURSAL_1(
    SUCURSAL_ID     NUMBER(10, 0)    NOT NULL,
    NUM_SUCURSAL    NUMBER(3, 0)     NOT NULL,
    BANCO_ID        NUMBER(5, 0)     NOT NULL,
    PAIS_ID         NUMBER(4, 0)     NOT NULL,
    GERENTE_ID      NUMBER(10, 0)    NOT NULL,
    CONSTRAINT F_CAH_SUCURSAL_1_PK PRIMARY KEY (SUCURSAL_ID), 
    CONSTRAINT F_CAH_SUCURSAL_1_BANCO_ID_FK FOREIGN KEY (BANCO_ID)
    REFERENCES F_CAH_BANCO_1(BANCO_ID)
);



-- 
-- TABLE: F_CAH_CUENTA_3
--

CREATE TABLE F_CAH_CUENTA_3(
    CUENTA_ID      NUMBER(10, 0)    NOT NULL,
    NUM_CUENTA     VARCHAR2(18)     NOT NULL,
    TIPO_CUENTA    CHAR(1)          NOT NULL,
    SUCURSAL_ID    NUMBER(10, 0)    NOT NULL,
    CONSTRAINT F_CAH_CUENTA_3_PK PRIMARY KEY (CUENTA_ID), 
    CONSTRAINT F_CAH_CUENTA_3_SUCURSAL_ID_FK FOREIGN KEY (SUCURSAL_ID)
    REFERENCES F_CAH_SUCURSAL_1(SUCURSAL_ID)
);



-- 
-- TABLE: F_CAH_EMPLEADO_1 
--

CREATE TABLE F_CAH_EMPLEADO_1(
    EMPLEADO_ID            NUMBER(10, 0)    NOT NULL,
    NOMBRE                 VARCHAR2(40)     NOT NULL,
    AP_PATERNO             VARCHAR2(40)     NOT NULL,
    AP_MATERNO             VARCHAR2(40)     NOT NULL,
    FOLIO_CERTIFICACION    VARCHAR2(10),
    JEFE_ID                NUMBER(10, 0),
    CONSTRAINT F_CAH_EMPLEADO_1_PK PRIMARY KEY (EMPLEADO_ID)
);



-- 
-- TABLE: F_CAH_MOVIMIENTO_2 
--

CREATE TABLE F_CAH_MOVIMIENTO_2(
    NUM_MOVIMIENTO      NUMBER(10, 0)     NOT NULL,
    CUENTA_ID           NUMBER(10, 0)     NOT NULL,
    FECHA_MOVIMIENTO    DATE              NOT NULL,
    TIPO_MOVIMIENTO     CHAR(1)           NOT NULL,
    IMPORTE             NUMBER(18, 2)     NOT NULL,
    DESCRIPCION         VARCHAR2(2000)    NOT NULL,
    COMPROBANTE         BLOB,
    CONSTRAINT F_CAH_MOVIMIENTO_2_PK PRIMARY KEY (NUM_MOVIMIENTO, CUENTA_ID), 
    CONSTRAINT F_MOVIMIENTO_2_CUENTA_ID_FK FOREIGN KEY (CUENTA_ID)
    REFERENCES F_CAH_CUENTA_3(CUENTA_ID)
);

-- 
-- TABLE: F_CAH_PAIS_1 
--

CREATE TABLE F_CAH_PAIS_1(
    PAIS_ID           NUMBER(4, 0)     NOT NULL,
    CLAVE             VARCHAR2(5)      NOT NULL,
    NOMBRE            VARCHAR2(100)    NOT NULL,
    ZONA_ECONOMICA    CHAR(1)          NOT NULL,
    CONSTRAINT F_CAH_PAIS_1_PK PRIMARY KEY (PAIS_ID)
);


commit;