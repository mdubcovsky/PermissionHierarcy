
--Select all users who are members of a particular privilege
--either through direct assignment, or inherited permission
select *
from EFFECTIVE_USER_PRIVILEGES
where assigned_privilege_id = :PrivilegeId;

--Select all roles that are members of a particular privilege
--either through direct assignment, or inherited permission
select *
from EFFECTIVE_PRIVILEGE_PRIVILEGES
where assigned_privilege_id = :PrivilegeId;