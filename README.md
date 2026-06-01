# MedCare Healthcare Analytics Project

## Project Overview

MedCare is an end-to-end Healthcare Analytics project developed using Excel, MySQL, and Power BI. The project focuses on analyzing patient records, appointments, billing transactions, and insurance claims to generate actionable business insights and identify data quality issues.

The objective was to simulate a real-world healthcare analytics workflow, starting from data cleaning and validation to database design, SQL analysis, and interactive dashboard development.

---

## Tools & Technologies

### Excel

* Data Cleaning
* Data Validation
* Conditional Formatting
* VLOOKUP
* XLOOKUP
* INDEX-MATCH
* Pivot Tables
* Pivot Charts
* VBA & Macros

### MySQL

* Database Design
* Data Auditing
* Data Cleaning
* Views
* Stored Procedures
* Joins
* CTEs
* Window Functions
* Ranking Functions

### Power BI

* Data Modeling
* DAX Measures
* KPI Cards
* Slicers & Filters
* Interactive Dashboards
* Drill-down Analysis

---

## Database Structure

The project consists of five core tables:

### Patients

Contains demographic and medical information of patients.

### Doctors

Stores doctor details, department information, and experience.

### Appointments

Tracks patient appointments, wait times, and appointment status.

### Billing

Contains treatment, medicine, room charges, and billing details.

### Insurance Claims

Stores claim information, approval status, and insurance provider details.

---

## Data Validation & Cleaning

Several data quality checks were performed:

* Duplicate Record Detection
* Null Value Analysis
* Relationship Validation
* Insurance Claim Validation
* Missing Rejection Reason Detection
* Approved Claims with Invalid Rejection Reasons
* Revenue Records Without Appointment Records

Data inconsistencies were corrected using SQL updates and validation logic.

---

## Advanced SQL Concepts Used

* INNER JOIN
* LEFT JOIN
* Common Table Expressions (CTEs)
* Window Functions
* ROW_NUMBER()
* RANK()
* LAG()
* LEAD()
* Aggregate Functions
* Views
* Stored Procedures

---

## Power BI Dashboard Pages

### Executive Overview

Provides high-level KPIs and business summary.

### Revenue Analysis

* Revenue by Department
* Revenue by Disease
* Revenue by Gender
* Revenue by State
* Top Revenue Generating Doctors

### Insurance Analysis

* Claim Status Distribution
* Claimed vs Approved Amount
* Insurance Provider Analysis
* Revenue Loss Analysis

### Operations Analysis

* Appointment Status Analysis
* Department Workload
* Wait Time Analysis
* Appointment Trends

### Data Quality Dashboard

* Patients with Revenue but No Appointments
* Insurance Claims without Appointments
* Missing Rejection Reasons
* Data Consistency Issues

---

## Key Business Insights

* Revenue showed a declining trend in recent quarters.
* Flu and Cancer were the most common diseases among patients.
* Neurology and ENT departments handled the highest workload.
* Approximately 77% of total billing revenue was covered through insurance claims.
* HDFC ERGO and ICICI Lombard contributed the highest approved claim amounts.
* Multiple data quality issues were identified across appointment and insurance datasets.
* Patients generated approximately ₹13 Crore in revenue despite having no appointment records.

---

## Business Recommendations

1. Improve appointment tracking and status management.
2. Strengthen data validation rules for insurance claims.
3. Investigate revenue generated without appointment records.
4. Allocate additional resources to high-demand departments.
5. Reduce pending insurance claims through process optimization.
6. Conduct regular data quality audits across operational systems.

---

## Project Outcome

This project demonstrates the complete Data Analytics lifecycle, including:

* Data Cleaning
* Data Validation
* Database Design
* Advanced SQL Analysis
* Business Intelligence
* Dashboard Development
* Insight Generation
* Data Quality Monitoring

The project helped strengthen practical skills in Excel, SQL, Power BI, DAX, and business analytics while solving real-world healthcare reporting challenges.
