#!/usr/bin/env python3
"""
A simple Python script to e-mail yourself the latest weather forecast from the
National Weather Service.
"""

import email.mime.text
import logging
import os
import smtplib
import sys
import urllib.error
import urllib.request


class WeatherForecastException(Exception):
    def __init__(self, message=None):
        logging.critical(': '.join([type(self).__name__, message]))
        sys.exit(1)


def get_forecast(zipcode):
    zipcity_svc_url = 'http://forecast.weather.gov/zipcity.php?inputstring='
    logging.info("Getting the weather forecast for zip code {}".format(zipcode))

    try:
        zipcity = urllib.request.urlopen(''.join([zipcity_svc_url, zipcode]))

        forecast_url = ''.join([zipcity.geturl(), '&FcstType=text&TextType=1'])
        forecast_resp = urllib.request.urlopen(forecast_url)
        forecast = forecast_resp.read().decode()

        logging.info('Successfully got the forecast.')
        return forecast

    except urllib.error.HTTPError as e:
        raise WeatherForecastException(e)

    else:
        raise WeatherForecastException('An uncaught exception occurred.')


def send_email(server, sender, recipient, username, password, subject, content):
    msg = email.mime.text.MIMEText(content, 'html')
    msg['From'] = sender
    msg['To'] = recipient
    msg['Subject'] = subject

    try:
        with smtplib.SMTP(server) as smtp:
            logging.info("Connecting to server {}".format(server))

            try:
                logging.info("Attempting STARTTLS for {}".format(server))
                smtp.starttls()

            except:
                logging.warning("STARTTLS not supported for {}".format(server))

            if username and password:
                logging.info("Attempting to auth with server {}".format(server))
                smtp.login(username, password)

            logging.info("Sending mail to {}".format(recipient))
            smtp.sendmail(sender, recipient, msg.as_string())

        logging.info('The e-mail was sent successfully.')

    except Exception as e:
        raise WeatherForecastException("Could not send e-mail to {} via {}."
                "The error was: {}.".format(recipient, server, e))


def main():
    logging.basicConfig(format='%(asctime)s %(levelname)s %(message)s',
            level=logging.INFO)
    logging.info('Starting the script.')

    # Required settings
    recipient = os.environ.get('TO_EMAIL_ADDR')
    zipcode = os.environ.get('ZIP_CODE')
    subject = "NWS Forecast for {}".format(zipcode)

    # Optional settings
    sender = os.environ.get('FROM_EMAIL_ADDR', 'weather@localhost')
    server = os.environ.get('MAIL_SERVER', 'localhost:25')
    server_user = os.environ.get('MAIL_USERNAME', None)
    server_pass = os.environ.get('MAIL_PASSWORD', None)

    if not recipient or not zipcode:
        if not recipient:
            logging.critical('Missing a value for TO_EMAIL_ADDR')
        if not zipcode:
            logging.critical('Missing a value for ZIP_CODE')
        raise WeatherForecastException('Missing required environment variables.')

    # Get the forecast from the NWS
    forecast = get_forecast(zipcode)

    # Send the e-mail
    email = send_email(server, sender, recipient, server_user, server_pass,
            subject, forecast)

    logging.info('Script completed successfully.')


if __name__ == '__main__':
    main()
