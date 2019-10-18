# Rerun dev guide

## Start launch rerun

### Latest launch

To start launch rerun set `rp.rerun=true` in `reportportal.properties` file. In case properties file contains the value client send request with object `"rerun": true`:
```json
{
    "name": "launch_name",
    "description": "some description",
    "mode": "DEFAULT",
    "rerun": true
}
```

System tries to find the latest launch on the project with same name as in request. If launch found system updates the following attributes if they are present in request:
- Mode
- Description
- Attributes
- UUID
- Status = `IN_PROGRESS` 

and returns response containing found launch id and number:
```json
{
  "id": "89f6d409-bee0-428e-baca-4848f86c06e7",
  "number": 4
}
```

If system cannot find launch with the same name system throw error with `404` code.

### Specified launch

To start launch rerun set `rp.rerun=true` and `rp.rerun.of=launch_uuid` in `reportportal.properties` file where `launch_uuid` uuid of launch that have to be reruned.

## Test Items

### Container types (has children)

System tries to find item with the same name, set of parameters and under the same path. If such item found, system updates the following attributes:

- Description
- UUID
- Status = `IN_PROGRESS`
 
If not - new item will be created.

### Step types (without children)

System tries to find item with the same name, set of parameters and under the same path. If such item found, retry created. If not - new item will be created.

You can try to rerun launch [here](https://github.com/reportportal/examples-java)










