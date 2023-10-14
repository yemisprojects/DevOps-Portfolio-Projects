<h2 align="center">AWS Serverless Solution to delete Glacier archives</h2>

![Solution diagram](https://github.com/yemisprojects/lambda-delete-glacier-archives/blob/main/images/architecture.png)
<h4 align="center">Architecture digram</h4>

## How does this solution work

This solution requires the vault's archive id's be available in a S3 bucket before invoking the deployed solution. Hence, an inventory of the vault first needs to be obtained. This can be done using the AWS CLI. The vault's archive ids are obtained from the inventory, extracted into a file(s) and uploaded to an S3 bucket. Per the architecture diagram above, once the solution is deployed and invoked a lambda function reads the S3 Bucket and sends messages to a standard SQS queue. Each message references a file in the S3 Bucket. Another lambda function polls the queue and processes the messages to delete the archives in a glacier vault. 

The archive remover lambda function uses a reserved concurrency [(defined here in the cloudformation template)](https://github.com/yemisprojects/lambda-delete-glacier-archives/blob/main/Cloudformation/main_template.yaml#L181) as a way to limit the API call rate to delete the archives. When the lambda function scales on demand due to the queue it can cause significant throttling if there is a large number of archives. 

## When to use this solution
- This solution is more suited for vaults with thousands or millions of archives
- If there is a desire or strict requirement to use a serverless approach this solution can be used
- If there are only a few archives it is probably more ideal to use the AWS Cli or a simple script.

## Prerequisites 

- An AWS account and user with admin permissions
- Install AWS CLI
- Install python 3.x on your local PC.

## High level deployment steps

1. Obtain a json inventory file for the vault to be deleted using this [aws documentation](https://docs.aws.amazon.com/amazonglacier/latest/dev/deleting-vaults-cli.html#Deleting-A-Nonempty-Vaults-CLI-Implementation)
2. Create an S3 bucket using this cloudformation template, [bucket.yaml](https://github.com/yemisprojects/lambda-delete-glacier-archives/blob/main/Cloudformation/main_template.yaml) to store lambda deployment packages
3. Split the archive ids from the json file into any desired number of files using this script, [generate_split_files.py](https://github.com/yemisprojects/lambda-delete-glacier-archives/tree/main/script)
4. Upload the script's generated folder (with included files) from step 3 to the root of the S3 bucket
5. Upload these lambda deployment zip packages to the root of the S3 bucket
    - [s3_bucket_reader.zip](https://github.com/yemisprojects/lambda-delete-glacier-archives/tree/main/src/producer)
    - [delete_glacier_archive.zip](https://github.com/yemisprojects/lambda-delete-glacier-archives/tree/main/src/consumer)
6. Deploy the cross stack template, [main.yaml](https://github.com/yemisprojects/lambda-delete-glacier-archives/blob/main/Cloudformation/main_template.yaml).
    - Ensure you specify a [vault name](https://github.com/yemisprojects/lambda-delete-glacier-archives/blob/main/Cloudformation/main_template.yaml#L30)
7. Invoke the S3BucketReader lambda function to initiate the job

##### Detailed deployment steps [documented here](https://github.com/yemisprojects/lambda-delete-glacier-archives/tree/main/doc)

## Limitations 

- The current version of this solution can only delete archives from one vault at a time. 
    - To delete achives from another vault, this [stack's parameter value](https://github.com/yemisprojects/lambda-delete-glacier-archives/blob/main/Cloudformation/main_template.yaml#L30) needs to be updated with the new vault name

## Future Improvements

- The solution can be updated to work on multiple vaults in multiple accounts.
   - One approach could be to upload archives from different vaults into different S3 folders
   - Correspondingly update the code logic and include identifiers to the sqs messages for different vaults
   - or simply specifying filenames with a prefix or suffix of the vault and account name
- The entire workflow can be automated 
    - Using a single script to deploy the entire solution, which performs the following and more
        - Generating the vault inventory, splitting the files and uploading to S3
        - Creating the stacks
        - Deploying the lambda packages etc
        - Invoking the solution

