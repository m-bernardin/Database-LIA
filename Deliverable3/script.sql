CREATE DATABASE DentistOffice;
USE DentistOffice;

-- deliverable 2:

-- data definition (DDL)
CREATE TABLE InsuranceCompany(
    companyID INT CONSTRAINT PK_InsuranceCompany PRIMARY KEY,
    name VARCHAR(30),
    city VARCHAR(30)
);
CREATE TABLE Patient(
    patientID INT IDENTITY CONSTRAINT PK_Patient PRIMARY KEY,
    fName VARCHAR(20),
    lName VARCHAR(20),
    email VARCHAR(40) CONSTRAINT Patient_email_unique UNIQUE,
    address VARCHAR(40)
);
CREATE TABLE Dentist(
    dentistID INT IDENTITY CONSTRAINT PK_Dentist PRIMARY KEY,
    fName VARCHAR(20),
    lName VARCHAR(20),
    email VARCHAR(40) CONSTRAINT Dentist_email_unique UNIQUE,
    address VARCHAR(40),
    fee MONEY CONSTRAINT Dentist_fee_CheckPositive CHECK(fee>=0)
);
CREATE TABLE Appointment(
    apptID INT CONSTRAINT PK_Appointment PRIMARY KEY,
    patientID INT CONSTRAINT Appointment_Patient_FK FOREIGN KEY REFERENCES Patient ON DELETE CASCADE CONSTRAINT Appointment_Patient_NotNull NOT NULL, -- on delete cascade as if a patient is removed from the system we no longer need to worry about their appointments
    dentistID INT CONSTRAINT Appointment_Dentist_FK FOREIGN KEY REFERENCES Dentist CONSTRAINT Appointment_Dentist_NotNull NOT NULL, -- on delete cascade as if a doctor is removed from the system we no longer need to worry about their appointments
    date DATE,
    time TIME
);
CREATE TABLE Visit(
    visitID INT CONSTRAINT PK_Visit PRIMARY KEY,
    apptID INT CONSTRAINT Visit_Appointment_FK FOREIGN KEY REFERENCES Appointment ON DELETE SET NULL, -- on delete set null as if an appointment is removed we still need to keep visit details for financial records
    symptoms VARCHAR(150),
    diagnosis VARCHAR(30)
);
CREATE TABLE Treatment(
    treatmentID INT CONSTRAINT PK_Treatment PRIMARY KEY,
    visitID INT CONSTRAINT Treatment_Visit_FK FOREIGN KEY REFERENCES Visit ON DELETE CASCADE CONSTRAINT Treatment_Visit_NotNull NOT NULL, -- on delete cascade as if were removing a visit we must no longer care about the financial records
    description VARCHAR(40),
    cost MONEY
)
CREATE TABLE Bill(
    billID INT CONSTRAINT PK_Bill PRIMARY KEY,
    visitID INT CONSTRAINT Bill_Visit_FK FOREIGN KEY REFERENCES Visit ON DELETE CASCADE CONSTRAINT Bill_Visit_NotNull NOT NULL -- on delete cascade as if were removing a visit we must no longer care about the financial records
);
CREATE TABLE Payment(
    paymentID INT CONSTRAINT PK_Payment PRIMARY KEY,
    patientID INT CONSTRAINT Payment_Patient_FK FOREIGN KEY REFERENCES Patient ON DELETE SET NULL, -- on delete set null as if an patient is removed we still need to keep payment details for financial records
    amntPaid MONEY
);
CREATE TABLE Claim(
    claimID INT CONSTRAINT PK_Claim PRIMARY KEY,
    companyID INT CONSTRAINT Claim_InsuranceCompany_FK FOREIGN KEY REFERENCES InsuranceCompany ON DELETE SET NULL, -- on delete set null as if an insurance company is removed we still need to keep claim details for financial records
    patientID INT CONSTRAINT Claim_Patient_FK FOREIGN KEY REFERENCES Patient ON DELETE SET NULL, -- on delete set null as if an patient is removed we still need to keep claim details for financial records
    paymentID INT CONSTRAINT Claim_Payment_FK FOREIGN KEY REFERENCES Payment ON DELETE CASCADE CONSTRAINT Claim_Payment_NotNull NOT NULL, -- on delete cascade as if a payment is removed we must no longer care about the financial records
    amnt MONEY
);
CREATE TABLE PaysFor(
    paysForID INT CONSTRAINT PK_PaysFor PRIMARY KEY,
    billID INT CONSTRAINT PaysFor_Bill_FK FOREIGN KEY REFERENCES Bill ON DELETE CASCADE CONSTRAINT PaysFor_Bill_NotNull NOT NULL, -- on delete cascade as if a bill is removed we must no longer care about the financial records
    paymentID INT CONSTRAINT PaysFor_Payment_FK FOREIGN KEY REFERENCES Payment ON DELETE CASCADE CONSTRAINT PaysFor_Payment_NotNull NOT NULL -- on delete cascade as if a payment is removed we must no longer care about the financial records
);

-- TODO sequences
CREATE SEQUENCE treatmentSequence AS INT
NO CACHE;

-- TODO data creation
INSERT INTO InsuranceCompany VALUES (1, 'SunLife Dental', 'Montreal'),
                                    (2, 'BlueCross Health', 'Toronto'),
                                    (3, 'Maple Insurance', 'Ottawa'),
                                    (4, 'Northern Benefits', 'Calgary');
INSERT INTO Patient VALUES  ('John', 'Smith', 'john.smith@email.com', '12 King St'),
                            ('Emily', 'Johnson', 'emily.j@email.com', '55 Pine Ave'),
                            ('Michael', 'Brown', 'michael.b@email.com', '9 Maple Rd'),
                            ('Sarah', 'Davis', 'sarah.d@email.com', '101 Oak Lane'),
                            ('Daniel', 'Wilson', 'dan.w@email.com', '88 Cedar Blvd');
INSERT INTO Dentist VALUES  ('Alice', 'Martin', 'alice.martin@clinic.com', '200 Dental Ave', 120),
                            ('Robert', 'Lee', 'robert.lee@clinic.com', '15 Queen St', 150),
                            ('Sophia', 'Taylor', 'sophia.t@clinic.com', '33 Smile Rd', 180);
INSERT INTO Appointment VALUES  (1, 1, 1, '2026-05-01', '09:00'),
                                (2, 2, 2, '2026-05-01', '10:30'),
                                (3, 3, 1, '2026-05-02', '11:00'),
                                (4, 4, 3, '2026-05-02', '13:00'),
                                (5, 5, 2, '2026-05-03', '15:30');
INSERT INTO Visit VALUES(1, 1, 'Tooth pain and swelling', 'Cavity'),
                        (2, 2, 'Bleeding gums', 'Gingivitis'),
                        (3, 3, 'Routine cleaning', 'Healthy'),
                        (4, 4, 'Jaw pain', 'Impacted wisdom tooth'),
                        (5, 5, 'Sensitive teeth', 'Enamel erosion');
INSERT INTO Treatment VALUES(NEXT VALUE FOR treatmentSequence, 1, 'Cavity filling', 250),
                            (NEXT VALUE FOR treatmentSequence, 2, 'Deep cleaning', 180),
                            (NEXT VALUE FOR treatmentSequence, 3, 'Dental cleaning', 100),
                            (NEXT VALUE FOR treatmentSequence, 4, 'Wisdom tooth extraction', 600),
                            (NEXT VALUE FOR treatmentSequence, 5, 'Fluoride treatment', 120);
INSERT INTO Bill VALUES (1, 1),
                        (2, 2),
                        (3, 3),
                        (4, 4),
                        (5, 5);
INSERT INTO Payment VALUES  (1, 1, 250),
                            (2, 2, 180),
                            (3, 3, 100),
                            (4, 4, 600),
                            (5, 5, 120);
INSERT INTO Claim VALUES(1, 1, 1, 1, 200),
                        (2, 2, 2, 2, 140),
                        (3, 3, 3, 3, 80),
                        (4, 1, 4, 4, 500),
                        (5, 4, 5, 5, 90);
INSERT INTO PaysFor VALUES  (1, 1, 1),
                            (2, 2, 2),
                            (3, 3, 3),
                            (4, 4, 4),
                            (5, 5, 5);

-- indexes
CREATE INDEX PaysFor_billID_index ON PaysFor(billID);
-- explanation:
-- this index makes finding all payments relating to a specific bill much more efficient, through the PaysFor table

CREATE INDEX Patient_fName_index ON Patient(fName);
-- explanation
-- often, we would be searching for a patient solely on name, this index makes querying these names more efficient

-- TODO alters
ALTER TABLE Patient
ADD balance MONEY;

ALTER TABLE Treatment
ADD CONSTRAINT Treatment_cost_Check CHECK(cost>=0);

-- deliverbale 3:

-- complex queries

-- views


-- procedures

-- trigger
GO
CREATE TRIGGER autoBillPatient ON Bill INSTEAD OF INSERT AS
BEGIN
    DECLARE @patientID INT=(SELECT patientID FROM Patient WHERE patientID IN (
        SELECT patientID FROM Appointment WHERE apptID IN (
            SELECT apptID FROM Visit WHERE visitID IN (
                SELECT visitID FROM inserted))));

END;


-- roles and users
CREATE LOGIN mBernardin WITH PASSWORD='mBernardin9!66';
CREATE USER mBernardin FOR LOGIN mBernardin;
CREATE ROLE dba;
GRANT ALL ON ALL TO dba;



-- backup strategy