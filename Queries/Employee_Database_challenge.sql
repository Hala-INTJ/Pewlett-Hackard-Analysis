-- Creating a new table "retirement_titles" for employees born between 1952 and 1956
SELECT em.emp_no, em.first_name, em.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees as em
INNER JOIN titles as ti
ON em.emp_no = ti.emp_no
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY em.emp_no;

-- Use Dictinct with Order by to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC;

-- Retreive the number of employees by their most recent job title who are about to retire
SELECT COUNT(title) as count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

-- Creating a new table "mentorship_eligibility" for current employees 
-- who are eligible to participate in a mentorhsip program
SELECT DISTINCT ON (em.emp_no) em.emp_no, em.first_name, em.last_name, em.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_eligibility
FROM employees as em 
JOIN dept_emp as de using (emp_no)
JOIN titles as ti using (emp_no)
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (ti.to_date = '9999-01-01')
ORDER BY em.emp_no, de.to_date DESC;