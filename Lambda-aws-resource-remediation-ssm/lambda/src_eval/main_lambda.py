"""
The lambda handler is invoked by a Custom Config rule when there are SQS configuration changes
and it evaluates a queue's compliance by checking if encryption is enabled with a KMS Key
"""
import os
import json
import boto3
import logging
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
config_client = boto3.client('config')

def evaluate_compliance(queue_url):
    '''Evaluates and returns the compliance type of SQS Queue'''

    try:
        response =  sqs_client.get_queue_attributes(QueueUrl=queue_url,AttributeNames=["KmsMasterKeyId"])
        log.info(f"get_queue_attributes response: {response}")

        if "Attributes" in response and "KmsMasterKeyId" in response.get("Attributes"):
            return "COMPLIANT"

        return "NON_COMPLIANT"
    except ClientError:
        log.exception(f"Could not evaluate compliance of Queue {queue_url}")
        raise

def put_evaluation( config_item, result_token, compliance_type):
    '''Delivers Resource Compliance Evaluation Result to Config Rule'''

    resource_type = config_item["resourceType"]
    resource_id = config_item["resourceId"]
    capture_time = config_item.get("configurationItemCaptureTime")

    evaluation = []        
    evaluation.append({'ComplianceResourceType': resource_type,
                        'ComplianceResourceId': resource_id,
                        'ComplianceType': compliance_type,
                        'Annotation': "N/A",
                        'OrderingTimestamp': capture_time
                    } )

    try:
        config_client.put_evaluations(Evaluations=evaluation,ResultToken=result_token)
        log.info(f"{resource_id} is {compliance_type}")
        log.info(f"Successfully updated config rule for {resource_id}")
    except ClientError:
        log.exception(f"Failed to update config rule for {resource_id}")

def lambda_handler(event, context):
    """
    It extracts the SQS queue URL from the event and evaluates the queue's encryption status. 
    If the queue is not encrypted with a KMS Key, it returns a NON_COMPLIANT STATUS else
    it returns a COMPLIANT STATUS
    """

    invoking_event = json.loads(event["invokingEvent"])
    message_type = invoking_event.get("messageType")
    result_token = event.get("resultToken", "no token")

    log.info('## RAW EVENT ##')
    log.info(event)
    log.info('## INVOKING EVENT ##')
    log.info(json.dumps(invoking_event, indent=4))

    if message_type == "ConfigurationItemChangeNotification":
        config_item = invoking_event["configurationItem"]
    elif message_type == "OversizedConfigurationItemChangeNotification":
        config_item = invoking_event["configurationItemSummary"]
    else:
        log.info("Only Config Item Change events are evaluated")
        return
    
    if config_item["configurationItemStatus"] == "ResourceDeleted":
        compliance_type = "NOT_APPLICABLE"
    else:
        QUEUE_URL = config_item["resourceId"]
        compliance_type = evaluate_compliance(queue_url=QUEUE_URL)
    
    put_evaluation(config_item, result_token, compliance_type)
