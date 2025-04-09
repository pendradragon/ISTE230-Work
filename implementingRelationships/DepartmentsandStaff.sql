CREATE TABLE DEPARTMENT(
    deptNum int AUTO_INCREMENT,
    name VARCHAR(50),
    CONSTRAINT deptNum_pk PRIMARY KEY (deptNum) --primary key creation
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE PERSON(
    personID int AUTO_INCREMENT,
    firstName VARCHAR(50), 
    lastName VARCHAR(50), 
    isPatient TINYINT NOT NULL, --discriminator for the PATIENT 0=not patient 1=patient
    isStaff TINYINT NOT NULL, --discriminator for the STAFF subtype  0=not staff 1=staff 
    CONSTRAINT personID_pk PRIMARY KEY (personID) --primaray key creation
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE STAFF(
    staffID int, 
    managerID int, 
    staffType ENUM('ss', 'n', 'd'), --for the type of staff
    CONSTRAINT staffID_pk PRIMARY KEY(staffID), --primary key creation
    CONSTRAINT staffID_fk FOREIGN KEY (managerID) REFERENCES STAFF(staffID) --recurvise forgein key
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Doctor must be a member of staff and have a mentor
    A mentorID has to be a doctorID */
CREATE TABLE DOCTOR(
    doctorID int, 
    mentorID int, 
    CONSTRAINT doctorID_pk PRIMARY KEY(doctorID), --doctorID is how you ID a doctor
    CONSTRAINT doctorID_fk FOREIGN KEY(doctorID) REFERENCES STAFF(staffID), --doctorID has to be a staff ID
    CONSTRAINT mentorID_fk FOREIGN KEY(mentorID) REFERENCES DOCTOR(doctorID) --mentorID must be a doctorID
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE NURSE(
    nurseID int, 
    certification ENUM('LPN', 'RN', 'APRN') NOT NULL, 
    CONSTRAINT nurseID_pk PRIMARY KEY(nurseID), 
    CONSTRAINT nurseID_fk FORGEIN KEY(nurseID) REFERENCES STAFF(staffID) --a nurse must also be a member of staff
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE SUPPORT_STAFF(
    supportStaffID int, 
    wage DECIMAL(5, 2), 
    CONSTRAINT supportStaffID_pk PRIMARY KEY(supportStaffID), --supportStaffID is how you ID a support staff member
    CONSTRAINT supportStaffID_fk FOREIGN KEY(supportStaffID) REFERENCES STAFF(staffID) --supportStaffID must be a staffID
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE DEPARTMENT_STAFF(
    deptNum int, 
    staffID int, 
    CONSTRAINT deptNum_fk FOREIGN KEY(deptNum) REFERENCES DEPARTMENT(deptNum),
    CONSTRAINT staffID_fk FOREIGN KEY(staffID) REFERENCES STAFF(staffID), 
    CONSTRAINT dept_staff_pk PRIMARY KEY(deptNum, staffID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE PATIENT(
    patientID int, 
    doctorID int, 
    CONSTRAINT patientID_pk PRIMARY KEY (patientID), 
    CONSTRAINT patientID_fk FOREIGN KEY (patientID) REFERENCES PERSON(personID), --patientID must be a personID
    CONSTRAINT doctorID_fk FOREIGN KEY (doctorID) REFERENCES DOCTOR(doctorID) --doctorID must be a doctorID
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE INSURANCE_COMPANY(
    coID int AUTO_INCREMENT, 
    name VARCHAR(50), 
    CONSTRAINT coID_pk PRIMARY KEY(coID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE INSURANCE_POLICY(
    policyNum VARCHAR(25), --the only one that is not in a foreign key
    patientID int, --must also be in PATIENT(patientID)
    insCoID int, --must also be in INSURANCE_COMPANY(coID)
    CONSTRAINT patientID_fk FOREIGN KEY(patientID) REFERENCES PATIENT(patientID),
    CONSTRAINT insCoID_fk FOREIGN KEY(insCoID) REFERENCES INSURANCE_COMPANY(coID), 
    CONSTRAINT policy_patient_co_pk PRIMARY KEY(policyNum, patientID, insCoID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
