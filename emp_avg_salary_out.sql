use employees;

drop procedure if exists emp_avg_salary_out;

delimiter $$

create procedure emp_avg_salary_out(in p_emp_no int, out p_avg_salary decimal(10, 2))
begin
	select
		avg(s.salary) as avg_salary
	into
		p_avg_salary
	from
		employees e
			join
		salaries s
			on e.emp_no = s.emp_no
	where
		e.emp_no = p_emp_no;
end$$

delimiter ;