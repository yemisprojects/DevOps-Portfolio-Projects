"""
This function is triggered by an Amazon EventBridge rule when a new sns topic is created.
It extracts the identity of the resource creator and tags each newly created topic with this identity
and it's associated tags
"""
import os
import boto3
import json
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
log.setLevel(log_level[os.environ.get('LOG_LEVEL',"DEBUG")])

def get_iam_identity_tags(user_name=None, role_name=None):
    """
    Gets and returns a list of tags from an iam user or role
    """
    iam_client = boto3.client('iam')

    if user_name:
        response = iam_client.list_user_tags(UserName=user_name)
    elif role_name:
        response = iam_client.list_role_tags(RoleName=role_name)

    tags = response.get("Tags")
    while response.get("Marker"):
        if user_name:
            response = iam_client.list_user_tags(UserName=user_name, Marker=response.get("Marker"))
        elif role_name:
            response = iam_client.list_role_tags(RoleName=role_name, Marker=response.get("Marker"))
        tags.extend(response.get('Tags'))

    log.debug(f"Tags parsed from IAM identity: {tags}")    
    return tags

def get_resource_tag(event):
    """
    Takes in a cloudtrail event, extract IAM identity and returns a list of resource tags 
    """
    resource_tags = []
    user_id = event.get("detail").get("userIdentity")

    if user_id.get("type") == "IAMUser" and user_id.get("userName"):
        user_name = user_id.get("userName")
        resource_tags.append( {"Key": "CreatedByUser", "Value": user_name} )
        resource_tags.append( {"Key": "DateCreated", "Value": event.get("detail").get("eventTime")} )  
        log.debug(f"IAM user tags parsed from Cloudtrail event: {resource_tags}")
        try:
            tags = get_iam_identity_tags(user_name=user_name)
            resource_tags.extend(tags)
        except ClientError as error:
            log.exception(error)
          
    elif user_id.get("type") == "AssumedRole" and user_id.get("arn"):
        role_name = user_id.get("arn").split("/")[-2]
        resource_tags.append( {"Key": "CreatedByRole", "Value": role_name} )
        resource_tags.append( {"Key": "DateCreated", "Value": event.get("detail").get("eventTime")} )  
        log.debug(f"IAM Role tags parsed from Cloudtrail event: {resource_tags}")
        try:
            tags = get_iam_identity_tags(role_name=role_name)
            resource_tags.extend(tags)
        except ClientError as error:
            log.exception(error)

    return resource_tags              

def lambda_handler(event, context):
    """
    If SNS topic is created successfully, get the resource tags 
    from the event and append them to the newly created SNS topic
    """
    log.info(json.dumps(event))  
    event_name = event.get("detail").get("eventName")

    if "errorCode" not in event.get("detail") and event_name == "CreateTopic":

        resource_tags = get_resource_tag(event)
        if resource_tags:
            log.info(f"Resource tag to be appended\n{resource_tags}")
            topic_arn = event.get("detail").get("responseElements").get("topicArn") 
            sns_client = boto3.client('sns')
            try:
                sns_client.tag_resource(ResourceArn=topic_arn,Tags=resource_tags)
                log.info(f'Successfully tagged SNS topic: {topic_arn}') 
            except ClientError as error:
                log.exception(error)  