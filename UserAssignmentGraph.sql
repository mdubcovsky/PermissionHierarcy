
CREATE OR REPLACE FORCE VIEW USER_ASSIGNMENT_TREE (
  "LOGIN_ID", "PARENT_PRIVILEGE_ID", "ASSIGNED_PRIVILEGE_ID", 
  "AUTHORIZING_USER", "ASSIGNMENT_DATE", "EXPIRATION_DATE", "ENABLED", 
  "PATH_ASSIGNMENT_DATE", "PATH_EXPIRATION_DATE", "PATH_ENABLED", 
  "TREE_PATH", "TREE_DEPTH"
) AS 
  select login_id, null parent_privilege_id, assigned_privilege_id, 
    AUTHORIZING_USER,ASSIGNMENT_DATE, EXPIRATION_DATE, ENABLED, 
    ASSIGNMENT_DATE path_assignment_date, EXPIRATION_DATE path_expiration_date, ENABLED path_enabled,
    '/' tree_path, 0 tree_depth
    from user_assignment
  union
  select login_id, 
    coalesce(PRIVILEGE_ASSIGNMENT_TREE.parent_privilege_id, user_assignment.assigned_privilege_id) parent_privilege_id, 
    PRIVILEGE_ASSIGNMENT_TREE.ASSIGNED_PRIVILEGE_ID, 
    user_assignment.AUTHORIZING_USER,
    greatest(user_assignment.ASSIGNMENT_DATE, PRIVILEGE_ASSIGNMENT_TREE.ASSIGNMENT_DATE) ASSIGNMENT_DATE,
    coalesce(least(user_assignment.EXPIRATION_DATE, PRIVILEGE_ASSIGNMENT_TREE.EXPIRATION_DATE), user_assignment.EXPIRATION_DATE,PRIVILEGE_ASSIGNMENT_TREE.EXPIRATION_DATE) EXPIRATION_DATE,
    case when user_assignment.ENABLED='N' or PRIVILEGE_ASSIGNMENT_TREE.ENABLED='N' then 'N' else 'Y' end,    
    greatest(user_assignment.ASSIGNMENT_DATE, PRIVILEGE_ASSIGNMENT_TREE.PATH_ASSIGNMENT_DATE),
    coalesce(least(user_assignment.EXPIRATION_DATE, PRIVILEGE_ASSIGNMENT_TREE.PATH_EXPIRATION_DATE), user_assignment.EXPIRATION_DATE,PRIVILEGE_ASSIGNMENT_TREE.PATH_EXPIRATION_DATE), 
    case when user_assignment.ENABLED='N' or PRIVILEGE_ASSIGNMENT_TREE.PATH_ENABLED='N' then 'N' else 'Y' end ,
    '/' || user_assignment.assigned_privilege_id || PRIVILEGE_ASSIGNMENT_TREE.tree_path,
    1+ tree_depth
  from user_assignment
  inner join PRIVILEGE_ASSIGNMENT_TREE on user_assignment.assigned_privilege_id=PRIVILEGE_ASSIGNMENT_TREE.privilege_id;


