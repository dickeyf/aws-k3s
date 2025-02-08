resource "auth0_role" "cluster_admin_role" {
  name        = "cluster-admin"
  description = "K3S Cluster Administrator"
}


# Create an admin user
resource "auth0_user" "cluster_admin_user" {
  connection_name = "Username-Password-Authentication"
  name            = "Test Admin"
  email           = "admin@mycluster.com"
  email_verified  = true
  password        = var.default_password
}

# Assign roles to the admin user
resource "auth0_user_roles" "admin_user_roles" {
  user_id = auth0_user.cluster_admin_user.id
  roles   = [auth0_role.cluster_admin_role.id]
}
