locals {
  db_password = random_password.db.result
  db_username = "admin${random_integer.db_user.id}"
  db_endpoint = element((split(":3306", module.db.db_instance_endpoint)), 0)
}