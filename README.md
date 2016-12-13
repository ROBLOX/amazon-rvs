# Chef Cookbook for Amazon Receipt Verification Service

This cookbook will setup Apache Tomcat and then deploy 
[Amazon RVS](https://developer.amazon.com/public/apis/earn/in-app-purchasing/docs-v2/verifying-receipts-in-iap#setting-up-rvs) into `/amazon-rvs-sandbox`


# Attributes

## default

- `node['amazon_rvs']['tomcat']['file_url']` - URL for [Amazon WAR](https://developer.amazon.com/public/resources/development-tools/sdk) file.
- `node['amazon_rvs']['creds']['data_bag']` - Password for Admin site
