CREATE TABLE CATEGORY(
    categoryName VARCHAR(35),
    shippingPerPound DECIMAL(4, 2), 
    offersAllowed ENUM('y', 'n'),
    CONSTRAINT categoryName_pk PRIMARY KEY (categoryName)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* ITEMS are apart of a category
    Need to add foreign key of category name
    */
CREATE TABLE ITEM(
    itemNumber INT AUTO_INCREMENT, --will become the primary key
    itemName VARCHAR(35) NOT NULL, 
    description VARCHAR(255),
    modelNumber VARCHAR(50) NOT NULL, 
    price DECIMAL(8, 2),
    categoryName VARCHAR(35), --will become the forgein key
    CONSTRAINT itemNumber_pk PRIMARY KEY (itemNumber), 
    CONSTRAINT categoryName FOREIGN KEY (categoryName) REFERENCES CATEGORY(categoryName)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE OFFER(
    offerCode VARCHAR(15), --will become the primary key
    discountAmt VARCHAR(35) NOT NULL, 
    minAmount DECIMAL(4, 2) NOT NULL, 
    expirationDate DATE NOT NULL, 
    CONSTRAINT offerCode_pk PRIMARY KEY (offerCode)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--doing the supertype subtype relations next bc they are used by a lot later on
CREATE TABLE CUSTOMER(
    customerID INT AUTO_INCREMENT, --will become the primary key
    customerName VARCHAR(50) NOT NULL, 
    address VARCHAR(150) NOT NULL, 
    email VARCHAR(80), 
    customerType ENUM('b', 'h'), --the type of customer. 'h' for home, 'b' for business
    CONSTRAINT customerID_pk PRIMARY KEY (customerID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--table is used when the value of customerType is b
CREATE TABLE BUSINESS(
    customerID INT, --will become a fk and pk
    paymentTerms VARCHAR(50) NOT NULL, 
    CONSTRAINT customerID_fk FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT customerID_pk PRIMARY KEY (customerID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--table is used whn the value of the customerType is h
CREATE TABLE HOME(
    customerID INT, --becomes a pk and an fk
    creditCardNum CHAR(16) NOT NULL, 
    cardExpiration CHAR(6) NOT NULL, 
    CONSTRAINT customerID_fk FOREIGN KEY (customerID) REFERENES CUSTOMER(customerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
    CONSTRAINT customerID_pk PRIMARY KEY (customerID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* ORDER:
    pk: orderID
    fks: offerCode --VARCHAR(15) (from OFFER) & customerID INT (from CUSTOMER)
    total cost DECIMAL (8,2)
    */
CREATE TABLE ORDERED(
    orderID INT AUTO_INCREMENT, -- becomes pk
    totalCost DECIMAL(8, 2),
    offerCode VARCHAR(15), --becomes fk
    customerID INT, --becomes fk
    CONSTRAINT offerCode_fk FOREIGN KEY (offerCode) REFERENCES OFFER(offerCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
    CONSTRAINT customerID_fk FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
    CONSTRAINT orderID_pk PRIMARY KEY (orderID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Primary key = itemNumber & orderID
    itemNumber should reference ITEM(itemNumber) -- INT -- CASCADE/CASCADE
    orderID should reference ORDERED(orderID) -- INT -- CASCADE/SET NULL
    */
CREATE TABLE LINE_ITEM(
    itemNumber INT, 
    orderID INT, 
    quantity SMALLINT, 
    shippingAmount DECIMAL(6, 2), 
    CONSTRAINT itemNumber_fk FOREIGN KEY (itemNumber) REFERNCES ITEM(itemNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
    CONSTRAINT orderID_fk FOREIGN KEY (orderID) REFERENCES ORDERED(orderID)
        ON DELETE SET NULL 
        ON UPDATE CASCADE, 
    CONSTRAINT orderNumber_pk PRIMARY KEY (itemNumber, orderID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Primary key = oderID & customerID
    orderID should reference ORDERED(orderID) -- INT -- CASCADE/CASCADE
    customerID should reference HOME(customerID) -- INT -- CASCADE/CASCADE
*/
CREATE TABLE GUARENTEE(
    orderID INT, 
    customerID INT, 
    url VARCHAR(50),
    refundAmount DECIMAL(10, 2),
    CONSTRAINT orderID_fk FOREIGN KEY (orderID) REFERENCES ORDERED(orderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT customerID_fk FOREIGN KEY (customerID) REFERENCES HOME(customerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT orderCustomer PRIMARY KEY (orderID, customerID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Primary key = contactName & customerID
    customerID should reference BUSINESS(customerID) -- INT -- CASCADE/CASCADE
    */ 
CREATE TABLE PURCHASE_CONTACT(
    contactName VARCHAR(50), 
    customerID INT, 
    contactPhone CHAR(12) NOT NULL, 
    CONSTRAINT customerID_fk FOREIGN KEY (customerID) REFERENCES BUSINESS(customerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT customerContact PRIMARY KEY (contactName, customerID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--inserting data
INSERT INTO CATEGORY(categoryName, shippingPerPound, offersAllowed) VALUES
    ('Books', 0.99, 'y'),
    ('Home', 1.99, 'y'),
    ('Jewlery', 0.99, 'n'),
    ('Toys', 0.99, 'y');

INSERT INTO ITEM(itemName, description, model, price, categoryName) VALUES
    ('Cabbage Patch Doll', 'Baby boy doll', 'Boy', 39.95, 'Toys'),
    ('The Last Lecture', 'Written by Randy Pausch', 'Hardcover', 9.95, 'Books'), 
    ('Keurig Beverage Maker', 'Keurig Platinum Beverage Maker in Red', 'Platinum Edition', 299.95, 'Home'),
    ('1ct diamond ring in white gold', 'diamond is certified vvs, D, round', '64gt32', 4000.00, 'Jewlery');

INSERT INTO OFFER(offerCode, discountAmt, minAmount, expirationDate) VALUES
    ('345743213', '20% Off', 20.00, '2013-12-31'),
    ('4567890123', '30% Off', 30.00, '2013-12-31');

--Janine's stuff
START TRANSACTION; 
-- changing Janie's informaiton to be a HOME customer
UPDATE CUSTOMER
SET customerType = 'h' -- 'h' for HOME CUSTOMER
WHERE customerName = 'Janine Jeffers';

--Adding her order
INSERT INTO ORDERED(customreName, orderTotal, offerCode) VALUES 
    ('Janine Jeffers', 4919.75, '4567890123');

--adding the line items
INSERT INTO LINE_ITEM(orderID, itemNumber, quantity, shippingAmount) VALUES
    (1, 4, 1, 0.99),
    (1, 2, 2, 3.99),
    (1, 3, 3, NULL);

COMMIT;

--John's stuff
START TRANSACTION;
--update the customer to a business
UPDATE CUSTOMER
SET customerType = 'b'
WHERE customerName = 'Joey John Barber Shop';

--inserting the order
INSERT INTO ORDERED(customerName, orderTotal, offerCode) VALUES
    ('Joey John Barber Shop', 299.95, '345743213');

--adding the line item
INSERT INTO LINE_ITEM(orderID, itemNumber, quantity) VALUES
    (2, 3, 1);

COMMIT; 
