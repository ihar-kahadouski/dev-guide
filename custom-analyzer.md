# API - Analyzer interactions

## Overview

Communication between `API service` and `analyzer service` is carried out using [AMQP 0-9-1](http://www.amqp.org/specification/0-9-1/amqp-org-download) and [RabbitMQ](https://www.rabbitmq.com) as message broker. `API service` creates [virtual host](https://www.rabbitmq.com/vhosts.html) inside RabbitMQ with name `analyzer` on start. Analyzers connect to the virtual host in theirs turn. Any type of request from `API` and response from `analyzer` stores in the same queue.  

![](/images/analyzer/api-analyzer.png)

