# Load .env files
include .envrc

help:##............Show this help
	@echo ""
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//' | sed 's/^/    /'
	@echo ""

.PHONY: deploy-%
deploy-%:##........Deploy specific job from sub folder
	docker run \
  --rm \
  -e NOMAD_ADDR \
  -e NOMAD_CACERT \
  -e NOMAD_CLIENT_CERT \
  -e NOMAD_CLIENT_KEY \
  -e NOMAD_TOKEN \
  -e NOMAD_REGION \
  -e VAULT_TOKEN \
  -e ENVIRONMENT \
  -v ${PWD}/:/workdir \
  -w /workdir \
  jrasell/levant deploy -vault -var-file=/workdir/levant.yaml /workdir/recipes/$*/nomad.job

.PHONY: plan-%
plan-%:##..........Plan specific job from sub folder
	docker run \
  --rm \
  -e NOMAD_ADDR \
  -e NOMAD_CACERT \
  -e NOMAD_CLIENT_CERT \
  -e NOMAD_CLIENT_KEY \
  -e NOMAD_TOKEN \
  -e NOMAD_REGION \
  -e VAULT_TOKEN \
  -e ENVIRONMENT \
  -v ${PWD}/:/workdir \
  -w /workdir \
  jrasell/levant plan -var-file=/workdir/levant.yaml /workdir/recipes/$*/nomad.job

.PHONY: render-%
render-%:##........Render specific job from sub folder
	docker run \
  --rm \
  -e NOMAD_ADDR \
  -e NOMAD_CACERT \
  -e NOMAD_CLIENT_CERT \
  -e NOMAD_CLIENT_KEY \
  -e NOMAD_TOKEN \
  -e NOMAD_REGION \
  -e VAULT_TOKEN \
  -e ENVIRONMENT \
  -v ${PWD}/:/workdir \
  -w /workdir \
  jrasell/levant render -var-file=/workdir/levant.yaml /workdir/recipes/$*/nomad.job
