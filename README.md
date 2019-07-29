# aws-vpn_terraform
## aws-vpn_terraform
### aws-vpn_terraform
#### aws-vpn_terraform

## terraform:
#### https://docs.aws.amazon.com/general/latest/gr/rande.html
#### aws s3api create-bucket --bucket tf-states-es --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1

###first start:
###1 git clone this repo
###2 terraform init
###3 terraform apply
###4 rename terraform.tf.example to terraform.tf
###5 terraform init

## ansible: 

1. Запустить инициализации скрипт:
   * ansible-playbook -i inventory/hosts init.yml -u ubuntu
   * ansible-playbook -i inventory/hosts init.yml -u ubuntu -k
