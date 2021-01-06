REGION=us-west-1

clean:
	rm -fr ./build && \
	mkdir -p ./build && \
	cp build.sh ./build/ && \
	cp freshclam.conf ./build/ && \
	chmod +x ./build/build.sh
.PHONY: clean

build: clean
	docker run --rm -ti \
		-v `pwd`/build:/opt/app \
		amazonlinux:2 \
		/bin/bash -c "cd /opt/app && ./build.sh"
.PHONY: build

publish: build/lambda_layer.zip
	aws lambda publish-layer-version \
		--region $(REGION) \
		--layer-name clamav-antivirus \
		--zip-file fileb://build/lambda_layer.zip
.PHONY: publish
