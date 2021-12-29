create database if not exists `order-directory` ;

use `order-directory`;

create table if not exists `supplier`(
	`SUPP_ID` int primary key,
    `SUPP_NAME` varchar(50) ,
	`SUPP_CITY` varchar(50),
	`SUPP_PHONE` varchar(10)
);

create table if not exists `customer` (
	`CUS_ID` int not null,
	`CUS_NAME` varchar(20) null default null,
	`CUS_PHONE` varchar(10),
	`CUS_CITY` varchar(30) ,
	`CUS_GENDER` CHAR,
	primary key (`CUS_ID`)
);


create table if not exists `category` (
	`CAT_ID` int not null,
	`CAT_NAME` varchar(20) null default null,
	primary key (`CAT_ID`)
);


create table if not exists `product` (
	`PRO_ID` int not null,
	`PRO_NAME` varchar(20) null default null,
	`PRO_DESC` varchar(60) null default null,
	`CAT_ID` int not null,
	primary key (`PRO_ID`),
	foreign key (`CAT_ID`) references category(`CAT_ID`)
);


create table if not exists `product_details` (
	`PROD_ID` int not null,
	`PRO_ID` int not null,
	`SUPP_ID` int not null,
	`PROD_PRICE` int not null,
	primary key (`PROD_ID`),
	foreign key (`PRO_ID`) references product(`PRO_ID`),
	foreign key (`SUPP_ID`) references supplier(`SUPP_ID`)
);


create table if not exists `order` (
  `ORD_ID` int not null,
  `ORD_AMOUNT` int not null,
  `ORD_DATE` date,
  `CUS_ID` int not null,
  `PROD_ID` int not null,
  primary key (`ORD_ID`),
  foreign key (`CUS_ID`) references customer(`CUS_ID`),
  foreign key (`PROD_ID`) references product_details(`PROD_ID`)
);


create table if not exists `rating` (
	`RAT_ID` int not null,
	`CUS_ID` int not null,
	`SUPP_ID` int not null,
	`RAT_RATSTARS` int not null,
	primary key (`RAT_ID`),
	foreign key (`SUPP_ID`) references supplier(`SUPP_ID`),
	foreign key (`CUS_ID`) references customer(`CUS_ID`)
  );
  
  
insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');

insert into `CUSTOMER` values(1,"AAKASH",'9999999999',"DELHI",'M');
insert into `CUSTOMER` values(2,"AMAN",'9785463215',"NOIDA",'M');
insert into `CUSTOMER` values(3,"NEHA",'9999999999',"MUMBAI",'F');
insert into `CUSTOMER` values(4,"MEGHA",'9994562399',"KOLKATA",'F');
insert into `CUSTOMER` values(5,"PULKIT",'7895999999',"LUCKNOW",'M');

insert into `CATEGORY` values(1,"BOOKS");
insert into `CATEGORY` values(2,"GAMES");
insert into `CATEGORY` values(3,"GROCERIES");
insert into `CATEGORY` values(4,"ELECTRONICS");
insert into `CATEGORY` values(5,"CLOTHES");

insert into `PRODUCT` values(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
insert into `PRODUCT` values(2,"TSHIRT","DFDFJDFJDKFD",5);
insert into `PRODUCT` values(3,"ROG LAPTOP","DFNTTNTNTERND",4);
insert into `PRODUCT` values(4,"OATS","REURENTBTOTH",3);
insert into `PRODUCT` values(5,"HARRY POTTER","NBEMCTHTJTH",1);

insert into `PRODUCT_DETAILS` values(1,1,2,1500);
insert into `PRODUCT_DETAILS` values(2,3,5,30000);
insert into `PRODUCT_DETAILS` values(3,5,1,3000);
insert into `PRODUCT_DETAILS` values(4,2,3,2500);
insert into `PRODUCT_DETAILS` values(5,4,1,1000);

insert into `ORDER` values (50,2000,"2021-10-06",2,1);
insert into `ORDER` values(20,1500,"2021-10-12",3,5);
insert into `ORDER` values(25,30500,"2021-09-16",5,2);
insert into `ORDER` values(26,2000,"2021-10-05",1,1);
insert into `ORDER` values(30,3500,"2021-08-16",4,3);

insert into `RATING` values(1,2,2,4);
insert into `RATING` values(2,3,4,3);
insert into `RATING` values(3,5,1,5);
insert into `RATING` values(4,1,3,2);
insert into `RATING` values(5,4,5,4);


-- 3. Display the number of the customers, grouped by their genders, who have placed any order of amount greater than or equal to Rs. 3000.
select customer.cus_gender, count(customer.cus_gender) as count
from customer inner join `order` on customer.cus_id = `order`.cus_id
where `order`.ord_amount >= 3000
group by customer.cus_gender;

-- 4. Display all the order along with product name ordered by a customer having Customer_Id=2;
select `order`.*, product.pro_name
from `order`, product_details, product
where `order`.cus_id = 2 and `order`.prod_id = product_details.prod_id and product_details.prod_id = product.pro_id;  
  
-- 5. Display the Supplier details who can supply more than one product.
select supplier.*
from supplier
	where supplier.supp_id in (
		select product_details.supp_id
        from product_details
        group by product_details.supp_id
        having count(product_details.supp_id) > 1
	);
    
-- 6. Find the category of the product whose order amount is minimum.
select category.*, sum(`order`.ord_amount) as sum_ord_amount
from `order`, product_details, product, category
    where `order`.prod_id = product_details.prod_id and product.pro_id = product_details.pro_id and category.cat_id = product.cat_id
group by category.cat_id
order by sum_ord_amount limit 1;

-- 7. Display the Id and Name of the Product ordered after "2021-10-05".
select product.pro_id, product.pro_name, `order`.ord_date
from
	`order`
    inner join product_details on product_details.prod_id = `order`.prod_id
    inner join product on product.pro_id = product_details.pro_id
    where `order`.ord_date > "2021-10-05";
    
-- 8. Print the top 3 supplier name and id and rating on the basis of their rating along with the customer name who has given the rating.	
select supplier.supp_id, supplier.supp_name, customer.cus_name, rating.rat_ratstars
from
	rating
    inner join supplier on rating.supp_id = supplier.supp_id
    inner join customer on rating.cus_id = customer.cus_id
    order by rating.rat_ratstars desc limit 3;
    
-- 9. Display customer name and gender whose names start or end with character 'A'.
select customer.cus_name, customer.cus_gender
from customer
where customer.cus_name like 'A%' or customer.cus_name like '%A';

-- 10. Display the total order amount of the male customers.
select sum(`order`.ord_amount) as Amount
from `order` inner join customer on `order`.cus_id = customer.cus_id
where customer.cus_gender = 'M';

-- 11. Display all the Customers left outer join with  the orders.
select *
from customer left outer join `order` on customer.cus_id = `order`.cus_id; 


-- 12. Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like 
-- 	   if rating > 4 then "Genuine Supplier" if rating > 2 "Average Supplier" else "Supplier should not be considered".
DELIMITER //
CREATE PROCEDURE Categorize_Supplier()
BEGIN
	Select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
		CASE
			 WHEN rating.rat_ratstars > 4 THEN 'Genuine Supplier'
			 WHEN rating.rat_ratstars > 2 THEN 'Average Supplier'
			 ELSE 'Supplier should not be considered'
		END AS verdict
	from rating inner join supplier on rating.supp_id=supplier.supp_id;
END //
DELIMITER ;

CALL Categorize_Supplier();
  
  
  
  
  

