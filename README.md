# Hospital Management System Database

## ERD Diagram
[Hospital Management System ERD](https://drive.google.com/file/d/1JpFg8Ds0S19CtuZgN8rFHqV-eWDI8YgW/view?usp=sharing)
![Hospital system drawio](https://github.com/user-attachments/assets/0a0db5e7-139a-4d3b-bf30-5cdf023d76e3)

## Brief Description
This Hospital Management System database is designed to efficiently manage various aspects of hospital operations. It covers patient information, staff and doctor records, appointments, medical supplies inventory, room management, medical records, and billing. The system is structured to ensure data integrity, optimize query performance, and provide flexible search capabilities across different entities.

## Entities

**Entity: users**

| Attributes    | Notes         |
|--------------|-------------|
| `uid`        | (SERIAL, PK) |
| `firstName`  | (VARCHAR(50)) |
| `lastName`   | (VARCHAR(50)) |
| `email`      | (VARCHAR(100)) |
| `phoneNumber` | (VARCHAR(50)) |

**Entity: patient**

| Attributes    | Notes         |
|--------------|-------------|
| `uid`        | (INT, PK, FK) ---> `users.uid` |
| `EmergencyContact` | (VARCHAR(50)) |
| `DateOfBirth` | (DATE) |
| `gender`     | (gender_enum) |
| `address`    | (VARCHAR(200)) |

**Entity: staff**

| Attributes    | Notes         |
|--------------|-------------|
| `uid`        | (INT, PK, FK) ---> `users.uid` |
| `role`       | (VARCHAR(100)) |

**Entity: doctor**

| Attributes    | Notes         |
|--------------|-------------|
| `uid`        | (INT, PK, FK) ---> `users.uid` |
| `Specialization` | (VARCHAR(100)) |

**Entity: department**

| Attributes    | Notes         |
|--------------|-------------|
| `departmentId` | (SERIAL, PK) |
| `DepartmentName` | (VARCHAR(100)) |

**Entity: department_management**

| Attributes    | Notes         |
|--------------|-------------|
| `departmentId` | (INT, PK, FK) ---> `department.departmentId` |
| `uid`        | (INT, PK, FK) ---> `users.uid` |

**Entity: appointment**

| Attributes    | Notes         |
|--------------|-------------|
| `appointmentId` | (SERIAL, PK) |
| `AppointmentDate` | (DATE) |
| `AppointmentTime` | (TIME) |
| `ReasonForVisit` | (TEXT) |
| `patientId`  | (INT, FK) ---> `patient.uid` |
| `doctorId`   | (INT, FK) ---> `doctor.uid` |

**Entity: medical_supplies**

| Attributes    | Notes         |
|--------------|-------------|
| `suppliesId` | (SERIAL, PK) |
| `SupplyName` | (TEXT) |
| `Quantity`   | (INT) |
| `Supplier`   | (VARCHAR(100)) |
| `PurchaseDate` | (DATE) |
| `ExpiryDate` | (DATE) |

**Entity: medical_supplies_management**

| Attributes    | Notes         |
|--------------|-------------|
| `management_id` | (SERIAL, PK) |
| `suppliesId` | (INT, FK) ---> `medical_supplies.suppliesId` |
| `staffId`    | (INT, FK) ---> `staff.uid` |

**Entity: room**

| Attributes    | Notes         |
|--------------|-------------|
| `RoomNumber` | (INT, PK) |
| `RoomType`   | (room_enum) |
| `AvailabilityStatus` | (BOOLEAN) |

**Entity: room_reservation**

| Attributes    | Notes         |
|--------------|-------------|
| `bookedBy`   | (INT, PK, FK) ---> `staff.uid` |
| `patientId`  | (INT, PK, FK) ---> `patient.uid` |
| `roomId`     | (INT, PK, FK) ---> `room.RoomNumber` |

**Entity: medical_records**

| Attributes    | Notes         |
|--------------|-------------|
| `patientId`  | (INT, PK, FK) ---> `patient.uid` |
| `Diagnosis`  | (TEXT) |
| `Treatment`  | (TEXT) |
| `Prescription` | (TEXT) |
| `RecordDate` | (DATE) |

**Entity: billings**

| Attributes    | Notes         |
|--------------|-------------|
| `billingId`  | (SERIAL, PK) |
| `ServiceDescription` | (TEXT) |
| `Amount`     | (DECIMAL) |
| `BillingDate` | (DATE) |
| `PaymentStatus` | (BOOLEAN) |
| `patientId`  | (INT, FK) ---> `patient.uid` |

## Indexes

| Table | Index Name | Columns |
|-------|------------|---------|
| users | idx_users_name | (firstName, lastName) |
| appointment | idx_appointments_date | (AppointmentDate) |
| appointment | idx_appointments_patient_id | (patientId) |
| appointment | idx_appointments_doctor_id | (doctorId) |
| medical_supplies | idx_supplies_name | (SupplyName) |

## Triggers

| Trigger Name | Table | Event | Function |
|--------------|-------|-------|----------|
| update_medical_supplies_quantity | medical_supplies | AFTER UPDATE OF Quantity | update_medical_supplies_quantity() |

## Functions

1. **update_medical_supplies_quantity()**

   | Aspect | Description |
   |--------|-------------|
   | Purpose | Monitors and alerts for low supply quantities |
   | Return Type | TRIGGER |
   | Language | plpgsql |

2. **search_users_by_name(search_first_name VARCHAR(50), search_last_name VARCHAR(50))**

   | Aspect | Description |
   |--------|-------------|
   | Purpose | Facilitates user search by name |
   | Parameters | search_first_name, search_last_name |
   | Return Type | TABLE(uid INT, firstName VARCHAR(50), lastName VARCHAR(50), email VARCHAR(100), phoneNumber VARCHAR(50)) |
   | Language | plpgsql |

3. **search_appointments(search_date DATE DEFAULT NULL, search_reason TEXT DEFAULT NULL)**

   | Aspect | Description |
   |--------|-------------|
   | Purpose | Enables appointment search by date and reason |
   | Parameters | search_date, search_reason |
   | Return Type | TABLE(appointmentId INT, AppointmentDate DATE, AppointmentTime TIME, ReasonForVisit TEXT, patientId INT, doctorId INT) |
   | Language | plpgsql |

4. **search_medical_supplies(search_name TEXT DEFAULT NULL)**

   | Aspect | Description |
   |--------|-------------|
   | Purpose | Allows searching for medical supplies by name |
   | Parameters | search_name |
   | Return Type | TABLE(suppliesId INT, SupplyName TEXT, Quantity INT, Supplier VARCHAR(100), PurchaseDate DATE, ExpiryDate DATE) |
   | Language | plpgsql |
