create database if not exists e_commerce;
use e_commerce;

-- Q1 - You are required to create tables for supplier,customer,category,product,productDetails,order,rating to store the data for the E-commerce with the schema definition given below.
CREATE TABLE IF NOT EXISTS `supplier` (
    `SUPP_ID` INT PRIMARY KEY,
    `SUPP_NAME` VARCHAR(50),
    `SUPP_CITY` VARCHAR(50),
    `SUPP_PHONE` VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS `customer` (
    `CUS_ID` INT NOT NULL,
    `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
    `CUS_PHONE` VARCHAR(10),
    `CUS_CITY` VARCHAR(30),
    `CUS_GENDER` CHAR,
    PRIMARY KEY (`CUS_ID`)
);

CREATE TABLE IF NOT EXISTS `category` (
    `CAT_ID` INT NOT NULL,
    `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (`CAT_ID`)
);

CREATE TABLE IF NOT EXISTS `product` (
    `PRO_ID` INT NOT NULL,
    `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
    `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
    `CAT_ID` INT NOT NULL,
    PRIMARY KEY (`PRO_ID`),
    FOREIGN KEY (`CAT_ID`)
        REFERENCES category (`CAT_ID`)
);

CREATE TABLE IF NOT EXISTS `product_details` (
    `PROD_ID` INT NOT NULL,
    `PRO_ID` INT NOT NULL,
    `SUPP_ID` INT NOT NULL,
    `PROD_PRICE` INT NOT NULL,
    PRIMARY KEY (`PROD_ID`),
    FOREIGN KEY (`PRO_ID`)
        REFERENCES product (`PRO_ID`),
    FOREIGN KEY (`SUPP_ID`)
        REFERENCES supplier (`SUPP_ID`)
);

CREATE TABLE IF NOT EXISTS `order` (
    `ORD_ID` INT NOT NULL,
    `ORD_AMOUNT` INT NOT NULL,
    `ORD_DATE` DATE,
    `CUS_ID` INT NOT NULL,
    `PROD_ID` INT NOT NULL,
    PRIMARY KEY (`ORD_ID`),
    FOREIGN KEY (`CUS_ID`)
        REFERENCES customer (`CUS_ID`),
    FOREIGN KEY (`PROD_ID`)
        REFERENCES product_details (`PROD_ID`)
);

CREATE TABLE IF NOT EXISTS `rating` (
    `RAT_ID` INT NOT NULL,
    `CUS_ID` INT NOT NULL,
    `SUPP_ID` INT NOT NULL,
    `RAT_RATSTARS` INT NOT NULL,
    PRIMARY KEY (`RAT_ID`),
    FOREIGN KEY (`SUPP_ID`)
        REFERENCES supplier (`SUPP_ID`),
    FOREIGN KEY (`CUS_ID`)
        REFERENCES customer (`CUS_ID`)
);

-- Q2 - Insert the following data in the table created above
INSERT INTO `supplier` VALUES(1,"Rajesh Retails","Delhi",'1234567890');
INSERT INTO `supplier` VALUES(2,"Appario Ltd.","Mumbai",'2589631470');
INSERT INTO `supplier` VALUES(3,"Knome products","Banglore",'9785462315');
INSERT INTO `supplier` VALUES(4,"Bansal Retails","Kochi",'8975463285');
INSERT INTO `supplier` VALUES(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO `customer` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `customer` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `customer` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `customer` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `customer` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO `category` VALUES( 1,"BOOKS");
INSERT INTO `category` VALUES(2,"GAMES");
INSERT INTO `category` VALUES(3,"GROCERIES");
INSERT INTO `category` VALUES(4,"ELECTRONICS");
INSERT INTO `category` VALUES(5,"CLOTHES");

INSERT INTO `product` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `product` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `product` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `product` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `product` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

INSERT INTO `product_details` VALUES(1,1,2,1500);
INSERT INTO `product_details` VALUES(2,3,5,30000);
INSERT INTO `product_details` VALUES(3,5,1,3000);
INSERT INTO `product_details` VALUES(4,2,3,2500);
INSERT INTO `product_details` VALUES(5,4,1,1000);

INSERT INTO `order` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `order` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `order` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `order` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `order` VALUES(30,3500,"2021-08-16",4,3);

INSERT INTO `rating` VALUES(1,2,2,4);
INSERT INTO `rating` VALUES(2,3,4,3);
INSERT INTO `rating` VALUES(3,5,1,5);
INSERT INTO `rating` VALUES(4,1,3,2);
INSERT INTO `rating` VALUES(5,4,5,4);

-- Q3 - Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
SELECT c.cus_gender, COUNT(o.ord_id) AS Count FROM `order` o INNER JOIN `customer` c ON o.cus_id = c.cus_id WHERE o.ord_amount > 3000 GROUP BY c.cus_gender;

-- Q4 - Display all the orders along with the product name ordered by a customer having Customer_Id=2.
SELECT o.*, p.pro_name FROM `order` o, product_details prod, product p WHERE o.cus_id = 1 AND o.prod_id = prod.prod_id AND prod.pro_id = p.pro_id;
        
-- Q5 - Display the Supplier details who can supply more than one product.
SELECT * FROM supplier s WHERE s.supp_id IN 
(SELECT supp_id FROM product_details GROUP BY supp_id HAVING COUNT(supp_id) > 1);

-- Q6 - Find the category of the product whose order amount is minimum.
SELECT c.* FROM `order` o INNER JOIN product_details prod ON o.prod_id = prod.prod_id INNER JOIN product p ON p.pro_id = prod.pro_id INNER JOIN category c ON c.cat_id = p.cat_id WHERE o.ORD_AMOUNT = (SELECT MIN(ORD_AMOUNT) FROM `order`);
            
-- Q7 - Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT p.pro_id, p.pro_name FROM `order` o INNER JOIN `product_details` prod ON o.prod_id = prod.prod_id INNER JOIN product p ON p.pro_id = prod.pro_id WHERE o.ORD_DATE > '2021-10-05';
    

-- Q8 - Display customer name and gender whose names start or end with character 'A'.
SELECT * FROM customer c WHERE c.cus_name LIKE 'A%' OR c.cus_name LIKE '%A';

-- Q9 - Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
DELIMITER //
CREATE PROCEDURE `supplierRatings` ()
BEGIN
select s.supp_id, s.supp_name, r.rat_ratstars,
case
when r.rat_ratstars > 4 then 'Genuine supplier'
when r.rat_ratstars > 2 then 'Average'
else 'Not okay'
end as verdict from rating r inner join supplier s on s.supp_id = r.supp_id;
END //
DELIMITER ;