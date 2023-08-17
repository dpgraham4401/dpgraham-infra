# iam.tf creates the global IAM policies for the organization
# It was initially generated by the GCP organization setup tool
# resource names follow a convention of <principal>-<resource>-<optional description>
# for example, for a given principal (usually a group), we assign a list of roles for a given resource


# We use the terraform-google-modules GitHub organization, specifically the iam repo and its TF modules
# they expose modules to declare IAM policies for organizations, folders, projects, etc.
# https://github.com/terraform-google-modules/terraform-google-iam
# Just remember that roles are inherited, if we assign a role to a folder,
# it will be inherited by all projects and resources under that folder

# Not all polies are managed by terraform, such as billing account permissions and organization ownership
# These are managed manually to ensure that we don't accidentally remove them with `terraform destroy`

module "developer-folder-nonprod" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.envs.ids["Non-Production"],
  ]
  bindings = {
    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@dpgraham.com",
    ]
    "roles/container.admin" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

module "developers-folders-dev" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.envs.ids["Development"],
  ]
  bindings = {
    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@dpgraham.com",
    ]
    "roles/container.admin" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

module "devops-folder-dev" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.envs.ids["Development"],
  ]
  bindings = {
    "roles/cloudsql.admin" = [
      "group:gcp-devops@${var.primary_domain}",
    ]
    "roles/editor" = [
      "group:gcp-devops@${var.primary_domain}",
    ]
  }
}

## IAM permissions related to the logging project

#module "projects-iam-2-loggingviewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/logging.viewer" = [
#      "group:gcp-logging-viewers@dpgraham.com",
#    ]
#  }
#}
#
#module "projects-iam-2-loggingprivateLogViewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/logging.privateLogViewer" = [
#      "group:gcp-logging-viewers@dpgraham.com",
#    ]
#  }
#}
#
#module "projects-iam-2-bigquerydataViewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/bigquery.dataViewer" = [
#      "group:gcp-logging-viewers@dpgraham.com",
#    ]
#  }
#}
#
#module "projects-iam-3-bigquerydataViewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/bigquery.dataViewer" = [
#      "group:gcp-security-admins@dpgraham.com",
#    ]
#  }
#}