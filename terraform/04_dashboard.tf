#################
### Dashboard ###
#################

# Dashboard - APM
resource "newrelic_one_dashboard" "app" {
  name = "APM | ${var.app_name}"

  ###########
  ### WEB ###
  ###########
  page {
    name = "Web"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 2
      width  = 3

      text = "## Web | ${var.app_name}\nThis page is dedicated to provide insights of overall application performance regarding web transactions."
    }

    # Average web response time (ms)
    widget_billboard {
      title  = "Average web response time (ms)"
      row    = 1
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(apm.service.overview.web*1000) AS `duration` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX) SELECT sum(`duration`) AS `Average web response time (ms)`"
      }
    }

    # Average web throughput (rpm)
    widget_billboard {
      title  = "Average web throughput (rpm)"
      row    = 1
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX"
      }
    }

    # Average web error rate (%)
    widget_billboard {
      title  = "Average web error rate (%)"
      row    = 1
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX"
      }
    }

    # Web response time by segment (ms)
    widget_area {
      title  = "Web response time by segment (ms)"
      row    = 3
      column = 1
      height = 3
      width  = 12

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.overview.web*1000) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX TIMESERIES"
      }
    }

    # Average web throughput (rpm)
    widget_line {
      title  = "Average web throughput (rpm)"
      row    = 6
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX TIMESERIES"
      }
    }

    # Average web error rate (%)
    widget_line {
      title  = "Average web error rate (%)"
      row    = 6
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX TIMESERIES"
      }
    }
  }

  ###############
  ### NON-WEB ###
  ###############
  page {
    name = "Non-Web"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 2
      width  = 3

      text = "## Non-Web | ${var.app_name}\nThis page is dedicated to provide insights of overall application performance regarding non-web transactions."
    }

    # Average non-web response time (ms)
    widget_billboard {
      title  = "Average non-web response time (ms)"
      row    = 1
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(apm.service.overview.other*1000) AS `duration` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX) SELECT sum(`duration`) AS `Average non-web response time (ms)`"
      }
    }

    # Average non-web throughput (rpm)
    widget_billboard {
      title  = "Average non-web throughput (rpm)"
      row    = 1
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average non-web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX"
      }
    }

    # Average non-web error rate (%)
    widget_billboard {
      title  = "Average non-web error rate (%)"
      row    = 1
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average non-web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX"
      }
    }

    # Non-Web response time by segment (ms)
    widget_area {
      title  = "Non-Web response time by segment (ms)"
      row    = 3
      column = 1
      height = 3
      width  = 12

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.overview.other*1000) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX TIMESERIES"
      }
    }

    # Average non-web throughput (rpm)
    widget_line {
      title  = "Average non-web throughput (rpm)"
      row    = 6
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average non-web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX TIMESERIES"
      }
    }

    # Average non-web error rate (%)
    widget_line {
      title  = "Average non-web error rate (%)"
      row    = 6
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average non-web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX TIMESERIES"
      }
    }
  }
}
