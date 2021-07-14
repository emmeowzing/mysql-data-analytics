use employees;

delimiter $$

create procedure average_employee_salary()
begin
	select
		avg(salary) as avg_salary
	from
		salaries;
end $$

delimiter ;