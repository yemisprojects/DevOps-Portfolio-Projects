# Maintained by Yemi Odunade
# Version: 2.0

import os
import json
import boto3
import logging
from botocore.exceptions import ClientError

lvl = {
        "CRITICAL": logging.CRITICAL,
        "ERROR" : logging.ERROR,
        "WARNING" : logging.WARNING,
        "INFO" : logging.INFO,
        "DEBUG" : logging.DEBUG
        }
log = logging.getLogger(__name__)
log.setLevel(lvl[os.environ.get('LOG_LEVEL',"INFO")])

BUCKET_NAME = os.environ.get('SOURCE_BUCKET')

def get_s3_objects():
    """
    This function gets a list of S3 objects from the S3 bucket and returns the list of objects
    :return: A list of dictionaries. Each dictionary contains the metadata for a single object.
    """
    s3_objects = []
    next_token = ""
    s3_key_prefix = os.environ['S3_ARCHIVE_PATH']
    max_s3_keys = int(os.environ.get('NUM_FILES',1000))
    s3_client = boto3.client('s3')

    try:
        while True:
            if not next_token:
                response = s3_client.list_objects_v2(Bucket=BUCKET_NAME,MaxKeys=max_s3_keys,Prefix=s3_key_prefix)
            else:
                response = s3_client.list_objects_v2(Bucket=BUCKET_NAME,MaxKeys=max_s3_keys,Prefix=s3_key_prefix,ContinuationToken=next_token)
            log.debug("## S3 list object response ##")
            log.debug(response)
            s3_objects.extend(response['Contents'])
            next_token = response.get('NextContinuationToken', "no_token")
            if next_token == "no_token" or next_token == "": break
            log.debug(f'next continuation token: {next_token}')
    except ClientError:
        log.exception("### Failed to Get S3 Files ###")
        raise

    return s3_objects

def send_objects_to_sqs(s3_objects):
    """
    This function sends messages to SQS for each file in the S3 bucket.
    :return: The number of files in the S3 bucket and a list of the file names that failed to be sent to SQS.
    """   
    num_s3_files = 0                                                         
    failed_file_names = []
    sqs_client = boto3.client('sqs')
    queue_url = sqs_client.get_queue_url(QueueName=(os.environ["QUEUE_NAME"]))['QueueUrl'] 
    
    for obj in s3_objects:
        try:
            if obj.get('Key') != (os.environ["S3_ARCHIVE_PATH"]+"/"):                            
                num_s3_files += 1
                filename = obj.get('Key')                                  
                pay_load = {"BucketName": BUCKET_NAME,"filename": filename}
                sqs_client.send_message( QueueUrl=queue_url, DelaySeconds=0, MessageBody=(json.dumps(pay_load)) )
                log.info(f'Sent S3 File {filename} to SQS')
        except ClientError:
            log.exception(f"### Failed to Send S3 file {filename} to SQS ###")
            failed_file_names.append(filename)

    return num_s3_files,failed_file_names

def lambda_handler(event, context):
    """
    It gets all the files in the S3 bucket, sends them to SQS, and returns a status code and message
    
    :param event: A JSON object that contains the payload of the event that triggered the Lambda function
    :param context: This is an object that contains information about the Lambda function's execution environment
    :return: A dictionary with a statusCode and a message.
    """
    try:
        s3_objects = get_s3_objects()
    except ClientError:
        return dict(statusCode=500, Message="Failed to Get S3 Files")
   
    if s3_objects:

        num_s3_files,failed_file_names = send_objects_to_sqs(s3_objects)

        if len(failed_file_names) == 0:        
            log.info(f'Successfully sent all {num_s3_files} S3 file(s) to SQS')                    
            return dict(statusCode=200, Message=f"Sent all {num_s3_files} file(s) to SQS successfully")
        else:
            log.error(f'### Failed to send some files to SQS ###')  
            log.error(failed_file_names)                 
            return dict(statusCode=500, Message= f"{len(failed_file_names)} file(s) were not sent to SQS")
    else:
        log.info("There are no files in the S3 bucket")
