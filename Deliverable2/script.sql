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
CREATE TABLE Dentist;
CREATE TABLE Appointment;
CREATE TABLE Visit;
CREATE TABLE VisitDetails;
CREATE TABLE Bill;
CREATE TABLE Claim;
CREATE TABLE Payment;
CREATE TABLE PaysFor;