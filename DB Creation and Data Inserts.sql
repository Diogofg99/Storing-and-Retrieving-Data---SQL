-- MySQL Workbench Forward Engineering

/* NOTE/ DISCLAIMER: When opening the scripts right after re-starting MySQL Workbench, an error may appear, or when running the queries
the exercises' output may be blank. This is solved simply by dropping the schema, re-running this script and everything should work fine.
This issue only happens when creating the schema right after opening the Workbench.*/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema surf_shop
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema surf_shop
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `surf_shop` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `surf_shop` ;

-- -----------------------------------------------------
-- Table `surf_shop`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`categories` (
  `category_id` INT NOT NULL,
  `category_name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(1000) NOT NULL,
  PRIMARY KEY (`category_id`),
  INDEX `category_id` USING BTREE (`category_id`) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`country` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(50) NOT NULL,
  `tax_rate` DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (`country_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`city` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(50) NOT NULL,
  `country_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `country_id_foreign` (`country_id` ASC) VISIBLE,
  CONSTRAINT `country_id_foreign`
    FOREIGN KEY (`country_id`)
    REFERENCES `surf_shop`.`country` (`country_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`clients` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `address` VARCHAR(100) NULL DEFAULT NULL,
  `age` INT NULL DEFAULT NULL,
  `spending_category` VARCHAR(45) NULL DEFAULT NULL,
  `city_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `client_id` USING BTREE (`client_id`) VISIBLE,
  INDEX `clients_city_foreign` (`city_id` ASC) VISIBLE,
  CONSTRAINT `clients_city_foreign`
    FOREIGN KEY (`city_id`)
    REFERENCES `surf_shop`.`city` (`city_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 60684
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`log_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`log_products` (
  `id_log_products` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `unit_price_old` DECIMAL(10,2) NOT NULL,
  `unit_price_new` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_log_products`),
  UNIQUE INDEX `id_log_products_UNIQUE` (`id_log_products` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`products` (
  `product_id` INT NOT NULL,
  `product_name` VARCHAR(100) NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `descriptions` VARCHAR(1000) NOT NULL,
  `stock` INT NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `product_id` USING BTREE (`product_id`) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`product_rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`product_rating` (
  `rating_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `rating` INT NOT NULL,
  PRIMARY KEY (`rating_id`),
  INDEX `rating_product_foreign` (`product_id` ASC) VISIBLE,
  CONSTRAINT `product_rating_ibfk_1`
    FOREIGN KEY (`product_id`)
    REFERENCES `surf_shop`.`products` (`product_id`),
  CONSTRAINT `rating_product_foreign`
    FOREIGN KEY (`product_id`)
    REFERENCES `surf_shop`.`products` (`product_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`products_categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`products_categories` (
  `product_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `products_categories_id_foreign` (`category_id` ASC) VISIBLE,
  CONSTRAINT `products__id_foreign`
    FOREIGN KEY (`product_id`)
    REFERENCES `surf_shop`.`products` (`product_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `products_categories_id_foreign`
    FOREIGN KEY (`category_id`)
    REFERENCES `surf_shop`.`categories` (`category_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`purchase`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`purchase` (
  `purchase_id` INT NOT NULL,
  `client_id` INT DEFAULT NULL,
  `purchase_value` DECIMAL(10,2) NOT NULL,
  `purchase_date` VARCHAR(15) NOT NULL,
  `purchase_status` ENUM('Shipped', 'Complete') NOT NULL,
  `date_max_payment` VARCHAR(15) NOT NULL,
  `city_id` INT NOT NULL,
  PRIMARY KEY (`purchase_id`),
  INDEX `client_id_idx` (`client_id` ASC) VISIBLE,
  INDEX `city_id_idx` (`city_id` ASC) VISIBLE,
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `surf_shop`.`clients` (`client_id`)
    ON DELETE CASCADE,
  CONSTRAINT `city_id`
    FOREIGN KEY (`city_id`)
    REFERENCES `surf_shop`.`city` (`city_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `surf_shop`.`purchase_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `surf_shop`.`purchase_details` (
  `purchased_products_id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `purchase_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `discount` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`purchased_products_id`),
  INDEX `purchase_id` (`purchase_id` ASC) VISIBLE,
  INDEX `product_id` (`product_id` ASC) VISIBLE,
  CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `surf_shop`.`products` (`product_id`)
    ON DELETE CASCADE,
  CONSTRAINT `purchase_id`
    FOREIGN KEY (`purchase_id`)
    REFERENCES `surf_shop`.`purchase` (`purchase_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 49
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `surf_shop`;

DELIMITER $$
USE `surf_shop`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `surf_shop`.`price_update`
AFTER UPDATE ON `surf_shop`.`products`
FOR EACH ROW
BEGIN
    IF OLD.unit_price <> new.unit_price THEN
        INSERT INTO log_products(id_log_products, product_id, unit_price_old, unit_price_new)
        VALUES(OLD.product_id, OLD.unit_price, NEW.unit_price);
    END IF;
END$$

USE `surf_shop`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `surf_shop`.`purchase_details_AFTER_INSERT`
AFTER INSERT ON `surf_shop`.`purchase_details`
FOR EACH ROW
BEGIN
UPDATE products
SET products.stock = Products.stock - New.quantity 
WHERE products.product_id = New.product_id ;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- ---------------------------------------------------------------------------------------------------------------------
/* This portion of the script refers to question F, insertion of extra data with purchase information.  */ 
-- ---------------------------------------------------------------------------------------------------------------------

USE `surf_shop` ;

INSERT INTO clients(client_id,name,age,address,city_id)
VALUES 
(60650,"Haley",50,"1627 Ut, Avenue",6),(60651,"Scarlet",57,"488-6854 Adipiscing St.",4),(60652,"Kessie",73,"7535 Molestie St.",2),
(60653,"Eden",38,"P.O. Box 252, 8682 Quis St.",2),(60654,"Michael",68,"5362 Diam. Avenue",3),(60655,"Rowan",46,"8617 Semper Rd.",2),
(60656,"Kylan",35,"P.O. Box 955, 7560 Porta Street",1),(60657,"Marvin",45,"P.O. Box 905, 4136 Lectus St.",2),
(60658,"Uriah",22,"994-1618 Proin St.",6),(60659,"Oren",43,"P.O. Box 826, 3599 Luctus Ave",3),
(60660,"Dane",71,"890-3786 Eu St.",3),(60661,"Drew",38,"8391 Lacus. Ave",4),(60662,"Grant",30,"P.O. Box 626, 6647 Eget, Road",6),
(60663,"Rowan",24,"984-8535 Neque Street",4), (60664,"Kylie",53,"680 Scelerisque Ave",5),(60665,"Ira",40,"P.O. Box 822, 2594 Nam Rd.",3),
(60666,"Josephine",53,"Ap #666-5731 Ornare Av.",2), (60667,"Anika",36,"Ap #244-587 Integer St.",2),(60668,"Priscilla",39,"3443 Fusce Rd.",1),
(60669,"Wynne",69,"P.O. Box 685, 6697 Magnis St.",2), (60670,"Marah",56,"Ap #263-4772 Ac Ave",1),
(60671,"Maris",69,"P.O. Box 835, 676 Mauris. Avenue",1),(60672,"Tate",62,"294-9890 Nisl. Rd.",6), (60673,"Geraldine",30,"183-1898 Dui, Street",3),
(60674,"Dillon",18,"930-2144 Nullam Avenue",1),(60675,"Chava",33,"5906 Proin Street",1),(60676,"Tad",27,"330-7729 Ullamcorper Ave",4),
(60677,"Hope",71,"P.O. Box 566, 5057 Bibendum Road",1),(60678,"Quincy",51,"7926 Justo. Rd.",2),
(60679,"Travis",70,"P.O. Box 877, 2674 Pharetra. St.",2), (60680,"Ramona",71,"634-7056 Aliquet Ave",6),
(60681,"Vernon",52,"761-8201 Ut, Av.",2),(60682,"Rina",20,"256-4299 Curae; St.",3),(60683,"Colton",48,"175-4748 Velit Street",3);

INSERT INTO categories
VALUES (1, "Clothing", "T-Shirts, Jeans, Sweatshirts, Hoodies, Shoes"),
(2, "Surfing Gear", "Surfing equipment and clothing"),
(3, "Beach-Wear", "Beach equipment, accessories and clothing"),
(4, "Accessories", "Sunglasses, general fashion accessories"); 


INSERT INTO products
VALUES (1,"White Logo T-Shirt",21.99,"Brand logo cotton T-Shirt.",238),
(2,"Black Jean Pants",59.99,"Regular fit denim jeans in black",294),
(3,"Kaki Shorts",34.99,"Kaki Shorts for a comfortable summer fit",125),
(4,"Surf Board",169.99,"Specially hand-made surf Boards",138),
(5,"Board Wax",3.99,"Wax for proper board riding, sliding and grip.",200),
(6,"Reversible Hat",24.99,"Branded hat that can be reversed",146),
(7,"Low-Top Sneakers",78.99,"Sneakers with low ankle top for skating",125),
(8,"Wool Jacket",69.99,"Jacket fully made of naturally grown wool",195),
(9,"Camouflage Brown Sweatsuit",99.99,"Millitary inspired sweatsuit for comfort",300),
(10,"Standard T-Shirt",19.99,"Regular cotton T-Shirt in Multi-Colors",422),
(11,"Blue Denim Washed Jeans",49.99,"Tapered Jeans with washed effect",169),
(12,"Flower Dress",19.99,"Summer dress with flower pattern",138),
(13,"Jean Jacket",68.99,"Jacket made fully of denim", 123),
(14,"High-Top Sneakers",89.99,"Sneakers with high ankle top for skating", 100),
(15,"Surf Suit",94.99,"Regular Surf Suit", 109),
(16,"Bodyboard Board",49.99,"Specially hand-made bodyboard Boards", 89),
(17,"Bodyboard Suit",39.99,"Regular bodyboard suit", 260),
(18,"Black Oversized Hoodie",29.99,"Cotton heavyweight black hoodie",120),
(19,"Cotton-blend Shorts",24.99,"Comfortable cotton shorts",215),
(20,"Swimsuit",19.99,"Summer beach swimsuit", 70),
(21,"Beach Shorts",24.99,"Male beach shorts", 80),
(22,"Bikini",24.99,"Female bikini", 90),
(23,"Cotton Socks",9.99,"Regular cotton socks with flower embroidery", 102),
(24,"Red Chunky Sneaker",49.99,"Thick sole red sneaker", 104),
(25,"Underwear",14.99,"Regular underwear", 150),
(26,"Corduroy Hat",24.99,"Classic snapback cap with corduroy crown", 133),
(27,"Beige Regular Pants",49.99,"Wool-Denim washed faded blend with Beige dyeing", 124),
(28,"Slim Fit White Shirt",29.99,"Tight fitted regular white buttoned-up shirt", 177),
(29,"Colored Crewneck",29.99,"Cotton heavyweight colorful sweatshirt", 170),
(30,"Winter Hoodie",34.99,"Thick wool-cotton blend hoodie", 180),
(31,"Beach Towel",19.99,"Regular beach towel", 149),
(32,"Summer Light Jacket",39.99,"Breatheable summer jacket", 77),
(33,"Sunglasses",69.99,"UV Protection certified sunglasses", 97),
(34,"Patented Leather Wallet",44.99,"Bison leather wallet", 106),
(35,"Small Diamond Keychain",349.99,"Diamond encrusted very small irrelevant opulent keychain", 80);


INSERT INTO products_categories
VALUES (1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 2),
(16, 2),
(17, 2),
(18, 1),
(19, 1),
(20, 3),
(21, 3),
(22, 3),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 3),
(32, 1),
(33, 4),
(34, 4),
(35, 4);

INSERT INTO purchase
VALUES (1,60650,224.91,DATE("2018-05-04"),"Complete","2018-05-09",6),
(2,60651,929.85,DATE("2018-05-16"),"Complete","2018-05-21",4),
(3,60652,449.92,DATE("2018-03-01"),"Complete","2018-03-06",2),
(5,60654,399.89,DATE("2019-06-09"),"Complete","2019-06-14",3),
(6,60655,339.93,DATE("2018-09-11"),"Complete","2018-09-16",2),
(7,60656,1634.75,DATE("2018-12-27"),"Complete","2019-01-01",1),
(8,60657,74.97,DATE("2018-01-26"),"Complete","2018-01-31",2),
(9,60658,2449.93,DATE("2019-03-25"),"Complete","2019-03-30",6),
(11,60660,789.84,DATE("2018-06-17"),"Complete","2018-06-22",3),
(12,60661,149.95,DATE("2019-05-01"),"Complete","2019-05-06",4),
(14,60663,179.94,DATE("2019-02-18"),"Complete","2019-02-23",4),
(15,60664,259.9,DATE("2018-07-09"),"Complete","2018-07-14",5),
(36,60679,999.9,DATE("2018-06-04"),"Complete","2018-06-09",2),
(37,60673,999.88,DATE("2019-02-11"),"Complete","2019-02-16",3),
(38,60665,139.96,DATE("2019-11-30"),"Complete","2019-12-05",3),
(40,60654,478.95,DATE("2019-05-19"),"Complete","2019-05-24",3),
(41,60681,434.87,DATE("2019-07-23"),"Complete","2019-07-28",2),
(42,60680,2609.57,DATE("2019-03-22"),"Complete","2019-03-27",6),
(43,60659,199.91,DATE("2018-01-30"),"Complete","2018-02-04",3),
(44,60682,249.95,DATE("2019-08-30"),"Complete","2019-09-04",3),
(45,60671,404.82,DATE("2018-04-17"),"Complete","2018-04-22",1),
(46,60674,249.9,DATE("2019-02-10"),"Complete","2019-02-15",1),
(47,60675,583.8,DATE("2018-10-21"),"Complete","2018-10-26",1),
(50,60656,315.96,DATE("2019-04-14"),"Complete","2019-04-19",1),
(81,60658,69.98,DATE("2020-12-13"),"Shipped","2020-12-18",6),
(82,60659,34.99,DATE("2020-12-14"),"Shipped","2020-12-19",3),
(83,60660,244.93,DATE("2020-12-15"),"Shipped","2020-12-20",3),
(84,60661,39.98,DATE("2020-12-20"),"Shipped","2020-12-25",4),
(85,60662,9.99,DATE("2020-12-23"),"Shipped","2020-12-28",6);

INSERT INTO purchase_details(purchase_id, product_id, quantity, discount)
VALUES 
(47,1,12,0),
(37,16,2,0),
(6,31,3,0),
(37,14,10,0),
(11,8,11,0),
(42,15,15,0),
(12,28,5,0),
(42,28,6,0),
(2,14,9,0),
(2,12,6,0.2),
(45,10,9,0),
(42,30,5,0),
(5,31,5,0),
(1,19,9,0),
(7,18,3,0),
(36,9,10,0),
(7,11,11,0),
(3,2,7,0),
(15,32,3,0),
(44,24,5,0),
(45,6,9,0),
(3,28,1,0),
(38,30,4,0),
(14,29,6,0),
(46,26,10,0),
(40,9,4,0),
(41,32,2,0),
(8,19,3,0),
(43,31,7,0),
(41,20,2,0),
(11,5,5,0),
(7,15,1,0),
(7,14,10,0),
(41,30,9,0),
(6,33,4,0),
(81,30,2,0),
(82,30,1,0),
(83,30,7,0),
(84,31,2,0),
(85,23,1,0),
(5,24,6,0),
(47,32,8,0),
(15,20,7,0),
(50,7,4,0),
(40,7,1,0),
(43,18,2,0),
(9,35,7,0.15),
(42,33,8,0);

INSERT INTO country (country_id, country_name, tax_rate)
VALUES
(1, 'Portugal',0.23),
(2, 'China',0.13),
(3, 'Spain',0.21),
(4, 'Italy',0.22),
(5, 'Germany',0.19)
;

INSERT INTO city
VALUES
(1, 'Lisboa',1),
(6, 'Ericeira',1),
(2, 'Guangzhou',2),
(3, 'Barcelona',3),
(4, 'Palermo',4),
(5, 'Dresden',5);

INSERT INTO product_rating (`rating_id`,`product_id`,`rating`) VALUES (1,11,2),(51,27,8),(101,31,5),(201,26,9),(251,23,9),(301,33,8),(351,5,6),(401,13,2),(451,27,1);
INSERT INTO product_rating (`rating_id`,`product_id`,`rating`) VALUES (501,31,10),(551,7,9),(601,25,10),(701,5,4),(751,31,2),(801,25,5),(851,1,8);
INSERT INTO product_rating (`rating_id`,`product_id`,`rating`) VALUES (1001,31,5),(1051,19,5),(1101,25,4),(1151,29,7),(1201,28,1),(1301,31,10),(1401,2,9),(1451,21,3);
INSERT INTO product_rating (`rating_id`,`product_id`,`rating`) VALUES (1501,14,2),(1551,19,10),(1601,14,2),(1651,9,2),(1701,16,8),(1751,17,8),(1801,12,5),(1901,25,2),(1951,28,2);
INSERT INTO product_rating (`rating_id`,`product_id`,`rating`) VALUES (2001,11,7),(2051,25,2),(2101,26,3),(2151,29,9),(2201,29,3),(2301,11,6),(2351,7,4);

