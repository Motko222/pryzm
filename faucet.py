import requests
import capsolver
import sys
import os

address = sys.argv[2]

def get_captcha():
    capsolver.api_key = sys.argv[2]  # capsolver.com
    capsolver_data = {
        "type": "ReCaptchaV2TaskProxyLess",
        "websiteURL": "https://testnet.pryzm.zone",
        "websiteKey": "6LekyzwpAAAAAOCDLH9HmD6nPlSbUitwQ6rh5CCD",
    }
    solution = capsolver.solve(capsolver_data)
    return solution['gRecaptchaResponse']

token = get_captcha()
#print(token)

def get_token(address):
    url=f"https://testnet-pryzmatics.pryzm.zone/pryzmatics/faucet/claim?address={address}&recaptcha_response={token}&recaptcha_version=v2"
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0",
        "Accept": "application/json, text/plain, */*",
        "Accept-Language": "en-US,en;q=0.9",
        "Accept-Encoding": "gzip, deflate, br",
        "Referer": "https://testnet.pryzm.zone/",
        "Origin": "https://testnet.pryzm.zone/",
        "Sec-Ch-Ua": "",
        "Sec-Ch-Ua-Mobile": "?0",
        "Sec-Ch-Ua-Platform": "macOS",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-site",
    }

    data = {"address": address}

    response = requests.post(url, data, headers=headers)

    print(response.status_code, response.text)

get_token(address)
