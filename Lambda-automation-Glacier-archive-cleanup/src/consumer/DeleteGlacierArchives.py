# Maintained by Yemi Odunade
# Version: 2.0

import os
import json
import boto3
import time
import sys
import logging
from botocore.config import Config
from botocore.exceptions import ClientError

retry_config = Config(
   retries = {
      'max_attempts': 3,
      'mode': 'standard'
   }
)

lvl = {
        "CRITICAL": logging.CRITICAL,
        "ERROR" : logging.ERROR,
        "WARNING" : logging.WARNING,
        "INFO" : logging.INFO,
        "DEBUG" : logging.DEBUG
        }
log = logging.getLogger(__name__)
log.setLevel(lvl[os.environ.get('LOG_LEVEL',"INFO")])

s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')
s3_resource = boto3.resource('s3')
glacier_client = boto3.client('glacier', config=retry_config)

def delete_s3_file(sqs_msg):
    """
    The function takes in a SQS message, and deletes the file from S3
    
    :param sqs_msg: This is the message that was received from the SQS queue
    """
    try:
        s3_client.delete_object(Bucket=sqs_msg['bucket_name'],Key=sqs_msg['s3_filename'])
        log.info(f"The following S3 File({sqs_msg['s3_filename']}) in S3 Bucket({sqs_msg['bucket_name']}) has been deleted")
    except s3_client.exceptions.NoSuchKey:
        log.exception(f"### S3 File ({sqs_msg['s3_filename']}) no longer exists ###")
    except ClientError:
        log.exception(f"### Failed to Delete S3 File({sqs_msg['s3_filename']}) ###")

def delete_sqs_msg(sqs_msg):
    """
    It deletes the SQS message from the queue
    
    :param sqs_msg: This is the SQS message that we want to delete
    """
    try:
        sqs_client.delete_message(QueueUrl=sqs_msg['queue_url'],ReceiptHandle=sqs_msg['receipt_handle'])
        log.info(f"SQS message with ID ({sqs_msg['msg_id']}) has been deleted")
    except ClientError:
        log.exception(f"### Failed to Delete sqs msg Id({sqs_msg['msg_id']}) from queue for S3 File({sqs_msg['s3_filename']}) ###")

def update_s3_file(job,sqs_msg):
    """
    This function is used to update the S3 file with the remaining archives that were not deleted.

    :param sqs_msg: This is the message that was sent to the SQS queue.
    """
    try:
        with open(f"/tmp/{sqs_msg['s3_filename'].split('/')[-1]}","w") as s3_file:
            for id in job['remaining_archives']:
                s3_file.write(id+"\n")
        s3_resource.meta.client.upload_file(Filename=f'/tmp/{sqs_msg["s3_filename"].split("/")[-1]}', Bucket=sqs_msg['bucket_name'], Key=sqs_msg['s3_filename']) 
        log.info(f"Successfully uploaded updated {sqs_msg['s3_filename']} to S3 ")
        os.remove(f"/tmp/{sqs_msg['s3_filename'].split('/')[-1]}")
    except ClientError:
        log.exception(f"### Failed to Upload Updated S3 file ###")
        raise
    except Exception:
        log.exception("Failed to create or write to file")
        raise

def graceful_shutdown(job,sqs_msg):
    """
    If there are no more archives to delete, delete the S3 file and the SQS message. Otherwise, update
    the S3 file and log the remaining archives
    
    :param job: This is a dictionary that contains the list of archives that are yet to be deleted
    :param sqs_msg: This is the message that was received from the SQS queue
    """
    if len(job['remaining_archives']) == 0:
        log.info(f"All archives listed in {sqs_msg['s3_filename']} were successfully deleted")
        delete_s3_file(sqs_msg)
        delete_sqs_msg(sqs_msg)
    else:
        update_s3_file(job,sqs_msg)
        log.info(f"There were {len(job['remaining_archives'])} archives out of a total of {job['orig_num_archives']} archives that had not been deleted in S3 File ({sqs_msg['s3_filename']})")
        log.debug(f"List of archives which are yet to be deleted in S3 File({sqs_msg['s3_filename']})\n: {job['remaining_archives']}")

def get_archive_ids(s3_object):
    """
    It takes the S3 object, reads the body of the object, decodes the body from bytes to a string,
    splits the string on newlines, and returns a list of the resulting strings.
    
    :param s3_object: This is the object that contains the list of archive IDs
    :return: A list of archive ids
    """
    return list(filter(None, (s3_object['Body'].read().decode("utf-8")).split("\n")) )  

def get_s3_object(sqs_msg):
    """
    This function takes an SQS message as input and returns the S3 object associated with the message
    
    :param sqs_msg: This is the message that was received from the SQS queue
    :return: the s3_object.
    """
    try:
        s3_object = s3_client.get_object(Bucket=sqs_msg['bucket_name'],Key=sqs_msg['s3_filename'])
        log.debug(f"Successfully downloaded {sqs_msg['s3_filename']} from S3 bucket({sqs_msg['bucket_name']})")
        return s3_object
    except ClientError:
        log.exception("### Failed to get File from S3 Bucket ###")
        raise

def lambda_handler(event, context):
    """
    It reads the SQS message, gets the S3 object, gets the list of archive ids from the S3 object,
    deletes the archives, deletes the S3 object and deletes the SQS message
    
    :param event: The event that triggered the lambda function
    :param context: The Lambda context object contains information about the invocation, function, and
                    execution environment
    """
    log.info(f"### INVOKING EVENT ###\n{event}")
   
    countdown_time = int(os.environ.get("COUNT_DOWN_TIME"))
    countdown_timer_sec =  time.time() + countdown_time            
    obj = json.loads(event["Records"][0]["body"])
    que_url = sqs_client.get_queue_url(QueueName=(os.environ["QUEUE_NAME"]))['QueueUrl'] 
    sqs_msg = dict( 
                    s3_filename=obj['filename'], 
                    bucket_name=obj["BucketName"],
                    receipt_handle=event["Records"][0]["receiptHandle"],
                    msg_id=event["Records"][0]["messageId"],
                    queue_url=que_url
                  )

    s3_object = get_s3_object(sqs_msg)
    if s3_object["ContentLength"] == 0:       
        delete_s3_file(sqs_msg)
        delete_sqs_msg(sqs_msg)
        sys.exit()
    else:
        ids = get_archive_ids(s3_object)
        job = dict(remaining_archives=ids.copy(),orig_num_archives=len(ids))   

        log.info(f"{job['orig_num_archives']} archives will be deleted using ids in S3 File ({sqs_msg['s3_filename']})......")
        log.debug(f"List of ids in file,{sqs_msg['s3_filename']}\n{ids}")

        for id in ids:
            try:
                glacier_client.delete_archive(accountId='-',vaultName=os.environ["GLACIER_VAULT_NAME"],archiveId=id)
                log.debug(f'Deleted archive id: {id}') 
                job['remaining_archives'].remove(id)
            except glacier_client.exceptions.ResourceNotFoundException:
                log.debug(f"skipping an archive that does not exist in the vault.... {id}") 
                job['remaining_archives'].remove(id)
            except ClientError:
                log.exception(f"### Failed to Delete Glacier archive with id: {id} ###")
            if time.time() > countdown_timer_sec:
                graceful_shutdown(job,sqs_msg)
                log.info(f"Stopped Lambda execution!!!. It ran for more than {countdown_time}seconds")
                sys.exit()
        graceful_shutdown(job,sqs_msg)