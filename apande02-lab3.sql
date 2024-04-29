-- BAKERY-1
UPDATE goods 
SET Price = Price - 2
WHERE Food = 'Cake' AND (Flavor = 'Lemon' OR Flavor = 'Napoleon');

-- BAKERY-2
UPDATE goods
SET Price = Price * 1.15
WHERE Price < 5.95 AND (Flavor = 'Apricot' OR Flavor = 'Chocolate');

-- BAKERY-3
CREATE TABLE payments(
    Receipt int NOT NULL,
    Amount decimal(19,2) NOT NULL,
    PaymentSettled DATETIME NOT NULL,
    PaymentType varchar(20) NOT NULL ,
    FOREIGN KEY reciept_fk (Receipt) REFERENCES receipts(RNumber),
    PRIMARY KEY (Receipt, Amount)
);

-- BAKERY-4
CREATE TRIGGER sunday_sales_check BEFORE INSERT on items
FOR EACH ROW
    BEGIN
        DECLARE type_of_item_sold varchar(100);
        DECLARE flavor_of_item_sold varchar(100);
        DECLARE date_of_sale DATE;
        SELECT Food INTO type_of_item_sold FROM goods WHERE GId = NEW.Item;
        SELECT Flavor INTO flavor_of_item_sold FROM goods WHERE GId = NEW.Item;
        SELECT SaleDate INTO date_of_sale FROM receipts WHERE RNumber = NEW.Receipt;
        
        IF ((DAYOFWEEK(date_of_sale) = 1 OR DAYOFWEEK(date_of_sale) = 7) AND (type_of_item_sold = 'Meringue' OR flavor_of_item_sold = 'Almond')) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot sell this item on sundays';
        
        END IF;
    END;

-- AIRLINES-1
CREATE TRIGGER source_destination_check BEFORE INSERT on flights
FOR EACH ROW
    BEGIN
        if (NEW.SourceAirport = NEW.DestAirport) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Source and Destination Airport Must not be the same';
        END IF;
    END;

-- AIRLINES-2
ALTER TABLE airlines ADD Partner varchar(100);

CREATE TRIGGER add_partnership BEFORE UPDATE on airlines
FOR EACH ROW
    BEGIN
        DECLARE partner_abbr varchar(100);
        SELECT Partner INTO partner_abbr FROM airlines WHERE Abbreviation = NEW.Partner;
        if (NEW.Partner = NEW.Abbreviation) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Partner and airline abbrivation must not be the same';
        elseif (partner_abbr != NEW.Abbreviation) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Partner cannot be the same airline';
        END IF;
    END;
    
CREATE TRIGGER insert_airline BEFORE INSERT on airlines
FOR EACH ROW
    BEGIN
        DECLARE airline_exists varchar(100);
        SELECT Abbreviation INTO airline_exists FROM airlines WHERE Abbreviation = NEW.Partner;
        if (NEW.Partner = NEW.Abbreviation OR (airline_exists IS NULL AND NEW.Partner is NOT NULL)) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error adding Partner';
        END IF;
    END;

UPDATE airlines
SET Partner = 'Southwest'
WHERE Airline = 'JetBlue Airways';

UPDATE airlines
SET Partner = 'JetBlue'
WHERE Airline = 'Southwest Airlines';

-- KATZENJAMMER-1
UPDATE Instruments 
SET Instrument = 'awesome bass balalaika'
WHERE Instrument = 'bass balalaika';

UPDATE Instruments 
SET Instrument = 'acoustic guitar'
WHERE Instrument = 'guitar';

-- KATZENJAMMER-2
DELETE FROM Vocals
WHERE Bandmate != 1 OR `Type` = 'lead';