-- Use the information you have to create a table schema for each of the six CSV files. 
-- Remember to specify data types, primary keys, foreign keys, and other constraints.
-- Import each CSV file into the corresponding SQL table.


-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- FIRST CREATE THE TABLES

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL
);

-- RUN THE COMMANDS GIVEN BELOW AFTER CREATING TABLES 

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-- ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
-- REFERENCES "dept_emp" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-- ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
-- REFERENCES "titles" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "salaries" ("emp_no");

-- List the following details of each employee: employee number, last name, first name, gender, and salary.

-- CREATE TABLE en_ln_fn_gen_sal AS
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees AS e

LEFT JOIN salaries AS s
ON e.emp_no = s.emp_no;

-- List employees who were hired in 1986.

-- CREATE TABLE hired_in_1986 AS
SELECT *
FROM employees
WHERE hire_date LIKE '1986%';

-- List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name, and start and 
-- end employment dates.

-- CREATE TABLE dnum_dname_en_ln_fn_sd_ed AS
SELECT 
	dm.dept_no, 
	(SELECT dept_name FROM departments AS de WHERE de.dept_no = dm.dept_no) AS dept_name,
	dm.emp_no,
	e.last_name,
	e.first_name,
	dm.from_date AS start_date,
	dm.to_date AS end_date
FROM dept_manager AS dm

LEFT JOIN employees AS e
ON dm.emp_no = e.emp_no

ORDER BY dm.dept_no;

-- List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.

CREATE TABLE enum_ln_fn_dname AS
SELECT 
	e.emp_no,
	e.last_name,
	e.first_name,
	(SELECT dept_name FROM departments AS de WHERE de.dept_no = dept_emp.dept_no) AS dept_name
FROM dept_emp

LEFT JOIN employees AS e
ON dept_emp.emp_no = e.emp_no;

-- List all employees whose first name is "Hercules" and last names begin with "B."

-- CREATE TABLE hercules_b AS
SELECT first_name,last_name
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY last_name;

-- List all employees in the Sales department, including their employee number, last name, first name, 
-- and department name.

-- CREATE TABLE sales_department AS
SELECT *
FROM enum_ln_fn_dname -- We can use the table (enum_ln_fn_dname) that we have already constructed above:
WHERE dept_name = 'Sales';

-- List all employees in the Sales and Development departments, including their employee number, last name, first name, 
-- and department name.

-- CREATE TABLE sales_and_development_departments AS
SELECT *
FROM enum_ln_fn_dname -- We can use the table (enum_ln_fn_dname) that we have already constructed above:
WHERE dept_name = 'Sales' OR dept_name='Development';

-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

-- CREATE TABLE freq_count_of_ln AS
SELECT last_name, COUNT(last_name) AS count
FROM employees
GROUP BY last_name
ORDER BY count DESC;