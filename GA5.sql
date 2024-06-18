-- Drop the database if it exists
DROP DATABASE IF EXISTS group102;
CREATE DATABASE group102;
USE group102;

-- Patients Table
DROP TABLE IF EXISTS patient;
CREATE TABLE patient(
    patientID INT(5) AUTO_INCREMENT PRIMARY KEY,
    patientName VARCHAR(150),
    patientDOB DATE,
    patientPhone VARCHAR(13),
    patientAddress VARCHAR(255)
)
AUTO_INCREMENT = 10000;

-- Procedure to insert patient details
DELIMITER //
DROP PROCEDURE IF EXISTS insert_patient;
CREATE PROCEDURE insert_patient(
    IN Name VARCHAR(150),
    IN DOB DATE,
    IN Phone VARCHAR(13),
    IN Address VARCHAR(255)
)
BEGIN
    INSERT INTO patient (patientName, patientDOB, patientPhone, patientAddress) 
    VALUES (Name, DOB, Phone, Address);
END //
DELIMITER ;

-- Doctors Table
DROP TABLE IF EXISTS doctor;
CREATE TABLE doctor(
    doctorsMedicalLicense INT(5) AUTO_INCREMENT PRIMARY KEY,
    doctorsName VARCHAR(150),
    doctorsGender ENUM('M','F'),
    doctorsPhone VARCHAR(13),
    doctorsQualification VARCHAR(150)
)
AUTO_INCREMENT = 20000;

-- Procedure to insert doctor details
DELIMITER //
DROP PROCEDURE IF EXISTS insert_doctor;
CREATE PROCEDURE insert_doctor(
    IN Name VARCHAR(150),
    IN Gender ENUM('M','F'),
    IN Phone VARCHAR(13),
    IN Qualification VARCHAR(150)
)
BEGIN
    INSERT INTO doctor (doctorsName, doctorsGender, doctorsPhone, doctorsQualification) 
    VALUES (Name, Gender, Phone, Qualification);
END //
DELIMITER ;

-- Rooms Table
DROP TABLE IF EXISTS room;
CREATE TABLE room(
    roomNumber VARCHAR(5) PRIMARY KEY,
    bedCount INT,
    currentOccupancy INT DEFAULT 0,
    availabilityStatus ENUM('Available', 'Full', 'UnderMaintenance') DEFAULT 'Available',
    roomType ENUM('General', 'Private', 'ICU')
);

-- Procedure to insert room details
DELIMITER //
DROP PROCEDURE IF EXISTS insert_room;
CREATE PROCEDURE insert_room(
    IN room_number VARCHAR(5),
    IN bed_count INT,
    IN room_type ENUM('General', 'Private', 'ICU')
)
BEGIN
    INSERT INTO room (roomNumber, bedCount, roomType) 
    VALUES (room_number, bed_count, room_type);
END //
DELIMITER ;

-- Admissions Table
DROP TABLE IF EXISTS admission;
CREATE TABLE admission(
    patientID INT(5),
    doctorsID INT(5),
    roomNumber VARCHAR(5),
    severityOfCondition ENUM('Mild', 'Moderate', 'Severe', 'Critical'),
    admissionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (patientID, doctorsID),
    FOREIGN KEY (patientID) REFERENCES patient(patientID),
    FOREIGN KEY (doctorsID) REFERENCES doctor(doctorsMedicalLicense),
    FOREIGN KEY (roomNumber) REFERENCES room(roomNumber)
);

-- Procedure to admit patient
DELIMITER //
DROP PROCEDURE IF EXISTS admit_patient;
CREATE PROCEDURE admit_patient(
    IN patients INT(5),
    IN doctors INT(5),
    IN room VARCHAR(5),
    IN pcondition ENUM('Mild', 'Moderate', 'Severe', 'Critical')
)
BEGIN
    INSERT INTO admission (patientID, doctorsID, roomNumber, severityOfCondition) 
    VALUES (patients, doctors, room, pcondition);
END //
DELIMITER ;

-- Prescription Table
DROP TABLE IF EXISTS prescription;
CREATE TABLE prescription(
    prescriptionID INT(5) AUTO_INCREMENT PRIMARY KEY,
    patientID INT(5),
    doctorsID INT(5),
    medicationName VARCHAR(150),
    startDate DATE,
    FOREIGN KEY (patientID) REFERENCES patient(patientID),
    FOREIGN KEY (doctorsID) REFERENCES doctor(doctorsMedicalLicense)
)
AUTO_INCREMENT = 40000;

-- Procedure to insert prescription details
DELIMITER //
DROP PROCEDURE IF EXISTS insert_prescription;
CREATE PROCEDURE insert_prescription(
    IN patient INT(5),
    IN doctor INT(5),
    IN medication VARCHAR(150),
    IN date DATE
)
BEGIN
    INSERT INTO prescription (patientID, doctorsID, medicationName, startDate) 
    VALUES (patient, doctor, medication, date);
END //
DELIMITER ;

-- Triggers to update room status on admission insert and delete
DELIMITER //

DROP TRIGGER IF EXISTS update_room_status_on_admission_insert//
CREATE TRIGGER update_room_status_on_admission_insert
AFTER INSERT ON admission
FOR EACH ROW
BEGIN
    DECLARE patient_count INT;
    DECLARE room_occupancy INT;
    DECLARE room_bed_count INT;
    
    -- Count the number of patients assigned to the doctor
    SELECT COUNT(*) INTO patient_count FROM admission WHERE doctorsID = NEW.doctorsID;
    
    -- Check if doctor has more than 2 patients
    IF patient_count > 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor cannot have more than 2 patients';
    END IF;
    
    -- Get the number of people in the room and the number of beds
    SELECT currentOccupancy, bedCount INTO room_occupancy, room_bed_count
    FROM room WHERE roomNumber = NEW.roomNumber;

    -- Check if room is full
    IF room_occupancy + 1 > room_bed_count THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The room is full';
    END IF;
    
    -- Update room occupancy
    IF room_occupancy + 1 = room_bed_count THEN
        UPDATE room SET currentOccupancy = currentOccupancy + 1, availabilityStatus = 'Full' WHERE roomNumber = NEW.roomNumber;
    ELSE
        UPDATE room SET currentOccupancy = currentOccupancy + 1 WHERE roomNumber = NEW.roomNumber;
    END IF;
END //

DROP TRIGGER IF EXISTS update_room_status_on_admission_delete//
CREATE TRIGGER update_room_status_on_admission_delete
BEFORE DELETE ON admission
FOR EACH ROW
BEGIN
    DECLARE room_occupancy INT;
    DECLARE room_bed_count INT;
    
    -- Get current occupancy and bed count of the room
    SELECT currentOccupancy, bedCount INTO room_occupancy, room_bed_count
    FROM room WHERE roomNumber = OLD.roomNumber;
    
    -- Update room occupancy
    IF room_occupancy = room_bed_count THEN
        UPDATE room SET currentOccupancy = currentOccupancy - 1, availabilityStatus = 'Available' WHERE roomNumber = OLD.roomNumber;
    ELSE
        UPDATE room SET currentOccupancy = currentOccupancy - 1 WHERE roomNumber = OLD.roomNumber;
    END IF;
END //

DELIMITER ;

