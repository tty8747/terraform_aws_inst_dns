# aws-vpn_terraform
## aws-vpn_terraform
### aws-vpn_terraform
#### aws-vpn_terraform

## terraform:
#### https://docs.aws.amazon.com/general/latest/gr/rande.html
#### aws s3api create-bucket --bucket tf-states-es --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1

## first start with terraform:
* git clone this repo
* aws s3api create-bucket --bucket ec00-bucket --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
* terraform init
* terraform apply

<!--
* git clone this repo
* terraform init
* terraform apply
* rename terraform.tf.example to terraform.tf
* terraform init
-->

## ansible: 

1. Запустить инициализации скрипт:
   * ansible-playbook -i inventory/hosts init.yml -u ubuntu
   * ansible-playbook -i inventory/hosts init.yml -u ubuntu -k
