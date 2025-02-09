# Create a new Auth0 application for OIDC authentication
resource "auth0_client" "k3s_oidc" {
  name                = "K3S"
  description         = "My Cool App Client Created Through Terraform"
  app_type            = "spa"
  callbacks           = ["http://localhost:8000"]
  cross_origin_auth   = true
  oidc_conformant     = true
  grant_types = [
    "authorization_code"
  ]

  jwt_configuration {
    alg = "RS256"
  }
}
