use employees;

delimiter $$

drop function if exists f_avg_salary;

create functuion f_avg_salary(employee_no int) returns decimal(10, 2)
begin
	declare v_average_salary decimal(10, 2);
    
    select
		round(avg(s.salary), 2)
	from
		salaries s
	where
		s.emp_no = employee_no;
        
	return v_average_salary;
end$$

delimiter ;