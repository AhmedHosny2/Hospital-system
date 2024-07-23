-- Drop tables if they exist
DROP TABLE IF EXISTS medical_supplies_management CASCADE;
DROP TABLE IF EXISTS medical_records CASCADE;
DROP TABLE IF EXISTS billings CASCADE;
DROP TABLE IF EXISTS room_reservation CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS medical_supplies CASCADE;
DROP TABLE IF EXISTS appointment CASCADE;
DROP TABLE IF EXISTS department_management CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS doctor CASCADE;
DROP TABLE IF EXISTS stuff CASCADE;
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS users CASCADE;


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
CREATE TABLE users (
    uid SERIAL PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(50)
);

CREATE TABLE patient (
    uid INT PRIMARY KEY,
    EmergencyContact VARCHAR(50),
    DateOfBirth DATE,
    gender gender_enum,
    address VARCHAR(200),
    FOREIGN KEY (uid) REFERENCES users(uid)
);

CREATE TABLE stuff (
    uid INT PRIMARY KEY,
    role VARCHAR(100),
    FOREIGN KEY (uid) REFERENCES users(uid)
);

CREATE TABLE doctor (
    uid INT PRIMARY KEY,
    Specialization VARCHAR(100),
    FOREIGN KEY (uid) REFERENCES users(uid)
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
    stuffId INT,
    FOREIGN KEY (suppliesId) REFERENCES medical_supplies(suppliesId),
    FOREIGN KEY (stuffId) REFERENCES stuff(uid)
);

CREATE TABLE room (
    roomId SERIAL PRIMARY KEY,
    RoomNumber INT,
    RoomType room_enum,
    AvailabilityStatus BOOLEAN
);

CREATE TABLE room_reservation (
    bookedBy INT,
    patientId INT,
    roomId INT,
    PRIMARY KEY (bookedBy, patientId, roomId),
    FOREIGN KEY (roomId) REFERENCES room(roomId),
    FOREIGN KEY (patientId) REFERENCES patient(uid),
    FOREIGN KEY (bookedBy) REFERENCES stuff(uid)
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
