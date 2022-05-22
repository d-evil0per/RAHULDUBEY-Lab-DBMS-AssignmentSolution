create table supplier (
SUPP_ID int NOT NULL auto_increment,
SUPP_NAME varchar(50) NOT NULL,
SUPP_CITY varchar(50) NOT NULL,
SUPP_PHONE varchar(50) NOT NULL,
primary key(SUPP_ID)
);


create table customer (
CUS_ID int NOT NULL auto_increment,
CUS_NAME varchar(20) NOT NULL,
CUS_PHONE varchar(10) NOT NULL,
CUS_CITY varchar(30) NOT NULL,
CUS_GENDER CHAR(1) ,
primary key(CUS_ID)
);

create table category (
CAT_ID int NOT NULL auto_increment,
CAT_NAME varchar(20) NOT NULL,
primary key(CAT_ID)
);

create table product (
PRO_ID int NOT NULL auto_increment,
PRO_NAME varchar(20) NOT NULL Default "Dummy",
PRO_DESC varchar(60),
CAT_ID int,
primary key(PRO_ID),
foreign key(CAT_ID) references category(CAT_ID)
);

create table supplier_pricing (
PRICING_ID int NOT NULL auto_increment,
PRO_ID int,
SUPP_ID int,
SUPP_PRICE int Default 0,
primary key(PRICING_ID),
foreign key(PRO_ID) references product(PRO_ID),
foreign key(SUPP_ID) references supplier(SUPP_ID)
);

create table orders (
ORD_ID int NOT NULL auto_increment,
ORD_AMOUNT int NOT NULL,
ORD_DATE Date NOT NULL,
CUS_ID int,
PRICING_ID int,
primary key(ORD_ID),
foreign key(CUS_ID) references customer(CUS_ID),
foreign key(PRICING_ID) references supplier_pricing(PRICING_ID)
);

create table rating (
RAT_ID int NOT NULL auto_increment,
RAT_RATSTARS int NOT NULL,
ORD_ID int,
primary key(RAT_ID),
foreign key(ORD_ID) references orders(ORD_ID)
);