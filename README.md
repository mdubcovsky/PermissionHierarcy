# PermissionHierarcy

This is an example project for creating a hierarchical access control structure.

It demonstrate use of ORACLE's hierarchical query strategies to flat the graph structure and resolve cycles.



# Architecture

There are three concepts in the system: Users, Roles, and privileges.
Since membership in a role can be seen as a kind of privilege in of itself, Roles are implemented as a special case of privileges.

Concretely these concepts are implemented in two tables:
 1. Users - (LOGIN_ID, NAME) [users.sql](Users.sql)  
 1. Privileges - (ID, DESCRIPTION) [privileges.sql](Privileges.sql)
 
In a practice, these tables would likely be much richer.


Users are assigned privileges. This is maintained in the table:
  USER_ASSIGNMENT [UserAssignments.sql](UserAssignments.sql)
  
Roles are also assigned privileges. This is maintained in the table:
  PRIVILEGE_ASSIGNMENT [PrivilegeAssignments.sql](PrivilegeAssignments.sq)
  
The recursive nature of privilege assignment is explored in two views:
 1. USER_ASSIGNMENT_TREE [UserAssignmentGraph.sql](UserAssignmentGraph.sql)
 1. PRIVILEGE_ASSIGNMENT_TREE [PrivilegeAssignmentGraph.sql](PrivilegeAssignmentGraph.sql)

While the architecture allows for cycles to be created, the two view above terminate recursion when they encounter an cyclic edge.
