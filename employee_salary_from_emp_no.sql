use employees;

drop procedure if exists employee_salary; -- reset

delimiter $$

create procedure employee_salary(in p_emp_no int)
begin
	select 
		e.first_name, e.last_name, s.salary, s.from_date, s.to_date
	from
		employees e
			join
		salaries s
			on
			e.emp_no = s.emp_no
	where
		e.emp_no = p_emp_no
	order by s.salary;
end$$

delimiter ;