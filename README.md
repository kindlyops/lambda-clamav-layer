# lambda-clamav-layer
an AWS Lambda Layer with clamav binaries

To generate the layer, run

    docker-compose run layer

This will create a new layer file at build/lambda_layer.zip
This zip file contains the clamav binaries, along with the
shared libraries for json-c and pcre that are needed at runtime.

To inspect the contents of the zipfile, run

    unzip -vl build/lambda_layer.zip

To publish the lambda layer, run:

    TODO
