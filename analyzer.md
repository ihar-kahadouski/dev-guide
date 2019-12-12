# Interactions between API and Analyzer

1. [Overview](#overview)
1. [Declaring exchange](#declaring-exchange)

## Overview

Communication between `API service` and `analyzer service` is carried out using [AMQP 0-9-1](http://www.amqp.org/specification/0-9-1/amqp-org-download) and [RabbitMQ](https://www.rabbitmq.com) as message broker. `API service` creates [virtual host](https://www.rabbitmq.com/vhosts.html) inside RabbitMQ with name `analyzer` on start. Analyzers in theirs turn connect to the virtual host and declare exchange with name and arguments. Any type of request from `API` and response from `analyzer` stores in the same queue.  

![](/images/analyzer/api-analyzer.png)

## Declaring exchange

Each analyzer has to declare direct exchange with the following arguments:

- `analyzer` - Name of analyzer (string)
- `version` - Analyzer version (string)
- `analyzer_index` - Is indexing supported (boolean, false by default)
- `analyzer_log_search` - Is log searching supported (boolean, false by default)
- `analyzer_priority` - Priority of analyzer (number). The lower the number, the higher the priority. 

![](/images/analyzer/exchange.png)

## Declaring queues

Each analyzer has to declare 5 queues with names: `analyze`, `search`, `index`, `clean`, `delete`.

![](/images/analyzer/queues.png)

### Indexing







