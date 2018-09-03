drop table WAREHOUSES;
drop table PRODUCTS;

create table WAREHOUSES ( WAREHOUSE_NAME VARCHAR (12), MINPRODUCT INTEGER (12), MAXPRODUCT INTEGER (12), PRIMARY KEY (WAREHOUSE_NAME));
create table PRODUCTS ( PRODUCT_NAME VARCHAR (12), TOTAL_QTY INTEGER (12), REMAINING_QTY INTEGER (12), WAREHOUSE_NAME VARCHAR (12), PRIMARY KEY (PRODUCT_NAME),
FOREIGN KEY (WAREHOUSE_NAME) REFERENCES WAREHOUSES (WAREHOUSE_NAME));

insert into WAREHOUSES values ('Plant 1', 10, 100);
insert into WAREHOUSES values ('Plant 2', 5, 50);
insert into WAREHOUSES values ('Plant 3', 7, 75);

insert into PRODUCTS values ('Coke', 100, 50, 'Plant 1');
insert into PRODUCTS values ('Sprite', 45, 3, 'Plant 2');
insert into PRODUCTS values ('Dr. Pepper', 90, 85, 'Plant 3');
insert into PRODUCTS values ('Canada Dry', 95, 50, 'Plant 2');


-- Query
-- Original ////////////
-- select PRODUCT_NAME, REMAINING_QTY, TOTAL_QTY - REMAINING_QTY as SOLD, TOTAL_QTY, WAREHOUSE_NAME from WAREHOUSES natural join PRODUCTS;
-- Formatted //////////
-- select PRODUCT_NAME as Product_Name, REMAINING_QTY as On_Stock, TOTAL_QTY - REMAINING_QTY as SOLD, TOTAL_QTY as Total, WAREHOUSE_NAME as Warehouse from WAREHOUSES natural join PRODUCTS;