#################
### Variables ###
#################

### General ###

# New Relic Account ID
variable "NEW_RELIC_ACCOUNT_ID" {
  type = string
}

# New Relic API Key
variable "NEW_RELIC_API_KEY" {
  type = string
}

# New Relic Region
variable "NEW_RELIC_REGION" {
  type = string
}
######

# Cluster Name
variable "app_name" {
  type = string
}

# Workflow Enrichment
variable "enable_enrichments" {
  type = bool
}
