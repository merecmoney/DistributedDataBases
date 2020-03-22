# Distributed Data Bases

### Practices of Relational Distributed DataBases Course

- Practice 1: Given a Problem where Database has 2 nodes, create 
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

- Practice 2: According to Practice 1, create distributed database
defining tables, constraints, some data
and queries to retrieve information as name assign to constraints,
number of rows for each table and tables defined for each node.

Create scripts where all tables, constaints and queries are defined.

#### Tables defined for each node

Using script to create [tables](https://github.com/merecmoney/DistributedDataBases/blob/master/Practice_2/s-03-CAHA-main-ddl.sql)

![Tables for each node](/images/P2_DDB_1.png)

#### Foreign References defined for each node

Using script to retrieve  [tables'](https://github.com/merecmoney/DistributedDataBases/blob/master/Practice_2/s-05-CAHA-consulta-restricciones-main.sql) foreign 
references , first column is child table, second is reference name and last parent table.

![Tables for each node](/images/P2_DDB_2.png)