CREATE DATABASE Wellmeadows;

GO
USE [Wellmeadows];
CREATE TABLE Appointment
(
	appointment_id nchar(10) NOT NULL PRIMARY KEY,
	room nchar(10),
	[date] DATE,
	[time] TIME(7),
);

GO
USE [Wellmeadows];
CREATE TABLE DoctorInfo
(
	doctor_id nchar(10) NOT NULL PRIMARY KEY,
	doctor_fname nvarchar(50),
	doctor_extension int,
);

CREATE TABLE DocSpeciality
(
	doctor_id nchar(10) FOREIGN KEY REFERENCES DoctorInfo,
	doc_speciality nvarchar(50),
);

CREATE TABLE PatientInfo
(
	patient_id nchar(10) NOT NULL PRIMARY KEY,
	patient_fname nvarchar(50),
	patient_lname nvarchar(50),
	patient_dob date,
	patient_gender nvarchar(50),
	patient_address nvarchar(50),
	patient_maritalstatus nvarchar(50),
	date_registered date,
	nok_id nchar(10),
	patient_phoneno varchar(50),
);

CREATE TABLE OutPatient
(
	patient_id nchar(10) FOREIGN KEY REFERENCES PatientInfo,
	op_date date,
	op_time time(7),
);

CREATE TABLE WardInfo
(
	ward_id nchar(10) NOT NULL PRIMARY KEY,
	ward_name nvarchar(50),
	ward_gender nvarchar(50),
	ward_no_of_bed int,
	ward_tel_ext int,
);

CREATE TABLE InPatient
(
	ward_id nchar(10) FOREIGN KEY REFERENCES WardInfo,
	patient_id nchar(10) FOREIGN KEY REFERENCES PatientInfo,
	expected_duration int,
	[start_date] date,
	expected_leave date,
	actual_leave date,
	bed_id nchar(10)
);

CREATE TABLE NokInfo
(
	nok_id nchar(10) NOT NULL PRIMARY KEY,
	nok_fname nvarchar(50),
	nok_relationship nvarchar(50),
	nok_address nvarchar(50),
	patient_id nchar(10) FOREIGN KEY REFERENCES PatientInfo,
);

CREATE TABLE NurseInfo
(
	nurse_id nchar(10) NOT NULL PRIMARY KEY,
	nurse_fname nvarchar(50),
	nurse_lname nvarchar(50),
	nurse_dob date,
	nurse_gender nchar(10),
	nurse_address nvarchar(50),
	nurse_phoneno int,
	nurse_position nvarchar(50),
	nurse_salary int,
);

CREATE TABLE WardNurse
(
	ward_id nchar(10) FOREIGN KEY REFERENCES WardInfo,
	nurse_id nchar(10) FOREIGN KEY REFERENCES NurseInfo,
);

CREATE TABLE Schedule
(
	appointment_id nchar(10) FOREIGN KEY REFERENCES Appointment,
	patient_id nchar(10) FOREIGN KEY REFERENCES PatientInfo,
);

ALTER TABLE Appointment
    ADD doctor_id nchar(10),
    FOREIGN KEY(doctor_id) REFERENCES DoctorInfo(doctor_id);

--Insert rows into tables
GO
INSERT [dbo].[DoctorInfo] ([doctor_id], [doctor_fname], [doctor_extension]) VALUES (N'D1', N'David', N'100101')
GO
INSERT [dbo].[DoctorInfo] ([doctor_id], [doctor_fname], [doctor_extension]) VALUES (N'D2', N'Ted', N'200101')
GO
INSERT [dbo].[DoctorInfo] ([doctor_id], [doctor_fname], [doctor_extension]) VALUES (N'D3', N'Njeri', N'300101')
GO
INSERT [dbo].[DoctorInfo] ([doctor_id], [doctor_fname], [doctor_extension]) VALUES (N'D4', N'Wairimu', N'400101')
GO
INSERT [dbo].[DoctorInfo] ([doctor_id], [doctor_fname], [doctor_extension]) VALUES (N'D5', N'Tuiyott', N'500101')


GO
INSERT [dbo].[DocSpeciality] ([doctor_id], [doc_speciality]) VALUES (N'D1', N'Obstretics and Gynecology')
GO
INSERT [dbo].[DocSpeciality] ([doctor_id], [doc_speciality]) VALUES (N'D2', N'Dermatology')
GO
INSERT [dbo].[DocSpeciality] ([doctor_id], [doc_speciality]) VALUES (N'D3', N'Radiology')
GO
INSERT [dbo].[DocSpeciality] ([doctor_id], [doc_speciality]) VALUES (N'D5', N'Cardiology')
GO
INSERT [dbo].[DocSpeciality] ([doctor_id], [doc_speciality]) VALUES (N'D4', N'Dentistry')


GO
INSERT [dbo].[Appointment] ([appointment_id], [room], [date], [time], [doctor_id]) VALUES (N'A1', N'R1', N'8/1/2021', N'13:00:00', N'D1')
GO
INSERT [dbo].[Appointment] ([appointment_id], [room], [date], [time], [doctor_id]) VALUES (N'A2', N'R2', N'8/1/2021', N'13:00:00', N'D2')
GO
INSERT [dbo].[Appointment] ([appointment_id], [room], [date], [time], [doctor_id]) VALUES (N'A3', N'R3', N'8/1/2021', N'16:00:00', N'D3')
GO
INSERT [dbo].[Appointment] ([appointment_id], [room], [date], [time], [doctor_id]) VALUES (N'A4', N'R2', N'8/2/2021', N'09:00:00', N'D4')
GO
INSERT [dbo].[Appointment] ([appointment_id], [room], [date], [time], [doctor_id]) VALUES (N'A5', N'R1', N'8/2/2021', N'10:00:00', N'D5')



GO
INSERT [dbo].[PatientInfo] ([patient_id], [patient_fname], [patient_lname], [patient_dob], [patient_gender], [patient_address], [patient_maritalstatus], [date_registered], [nok_id], [patient_phoneno]) VALUES (N'P1', N'John', N'Kamau', N'7/19/1982', N'M', N'14-210', N'Married', N'7/29/2020', 'NOK1', '2727650')
GO
INSERT [dbo].[PatientInfo] ([patient_id], [patient_fname], [patient_lname], [patient_dob], [patient_gender], [patient_address], [patient_maritalstatus], [date_registered], [nok_id], [patient_phoneno]) VALUES (N'P2', N'Willy', N'Wonka', N'4/19/1969', N'M', N'19-382', N'Married', N'2/25/2020', 'NOK2', '7364922')
GO
INSERT [dbo].[PatientInfo] ([patient_id], [patient_fname], [patient_lname], [patient_dob], [patient_gender], [patient_address], [patient_maritalstatus], [date_registered], [nok_id], [patient_phoneno]) VALUES (N'P3', N'Laa', N'Laa', N'10/3/2010', N'F', N'10-950', N'Single', N'8/16/2019', 'NOK3', '3425178')
GO
INSERT [dbo].[PatientInfo] ([patient_id], [patient_fname], [patient_lname], [patient_dob], [patient_gender], [patient_address], [patient_maritalstatus], [date_registered], [nok_id], [patient_phoneno]) VALUES (N'P4', N'Mejja', N'Okonkwo', N'5/15/1997', N'M', N'81-749', N'Single', N'4/20/2020', 'NOK4', '3810253')
GO
INSERT [dbo].[PatientInfo] ([patient_id], [patient_fname], [patient_lname], [patient_dob], [patient_gender], [patient_address], [patient_maritalstatus], [date_registered], [nok_id], [patient_phoneno]) VALUES (N'P5', N'Ssaru', N'Mwaniki', N'4/20/1995', N'F', N'02-745', N'Single', N'1/25/2019', 'NOK5', '2764368')


GO
INSERT [dbo].[OutPatient] ([patient_id], [op_date], [op_time]) VALUES (N'P1', N'8/1/2021', N'13:00:00')
GO
INSERT [dbo].[OutPatient] ([patient_id], [op_date], [op_time]) VALUES (N'P2', N'8/1/2021', N'13:00:00')
GO
INSERT [dbo].[OutPatient] ([patient_id], [op_date], [op_time]) VALUES (N'P3', N'8/1/2021', N'16:00:00')
GO
INSERT [dbo].[OutPatient] ([patient_id], [op_date], [op_time]) VALUES (N'P4', N'8/2/2021', N'09:00:00')
GO
INSERT [dbo].[OutPatient] ([patient_id], [op_date], [op_time]) VALUES (N'P5', N'8/2/2021', N'10:00:00')


GO
INSERT [dbo].[Schedule] ([appointment_id], [patient_id]) VALUES (N'A1', N'P1')
GO
INSERT [dbo].[Schedule] ([appointment_id], [patient_id]) VALUES (N'A2', N'P2')
GO
INSERT [dbo].[Schedule] ([appointment_id], [patient_id]) VALUES (N'A3', N'P3')
GO
INSERT [dbo].[Schedule] ([appointment_id], [patient_id]) VALUES (N'A4', N'P4')
GO
INSERT [dbo].[Schedule] ([appointment_id], [patient_id]) VALUES (N'A5', N'P5')



GO
INSERT [dbo].[NokInfo] ([nok_id], [nok_fname], [nok_relationship], [nok_address], [patient_id]) VALUES (N'NOK1', N'Wanjiru', N'Wife', N'14-210', N'P1')
GO
INSERT [dbo].[NokInfo] ([nok_id], [nok_fname], [nok_relationship], [nok_address], [patient_id]) VALUES (N'NOK2', N'Snow', N'Partner', N'19-382', N'P2')
GO
INSERT [dbo].[NokInfo] ([nok_id], [nok_fname], [nok_relationship], [nok_address], [patient_id]) VALUES (N'NOK3', N'Suhayl', N'Father', N'10-950', N'P3')
GO
INSERT [dbo].[NokInfo] ([nok_id], [nok_fname], [nok_relationship], [nok_address], [patient_id]) VALUES (N'NOK4', N'Adhiambo', N'Mother', N'81-749', N'P4')
GO
INSERT [dbo].[NokInfo] ([nok_id], [nok_fname], [nok_relationship], [nok_address], [patient_id]) VALUES (N'NOK5', N'Mwazige', N'Cousin', N'02-745', N'P5')

