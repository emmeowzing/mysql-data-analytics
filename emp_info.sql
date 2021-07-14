use employees;

drop procedure if exists emp_info;

delimiter $$

create procedure emp_info(in first_name varchar(10), in last_name varchar(12), out employee_no int)
begin
	select 
		e.emp_no
	into 
		employee_no
    from
		employees e
	where
		e.first_name = first_name and e.last_name = last_name;
end$$

delimiter ;