-- DROP THE DATABASE IF IT EXISTS
DROP DATABASE IF EXISTS group10;
CREATE DATABASE group10;
USE group10;

-- PATIENTS TABLE
DROP TABLE IF EXISTS pomba_patient;
CREATE TABLE pomba_patient(
    patientID INT(5) AUTO_INCREMENT PRIMARY KEY,
    patientName VARCHAR(150),
    patientDOB DATE,
    patientPhone VARCHAR(13),
    patientAddress VARCHAR(255)
) AUTO_INCREMENT = 10000;

-- PROCEDURE TO INSERT PATIENT DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS insert_patient;
CREATE PROCEDURE insert_patient(
    IN Name VARCHAR(150), IN DOB DATE, IN Phone VARCHAR(13), IN Address VARCHAR(255)
)
BEGIN
    INSERT INTO pomba_patient (patientName, patientDOB, patientPhone, patientAddress) 
    VALUES (Name, DOB, Phone, Address);
END //
DELIMITER ;

-- PROCEDURE TO RETRIEVE PATIENT DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS get_patient;
CREATE PROCEDURE get_patient(IN patient_id INT(5))
BEGIN
    SELECT * FROM pomba_patient WHERE patientID = patient_id;
END //
DELIMITER ;

-- PROCEDURE TO DELETE A PATIENT
DELIMITER //
DROP PROCEDURE IF EXISTS delete_patient;
CREATE PROCEDURE delete_patient(IN patient_id INT(5))
BEGIN
    DELETE FROM pomba_patient WHERE patientID = patient_id;
END //
DELIMITER ;

-- PROCEDURE TO UPDATE PATIENT DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS update_patient;
CREATE PROCEDURE update_patient(
    IN patient_id INT(5), IN Name VARCHAR(150), IN DOB DATE, IN Phone VARCHAR(13), IN Address VARCHAR(255)
)
BEGIN
    UPDATE pomba_patient 
    SET patientName = Name, patientDOB = DOB, patientPhone = Phone, patientAddress = Address 
    WHERE patientID = patient_id;
END //
DELIMITER ;

-- DOCTORS TABLE
DROP TABLE IF EXISTS zano_doctor;
CREATE TABLE zano_doctor(
    doctorsMedicalLicense INT(5) AUTO_INCREMENT PRIMARY KEY,
    doctorsName VARCHAR(150),
    doctorsGender ENUM('M','F'),
    doctorsPhone VARCHAR(13),
    doctorsQualification VARCHAR(150)
) AUTO_INCREMENT = 20000;

-- PROCEDURE TO INSERT DOCTOR DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS insert_doctor;
CREATE PROCEDURE insert_doctor(
    IN Name VARCHAR(150), IN Gender ENUM('M','F'), IN Phone VARCHAR(13), IN Qualification VARCHAR(150)
)
BEGIN
    INSERT INTO zano_doctor (doctorsName, doctorsGender, doctorsPhone, doctorsQualification) 
    VALUES (Name, Gender, Phone, Qualification);
END //
DELIMITER ;

-- PROCEDURE TO RETRIEVE DOCTOR DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS get_doctor;
CREATE PROCEDURE get_doctor(IN doctor_id INT(5))
BEGIN
    SELECT * FROM zano_doctor WHERE doctorsMedicalLicense = doctor_id;
END //
DELIMITER ;

-- PROCEDURE TO DELETE A DOCTOR
DELIMITER //
DROP PROCEDURE IF EXISTS delete_doctor;
CREATE PROCEDURE delete_doctor(IN doctor_id INT(5))
BEGIN
    DELETE FROM zano_doctor WHERE doctorsMedicalLicense = doctor_id;
END //
DELIMITER ;

-- PROCEDURE TO UPDATE DOCTOR DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS update_doctor;
CREATE PROCEDURE update_doctor(
    IN doctor_id INT(5), IN Name VARCHAR(150), IN Gender ENUM('M', 'F'), IN Phone VARCHAR(13), IN Qualification VARCHAR(150)
)
BEGIN
    UPDATE zano_doctor 
    SET doctorsName = Name, doctorsGender = Gender, doctorsPhone = Phone, doctorsQualification = Qualification 
    WHERE doctorsMedicalLicense = doctor_id;
END //
DELIMITER ;

-- ROOMS TABLE
DROP TABLE IF EXISTS masela_room;
CREATE TABLE masela_room(
    roomNumber VARCHAR(5) PRIMARY KEY,
    bedCount INT,
    currentOccupancy INT DEFAULT 0,
    availabilityStatus ENUM('Available', 'Full', 'UnderMaintenance') DEFAULT 'Available',
    roomType ENUM('General', 'Private', 'ICU')
);

-- PROCEDURE TO INSERT ROOM DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS insert_room;
CREATE PROCEDURE insert_room(
    IN room_number VARCHAR(5), IN bed_count INT, IN room_type ENUM('General', 'Private', 'ICU')
)
BEGIN
    INSERT INTO masela_room (roomNumber, bedCount, roomType) 
    VALUES (room_number, bed_count, room_type);
END //
DELIMITER ;

-- PROCEDURE TO RETRIEVE ROOM DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS get_room;
CREATE PROCEDURE get_room(IN room_number VARCHAR(5))
BEGIN
    SELECT * FROM masela_room WHERE roomNumber = room_number;
END //
DELIMITER ;

-- PROCEDURE TO DELETE A ROOM
DELIMITER //
DROP PROCEDURE IF EXISTS delete_room;
CREATE PROCEDURE delete_room(IN room_number VARCHAR(5))
BEGIN
    DELETE FROM masela_room WHERE roomNumber = room_number;
END //
DELIMITER ;

-- PROCEDURE TO UPDATE ROOM DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS update_room;
CREATE PROCEDURE update_room(
    IN room_number VARCHAR(5), IN bed_count INT, IN availability_status ENUM('Available', 'Full', 'UnderMaintenance'), IN room_type ENUM('General', 'Private', 'ICU')
)
BEGIN
    UPDATE masela_room 
    SET bedCount = bed_count, availabilityStatus = availability_status, roomType = room_type 
    WHERE roomNumber = room_number;
END //
DELIMITER ;

-- ADMISSIONS TABLE
DROP TABLE IF EXISTS moyikwa_admission;
CREATE TABLE moyikwa_admission(
    patientID INT(5),
    doctorsID INT(5),
    roomNumber VARCHAR(5),
    severityOfCondition ENUM('Mild', 'Moderate', 'Severe', 'Critical'),
    admissionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (patientID, doctorsID),
    FOREIGN KEY (patientID) REFERENCES pomba_patient(patientID),
    FOREIGN KEY (doctorsID) REFERENCES zano_doctor(doctorsMedicalLicense),
    FOREIGN KEY (roomNumber) REFERENCES masela_room(roomNumber)
);

-- PROCEDURE TO ADMIT PATIENT
DELIMITER //
DROP PROCEDURE IF EXISTS admit_patient;
CREATE PROCEDURE admit_patient(
    IN patients INT(5), IN doctors INT(5), IN room VARCHAR(5), IN pcondition ENUM('Mild', 'Moderate', 'Severe', 'Critical')
)
BEGIN
    INSERT INTO moyikwa_admission (patientID, doctorsID, roomNumber, severityOfCondition) 
    VALUES (patients, doctors, room, pcondition);
END //
DELIMITER ;

-- PROCEDURE TO RETRIEVE ADMISSION DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS get_admission;
CREATE PROCEDURE get_admission(IN patient_id INT(5), IN doctor_id INT(5))
BEGIN
    SELECT * FROM moyikwa_admission WHERE patientID = patient_id AND doctorsID = doctor_id;
END //
DELIMITER ;

-- PROCEDURE TO DELETE AN ADMISSION
DELIMITER //
DROP PROCEDURE IF EXISTS delete_admission;
CREATE PROCEDURE delete_admission(IN patient_id INT(5), IN doctor_id INT(5))
BEGIN
    DELETE FROM moyikwa_admission WHERE patientID = patient_id AND doctorsID = doctor_id;
END //
DELIMITER ;

-- PROCEDURE TO UPDATE ADMISSION DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS update_admission;
CREATE PROCEDURE update_admission(
    IN patient_id INT(5), IN doctor_id INT(5), IN room VARCHAR(5), IN cond ENUM('Mild', 'Moderate', 'Severe', 'Critical')
)
BEGIN
    UPDATE moyikwa_admission 
    SET roomNumber = room, severityOfCondition = cond 
    WHERE patientID = patient_id AND doctorsID = doctor_id;
END //
DELIMITER ;

-- PRESCRIPTION TABLE
DROP TABLE IF EXISTS keith_prescription;
CREATE TABLE keith_prescription(
    prescriptionID INT(5) AUTO_INCREMENT PRIMARY KEY,
    patientID INT(5),
    doctorsID INT(5),
    medicationName VARCHAR(150),
    startDate DATE,
    FOREIGN KEY (patientID) REFERENCES pomba_patient(patientID),
    FOREIGN KEY (doctorsID) REFERENCES zano_doctor(doctorsMedicalLicense)
) AUTO_INCREMENT = 40000;

-- PROCEDURE TO INSERT PRESCRIPTION DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS insert_prescription;
CREATE PROCEDURE insert_prescription(
    IN patient INT(5), IN doctor INT(5), IN medication VARCHAR(150), IN date DATE
)
BEGIN
    INSERT INTO keith_prescription (patientID, doctorsID, medicationName, startDate) 
    VALUES (patient, doctor, medication, date);
END //
DELIMITER ;

-- PROCEDURE TO RETRIEVE PRESCRIPTION DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS get_prescription;
CREATE PROCEDURE get_prescription(IN prescription_id INT(5))
BEGIN
    SELECT * FROM keith_prescription WHERE prescriptionID = prescription_id;
END //
DELIMITER ;

-- PROCEDURE TO DELETE A PRESCRIPTION
DELIMITER //
DROP PROCEDURE IF EXISTS delete_prescription;
CREATE PROCEDURE delete_prescription(IN prescription_id INT(5))
BEGIN
    DELETE FROM keith_prescription WHERE prescriptionID = prescription_id;
END //
DELIMITER ;

-- PROCEDURE TO UPDATE PRESCRIPTION DETAILS
DELIMITER //
DROP PROCEDURE IF EXISTS update_prescription;
CREATE PROCEDURE update_prescription(
    IN prescription_id INT(5), IN medication VARCHAR(150), IN date DATE
)
BEGIN
    UPDATE keith_prescription 
    SET medicationName = medication, startDate = date 
    WHERE prescriptionID = prescription_id;
END //
DELIMITER ;

-- TRIGGERS TO UPDATE ROOM STATUS ON ADMISSION INSERT AND DELETE
DELIMITER //

DROP TRIGGER IF EXISTS update_room_status_on_admission_insert;
CREATE TRIGGER update_room_status_on_admission_insert
AFTER INSERT ON moyikwa_admission
FOR EACH ROW
BEGIN
    DECLARE patient_count INT;
    DECLARE room_occupancy INT;
    DECLARE room_bed_count INT;

    -- COUNT THE NUMBER OF PATIENTS ASSIGNED TO THE DOCTOR
    SELECT COUNT(*) INTO patient_count FROM moyikwa_admission WHERE doctorsID = NEW.doctorsID;

    -- CHECK IF DOCTOR HAS MORE THAN 2 PATIENTS
    IF patient_count > 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor cannot have more than 2 patients';
    END IF;

    -- GET THE NUMBER OF PEOPLE IN THE ROOM AND THE NUMBER OF BEDS
    SELECT currentOccupancy, bedCount INTO room_occupancy, room_bed_count
    FROM masela_room WHERE roomNumber = NEW.roomNumber;

    -- CHECK IF ROOM IS FULL
    IF room_occupancy + 1 > room_bed_count THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The room is full';
    END IF;

    -- UPDATE ROOM OCCUPANCY
    IF room_occupancy + 1 = room_bed_count THEN
        UPDATE masela_room SET currentOccupancy = currentOccupancy + 1, availabilityStatus = 'Full' WHERE roomNumber = NEW.roomNumber;
    ELSE
        UPDATE masela_room SET currentOccupancy = currentOccupancy + 1 WHERE roomNumber = NEW.roomNumber;
    END IF;
END //

DROP TRIGGER IF EXISTS update_room_status_on_admission_delete;
CREATE TRIGGER update_room_status_on_admission_delete
BEFORE DELETE ON moyikwa_admission
FOR EACH ROW
BEGIN
    DECLARE room_occupancy INT;
    DECLARE room_bed_count INT;

    -- GET CURRENT OCCUPANCY AND BED COUNT OF THE ROOM
    SELECT currentOccupancy, bedCount INTO room_occupancy, room_bed_count
    FROM masela_room WHERE roomNumber = OLD.roomNumber;

    -- UPDATE ROOM OCCUPANCY
    IF room_occupancy = room_bed_count THEN
        UPDATE masela_room SET currentOccupancy = currentOccupancy - 1, availabilityStatus = 'Available' WHERE roomNumber = OLD.roomNumber;
    ELSE
        UPDATE masela_room SET currentOccupancy = currentOccupancy - 1 WHERE roomNumber = OLD.roomNumber;
    END IF;
END //

DELIMITER ;

-- PROCEDURE TO CHECK ROOM AVAILABILITY
DELIMITER //
DROP PROCEDURE IF EXISTS check_room_availability;
CREATE PROCEDURE check_room_availability(IN room_number VARCHAR(5))
BEGIN
    DECLARE room_exists INT;

    -- CHECK IF THE ROOM EXISTS
    SELECT COUNT(*) INTO room_exists 
    FROM masela_room 
    WHERE roomNumber = room_number;

    IF room_exists = 0 THEN
        SELECT 'Room does not exist' AS status;
    ELSE
        SELECT availabilityStatus 
        FROM masela_room 
        WHERE roomNumber = room_number;
    END IF;
END //
DELIMITER ;

-- PROCEDURE TO CHECK DOCTOR AVAILABILITY
DELIMITER //
DROP PROCEDURE IF EXISTS check_doctor_availability;
CREATE PROCEDURE check_doctor_availability(IN doctor_id INT(5))
BEGIN
    DECLARE patient_count INT;
    DECLARE doctor_exists INT;

    -- CHECK IF THE DOCTOR EXISTS
    SELECT COUNT(*) INTO doctor_exists 
    FROM zano_doctor 
    WHERE doctorsMedicalLicense = doctor_id;

    IF doctor_exists = 0 THEN
        SELECT 'Doctor does not exist' AS status;
    ELSE
        -- COUNT THE NUMBER OF PATIENTS ASSIGNED TO THE DOCTOR
        SELECT COUNT(*) INTO patient_count 
        FROM moyikwa_admission 
        WHERE doctorsID = doctor_id;

        IF patient_count < 2 THEN
            SELECT 'Available' AS status;
        ELSE
            SELECT 'Not Available' AS status;
        END IF;
    END IF;
END //
DELIMITER ;

-- INSERT RECORDS
CALL insert_patient('John Doe', '1980-01-01', '1234567890', '123 Main St');
CALL insert_patient('Jane Smith', '2014-07-10', '1238769692', '1 cape town cbd');
CALL insert_doctor('Dr. Smith', 'M', '0987654321', 'MBBS');
CALL insert_doctor('Dr. Sally', 'F', '0687654321', 'HEART');
CALL insert_room('101', 2, 'General');
CALL insert_room('102', 4, 'ICU');
CALL admit_patient(10000, 20000, '101', 'Moderate');
CALL admit_patient(10001, 20000, '101', 'Moderate');
CALL insert_prescription(10000, 20000, 'Paracetamol', '2024-06-18');

-- RETRIEVE RECORDS
CALL get_patient(10000);
CALL get_doctor(20000);
CALL get_room('101');
CALL get_admission(10000, 20000);
CALL get_prescription(40000);

-- DELETE RECORDS
CALL delete_admission(10000, 20000);
CALL delete_prescription(40000);
CALL delete_patient(10000);
CALL delete_doctor(20000);
CALL delete_room('101');

-- UPDATE RECORDS
CALL update_patient(10000, 'John Doe Updated', '1980-01-02', '0987654321', '456 Main St');
CALL update_doctor(20000, 'Dr. John Smith', 'M', '0123456789', 'PhD');
CALL update_room('101', 3, 'UnderMaintenance', 'Private');
CALL update_admission(10000, 20000, '102', 'Severe');
CALL update_prescription(40000, 'Ibuprofen', '2024-07-01');

-- CHECK AVAILABILITY
CALL check_room_availability('101');
CALL check_doctor_availability(20000);
