-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`AIRPORT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AIRPORT` (
  `Airport_code` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NULL,
  `State` VARCHAR(45) NULL,
  `Name` VARCHAR(45) NULL,
  PRIMARY KEY (`Airport_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AIRPLANE_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AIRPLANE_TYPE` (
  `Airplane_type_name` VARCHAR(45) NOT NULL,
  `Max_seats` VARCHAR(45) NULL CHECK (`Max_seats` <= 600),
  `Company` VARCHAR(45) NULL,
  PRIMARY KEY (`Airplane_type_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AIRPLANE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AIRPLANE` (
  `Total_number_of_seats` VARCHAR(45) NULL,
  `Airplane_id` VARCHAR(45) NOT NULL,
  `Airplane_type_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Airplane_id`),
  INDEX `fk_AIRPLANE_AIRPLANE_TYPE1_idx` (`Airplane_type_name` ASC) VISIBLE,
  CONSTRAINT `fk_AIRPLANE_AIRPLANE_TYPE1`
    FOREIGN KEY (`Airplane_type_name`)
    REFERENCES `mydb`.`AIRPLANE_TYPE` (`Airplane_type_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FLIGHT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FLIGHT` (
  `Flight_number` VARCHAR(45) NOT NULL,
  `Airline` VARCHAR(45) NULL,
  `Weekdays` VARCHAR(45) NULL,
  PRIMARY KEY (`Flight_number`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FLIGHT_LEG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FLIGHT_LEG` (
  `Leg_number` VARCHAR(45) NOT NULL CHECK (`Leg_number` <= 4),
  `Scheduled_departure_time` TIME NULL,
  `Scheduled_arrival_time` TIME NULL,
  `Departure_airport_code` VARCHAR(45) NOT NULL,
  `Arrival_airport_code` VARCHAR(45) NOT NULL,
  `Flight_number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Leg_number`, `Flight_number`),
  INDEX `fk_FLIGHT_LEG_AIRPORT1_idx` (`Departure_airport_code` ASC) VISIBLE,
  INDEX `fk_FLIGHT_LEG_AIRPORT2_idx` (`Arrival_airport_code` ASC) VISIBLE,
  INDEX `fk_FLIGHT_LEG_FLIGHT1_idx` (`Flight_number` ASC) VISIBLE,
  CONSTRAINT `fk_FLIGHT_LEG_AIRPORT1`
    FOREIGN KEY (`Departure_airport_code`)
    REFERENCES `mydb`.`AIRPORT` (`Airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FLIGHT_LEG_AIRPORT2`
    FOREIGN KEY (`Arrival_airport_code`)
    REFERENCES `mydb`.`AIRPORT` (`Airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FLIGHT_LEG_FLIGHT1`
    FOREIGN KEY (`Flight_number`)
    REFERENCES `mydb`.`FLIGHT` (`Flight_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LEG_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LEG_INSTANCE` (
  `Number_of_available_seats` VARCHAR(45) NULL,
  `Date` DATE NOT NULL,
  `Departure_time` TIME NULL,
  `Arrival_time` TIME NULL,
  `Airplane_id` VARCHAR(45) NOT NULL,
  `Leg_number` VARCHAR(45) NOT NULL,
  `Flight_Number` VARCHAR(45) NOT NULL,
  `Departure_airport_code` VARCHAR(45) NULL,
  `Arrival_airport_code` VARCHAR(45) NULL,
  PRIMARY KEY (`Date`, `Leg_number`, `Flight_Number`),
  INDEX `fk_LEG_INSTANCE_AIRPLANE1_idx` (`Airplane_id` ASC) VISIBLE,
  INDEX `fk_LEG_INSTANCE_FLIGHT_LEG1_idx` (`Leg_number` ASC, `Flight_Number` ASC) VISIBLE,
  INDEX `fk_LEG_INSTANCE_AIRPORT1_idx` (`Departure_airport_code` ASC) VISIBLE,
  INDEX `fk_LEG_INSTANCE_AIRPORT2_idx` (`Arrival_airport_code` ASC) VISIBLE,
  CONSTRAINT `fk_LEG_INSTANCE_AIRPLANE1`
    FOREIGN KEY (`Airplane_id`)
    REFERENCES `mydb`.`AIRPLANE` (`Airplane_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LEG_INSTANCE_FLIGHT_LEG1`
    FOREIGN KEY (`Leg_number` , `Flight_Number`)
    REFERENCES `mydb`.`FLIGHT_LEG` (`Leg_number` , `Flight_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LEG_INSTANCE_AIRPORT1`
    FOREIGN KEY (`Departure_airport_code`)
    REFERENCES `mydb`.`AIRPORT` (`Airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LEG_INSTANCE_AIRPORT2`
    FOREIGN KEY (`Arrival_airport_code`)
    REFERENCES `mydb`.`AIRPORT` (`Airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SEAT_RESERVATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SEAT_RESERVATION` (
  `Customer_name` VARCHAR(45) NULL,
  `Customer_phone` VARCHAR(45) NULL,
  `SEAT_number` VARCHAR(45) NOT NULL,
  `Date` DATE NOT NULL,
  `Leg_number` VARCHAR(45) NOT NULL,
  `Flight_number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`SEAT_number`, `Date`, `Leg_number`, `Flight_number`),
  INDEX `fk_SEAT_LEG_INSTANCE1_idx` (`Date` ASC, `Leg_number` ASC, `Flight_number` ASC) VISIBLE,
  CONSTRAINT `fk_SEAT_LEG_INSTANCE1`
    FOREIGN KEY (`Date` , `Leg_number` , `Flight_number`)
    REFERENCES `mydb`.`LEG_INSTANCE` (`Date` , `Leg_number` , `Flight_Number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FARE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FARE` (
  `Restrictions` VARCHAR(45) NULL,
  `Amount` VARCHAR(45) NULL CHECK ((`AMOUNT` >= 0) AND (`AMOUNT` <= 10000)),
  `Fare_code` VARCHAR(45) NOT NULL,
  `Flight_number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Fare_code`, `Flight_number`),
  INDEX `fk_FARE_FLIGHT1_idx` (`Flight_number` ASC) VISIBLE,
  CONSTRAINT `fk_FARE_FLIGHT1`
    FOREIGN KEY (`Flight_number`)
    REFERENCES `mydb`.`FLIGHT` (`Flight_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CAN_LAND`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CAN_LAND` (
  `Airport_code` VARCHAR(45) NOT NULL,
  `Airplane_type_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Airport_code`, `Airplane_type_name`),
  INDEX `fk_AIRPORT_has_AIRPLANE_TYPE_AIRPLANE_TYPE1_idx` (`Airplane_type_name` ASC) VISIBLE,
  INDEX `fk_AIRPORT_has_AIRPLANE_TYPE_AIRPORT_idx` (`Airport_code` ASC) VISIBLE,
  CONSTRAINT `fk_AIRPORT_has_AIRPLANE_TYPE_AIRPORT`
    FOREIGN KEY (`Airport_code`)
    REFERENCES `mydb`.`AIRPORT` (`Airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AIRPORT_has_AIRPLANE_TYPE_AIRPLANE_TYPE1`
    FOREIGN KEY (`Airplane_type_name`)
    REFERENCES `mydb`.`AIRPLANE_TYPE` (`Airplane_type_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
