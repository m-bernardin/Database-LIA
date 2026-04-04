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
    address VARCHAR(40)
);
CREATE TABLE Appointment(
    appointmentID INT CONSTRAINT PK_Appointment PRIMARY KEY,
    patientID INT CONSTRAINT Appointment_Patient_FK FOREIGN KEY REFERENCES Patient CONSTRAINT Appointment_Patient_NotNull NOT NULL, -- TODO add ON DELETE
    dentistID INT CONSTRAINT Appointment_Dentist_FK FOREIGN KEY REFERENCES Dentist CONSTRAINT Appointment_Dentist_NotNull NOT NULL,
    date DATE,
    time TIME
);
CREATE TABLE Visit(
    
);
CREATE TABLE VisitDetails;
CREATE TABLE Bill;
CREATE TABLE Claim;
CREATE TABLE Payment;
CREATE TABLE PaysFor;