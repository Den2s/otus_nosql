CREATE TABLE employees (
    employee_id serial PRIMARY KEY,
    full_name VARCHAR NOT NULL,
    manager_id INT
);
INSERT INTO employees (
    employee_id,
    full_name,
    manager_id
)
VALUES
    (1, 'M.S Dhoni', NULL),
    (2, 'Sachin Tendulkar', 1),
    (3, 'R. Sharma', 1),
    (4, 'S. Raina', 1),
    (5, 'B. Kumar', 1),
    (6, 'Y. Singh', 2),
    (7, 'Virender Sehwag ', 2),
    (8, 'Ajinkya Rahane', 2),
    (9, 'Shikhar Dhawan', 2),
    (10, 'Mohammed Shami', 3),
    (11, 'Shreyas Iyer', 3),
    (12, 'Mayank Agarwal', 3),
    (13, 'K. L. Rahul', 3),
    (14, 'Hardik Pandya', 4),
    (15, 'Dinesh Karthik', 4),
    (16, 'Jasprit Bumrah', 7),
    (17, 'Kuldeep Yadav', 7),
    (18, 'Yuzvendra Chahal', 8),
    (19, 'Rishabh Pant', 8),
    (20, 'Sanju Samson', 8);

WITH RECURSIVE subordinates AS (
    SELECT
        e.employee_id,
        e.manager_id,
        e2.full_name as manager_name,
        e.full_name
    FROM
        employees as e left join employees as e2 on e.manager_id = e2.employee_id 
    WHERE
        e.employee_id = 1
    UNION
        SELECT
            e.employee_id,
            e.manager_id,
            s.full_name as manager_name,
            e.full_name
        FROM
            employees e
        INNER JOIN subordinates s ON s.employee_id = e.manager_id
) SELECT * FROM
    subordinates;