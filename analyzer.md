# Interactions between API and Analyzer

## Overview

Communication between `API service` and `analyzer service` is carried out using [AMQP 0-9-1](http://www.amqp.org/specification/0-9-1/amqp-org-download) and [RabbitMQ](https://www.rabbitmq.com) as message broker. `API service` creates [virtual host](https://www.rabbitmq.com/vhosts.html) inside RabbitMQ with name `analyzer` on start. Analyzers in theirs turn connect to the virtual host and declare exchange with name and arguments. Any type of request from `API` and response from `analyzer` stores in the same queue.  

![](/images/analyzer/api-analyzer.png)

## Declaring exchange

Each analyzer has to declare direct exchange with the following arguments:

- `analyzer` - Name of analyzer (string)
- `version` - Analyzer version (string)
- `analyzer_index` - Is indexing supported (boolean)
- `analyzer_log_search` - Is log searching supported (boolean)
- `analyzer_priority` - Priority of analyzer (number)

![](/images/analyzer/exchange.png)




