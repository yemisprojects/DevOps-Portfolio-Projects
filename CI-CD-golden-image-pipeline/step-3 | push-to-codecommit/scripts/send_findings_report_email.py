import os
import boto3
from email import encoders
from email.mime.base import MIMEBase
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

AWS_REGION = "us-east-1"
IMAGE_ID = os.getenv('AMI_ID')

def email_recipient():
    ssm_client = boto3.client("ssm", region_name=AWS_REGION)
    try:
        response = ssm_client.get_parameter( Name="/codebuild/awsinspector/email_contact", WithDecryption=True)
        return response.get('Parameter')['Value']
    except Exception as e:
        print(f"Failed to get Email address for AWS Inspector Findings report\n")
        raise

def send_email_with_attachment():
    
    contact = email_recipient()
    msg = MIMEMultipart()
    msg["Subject"] = "AWS Inspector Findings Report"
    msg["From"] = contact
    msg["To"] = contact

    # Set message body
    body = MIMEText(f"Hi,\nFind attached AWS inspector Findings report for Golden AMI {IMAGE_ID} vulnerability scan\n\n")
    msg.attach(body)

    filename = "inspector_findings_report.pdf"  # In same directory as script

    with open(filename, "rb") as attachment:
        part = MIMEApplication(attachment.read())
        part.add_header("Content-Disposition","attachment",filename=filename)

    msg.attach(part)

    print(f"Created pdf attachment for email...\n")
    # Convert message to string and send
    ses_client = boto3.client("ses", region_name=AWS_REGION)
    try:
        response = ses_client.send_raw_email(
                                                Source=contact,
                                                Destinations=[contact],
                                                RawMessage={"Data": msg.as_string()}
                                            )
        print(f"Successfully sent AWS Inspector Findings report to {contact}\n")
    except Exception as e:
        print(f"Failed to send AWS Inspector Findings report\n")
        raise

if __name__ == "__main__":
    send_email_with_attachment()