locals {
    koodoo = jsondecode(file("${path.module}/${var.koodoo_json}"))
}

data mongodbatlas_clusters this {
  project_id = var.mongdbatlas_project_id
}

data mongodbatlas_cluster this {
  for_each = toset(data.mongodbatlas_clusters.this.results[*].name)

  project_id = var.mongdbatlas_project_id
  name       = each.value
}

resource random_password store-service-password {
  for_each           = { for v in local.koodoo : v.serviceName => v }

  length             = var.password_length
  special            = true
  override_special   = var.password_special_chars
}

resource mongodbatlas_database_user store-service-user {

  for_each           = { for v in local.koodoo : v.serviceName => v }
  
  project_id         = var.mongdbatlas_project_id
  
  username           = each.key 
  password           = "${random_password.store-service-password[each.key].result}"
  auth_database_name = "admin"

  # Create the right role (read only permissions) for this user and service
  dynamic roles {
    for_each = each.value.mongoCollection[*]
    content {
      role_name       = "read"
      database_name   = each.value.mongoDatabase
      collection_name = roles.value
    }
  }
}

#output "show_clusters" {
#    value = data.mongodbatlas_clusters.this
#}

#output "show_cluster" {
#    value = data.mongodbatlas_cluster.this
#}

#output "koodoo" {
#    value = local.koodoo
#}

output "connection_strings" {
    # mongodb+srv://[username]:[password]@[cluster]/[db]/[collection]
    value = flatten([
        for v in local.koodoo : [
            for x in v.mongoCollection : 
                "mongodb+srv://${v.serviceName}:${random_password.store-service-password[v.serviceName].result}@${v.mongoCluster}/${v.mongoDatabase}/${x}"
            ]
    ])
    sensitive = true
}
