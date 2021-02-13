# Challenge 7: Pewlett Hackard Analysis
## Overview of The Pewlett Hackard Analysis
This analysis is in response to a request to identify employees who may be retiring soon and also to identify employees who are eligible to participate in a mentorship program. A number of data base queries and data exports will be prepared for analysis.

## Pewlett Hackard Analysis Results

* ### Extracting employees eligible for retirement
  The first artifact created was a table of employees, with titles, eligible for retirement born between 1952 and 1956.

  **Note:** This table included current and former employees. 

  Here is the query used:
  ```
  SELECT em.emp_no, em.first_name, em.last_name, ti.title, ti.from_date, ti.to_date
  INTO retirement_titles
  FROM employees as em
  INNER JOIN titles as ti
  ON em.emp_no = ti.emp_no
  WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
  ORDER BY em.emp_no;
  ```
  | Sample of Results in *retirement_titles* Table | 
  | --- |
  | ![](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Queries/retirement_titles.png) | 
  Complete set of results are available in [retirement_titles.csv](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Data/retirement_titles.csv)

* ### Refining the list of employees eligible for retirement
  The second artifact removed duplicate titles and empolyees that are not currently active. Where an employee had multiple titles, their current title was selected.

  **Note:** The use of 'DISTINCT ON' in the following query is unneccessary. The 'WHERE' clause to remove the former employees guarantees a single record for each emp_no.

  Here is the query used:
  ```
  SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
  INTO unique_titles
  FROM retirement_titles
  WHERE to_date = '9999-01-01'
  ORDER BY emp_no ASC, to_date DESC;
  ```
  | Sample of Results in *unique_titles* Table | 
  | --- |
  | ![](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Queries/unique_titles.png) | 
  Complete set of results are available in [unique_titles.csv](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Data/unique_titles.csv)
* ### Counts by job title for active eligible retirees
  The third artifact counts, by job title, for all active eligible retirees. 

  Here is the query used:
  ```
  SELECT COUNT(title) as count, title
  INTO retiring_titles
  FROM unique_titles
  GROUP BY title
  ORDER BY count DESC;
  ```

  | Results in *retiring_titles* Table | 
  | --- |
  | ![](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Queries/retiring_titles.png) | 
  Complete set of results are available in [retiring_titles.csv](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Data/retiring_tiles.csv)

* ### Counts by job title for active eligible retirees
  The fourth artifact identifies employees eligible to participate in a mentorship program. Eligibility is limited to current employees born in 1965.

  **Notes for Deliverable 2:** 
  - For step 8, the filter must use the **birth_date** column as the instructions ask for employees **born** in 1965.
  - The table in Step 11 is incorrect as it doesn’t display the **current title** for some employees. 

  Here is the query used:
  ```
  SELECT DISTINCT ON (em.emp_no) em.emp_no, em.first_name, em.last_name, em.birth_date,
  de.from_date, de.to_date, ti.title
  INTO mentorship_eligibility
  FROM employees as em 
  JOIN dept_emp as de using (emp_no)
  JOIN titles as ti using (emp_no)
  WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
  AND (ti.to_date = '9999-01-01')
  ORDER BY em.emp_no, de.to_date DESC;
  ```

  | Sample of Results in *mentorship_eligibility* Table | 
  | --- |
  | ![](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Queries/mentorship_eligibility.png) | 
  Complete set of results are available in [mentorship_eligibility.csv](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Data/mentorship_eligibility.csv)
## Pewlett Hackard Analysis Summary

### Impact analysis on the number of eligible retirees
How many roles will need to be filled as the "silver tsunami" begins to make an impact?

Using the following query:
```
(SELECT 'Current Employee Count' as Category, COUNT(*) FROM dept_emp 
WHERE to_date = '9999-01-01')
UNION
(SELECT 'Eligible To Retire', COUNT(*) FROM unique_titles);
```
Here are the query results:

![](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Queries/Count%20By%20Category.png)

A total of 72,458 employees are eligible to retire. This represents 30.2% of the current active employees. This poses a significant risk to the company operations and a pending loss of institutional knowledge. 
### Potential for mentoring replacements for retirees
Are there enough qualified, retirement-ready employees 
in the departments to mentor the next generation of Pewlett Hackard employees?

Using the following query:
```
SELECT COUNT(*) as "count"
FROM mentorship_eligibility;
```

There are 1,549 potential mentors. With around 72K pending retirements, each mentor would need to take on 47 new hires to maintain the current employment levels.
### Further Analysis

Using the following queries:

| Retirements by Department | Mentors by Deparment | 
| --- | --- |
| ``` SELECT COUNT(ut.emp_no) as "count", de.dept_no, d.dept_name <br> FROM unique_titles as ut JOIN dept_emp as de USING (emp_no) JOIN departments as d USING (dept_no) GROUP BY de.dept_no, d.dept_name ORDER BY de.dept_no ```| ``` SELECT COUNT(me.emp_no) as "count", de.dept_no, d.dept_name FROM mentorship_eligibility as me JOIN dept_emp as de USING (emp_no) JOIN departments as d USING (dept_no) GROUP BY de.dept_no, d.dept_name ORDER BY de.dept_no ``` |
| ![](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Queries/Retirements%20By%20Department.png) | ![](https://github.com/Hala-INTJ/Pewlett-Hackard-Analysis/blob/main/Queries/Mentors%20By%20Department.png)|

This departmental comparison show that some departments have a greater challenger (..a.sdfasdf)
