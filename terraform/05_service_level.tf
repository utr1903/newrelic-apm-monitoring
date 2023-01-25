#####################
### Service Level ###
#####################

# Web latency
resource "newrelic_service_level" "app_web_latency" {
  guid        = data.newrelic_entity.app.guid
  name        = "Web Latency"
  description = "Proportion of web transactions that are performed slower than a threshold."

  events {
    account_id = var.NEW_RELIC_ACCOUNT_ID

    valid_events {
      from = "Transaction"
      select {
        function = "COUNT"
      }
      where = "entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web'"
    }

    bad_events {
      from = "Transaction"
      select {
        function = "COUNT"
      }
      where = "entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' AND duration > 0.1"
    }
  }

  objective {
    target = 99.00

    time_window {
      rolling {
        count = 7
        unit  = "DAY"
      }
    }
  }
}

# Non-web latency
resource "newrelic_service_level" "app_non_web_latency" {
  guid        = data.newrelic_entity.app.guid
  name        = "Non-web Latency"
  description = "Proportion of non-web transactions that are performed slower than a threshold."

  events {
    account_id = var.NEW_RELIC_ACCOUNT_ID

    valid_events {
      from  = "Transaction"
      where = "entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other'"
    }

    bad_events {
      from  = "Transaction"
      where = "entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' AND duration > 0.1"
    }
  }

  objective {
    target = 99.00

    time_window {
      rolling {
        count = 7
        unit  = "DAY"
      }
    }
  }
}
