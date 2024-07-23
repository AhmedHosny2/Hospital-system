-- Seed the users table
INSERT INTO users (firstName, lastName, email, phoneNumber) VALUES
('Ahmed', 'Mohamed', 'ahmed.mohamed@example.com', '+201234567890'),
('Ali', 'Hassan', 'ali.hassan@example.com', '+201234567891'),
('Mona', 'El-Sayed', 'mona.elsayed@example.com', '+201234567892'),
('Fatima', 'Abdelrahman', 'fatima.abdelrahman@example.com', '+201234567893'),
('Hassan', 'Said', 'hassan.said@example.com', '+201234567894'),
('Yasmine', 'Hussein', 'yasmine.hussein@example.com', '+201234567895'),
('Sara', 'Gamal', 'sara.gamal@example.com', '+201234567896'),
('Omar', 'El-Kholy', 'omar.elkholy@example.com', '+201234567897'),
('Nadia', 'Moussa', 'nadia.moussa@example.com', '+201234567898'),
('Mohamed', 'Hossam', 'mohamed.hossam@example.com', '+201234567899'),
('Layla', 'Ali', 'layla.ali@example.com', '+201234567900'),
('Khaled', 'Farag', 'khaled.farag@example.com', '+201234567901'),
('Rania', 'Mounir', 'rania.mounir@example.com', '+201234567902'),
('Tamer', 'Gabr', 'tamer.gabr@example.com', '+201234567903');

-- Seed the patient table
INSERT INTO patient (uid, EmergencyContact, DateOfBirth, gender, address) VALUES
(1, '1234567890', '1985-06-15', 'Male', '123 Nile Street, Cairo, Egypt'),
(2, '2345678901', '1990-12-05', 'Male', '456 Pyramids Road, Giza, Egypt'),
(3, '3456789012', '1982-03-22', 'Female', '789 Alexandria Avenue, Alexandria, Egypt'),
(4, '4567890123', '1975-08-30', 'Female', '101 Suez Canal Street, Suez, Egypt'),
(5, '5678901234', '1993-11-15', 'Male', '202 Tahrir Square, Cairo, Egypt'),
(6, '6789012345', '1988-05-20', 'Female', '303 Mohandessin Street, Cairo, Egypt');

-- Seed the staff table
INSERT INTO staff (uid, role) VALUES
(7, 'Nurse'),
(8, 'Administrative Assistant'),
(9, 'Pharmacist'),
(10, 'Janitor');

-- Seed the doctor table
INSERT INTO doctor (uid, Specialization) VALUES
(11, 'Cardiologist'),
(12, 'Orthopedic Surgeon'),
(13, 'Pediatrician'),
(14, 'Neurologist');

-- Seed the department table
INSERT INTO department (DepartmentName) VALUES
('Cardiology'),
('Orthopedics'),
('Pediatrics'),
('Neurology');

-- Seed the department_management table
INSERT INTO department_management (departmentId, uid) VALUES
(1, 11),
(2, 12),
(3, 13),
(4, 14);

-- Seed the appointment table
INSERT INTO appointment (AppointmentDate, AppointmentTime, ReasonForVisit, patientId, doctorId) VALUES
('2024-08-01', '09:00:00', 'Routine Checkup', 1, 11),
('2024-08-02', '10:00:00', 'Fracture Follow-up', 2, 12),
('2024-08-03', '11:00:00', 'Vaccination', 3, 13),
('2024-08-04', '12:00:00', 'Headache Evaluation', 4, 14);


-- Seed the medical_supplies table
INSERT INTO medical_supplies (SupplyName, Quantity, Supplier, PurchaseDate, ExpiryDate) VALUES
('Aspirin', 100, 'Pharma Egypt', '2024-07-15', '2025-07-15'),
('Bandages', 200, 'MedCare', '2024-07-20', '2025-07-20'),
('Syringes', 150, 'HealthPlus', '2024-07-22', '2025-07-22'),
('Antibiotics', 50, 'Cairo Medical', '2024-07-25', '2025-07-25');

-- Seed the medical_supplies_management table
INSERT INTO medical_supplies_management (suppliesId, staffId) VALUES
(1, 7),
(2, 8),
(3, 9),
(4, 10);

-- Seed the room table
INSERT INTO room (RoomNumber, RoomType, AvailabilityStatus) VALUES
(101, 'ICU', TRUE),
(102, 'General', TRUE),
(103, 'Private', FALSE),
(104, 'General', TRUE),
(105, 'ICU', TRUE),
(106, 'Private', FALSE);

-- Seed the room_reservation table
INSERT INTO room_reservation (bookedBy, patientId, roomId) VALUES
(7, 1, 101),
(8, 2, 104),
(9, 3, 102),
(10, 4, 105),
(7, 5, 106);

-- Seed the medical_records table
INSERT INTO medical_records (patientId, Diagnosis, Treatment, Prescription, RecordDate) VALUES
(1, 'Hypertension', 'Medication', 'Lisinopril', '2024-07-30'),
(2, 'Fracture', 'Cast', 'Painkillers', '2024-07-31'),
(3, 'Flu', 'Rest', 'Antiviral', '2024-07-28'),
(4, 'Migraine', 'Medication', 'Triptans', '2024-07-29'),
(5, 'Skin Rash', 'Cream', 'Hydrocortisone', '2024-08-01'),
(6, 'Diabetes', 'Insulin', 'Insulin', '2024-08-02');

-- Seed the billings table
INSERT INTO billings (ServiceDescription, Amount, BillingDate, PaymentStatus, patientId) VALUES
('Consultation Fee', 200.00, '2024-08-01', TRUE, 1),
('X-Ray', 500.00, '2024-08-02', FALSE, 2),
('Vaccination', 150.00, '2024-08-03', TRUE, 3),
('MRI Scan', 1000.00, '2024-08-04', TRUE, 4),
('Consultation Fee', 200.00, '2024-08-05', TRUE, 5),
('Consultation Fee', 200.00, '2024-08-06', TRUE, 6);

