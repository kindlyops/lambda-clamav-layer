# lambda-clamav-layer

An AWS Lambda Layer with `clamav` binaries

## building a fresh layer

To generate the layer, run

```shell
make build
```

To inspect the contents of the zip file, run

```shell
unzip -vl build/lambda_layer.zip
```

## Publishing the layer to your AWS environment

For convenience, a prebuilt zip is published as a github release for this
project, you can download it from the releases page.

Then create a layer version, specifying the zip file:

```shell
make publish

# specifying the region (default: us-west-1)
make publish REGION=ap-southeast-2
```

To grant permissions to all accounts inside your organization to use the layer,
use these commands.

First, find your organization ID:

```shell
aws organizations describe-organization
```

Next, add a permission grant for this organization:

```shell
aws lambda add-layer-version-permission \
    --layer-name clamav-antivirus \
    --version-number 1 \
    --statement-id allOrganizationAccounts \
    --principal '*' \
    --action lambda:GetLayerVersion \
    --organization-id o-NNN
```
