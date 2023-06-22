IMAGE = seqera-docs
REPO = cr.seqera.io/public/$(IMAGE):1.1

docker-image:
	docker buildx build \
			--push \
			--platform linux/amd64 \
			--tag $(REPO) \
			--build-arg GITEA_TOKEN=${GITEA_TOKEN} \
			.
	
build:
	docker run --rm -p 8000:8000 -v ${PWD}:/docs $(REPO) build

serve:
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs $(REPO) serve --dev-addr=0.0.0.0:8000

clean:
	rm -rf site

publish:
	aws s3 sync public s3://help.tower.nf/ \
	--cache-control max-age=2592000 \
	--metadata-directive REPLACE \
	--storage-class STANDARD \
	--delete \
	--acl public-read

dry-pub:
	aws s3 sync public s3://help.tower.nf/ \
	--dryrun \
	--cache-control max-age=2592000 \
	--metadata-directive REPLACE \
	--storage-class STANDARD \
	--delete \
	--acl public-read

invalidate:
	aws cloudfront create-invalidation \
		--distribution-id EE450FY2UY75L \
		--paths '/*'
