DROP TABLE IF EXISTS medical_supplies_management ;
DROP TABLE IF EXISTS medical_records ;
DROP TABLE IF EXISTS billings ;
DROP TABLE IF EXISTS room_reservation ;
DROP TABLE IF EXISTS room ;
DROP TABLE IF EXISTS medical_supplies ;
DROP TABLE IF EXISTS appointment ;
DROP TABLE IF EXISTS department_management ;
DROP TABLE IF EXISTS department ;
DROP TABLE IF EXISTS doctor ;
DROP TABLE IF EXISTS staff ;
DROP TABLE IF EXISTS patient ;
DROP TABLE IF EXISTS users ;


-- Drop ENUM types if they exist
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'gender_enum') THEN
        EXECUTE 'DROP TYPE gender_enum CASCADE';
    END IF;
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'room_enum') THEN
        EXECUTE 'DROP TYPE room_enum CASCADE';
    END IF;
END $$;



-- Create ENUM types
CREATE TYPE gender_enum AS ENUM ('Male', 'Female');
CREATE TYPE room_enum AS ENUM ('ICU', 'General', 'Private');

-- Create tables
-- Parent table with common user information
CREATE TABLE users (
    uid SERIAL PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(50)
);

-- Child table for patients with additional patient-specific information
CREATE TABLE patient (
    uid INT PRIMARY KEY,
    EmergencyContact VARCHAR(50),
    DateOfBirth DATE,
    gender gender_enum,
    address VARCHAR(200),
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);

-- Child table for staff (or employees) with additional staff-specific information
CREATE TABLE staff (
    uid INT PRIMARY KEY,
    role VARCHAR(100),
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);

-- Child table for doctors with additional doctor-specific information
CREATE TABLE doctor (
    uid INT PRIMARY KEY,
    Specialization VARCHAR(100),
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);

CREATE TABLE department (
    departmentId SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE department_management (
    departmentId INT,
    uid INT,
    PRIMARY KEY (departmentId, uid),
    FOREIGN KEY (uid) REFERENCES users(uid),
    FOREIGN KEY (departmentId) REFERENCES department(departmentId)
);

CREATE TABLE appointment (
    appointmentId SERIAL PRIMARY KEY,
    AppointmentDate DATE,
    AppointmentTime TIME,
    ReasonForVisit TEXT,
    patientId INT,
    doctorId INT,
    FOREIGN KEY (patientId) REFERENCES patient(uid),
    FOREIGN KEY (doctorId) REFERENCES doctor(uid)
);

CREATE TABLE medical_supplies (
    suppliesId SERIAL PRIMARY KEY,
    SupplyName TEXT,
    Quantity INT,
    Supplier VARCHAR(100),
    PurchaseDate DATE,
    ExpiryDate DATE
);

CREATE TABLE medical_supplies_management (
    management_id SERIAL PRIMARY KEY,
    suppliesId INT,
    staffId INT,
    FOREIGN KEY (suppliesId) REFERENCES medical_supplies(suppliesId),
    FOREIGN KEY (staffId) REFERENCES staff(uid)
);

CREATE TABLE room (
    RoomNumber INT primary key,
    RoomType room_enum,
    AvailabilityStatus BOOLEAN
);

CREATE TABLE room_reservation (
    bookedBy INT,
    patientId INT,
    roomId INT,
    PRIMARY KEY (bookedBy, patientId, roomId),
    FOREIGN KEY (roomId) REFERENCES room(RoomNumber),
    FOREIGN KEY (patientId) REFERENCES patient(uid),
    FOREIGN KEY (bookedBy) REFERENCES staff(uid)
);

CREATE TABLE medical_records (
    patientId INT PRIMARY KEY,
    Diagnosis TEXT,
    Treatment TEXT,
    Prescription TEXT,
    RecordDate DATE,
    FOREIGN KEY (patientId) REFERENCES patient(uid)
);

CREATE TABLE billings (
    billingId SERIAL PRIMARY KEY,
    ServiceDescription TEXT,
    Amount DECIMAL,
    BillingDate DATE,
    PaymentStatus BOOLEAN,
    patientId INT,
    FOREIGN KEY (patientId) REFERENCES patient(uid)
);

-- Index 
-- Indexes for Users
CREATE INDEX idx_users_name ON users (firstName, lastName);


-- Indexes for Appointments
CREATE INDEX idx_appointments_date ON appointment (AppointmentDate);
CREATE INDEX idx_appointments_patient_id ON appointment (patientId);
CREATE INDEX idx_appointments_doctor_id ON appointment (doctorId);

-- Indexes for Medical Supplies
CREATE INDEX idx_supplies_name ON medical_supplies (SupplyName);



-- Triggers
CREATE Trigger update_medical_supplies_quantity
After UPDATE of  Quantity on medical_supplies
For each row
Execute FUNCTION update_medical_supplies_quantity();


-- Function
CREATE OR REPLACE FUNCTION update_medical_supplies_quantity()
RETURNS TRIGGER AS $$
DECLARE 
	rec RECORD;
BEGIN
	for rec in 
		select supplyname, sum(quantity) as total_quantity 
		from medical_supplies 
		group by supplyname 
	LOOP 
    IF rec.total_quantity <  10 THEN
            RAISE NOTICE 'Alert: The total quantity of % is running low: %', rec.SupplyName, rec.total_quantity;
        -- or we could  insert a record into a notification table or log using an external system like LEK stack 
    END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- test data 
-- update medical_supplies set quantity = 5 where suppliesId = 1;

-- Search for users by first name and last name
CREATE OR REPLACE FUNCTION search_users_by_name(
    search_first_name VARCHAR(50),
    search_last_name VARCHAR(50)
)
RETURNS TABLE(uid INT, firstName VARCHAR(50), lastName VARCHAR(50), email VARCHAR(100), phoneNumber VARCHAR(50)) AS $$
BEGIN
    RETURN QUERY
    SELECT u.uid, u.firstName, u.lastName, u.email, u.phoneNumber
    FROM users u
    WHERE CONCAT(u.firstName, ' ', u.lastName) ILIKE '%' || search_first_name || '%';
    END;
$$ LANGUAGE plpgsql;


-- test data
-- select * from search_users_by_name('Ahmed', '');


-- search for appointments by 
CREATE OR REPLACE FUNCTION search_appointments(
    search_date DATE DEFAULT NULL,
    search_reason TEXT DEFAULT NULL
)
RETURNS TABLE(appointmentId INT, AppointmentDate DATE, AppointmentTime TIME, ReasonForVisit TEXT, patientId INT, doctorId INT) AS $$
BEGIN
    RETURN QUERY
    SELECT a.appointmentId, a.AppointmentDate, a.AppointmentTime, a.ReasonForVisit, a.patientId, a.doctorId
    FROM appointment a
    WHERE (search_date IS NULL OR a.AppointmentDate = search_date)
      AND (search_reason IS NULL OR a.ReasonForVisit ILIKE '%' || search_reason || '%');
END;
$$ LANGUAGE plpgsql;
-- test data
-- select * from search_appointments('2024-08-01', 'Routine Checkup');


-- search for medical supplies 
CREATE OR REPLACE FUNCTION search_medical_supplies(
    search_name TEXT DEFAULT NULL
)
RETURNS TABLE(suppliesId INT, SupplyName TEXT, Quantity INT, Supplier VARCHAR(100), PurchaseDate DATE, ExpiryDate DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT ms.suppliesId, ms.SupplyName, ms.Quantity, ms.Supplier, ms.PurchaseDate, ms.ExpiryDate
    FROM medical_supplies ms
    WHERE (search_name IS NULL OR ms.SupplyName ILIKE '%' || search_name || '%');
END;
$$ LANGUAGE plpgsql;
-- test data
-- select * from search_medical_supplies('Aspirin');
