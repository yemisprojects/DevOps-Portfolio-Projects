import boto3
from email import encoders
from email.mime.base import MIMEBase
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

AWS_REGION = "us-east-1"

def email_recipient():
    ssm_client = boto3.client("ssm", region_name=AWS_REGION)
    try:
        response = ssm_client.get_parameter( Name="/infracost/cost-usage-report/email-contact", WithDecryption=True)
        return response.get('Parameter')['Value']
    except Exception as e:
        print("Failed to get Email address for Infracost report")
        raise

def send_email_with_attachment():
    contact = email_recipient()
    msg = MIMEMultipart()
    msg["Subject"] = "Cost Report"
    msg["From"] = contact
    msg["To"] = contact

    # Set message body
    body = MIMEText("Find attached Infracost report")
    msg.attach(body)

    filename = "cost-report.html"  # In same directory as script

    with open(filename, "rb") as attachment:
        part = MIMEApplication(attachment.read())
        part.add_header("Content-Disposition","attachment",filename=filename)

    msg.attach(part)

    print(f"Created html attachment for email...\n")
    # Convert message to string and send
    ses_client = boto3.client("ses", region_name=AWS_REGION)
    try:
        response = ses_client.send_raw_email(
                                                Source=contact,
                                                Destinations=[contact],
                                                RawMessage={"Data": msg.as_string()}
                                            )
        print(f"Successfully sent Infracost email report to {contact}\n")
    except Exception as e:
        print("Failed to send Infracost email report")
        raise

if __name__ == "__main__":
    send_email_with_attachment()