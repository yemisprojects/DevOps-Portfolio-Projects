"""
The lambda handler is invoked by an Eventbridge rule when a resource is remediated.
It sends an email based using an email from a resource tag
"""
import os
import re
import json
import boto3
import logging
from random import randint
from botocore.config import Config
from botocore.exceptions import ClientError

log_level = {
                "CRITICAL": logging.CRITICAL,
                "ERROR" : logging.ERROR,
                "WARNING" : logging.WARNING,
                "INFO" : logging.INFO,
                "DEBUG" : logging.DEBUG
            }
log = logging.getLogger(__name__)
log.setLevel(log_level[os.environ.get('LOG_LEVEL',"INFO")])

sqs_client = boto3.client('sqs')
ses_client = boto3.client('ses')

class EmailNotFound(Exception):
    pass

def get_fallback_email(regex):
    '''Returns default email address if valid'''

    FALLBACK_EMAIL = os.environ.get("FALLBACK_EMAIL","")
    if (re.fullmatch(regex, FALLBACK_EMAIL)):
        log.info(f"Fallback email will be used")
        return FALLBACK_EMAIL
    
    raise EmailNotFound("No Valid Email found")

def get_contact_email(queue_url):
    '''Gets email address from tags or returns default email address if valid'''

    try:
        response = sqs_client.list_queue_tags(QueueUrl=queue_url)
        regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'

        if response.get("Tags"):
            email_address = response.get("Tags").get("owner_email")

            if(re.fullmatch(regex, email_address)):
                log.info(f"Valid email exists on {queue_url.split('/')[-1]}")
                return email_address
    except ClientError:
        log.exception(f"Failed to get valid email from Queue")

    email_address = get_fallback_email(regex)
    return email_address if ( re.fullmatch(regex, email_address) ) else None

def send_email(email_address, queue_url):
    '''Sends an email when an action is taken on a resource'''

    queue_name = queue_url.split("/")[-1]
    CHARSET = "UTF-8"

    BODY_TEXT = f"""SQS Queue {queue_name} was not in compliance with SampleOrg Security Policy. 
                \rServer-side encryption has been enabled using an AWS KMS key"""

    try:
        ses_client.send_email(
            Destination= { 'ToAddresses': [email_address] },
            Message={
                'Body': {
                    'Text': {
                        'Charset': CHARSET,
                        'Data': BODY_TEXT,
                    }
                },
                'Subject': {
                    'Charset': CHARSET,
                    'Data': f"SQS Queue COMPLIANCE NOTIFICATION",
                },
            },
            Source = email_address,
        )
        log.info(f"Email sent successfully to {email_address} ##")
    except ClientError:
        log.exception(f"Failed to send email to {email_address}")

def lambda_handler(event, context):
    """
    """
    log.info('## EVENT RECEIVED ##')
    log.info(event)

    event_detail = event['detail']
    if 'newEvaluationResult' in event_detail and 'oldEvaluationResult' in event_detail:
        new_status = event_detail.get('newEvaluationResult').get('complianceType')
        old_status = event_detail.get('oldEvaluationResult').get('complianceType')

        if new_status == "COMPLIANT" and old_status == "NON_COMPLIANT":
            QUEUE_URL = event_detail['resourceId']
            email_address = get_contact_email(QUEUE_URL)
            send_email(email_address,QUEUE_URL)