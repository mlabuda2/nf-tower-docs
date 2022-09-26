# Administration of Users, Organizations, and Memberships

As a **Root User**, you can access a comprehensive overview of the users and organizations in the system from the **Admin Panel**.

The Admin Panel menu entry will only be accessible in the top right avatar menu if you are logged in as a Root user. This role should only be assigned to a system administrator, since it enables several high level and potentially risky operations.

## Users Administration

![](_images/manage_orgs_button.png)

The Users administration page lists all the users in the Tower database. From this page, you can:

### Search Users
The user search function allows you to find a specific user by name or email and perform various operations with that user.

### Create a User
The Add User button in the top right corner above the table allows you to create a new user from scratch. If the new user email already exists in the system, the user creation will fail. Once the new user has been created, inform them that access has been granted.

### Edit a User

![](_images/edit_user.png)

By selecting a username from the table, you can edit some of the user details, or delete the user.


### Membership Administration 

**Available from version 22.3.X**

![](_images/organization_members.png)

From the user list, you have an overview of all the memberships for a selected user. The Membership administration page can be reached by selecting the **Edit Organizations** button. From here, you can list and search for all the organizations the user belongs to (as a member or as an owner), change the role of the user for a given membership, remove the user from an organization, and add the user to a new organization. 

**Note:** You can only add users to an existing organization, and you cannot remove the last owner of an organization.

## Organizations Administration

![](_images/organization_administration.png)

The Organization administration page lists all the organizations in the Tower database. From this page, you can:

### Search Organizations
The organization search function allows you to find a specific organization by its name or email and perform various operations with that organization.

### Create an Organization
The Create Organization button in the top right corner above the table allows you to create a new organization from scratch.

### Edit an Organization

![](_images/edit_organization.png)

By selecting an organization name from the table, you can edit some of the organization details, or delete it.


### Membership Administration 

**Available from version 22.3.X**

![](_images/organization_members.png)

From the organizations list, you have an overview of all the memberships for the selected organization. Select the **Manage User** button to access the Membership administration page. From here, you can list and search for all the users that are members or owners of the selected organization, change the role of the user for the given membership, remove the member from the organization, and add a new user to the organization.

**Note:** You can only add existing users to an organization, and you cannot remove a membership if the user being removed is the last owner of the selected organization. To overcome this, promote another user to **Owner** before removing or demoting the last owner.