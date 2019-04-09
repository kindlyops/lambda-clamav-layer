# lambda-clamav-layer
an AWS Lambda Layer with clamav binaries


## building a fresh layer

To generate the layer, run

    dockerbuild.sh

To inspect the contents of the zipfile, run

    unzip -vl build/lambda_layer.zip

## Publishing the layer to your AWS environment

For convenience, a prebuilt zip is published as a github release for this
project, you can download it from the releases page.

To publish the lambda layer, first upload it to S3 using a command like this:

    aws s3 cp build/lambda_layer.zip s3://<BUCKET-NAME>/clamavlayer.zip

Then create a layer version, specifying the zip file:

    aws lambda publish-layer-version --layer-name clamav-antivirus \
        --content S3Bucket=<BUCKET-NAME>,S3Key=clamavlayer.zip

To grant permissions to all accounts inside your organization to use the layer,
use these commands.

First, find your organization ID:

    aws organizations describe-organization

Next, add a permission grant for this organization:

    aws lambda add-layer-version-permission \
        --layer-name clamav-antivirus \
        --version-number 1 \
        --statement-id allOrganizationAccounts \
        --principal '*' \
        --action lambda:GetLayerVersion \
        --organization-id o-NNN
