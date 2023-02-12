ifdef CI
	PROFILE_REQUIRED=profile
	INIT_REQUIRED=init workspace
	TF_IN_AUTOMATION=true
endif

export SUBFOLDER ?= ./aws-infrastructure

init: .env $(PROFILE_REQUIRED)
	docker-compose run --rm terraform-utils terraform init $(BACKEND_CONFIG)
.PHONY: init

plan: init $(INIT_REQUIRED)
	docker-compose run --rm terraform-utils terraform plan
.PHONY: plan

apply: $(INIT_REQUIRED)
	docker-compose run --rm terraform-utils terraform apply
.PHONY: apply

applyAuto: $(INIT_REQUIRED)
	docker-compose run --rm terraform-utils terraform apply -auto-approve
.PHONY: applyAuto

output: $(INIT_REQUIRED)
	docker-compose run --rm terraform-utils sh -c 'terraform output -no-color > output.tfvars'
.PHONY: output

destroy: $(INIT_REQUIRED)
	docker-compose run --rm terraform-utils terraform destroy
.PHONY: destroy

destroyAuto: $(INIT_REQUIRED)
	docker-compose run --rm terraform-utils terraform destroy -auto-approve
.PHONY: destroyAuto

workspace: .env $(PROFILE_REQUIRED)
	docker-compose run --rm envvars ensure
	docker-compose run --rm terraform-utils sh -c 'terraform workspace new $${TERRAFORM_WORKSPACE} || terraform workspace select $${TERRAFORM_WORKSPACE}'
.PHONY: workspace

validate: $(INIT_REQUIRED)
	docker-compose run --rm envvars ensure
	docker-compose run --rm terraform-utils terraform fmt -diff -check -recursive
	docker-compose run --rm terraform-utils terraform validate
.PHONY: validate

check: .env
	docker-compose run --rm terraform-utils terraform fmt -check -diff -recursive
.PHONY: check

fmt: .env
	docker-compose run --rm terraform-utils terraform fmt -diff -recursive
.PHONY: fmt

profile: .env
	# Update target account profile
	docker-compose run --rm aws env -u AWS_PROFILE aws configure set credential_source Ec2InstanceMetadata --profile ${AWS_PROFILE}
	docker-compose run --rm aws aws configure set role_arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${AWS_ROLE_NAME} --profile ${AWS_PROFILE}
	@docker-compose run --rm aws aws configure set external_id ${GITLAB_EXTERNAL_ID} --profile ${AWS_PROFILE}
.PHONY: profile

.env:
	type NUL > .env
	docker-compose run --rm envvars validate
	docker-compose run --rm envvars envfile --overwrite
.PHONY: .env

version: 
	docker-compose run --rm terraform-utils terraform version
.PHONY: version

import: $(INIT_REQUIRED) workspace 
	docker-compose run --rm terraform-utils terraform import <resource.logicalid>
.PHONY: import
