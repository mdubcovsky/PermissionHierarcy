CREATE OR REPLACE FORCE VIEW PRIVILEGE_ASSIGNMENT_TREE (
  PRIVILEGE_ID, PARENT_PRIVILEGE_ID, ASSIGNED_PRIVILEGE_ID, 
  AUTHORIZING_USER, ASSIGNMENT_DATE, EXPIRATION_DATE, ENABLED, 
  PATH_ASSIGNMENT_DATE, PATH_EXPIRATION_DATE, PATH_ENABLED, 
  TREE_PATH, TREE_DEPTH
) AS 
  with privilegeGraph(
    privilege_id, parent_privilege_id, assigned_privilege_id, 
    authorizing_user, assignment_date, expiration_date, enabled, 
    path_assignment_date, path_expiration_date, path_enabled, 
    tree_path, tree_depth
  ) as (
    select 
      privilege_id, null, assigned_privilege_id, 
      authorizing_user, assignment_date, expiration_date, enabled, 
      assignment_date, expiration_date, enabled,
      '/', 0
    from privilege_assignment
    union all
    select 
      privilegeGraph.privilege_Id, privilegeGraph.assigned_privilege_Id, privilege_assignment.assigned_privilege_id,
      privilegeGraph.AUTHORIZING_USER,
      GREATEST(privilegeGraph.ASSIGNMENT_DATE , privilege_assignment.ASSIGNMENT_DATE), 
      COALESCE(
        LEAST(privilegeGraph.EXPIRATION_DATE, privilege_assignment.EXPIRATION_DATE), 
        privilegeGraph.EXPIRATION_DATE,  
        privilege_assignment.EXPIRATION_DATE
      ),
      case when privilegeGraph.ENABLED='N' or privilege_assignment.ENABLED='N' then 'N' else 'Y' end,
      privilegeGraph.assignment_date, privilegeGraph.expiration_date, privilegeGraph.enabled, 
      privilegeGraph.tree_path || privilege_assignment.privilege_id || '/', 
      tree_depth + 1
    from privilegeGraph 
    inner join privilege_assignment 
      on privilegeGraph.assigned_privilege_id = privilege_assignment.privilege_id 
      and privilegeGraph.privilege_id != privilege_assignment.assigned_privilege_id  
  ) 
  cycle assigned_privilege_id set is_cycle to '1' default '0'
  select 
    privilege_id, parent_privilege_id, assigned_privilege_id, 
    authorizing_user, assignment_date, expiration_date, enabled,
    path_assignment_date, path_expiration_date, path_enabled, tree_path, tree_depth
  from privilegeGraph 
  where is_cycle=0;
