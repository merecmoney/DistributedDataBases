# Distributed Data Bases

### Practices of Relational Distributed DataBases Course

- __Practice 1__: Given a Problem where Database has 2 nodes, create
Fragmentation Scheme for Database, define relational algebrea to
fragment each table, write Reconstruction Expressions and create
Relational Model for each node using Crow's foot notation.

#### Fragmentation Scheme

![Fragmentation Scheme](/images/P1_DDB_1.png)

#### Reconstruction Expressions

![Reconstruction Expressions](/images/P1_DDB_2.png)

#### Relational Model for Node 1 called s1

![node s1](/images/P1_N1.jpg)

#### Relational Model for Node 2 called s2

![node s2](/images/P1_N2.jpg)

Create paper where all of this is defined.

- __Practice 2__: According to Practice 1, create distributed database
defining tables, constraints, some data
and queries to retrieve information as name assign to constraints,
number of rows for each table and tables defined for each node.

Create scripts where all tables, constaints and queries are defined.

#### Tables defined for each node

Using script to create [tables](/Practice_2/s-03-CAHA-main-ddl.sql)

![Tables for each node](/images/P2_DDB_1.png)

#### Foreign References defined for each node

Using script to retrieve  [tables'](/Practice_2/s-05-CAHA-consulta-restricciones-main.sql) foreign
references , first column is child table, second is reference name and last parent table.

![Tables for each node](/images/P2_DDB_2.png)

- __Practice 3__: Impletended Local Mapping Transparency(Is when the end user or programmer must specify both the fragment names and their locations)

This requirement was achieved using database links, the DDL code to
create those links are derfined in the script
[s-02-CAHA-creacion-ligas.sql](/Practice_3/s-02-CAHA-creacion-ligas.sql).

After creating those database links, we can use them to get data
from another node's using the node's global name, in this case
there are two nodes:

- CAHABDD_S1: __cahabdd_s1.fi.unam__

- CAHABDD_S2: __cahabdd_s2.fi.unam__

For example in the script [s-03-CAHABDD_S1-consultas.sql](/Practice_3/s-03-CAHABDD_S1-consultas.sql)
and [s-03-CAHABDD_S2-consultas.sql](/Practice_3/s-03-CAHABDD_S2-consultas.sql), get data from
the other node to count the number of rows for each tables defined in the schema, where
reconstruction expression are used which were defined in *Practice_1*.

Results after running these script on each node:

For node CAHABDD_S1 after running s-03-CAHABDD_S1-consultas.sql:
![Result after running ](/images/P3_C3_1.png)

For node CAHABDD_S2 after running s-03-CAHABDD_S2-consultas.sql:
![Result after running ](/images/P3_C3_2.png)

As seen, both results are the same, the only thing that change
in both scripts are the reconstruction expressions used and
the fragments that are obtained from the other node.

Add [s-00-carga-blob-en-bd.sql](/Practice_3/s-00-carga-blob-en-bd.sql)
and [s-00-guarda-blob-en-archivo.sql](/Practice_3/s-00-guarda-blob-en-archivo.sql)
to import BLOB data to database and export BLOB data from database to a system file.
Script [s-04-prepara-carga-archivos.sql](/Practice_3/s-04-prepara-carga-archivos.sql)
is used to verify this scripts work correctly and import and export some data to
the database.

- __Practice 4__: Implemented Localization and Fragmentantion Transparency for SELECT.

The first enables to retrieve info from a fragment without specifying its location
(node where the fragment is at), just fragment's name like PAIS_2.

The second one is to retrieve info from a global entitie like if it were
a entitie on a centralized database, uses reconstruction expression
for each entitie.

For example, to retrieve all info from entitie PAIS from node CAHABDD_S1
using Local Mapping Transparency, it would be like:
```sql
    select pais_id, clave, nombre, zona_economica
        from pais_1
        union all
    select pais_id, clave, nombre, zona_economica
        from f_cah_pais_2@cahabdd_s2;
```

Result is:
![Result after running query](/images/P4_1.png)

using Localization Transparency:

```sql
    select pais_id, clave, nombre, zona_economica
        from pais_1
        union all
    select pais_id, clave, nombre, zona_economica
        from pais_2;
```

Result is:
![Result after running query](/images/P4_2.png)

using Fragmentation Transparency:

```sql
    select pais_id, clave, nombre, zona_economica
        from pais;
```

Result is:
![Result after running query](/images/P4_3.png)

As seen in each image, the result is the same, just
change the way query was written.

Fragmentantion Transparency makes querying for programmer
much easier because he shouldn't know Fragmentation Scheme
to use the Distribuited Database.