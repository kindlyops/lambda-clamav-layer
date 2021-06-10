REGION=us-west-1

clean:
	rm -fr ./build && \
	mkdir -p ./build && \
	cp build.sh ./build/ && \
	cp freshclam.conf ./build/ && \
	chmod +x ./build/build.sh
.PHONY: clean

build: clean
	docker run --rm \
		-v `pwd`/build:/opt/app:Z \
		amazonlinux:2 \
		/bin/bash -c "cd /opt/app && ./build.sh"
.PHONY: build

test-node12:
	docker run -it --rm \
		-v `pwd`/build:/opt:ro,delegated,Z \
		lambci/lambda:build-nodejs12.x \
		bash
.PHONY: test-node12

publish: build/lambda_layer.zip
	aws lambda publish-layer-version \
		--region $(REGION) \
		--layer-name clamav-antivirus \
		--zip-file fileb://build/lambda_layer.zip
.PHONY: publish
