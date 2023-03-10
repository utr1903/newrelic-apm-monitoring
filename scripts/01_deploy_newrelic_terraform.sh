#!/bin/bash

# Get commandline arguments
while (( "$#" )); do
  case "$1" in
    --destroy)
      flagDestroy="true"
      shift
      ;;
    --dry-run)
      flagDryRun="true"
      shift
      ;;
    --app-name)
      appName="$2"
      shift
      ;;
    --enrich)
      enableEnrichments="true"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

### Check input

# New Relic account ID
if [[ $NEWRELIC_ACCOUNT_ID == "" ]]; then
  echo "Define New Relic account ID as an environment variable [NEWRELIC_ACCOUNT_ID]. For example: -> export NEWRELIC_ACCOUNT_ID=xxx"
  exit 1
fi

# New Relic region
if [[ $NEWRELIC_REGION == "" ]]; then
  echo "Define New Relic region as an environment variable [NEWRELIC_REGION]. For example: -> export NEWRELIC_REGION=us or export NEWRELIC_REGION=eu"
  exit 1
else
  if [[ $NEWRELIC_REGION != "us" && $NEWRELIC_REGION != "eu" ]]; then
    echo "New Relic region can either be 'us' or 'eu'."
    exit 1
  fi
fi

# New Relic API key
if [[ $NEWRELIC_API_KEY == "" ]]; then
  echo "Define New Relic API key as an environment variable [NEWRELIC_API_KEY]. For example: -> export NEWRELIC_API_KEY=xxx"
  exit 1
fi

# Application name
if [[ $appName == "" ]]; then
  echo "Define application name with the flag [--app-name]. For example -> <mydopeappprod>"
  exit 1
fi

# Workflow enrichments
if [[ $enableEnrichments == "" ]]; then
  enableEnrichments="false"
fi

#################
### TERRAFORM ###
#################

if [[ $flagDestroy != "true" ]]; then

  # Initialize Terraform
  terraform -chdir=../terraform init

  # Check if workspace exists
  workspaceExists=$(terraform -chdir=../terraform workspace list \
    | grep -w "$appName")
  
  if [[ $workspaceExists = "" ]]; then
    terraform -chdir=../terraform workspace new "$appName"
  else
    terraform -chdir=../terraform workspace select "$appName"
  fi

  # Plan Terraform
  terraform -chdir=../terraform plan \
    -var NEW_RELIC_ACCOUNT_ID=$NEWRELIC_ACCOUNT_ID \
    -var NEW_RELIC_API_KEY=$NEWRELIC_API_KEY \
    -var NEW_RELIC_REGION=$NEWRELIC_REGION \
    -var app_name=$appName \
    -var enable_enrichments=$enableEnrichments \
    -out "./tfplan"

  # Apply Terraform
  if [[ $flagDryRun != "true" ]]; then
    terraform -chdir=../terraform apply tfplan
  fi
else

  # Check if workspace exists
  workspaceExists=$(terraform -chdir=../terraform workspace list \
    | grep -w "$appName")
  
  if [[ $workspaceExists = "" ]]; then
    echo "Workspace for $appName does not exist!"
    exit 1
  else
    terraform -chdir=../terraform workspace select "$appName"
  fi

  # Destroy Terraform
  terraform -chdir=../terraform destroy \
    -var NEW_RELIC_ACCOUNT_ID=$NEWRELIC_ACCOUNT_ID \
    -var NEW_RELIC_API_KEY=$NEWRELIC_API_KEY \
    -var NEW_RELIC_REGION=$NEWRELIC_REGION \
    -var app_name=$appName \
    -var enable_enrichments=$enableEnrichments

  # Remove workspace
  terraform -chdir=../terraform workspace select "default"
  terraform -chdir=../terraform workspace delete "$appName"
fi
#########
