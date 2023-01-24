############
### Data ###
############

data "newrelic_entity" "app" {
  name   = var.app_name
  domain = "APM"
  type   = "APPLICATION"

  tag {
    key   = "accountID"
    value = var.NEW_RELIC_ACCOUNT_ID
  }
}
