# Reporting developers guide

## Oveview

Let's imagine we have the following tests structure:

```
(Suite) Services
    (Test) PluginServiceTest
        (Step) uploadPlugin
        (Step) updatePlugin
        (Step) removePlugin
    (Test) UserServiceTest
        (Step) createUser
        (Step) updateUser
        (Step) deleteUser
``` 

So our goal is run the test and send results to Report Portal.
We can interact with Report Portal API instance trough HTTP requests.

The main flow is set of HTTP requests:
1. Start launch
2. Start test item 
3. Save log with attachment if necessary
4. Finish test item
5. Finish launch

Steps 2-4 should execute for each test item in structure.

## Preconditions 

Let's assume that our Report Portal instance deployed at `http://rp.com`.
And we have api key `039eda00-b397-4a6b-bab1-b1a9a90376d1`. You can find it in profile (`http://rp.com/ui/#user-profile`).
And our project name is `rp_project`.


## Start launch

To start launch you should send request to the following endpoint:
POST `/api/{version}/{projectName}/launch`

Start launch request model contains the following attributes:

|  Attribute  | Required | Description                                                              | Default value       | Examples                                                                                                                                                             |
|:-----------:|----------|--------------------------------------------------------------------------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| name        | Yes      | Name of launch                                                           | -                   | AutomationRun                                                                                                                                                        |
| startTime   | Yes      | Launch start time                                                        | -                   | 2019-11-22T11:47:01+00:00 (ISO 8601) Fri, 22 Nov 2019 11:47:01 +0000 (RFC 822, 1036, 1123, 2822) 2019-11-22T11:47:01+00:00 (RFC 3339) 1574423221000 (Unix Timestamp) |
| description | No       | Description of launch                                                    | empty               | Services tests                                                                                                                                                       |
| uuid        | No       | Launch uuid (string identificator)                                       | auto generated UUID | 69dc75cd-4522-44b9-9015-7685ec0e1abb                                                                                                                                 |
| attributes  | No       | Launch attributes(tags). Pairs of key and value                          | empty               | build:3.0.1 os:bionic                                                                                                                                                |
| mode        | No       | Launch mode. Allowable values 'default' or 'debug'                       | default             | DEFAULT                                                                                                                                                              |
| rerun       | No       | Rerun mode. Allowable values 'true' of 'false'                           | false               | false                                                                                                                                                                |
| rerunOf     | No       | Rerun mode. Specifies launch to be reruned. Uses with 'rerun' attribute. | empty               | 694e1549-b8ab-4f20-b7d8-8550c92431b0                                                                                                                                 |

Start launch response contains the following attributes:

| Attribute | Required | Description              | Examples                             |
|-----------|----------|--------------------------|--------------------------------------|
| id        | Yes      |  UUID of created launch  | 1d1fb22e-01f7-4ac9-9ebc-f020d8fe93ff |
| number    | No       | Number of created launch | 1                                    |

So full request to start our launch looks like 

```shell script
curl --header "Content-Type: application/json" \
     --header "Authorization: Bearer 039eda00-b397-4a6b-bab1-b1a9a90376d1" \
     --request POST \
     --data 'body' \
     http://rp.com/api/v1/rp_project/launch
```

Where body is the following json:

```json
{
   "name": "rp_launch",
   "description": "My first launch on RP",
   "startTime": "1574423221000",
   "mode": "DEFAULT",
   "attributes": [
     {
       "key": "build",
       "value": "0.1"
     },
     {
       "value": "test"
     }   
   ] 
 }
```

In the response we can see `id` and `number` if launch started successfully or an error if something went wrong. 

```json
{
  "id": "96d1bc02-6a3f-451e-b706-719149d51ce4",
  "number": 1
}
```
Value of `id` field should save somewhere. It will be used later to report test items.

## Start suite(root) item

Now we have created launch and can report items under it.
To start root item you should send request to the following endpoint:
POST `/api/{version}/{projectName}/item`

Start test item request model contains the following attributes:

| Attribute   | Required | Description                                                                                                                                                                                                                                         | Default value  | Examples                                                                                                                                                             |
|-------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| name        | Yes      | Name of test item                                                                                                                                                                                                                                   | -              | Logging Tests                                                                                                                                                        |
| startTime   | Yes      | Test item start time                                                                                                                                                                                                                                | -              | 2019-11-22T11:47:01+00:00 (ISO 8601) Fri, 22 Nov 2019 11:47:01 +0000 (RFC 822, 1036, 1123, 2822) 2019-11-22T11:47:01+00:00 (RFC 3339) 1574423221000 (Unix Timestamp) |
| type        | Yes      | Type of test item. Allowable values: "suite", "story", "test", "scenario", "step", "before_class", "before_groups", "before_method", "before_suite",      "before_test", "after_class", "after_groups", "after_method", "after_suite", "after_test" | -              | suite                                                                                                                                                                |
| launchUuid  | Yes      | Parent launch UUID                                                                                                                                                                                                                                  | -              | 96d1bc02-6a3f-451e-b706-719149d51ce4                                                                                                                                 |
| description | No       | Test item description                                                                                                                                                                                                                               | empty          | Tests of loggers                                                                                                                                                     |
| attributes  | No       | Test item attributes(tags). Pairs of key and value                                                                                                                                                                                                  | empty          | most failed os:android                                                                                                                                               |
| uuid        | No       | Test item UUID                                                                                                                                                                                                                                      | auto generated | e9ca837e-966c-412e-bf8b-e879510d99d5                                                                                                                                 |
| codeRef     | No       | Physical location of test item                                                                                                                                                                                                                      | empty          | com.rpproject.tests.LoggingTests                                                                                                                                     |
| parameters  | No       | Set of parameters (for parametrized tests)                                                                                                                                                                                                          | empty          | logger:logback                                                                                                                                                       |
| uniqueId    | No       |                                                                                                                                                                                                                                                     | auto generated | auto:cd5a6c616d412b6739738951c922377f                                                                                                                                |
| retry       | No       | Uses to report retry of test. Allowable values: 'true' or 'false'                                                                                                                                                                                   | false          | false                                                                                                                                                                |
| hasStats    | No       |                                                                                                                                                                                                                                                     | true           | true                                                                                                                                                                 |

Start test item response contains the following attributes:

| Attribute | Required | Example                              |
|-----------|----------|--------------------------------------|
| id        | Yes      | 7189ec02-4c36-4e36-9f90-5a9b31dcbdba |

So full request to start suite test looks like

 ```shell script
curl --header "Content-Type: application/json" \
     --header "Authorization: Bearer 039eda00-b397-4a6b-bab1-b1a9a90376d1" \
     --request POST \
     --data 'body' \
     http://rp.com/api/v1/rp_project/item
```

Where body is the following json:

```json
{
  "name": "Services",
  "startTime": "1574423234000",
  "type": "suite",
  "launchUuid": "96d1bc02-6a3f-451e-b706-719149d51ce4",
  "description": "Services tests"
}
```

And in the response we get `id` of created test item:

```json
{
  "id": "1e183148-c79f-493a-a615-2c9a888cb441"
}
```

Also we should save it to report child items under this one







