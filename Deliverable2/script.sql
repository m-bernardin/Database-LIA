CREATE DATABASE DoctorsOffice;
USE DoctorsOffice;

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
    appointmentID INT CONSTRAINT PK_Appointment PRIMARY KEY,
    patientID INT CONSTRAINT Appointment_Patient_FK FOREIGN KEY REFERENCES Patient CONSTRAINT Appointment_Patient_NotNull NOT NULL, -- TODO add ON DELETE
    dentistID INT CONSTRAINT Appointment_Dentist_FK FOREIGN KEY REFERENCES Dentist CONSTRAINT Appointment_Dentist_NotNull NOT NULL, -- TODO add ON DELETE
    date DATE,
    time TIME
);
CREATE TABLE Visit(
    visitID INT CONSTRAINT PK_Visit PRIMARY KEY,
    symptoms VARCHAR(150),
    diagnosis VARCHAR(30)
);
CREATE TABLE Treatment(
    treatmentID INT CONSTRAINT PK_Treatment PRIMARY KEY,
    description VARCHAR(40),
    cost MONEY CONSTRAINT Treatment_cost_Check CHECK(cost>=0)
)
CREATE TABLE Bill(
    billID INT CONSTRAINT PK_Bill PRIMARY KEY,
    visitID INT CONSTRAINT Bill_Visit_FK FOREIGN KEY REFERENCES Visit CONSTRAINT Bill_Visit_NotNull NOT NULL, -- TODO add ON DELETE
    remainingSum MONEY
);
CREATE TABLE Payment(
    paymentID INT CONSTRAINT PK_Payment PRIMARY KEY,
    patientID INT CONSTRAINT Payment_Patient_FK FOREIGN KEY REFERENCES Patient CONSTRAINT Payment_Patient_NotNull NOT NULL, -- TODO add ON DELETE
    amntPaid MONEY
);
CREATE TABLE Claim(
    claimID INT CONSTRAINT PK_Claim PRIMARY KEY,
    companyID INT CONSTRAINT Claim_InsuranceCompany_FK FOREIGN KEY REFERENCES InsuranceCompany CONSTRAINT Claim_InsuranceCompany_NotNull NOT NULL, -- TODO add ON DELETE
    patientID INT CONSTRAINT Claim_Patient_FK FOREIGN KEY REFERENCES Patient CONSTRAINT Claim_Patient_NotNull NOT NULL, -- TODO add ON DELETE
    paymentID INT CONSTRAINT Claim_Payment_FK FOREIGN KEY REFERENCES Payment CONSTRAINT Claim_Payment_NotNull NOT NULL, -- TODO add ON DELETE
    amnt MONEY
);
CREATE TABLE PaysFor(
    paysForID INT CONSTRAINT PK_PaysFor PRIMARY KEY,
    billID INT CONSTRAINT PaysFor_Bill_FK FOREIGN KEY REFERENCES Bill CONSTRAINT PaysFor_Bill_NotNull NOT NULL, -- TODO add ON DELETE
    paymentID INT CONSTRAINT PaysFor_Payment_FK FOREIGN KEY REFERENCES Payment CONSTRAINT PaysFor_Payment_NotNull NOT NULL -- TODO add ON DELETE
);

-- TODO sequences

-- TODO data creation

-- TODO indexes

-- TODO alters