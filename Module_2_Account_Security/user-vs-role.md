|                                                               | Root user             | IAM user  | IAM role  |
| ------------------------------------------------------------- | --------------------- | --------- | --------- |
| Can have a password (needed to log into AWS Console)          | Alway                 | Yes       | No        |
| Can have access keys (needed to send requests to the AWS API) | Yes (not recommended) | Yes       | No        |
| Can belong to a group                                         | No                    | Yes       | No        |
| Can associated with an EC2 instance                           | No                    | No        | Yes       |

By default, users and roles can't do anything. You have to create a *policy* stating what actions they are allowed to perform.