CREATE TABLE Products_P(
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price INT
);

INSERT INTO Products_P VALUES('P101','Laptop','Electronics',800);
INSERT INTO Products_P VALUES('P102','Mouse','Accessories',25);
INSERT INTO Products_P VALUES('P103','Keyboard','Accessories',800);

----------------------------------------------------------------------
-- STEP 2 : CREATE CUSTOMERS TABLE
----------------------------------------------------------------------

CREATE TABLE Customers_P(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    email VARCHAR(50)
);

INSERT INTO Customers_P VALUES
(101,'John Smith','London','john@email.com');

INSERT INTO Customers_P VALUES
(102,'Emma Brown','Manchester','emma@email.com');

INSERT INTO Customers_P VALUES
(103,'David Lee','Birmingham','david@email.com');

----------------------------------------------------------------------
-- STEP 3 : CREATE EMPLOYEES TABLE
----------------------------------------------------------------------

CREATE TABLE Employees_PP(
    employee_id VARCHAR(50) PRIMARY KEY,
    employee_name VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO Employees_PP VALUES('E01','Alice','North');
INSERT INTO Employees_PP VALUES('E02','Bob','South');

----------------------------------------------------------------------
-- STEP 4 : CREATE ORDERS TABLE
----------------------------------------------------------------------

CREATE TABLE Orders_P(
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id INT,
    employee_id VARCHAR(50),
    order_date DATE,

    FOREIGN KEY(customer_id)
    REFERENCES Customers_P(customer_id),

    FOREIGN KEY(employee_id)
    REFERENCES Employees_PP(employee_id)
);

INSERT INTO Orders_P VALUES
('O1001',101,'E01',DATE '2025-01-10');

INSERT INTO Orders_P VALUES
('O1002',102,'E02',DATE '2025-02-10');

----------------------------------------------------------------------
-- STEP 5 : CREATE ORDER ITEMS TABLE
----------------------------------------------------------------------

CREATE TABLE Order_Item_P(
    order_item_id INT PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,

    FOREIGN KEY(order_id)
    REFERENCES Orders_P(order_id),

    FOREIGN KEY(product_id)
    REFERENCES Products_P(product_id)
);

INSERT INTO Order_Item_P VALUES
(1,'O1001','P101',10);

INSERT INTO Order_Item_P VALUES
(2,'O1001','P102',20);

INSERT INTO Order_Item_P VALUES
(3,'O1002','P103',30);

INSERT INTO Order_Item_P VALUES
(4,'O1002','P103',20);

----------------------------------------------------------------------
-- BUSINESS QUESTION 1
-- Which Product Sold the Most?
----------------------------------------------------------------------

SELECT
    P.product_name,
    SUM(O_I.quantity) AS Total_Units_Sold
FROM Products_P P
JOIN Order_Item_P O_I
ON P.product_id = O_I.product_id
GROUP BY P.product_name
ORDER BY Total_Units_Sold DESC;

----------------------------------------------------------------------
-- BUSINESS QUESTION 2
-- Which Product Generated the Most Revenue?
----------------------------------------------------------------------

SELECT
    P.product_name,
    SUM(P.price * O_I.quantity) AS Total_Revenue
FROM Products_P P
JOIN Order_Item_P O_I
ON P.product_id = O_I.product_id
GROUP BY P.product_name
ORDER BY Total_Revenue DESC;

----------------------------------------------------------------------
-- BUSINESS QUESTION 3
-- Which Customer Generated the Highest Revenue?
----------------------------------------------------------------------

SELECT
    C.customer_id,
    C.customer_name,
    SUM(P.price * O_I.quantity) AS Total_Revenue_By_Customer
FROM Customers_P C
JOIN Orders_P O
ON C.customer_id = O.customer_id
JOIN Order_Item_P O_I
ON O.order_id = O_I.order_id
JOIN Products_P P
ON P.product_id = O_I.product_id
GROUP BY
    C.customer_id,
    C.customer_name
ORDER BY Total_Revenue_By_Customer DESC;

----------------------------------------------------------------------
-- BUSINESS QUESTION 4
-- Which City Performs Best?
----------------------------------------------------------------------

SELECT
    C.city,
    SUM(P.price * O_I.quantity) AS Total_Revenue_By_City
FROM Customers_P C
JOIN Orders_P O
ON C.customer_id = O.customer_id
JOIN Order_Item_P O_I
ON O.order_id = O_I.order_id
JOIN Products_P P
ON P.product_id = O_I.product_id
GROUP BY C.city
ORDER BY Total_Revenue_By_City DESC;

----------------------------------------------------------------------
-- BUSINESS QUESTION 5
-- Monthly Sales Trends
----------------------------------------------------------------------

SELECT
    TO_CHAR(O.order_date,'Month') AS Month,
    SUM(P.price * O_I.quantity) AS Total_Revenue_In_Month
FROM Orders_P O
JOIN Order_Item_P O_I
ON O.order_id = O_I.order_id
JOIN Products_P P
ON P.product_id = O_I.product_id
GROUP BY
    TO_CHAR(O.order_date,'Month'),
    TO_CHAR(O.order_date,'MM')
ORDER BY
    TO_CHAR(O.order_date,'MM');

------------------------- Employee Performance -----------------------------

SELECT E.employee_name, SUM(P.price * O_I.quantity) AS Total_Revenue_By_Employee FROM Employees_PP E
JOIN Orders_P O ON E.employee_id=O.employee_id
JOIN Order_Item_P O_I ON O.order_id = O_I.order_id
JOIN Products_P P ON P.product_id = O_I.product_id
GROUP BY E.employee_name;

------------------------- Category-wise revenue -----------------------------

SELECT P.category, SUM(P.price * O_I.quantity) AS Total_Revenue_By_category FROM Products_P P
JOIN Order_Item_P O_I ON P.product_id = O_I.product_id
GROUP BY P.category;

------------------------- Customer-purchasing behaviour -----------------------------

SELECT C.customer_name, COUNT(O.order_id) AS Total_orders FROM Customers_P C
LEFT JOIN Orders_P O ON C.customer_id=O.customer_id
GROUP BY C.customer_name;

