# english_department_alignment_data

The English department wanted a way to easily few and explore the teachers' 3rd Quarter grades in order to check alignment of teachers and grade levels. To this end, I created a spreadsheet that organized this data, grouped the data into meaningful tables targeted to different kinds of alignment, and created hyperlinked filter headings so teachers could easily explore the data. In addition, I noted trends and outliers of teachers/year groups (called "PLCs") so that those trends could be part of the larger conversation.

See table (with names anonymized) [here](https://docs.google.com/spreadsheets/d/1H8QVicUVMw2CJtSc81BcSP1rktogyKEM6NhxcU5mEhE/edit?usp=sharing). You can find the SQl queries that created this data under 'department_queries_for_dashboard'.

## SQL Functions Used:

### SQL Basics
* Essentials: `SELECT`, `FROM`, `WHERE`
* Grouping: `GROUP BY`, `WITH ROLLUP`
* Viewing/Aliases: `ORDER BY`, `AS`
* Basic Operators: `=`, `<`, `>`, `!=`, `%`
* Basic Arithmetic: `+`, `-`, `*`, `/`

### Aggregate Functions
* Basic Aggregation: `COUNT()`, `AVG()`, `SUM()`
* Aggregation Support: `ROUND()`,`WITH ROLLUP` 

### Joins & Condition Expressions
* Joins: `LEFT JOIN`, `USING()`
* Conditional Logic: `CASE WHEN ... THEN ... ELSE ... END`
* Pattern Matching: `LIKE`, `NOT LIKE`


