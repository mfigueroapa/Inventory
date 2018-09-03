////// API INVENTORY

const express = require('express')
const app = express()
const mysql = require('mysql')
const morgan = require('morgan')
const bodyParser = require('body-parser')

app.use(morgan('short'))//Informacion en consola
app.use(bodyParser.urlencoded({extended: true})) //middleware para procesar la peticion de manera mas facil

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "naranjas",
  database: "Inventory"
});

/// ------------------------------ //
// SELECT PRODUCTS
// ------------------------------ //
app.get('/products', (req, res) => {
  console.log("Select products...")

  con.query(
    "select PRODUCT_NAME as Product_Name, TOTAL_QTY as Total_Qty, REMAINING_QTY as Remaining_Qty, WAREHOUSE_NAME as Warehouse_Name from Products;",
     (err, rows, fields) => {
    console.log("Products fetched successfully.")
    res.json(rows)
  })
})

/// ------------------------------ //
// SELECT WAREHOUSES
// ------------------------------ //
app.get('/warehouses', (req, res) => {
  console.log("Select warehouses.")

  con.query(
    "Select WAREHOUSE_NAME as Warehouse_name, MINPRODUCT as Min_Product, MAXPRODUCT as Max_Product from WAREHOUSES;",
     (err, rows, fields) => {
    console.log("Warehouses fetched successfully.")
    res.json(rows)
  })
})
/// ------------------------------ //
// SELECT INVENTORY
// ------------------------------ //
app.get('/inventory', (req, res) => {
  console.log("Select inventory")

  con.query(
    "select PRODUCT_NAME as Product_Name, REMAINING_QTY as On_Stock,TOTAL_QTY - REMAINING_QTY as Sold, TOTAL_QTY as Total, WAREHOUSE_NAME as Warehouse, MINPRODUCT as MinProduct, MAXPRODUCT as MaxProduct from WAREHOUSES natural join PRODUCTS;",
     (err, rows, fields) => {
    console.log("Inventory fetched successfully.")
    res.json(rows)
  })
})

// ------------------------------ //
// ADD PRODUCTS
// ------------------------------ //
app.post('/create_product', (req, res) => {

  console.log(req.body)
  res.send(200, {message: "Data received"})

  const product_name = req.body.product_name
  const total_qty = req.body.total_qty
  const remaining_qty = req.body.remaining_qty
  const warehouse_name = req.body.warehouse

  console.log("----------------------------Trying to create product--------------------");
  console.log(product_name)
  console.log(total_qty)
  console.log(remaining_qty)
  console.log(warehouse_name)
  //Insert a record in the "PRODUCTS" table:
  var sql =
  "INSERT INTO PRODUCTS (PRODUCT_NAME, TOTAL_QTY, REMAINING_QTY, WAREHOUSE_NAME) VALUES ('"+product_name+"', '"+total_qty+"', '"+remaining_qty+"', '"+warehouse_name+"')";
  con.query(sql, function (err, result) {
    if (err) throw err;
    console.log("1 record inserted");
    });
})

// ------------------------------ //
// DELETE PRODUCT
// ------------------------------ //
app.post('/delete_product', (req, res) => {

  console.log(req.body)
  res.send(200, {message: "Data received"})

  const product_name = req.body.product_name

  //Delete the record with the given product name
  var sql =
  "DELETE FROM PRODUCTS WHERE PRODUCT_NAME = '"+product_name+"';"
  con.query(sql, function (err, result) {
    if (err) throw err;
    console.log("Record with given name deleted!");
    });
})

// ------------------------------ //
// UPDATE PRODUCT INFO
// ------------------------------ //
app.post('/update_product_info', (req, res) => { //No se puede modificar el nombre, unicamente la informacion de un producto

  console.log(req.body)
  res.send(200, {message: "Data received"})
  const product_name = req.body.product_name
  const newTotal_Qty = req.body.newTotal_Qty
  const newRemaining_Qty = req.body.newRemaining_Qty
  const newWarehouse_Name = req.body.newWarehouse_Name

  var sql =
  "UPDATE PRODUCTS SET TOTAL_QTY = '"+newTotal_Qty+"', REMAINING_QTY = '"+newRemaining_Qty+"', WAREHOUSE_NAME = '"+newWarehouse_Name+"'  WHERE PRODUCT_NAME = '"+product_name+"';"
  con.query(sql, function (err, result) {
    if (err) throw err;
    console.log("Record with given name updated!");
    });
})

// ------------------------------ //
// ADD WAREHOUSES
// ------------------------------ //
app.post('/create_warehouse', (req, res) => {

  console.log(req.body)
  res.send(200, {message: "Data received"})

  const warehouse_name = req.body.warehouse_name
  const minproduct = req.body.minproduct
  const maxproduct = req.body.maxproduct

  console.log("----------------------------Trying to create warehouse--------------------");
  console.log(warehouse_name)
  console.log(minproduct)
  console.log(maxproduct)
  //Insert a record in the "WAREHOUSES" table:
  var sql =
  "INSERT INTO WAREHOUSES (WAREHOUSE_NAME, MINPRODUCT, MAXPRODUCT) VALUES ('"+warehouse_name+"', '"+minproduct+"', '"+maxproduct+"')";
  con.query(sql, function (err, result) {
    if (err) throw err;
    console.log("1 record inserted");
    });
})

// ------------------------------ //
// DELETE WAREHOUSE
// ------------------------------ //
app.post('/delete_warehouse', (req, res) => {

  console.log(req.body)
  res.send(200, {message: "Data received"})

  const warehouse_name = req.body.warehouse_name

  //Delete the record with the given warehouse
  var sql =
  "DELETE FROM WAREHOUSES WHERE WAREHOUSE_NAME = '"+warehouse_name+"';"
  con.query(sql, function (err, result) {
    if (err) throw err;
    console.log("Record with given name deleted!");
    });
})

// ------------------------------ //
// UPDATE PRODUCT INFO
// ------------------------------ //
app.post('/update_warehouse_info', (req, res) => { //No se puede modificar el nombre, unicamente la informacion de un producto

  console.log(req.body)
  res.send(200, {message: "Data received"})
  const warehouse_name = req.body.warehouse_name
  const minproduct = req.body.minproduct
  const maxproduct = req.body.maxproduct

  var sql =
  "UPDATE WAREHOUSES SET MINPRODUCT = '"+minproduct+"', MAXPRODUCT = '"+maxproduct+"' WHERE WAREHOUSE_NAME = '"+warehouse_name+"';"
  con.query(sql, function (err, result) {
    if (err) throw err;
    console.log("Record with given name updated!");
    });
})

app.listen(3001, () => {
  console.log("Server is UP and listeinig on port 3001!")
})
