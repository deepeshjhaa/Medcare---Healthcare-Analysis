create Database Medcare;
use medcare;

create table Patients (
Patient_ID varchar(20) primary key,
Patient_Name varchar(50),
Age	int,
Gender varchar(20),
Blood_Group varchar(20),
Disease varchar(40),
Admission_Date	Date,
Discharge_Date	Date,
City varchar(50),
State varchar(50),
Insurance_ID varchar(50));

create table Doctors(
Doctor_ID varchar(50) primary key,
Doctor_Name	varchar(50),
Department varchar(50),
Experience_Years int,
Hospital_Branch varchar(100),
Consultation_Fee decimal(10,2));

CREATE TABLE appointments (
Appointment_id VARCHAR(20) PRIMARY KEY,
Patient_id VARCHAR(20),
Doctor_id VARCHAR(20),
Appointment_date DATE,
Wait_time_minutes INT,
Appointment_status VARCHAR(50)
);

Create table billing(
Bill_id varchar(50) primary key,
Patient_id varchar(50),
Treatment_cost DECIMAL(12,2),
Medicine_cost DECIMAL(12,2),
Room_charges DECIMAL(12,2),
Total_bill DECIMAL(12,2),
Payment_mode VARCHAR(50)
);

CREATE TABLE insurance_claims (
claim_id VARCHAR(20) PRIMARY KEY,
patient_id VARCHAR(20),
insurance_provider VARCHAR(100),
claim_amount DECIMAL(12,2),
approved_amount DECIMAL(12,2),
claim_status VARCHAR(50),
rejected_reason VARCHAR(255),
claim_date DATE
);

LOAD DATA LOCAL INFILE 'C:/sql_data/appointments.csv'
INTO TABLE appointments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- DATA AUDIT
Select Count(*) as patients_count from patients;
Select Count(*) As doctors_count from doctors;
Select Count(*) as appointments_count from appointments;
Select Count(*) As billing_count from billing;

Select Count(*) As claims_count from insurance_claims;

-- Duplicates Check

select patient_id, count(*) AS total
from patients
Group by patient_id
Having count(*) > 1;

select * from patients
where patient_name is null;

select * from  doctors
where doctor_name is null;

-- Data Validation
-- Approved claim with rejected reason
Select * from insurance_claims
where claim_status="Approved"
and rejected_reason is not null
and rejected_reason <> '';

-- Pending claim without reasons
Select * from insurance_claims
where claim_status="pending"
and (rejected_reason is null
or rejected_reason = '');


-- Rejected claim without reasons
Select * from insurance_claims
where claim_status="Rejected"
and (rejected_reason is null
or rejected_reason = '');

-- Claim amount greater than approved amount
select * from insurance_claims
where approved_amount>claim_amount;

-- Relationship validation
-- Appointment table and patient table
select * from appointments a 
left join patients p 
on a.patient_id=p.patient_id
where p.patient_id is null;

-- appointment table and doctor table
SELECT *
FROM appointments a
LEFT JOIN doctors d
ON a.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;

-- Billing table Mapping;
select * from billing b left join
patients p on
b.patient_id=p.patient_id
where p.patient_id is null;

-- Insurance table mapping;
select * from insurance_claims ic
left join patients p
on ic.patient_id = p.patient_id
where p.patient_id is null;



SELECT claim_status,COUNT(*)
FROM insurance_claims
GROUP BY claim_status;

create table backup_claim_table as
select * from insurance_claims ;

-- Set Approved claim where there should not be rejection reason
update insurance_claims
set rejected_reason=null
where claim_status="Approved";

-- Set Rejected claim with rejection reason

update  insurance_claims
set rejected_reason="Reason not provided"
where claim_status="Rejected"
and (rejected_reason is null
or rejected_reason = '');

select count(*) as total from  insurance_claims
where claim_status="Rejected"
and (rejected_reason is null
or rejected_reason = '');

select count(*) from insurance_claims
where claim_status="Approved"
and rejected_reason is not null;

select claim_status, count(*) as total 
from insurance_claims
group by 1;

select claim_status, count(rejected_reason) as rows_with_reason
from insurance_claims
group by 1;

-- Adding Foreign Key
-- Appointments to Patient tables
Alter table appointments
add constraint fk_appointment_patient
foreign key (patient_id)
references patients(patient_id);

-- Appointments to Doctor Table
Alter table appointments
add constraint fk_appointment_doctor
foreign key (doctor_id)
references doctors(doctor_id);

-- billing table to patient table

Alter table billing
add constraint fk_billing_patient
foreign key(patient_id)
references patients(patient_id);

-- Insurance_claims to Patients
Alter table insurance_claims
add constraint fk_claim_patient
foreign key(patient_id)
references patients(patient_id);
 
-- Creating View 
create view medcare_analysis as
select P.patient_id, P.patient_name, P.age, p.gender, p.disease,
a.appointment_id, a.appointment_date, a.appointment_status, a.wait_time_minutes,
d.doctor_name, d.department, 
b.total_bill, 
i.claim_status, i.claim_amount, i.approved_amount, i.insurance_provider
from patients p
left join appointments a on
p.patient_id=a.patient_id
left join doctors d on
a.doctor_id=d.doctor_id
left join billing b
on
p.patient_id=b.patient_id
left join insurance_claims i
on p.patient_id=i.patient_id;

select * from medcare_analysis
limit 10;

SELECT COUNT(*)
FROM appointments;

SELECT COUNT(DISTINCT patient_id)
FROM appointments;

SELECT COUNT(*)
FROM patients p
LEFT JOIN appointments a
ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

SELECT
COUNT(*) AS patients_with_bill_but_no_appointment
FROM billing b
LEFT JOIN appointments a
ON b.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

SELECT
COUNT(*) AS affected_records,
ROUND(SUM(total_bill),2) AS affected_revenue
FROM billing b
LEFT JOIN appointments a
ON b.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

SELECT
COUNT(DISTINCT b.patient_id) AS patients
FROM billing b
LEFT JOIN appointments a
ON b.patient_id = a.patient_id
JOIN insurance_claims ic
ON b.patient_id = ic.patient_id
WHERE a.patient_id IS NULL;


-- Business Questions
-- Top 10 Diseases
select disease, count(*) as total
from medcare_analysis
group by disease
order by total desc
limit 10
;

-- Revenue by Department
select d.Department, sum(b.total_bill) as total_revenue
from billing b 
JOIN appointments a
ON b.patient_id = a.patient_id
JOIN doctors d
ON a.doctor_id = d.doctor_id
GROUP BY d.department
ORDER BY total_revenue DESC;

-- Insurance Coverage %
select round(sum(approved_amount)/sum(claim_amount) *100,2) as Coverage_percent
from insurance_claims;

-- Female vs Male Patients
select gender, count(*) as total from patients
group by gender;

select *  from medcare_analysis;


 -- Revenue by disease
 select disease, sum(total_bill) as Total_revenue from
 medcare_analysis
 group by disease
 order by Total_revenue desc;
 
 Select insurance_provider, count(*) as total_claims,
 sum(claim_amount) as Claimed_Amount,
 sum(Approved_amount) as Approved_Amount
 from medcare_analysis
 group by insurance_provider
 order by Approved_Amount desc;
 
--  Top Revenue Generating Doctors
select doctor_name, sum(total_bill) as total_revenue from medcare_analysis
group by doctor_name
order by total_revenue desc
limit 5;

-- Bussiness questions With Advance Excel
-- Q8. Departments Above Average Revenue
with department_revenue as (
select department, sum(total_bill) as revenue
from medcare_analysis
group by department)

select * from department_revenue
where revenue > ( select avg(revenue) from department_revenue)
order by revenue desc;

-- Q9. Patients Above Average Bill
	with patient_revenue as (
    select patient_name, sum(total_bill) as revenue
    from medcare_analysis
    group by patient_name)
    
    select * from patient_revenue
    where revenue> (select avg(revenue) from patient_revenue)
    order by revenue desc;
    
-- Top 5 Revenue Departments
with dept as(
select Department, sum(total_bill) as revenue from medcare_analysis
group by department)
select * from dept
order by revenue desc
limit 5;

-- Rank Departments by Revenue

with dept as(
select Department, sum(total_bill) as revenue from medcare_analysis
group by department)

select *,
row_number() over (order by revenue desc) as RNK
from dept;

-- Top Doctor in Every Department
with top_doctor as(
select department, doctor_name, sum(total_bill) as revenue,
row_number() over(partition by department order by sum(total_bill)  desc) as rn
 from medcare_analysis
 where doctor_name is not null
 group by 1,2)
 select * from top_doctor
 where rn=1;
 
 select * from medcare_analysis
 limit 5;
 
 -- Revenue Trend by Appointment Date
 select appointment_date,
 sum(total_bill) as revenue,
 lag(sum(total_bill)) over(order by Appointment_date ) as previous_revenue 
 from medcare_analysis
 group by 1;
 
  select appointment_date,
 sum(total_bill) as revenue,
 lead(sum(total_bill)) over(order by Appointment_date ) as latest_revenue 
 from medcare_analysis
 group by 1;
 
-- Compare Previous and Next Revenue  

with cte as(
select appointment_date,
sum(total_bill) as revenue
from medcare_analysis
group by appointment_date
)
select *, lag(revenue) over (order by appointment_date) as previous_revenue,
lead(revenue) over (order by appointment_date) as next_revenue from cte;

-- Stored_procedure
 delimiter //
 
 create procedure get_department_revenue()
 begin
 select
  department, sum(total_bill) as revenue
  from medcare_analysis
  where department is not null
  group by department
  order by revenue desc;
  end //
  
 delimiter ;
 
 call get_department_revenue();
 
delimiter //
 
 create procedure get_doctor_revenue()
 begin
 select
  doctor_name, sum(total_bill) as revenue
  from medcare_analysis
  where doctor_name is not null
  group by doctor_name
  order by doctor_name desc;
  end //
  
 delimiter ; 
 
 call get_doctor_revenue();
 
 delimiter //
 
 create procedure Patient_details(in p_patient_id varchar(20))
 begin
 select * from medcare_analysis
 where patient_id=p_patient_id;

  end //
  
 delimiter ; 
 
 delimiter //
  create procedure insurance_provider_details()
  begin
   Select insurance_provider, count(*) as total_claims,
 sum(claim_amount) as Claimed_Amount,
 sum(Approved_amount) as Approved_Amount
 from medcare_analysis
 group by insurance_provider
 order by Approved_Amount desc;
 end //
 
 delimiter ;
 
 call insurance_provider_details();
 
 
--  Creating Views again for further Analysis

Create view Revenue_analysis as
select patient_id, patient_name, gender, disease,
total_bill from medcare_analysis
where total_bill is not null;

create view Department_analysis as
select department, doctor_name, total_bill, appointment_status
from medcare_analysis
where department is not null
;

Create view insurance_analysis as
select claim_id, patient_id, insurance_provider, claim_status, claim_amount, approved_amount 
from insurance_claims;


select * from insurance_analysis;

create view Patient_analysis as
select   patient_id, patient_name, age, gender, disease, city, state
from patients;

create view Appointment_analysis as
select Patient_id, appointment_id, appointment_date, appointment_status, department, doctor_name, wait_time_minutes
from medcare_analysis
where appointment_id is not null;

select * from Appointment_analysis;

CREATE VIEW revenue_trend_analysis AS
SELECT
a.appointment_date,
SUM(b.total_bill) AS revenue
FROM appointments a
JOIN billing b
ON a.patient_id=b.patient_id
GROUP BY a.appointment_date;

select * from revenue_trend_analysis