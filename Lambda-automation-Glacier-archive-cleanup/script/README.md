## How to use the script

The script requires two arguments.
1. An input json file generated with the aws cli command below. output.json is an inventory of the vault. Refer to this [aws doc](https://docs.aws.amazon.com/amazonglacier/latest/dev/deleting-vaults-cli.html#Deleting-A-Nonempty-Vaults-CLI-Implementation)
~~~
    aws glacier get-job-output --vault-name <vault_name> --account-id <account-id> --job-id <jobID> output.json
~~~
2. The number of files to split the archive ids into
##### Script Usage:

~~~
    python generate_split_files.py -i <json_file> -n <num_split_files>
~~~
Example:
~~~
    python generate_split_files.py -i output.json -n 19
~~~

This is a sample of a successfull execution of the script for reference
![Script execution](https://github.com/yemisprojects/lambda-delete-glacier-archives/blob/main/images/Sample_script_usage_run.png)
