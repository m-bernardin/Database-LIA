CREATE DATABASE DentistOffice;
USE DentistOffice;

CREATE TABLE InsuranceCompany(
    companyID INT CONSTRAINT PK_InsuranceCompany PRIMARY KEY,
    name VARCHAR(30),
    city VARCHAR(30)
);
CREATE TABLE Patient(
    patientID INT IDENTITY CONSTRAINT PK_Patient PRIMARY KEY,
    fName VARCHAR(20),
    lName VARCHAR(20),
    email VARCHAR(40),
    address VARCHAR(40)
);
CREATE TABLE Dentist(
    dentistID INT IDENTITY CONSTRAINT PK_Dentist PRIMARY KEY,
    fName VARCHAR(20),
    lName VARCHAR(20),
    email VARCHAR(40),
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
    apptID INT CONSTRAINT Visit_Appointment_FK FOREIGN KEY REFERENCES Appointment ON DELETE SET NULL CONSTRAINT Visit_Appintment_NotNull NOT NULL, -- on delete set null as if an appointment is removed we still need to keep visit details for financial records
    symptoms VARCHAR(150),
    diagnosis VARCHAR(30)
);
CREATE TABLE Treatment(
    treatmentID INT CONSTRAINT PK_Treatment PRIMARY KEY,
    visitID INT CONSTRAINT Treatment_Visit_FK FOREIGN KEY REFERENCES Visit ON DELETE CASCADE CONSTRAINT Treatment_Visit_NotNull NOT NULL, -- on delete cascade as if were removing a visit we must no longer care about the financial records
    description VARCHAR(40),
    cost MONEY CONSTRAINT Treatment_cost_Check CHECK(cost>=0)
)
CREATE TABLE Bill(
    billID INT CONSTRAINT PK_Bill PRIMARY KEY,
    visitID INT CONSTRAINT Bill_Visit_FK FOREIGN KEY REFERENCES Visit ON DELETE CASCADE CONSTRAINT Bill_Visit_NotNull NOT NULL -- on delete cascade as if were removing a visit we must no longer care about the financial records
);
CREATE TABLE Payment(
    paymentID INT CONSTRAINT PK_Payment PRIMARY KEY,
    patientID INT CONSTRAINT Payment_Patient_FK FOREIGN KEY REFERENCES Patient ON DELETE SET NULL CONSTRAINT Payment_Patient_NotNull NOT NULL, -- on delete set null as if an patient is removed we still need to keep payment details for financial records
    amntPaid MONEY
);
CREATE TABLE Claim(
    claimID INT CONSTRAINT PK_Claim PRIMARY KEY,
    companyID INT CONSTRAINT Claim_InsuranceCompany_FK FOREIGN KEY REFERENCES InsuranceCompany ON DELETE SET NULL CONSTRAINT Claim_InsuranceCompany_NotNull NOT NULL, -- on delete set null as if an insurance company is removed we still need to keep claim details for financial records
    patientID INT CONSTRAINT Claim_Patient_FK FOREIGN KEY REFERENCES Patient ON DELETE SET NULL CONSTRAINT Claim_Patient_NotNull NOT NULL, -- on delete set null as if an patient is removed we still need to keep claim details for financial records
    paymentID INT CONSTRAINT Claim_Payment_FK FOREIGN KEY REFERENCES Payment ON DELETE CASCADE CONSTRAINT Claim_Payment_NotNull NOT NULL, -- on delete cascade as if a payment is removed we must no longer care about the financial records
    amnt MONEY
);
CREATE TABLE PaysFor(
    paysForID INT CONSTRAINT PK_PaysFor PRIMARY KEY,
    billID INT CONSTRAINT PaysFor_Bill_FK FOREIGN KEY REFERENCES Bill ON DELETE CASCADE CONSTRAINT PaysFor_Bill_NotNull NOT NULL, -- on delete cascade as if a bill is removed we must no longer care about the financial records
    paymentID INT CONSTRAINT PaysFor_Payment_FK FOREIGN KEY REFERENCES Payment ON DELETE CASCADE CONSTRAINT PaysFor_Payment_NotNull NOT NULL -- on delete cascade as if a payment is removed we must no longer care about the financial records
);

-- TODO sequences

-- TODO data creation

-- TODO indexes

-- TODO alters