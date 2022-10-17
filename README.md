# Terraform Module GitHub Repository

## Example Usage

The following example loops through the Json below and creates a repository and
checks for each.

```json
{
  "repository": [{
      "name": "apache2",
      "repo_type": "cookbook"
    },
    {
      "name": "apparmor",
      "repo_type": "cookbook",
       "additional_status_checks": [
        "integration-macos",
        "integration-freebsd"
      ]
    },
    {
      "name": "meta",
      "repo_type": "other",
      "description_override": "Discussion about Sous Chefs"
    }]
}
```

```hcl
module "repository" {
  for_each                  = { for repo in var.repository : repo.name => repo }
  source                    = "./modules/repository"
  name                      = each.value.name
  repo_type                 = each.value.repo_type
  supermarket_name_override = each.value.supermarket_name_override
  description_override      = each.value.description_override
  homepage_url_override     = each.value.homepage_url_override
  additional_topics         = each.value.additional_topics
  additional_status_checks  = each.value.additional_status_checks != null ? each.value.additional_status_checks : []
  projects_enabled          = each.value.projects_enabled
}
```
