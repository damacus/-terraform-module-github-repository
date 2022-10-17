resource "github_repository" "this" {
  name         = var.name
  description  = local.description
  homepage_url = local.homepage_url

  allow_auto_merge       = true
  allow_merge_commit     = false
  allow_squash_merge     = true
  allow_rebase_merge     = false
  archived               = false
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  has_downloads          = false
  topics                 = local.topics
  auto_init              = true
  license_template       = "apache-2.0"
  visibility             = "public"
  vulnerability_alerts   = true
}

resource "github_branch" "default" {
  repository = github_repository.this.name
  branch     = "main"
}

resource "github_branch_default" "default" {
  repository = github_repository.this.name
  branch     = github_branch.default.branch
}

resource "github_branch_protection" "default" {
  repository_id = github_repository.this.node_id
  pattern       = github_branch.default.branch

  # when a repo is being initialized/created you can run into race conditions
  # by adding an explicit depends we force the repo to be created
  # before it attempts to add branch protection
  depends_on = [github_repository.this]

  required_status_checks {
    strict   = true
    contexts = local.status_checks
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = var.require_code_owner_reviews
  }
}

resource "github_team_repository" "maintainer_access" {
  team_id    = "maintainers"
  repository = github_repository.this.name
  permission = "push"
}

resource "github_team_repository" "bot_access" {
  team_id    = "bots"
  repository = github_repository.this.name
  permission = "admin"
}

resource "github_team_repository" "board_access" {
  team_id    = "board"
  repository = github_repository.this.name
  permission = "admin"
}
