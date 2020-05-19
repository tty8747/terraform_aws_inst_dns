# How to do it

- `git clone https://github.com/tty8747/terraform_aws_inst_dns.git`
- Create s3 bucket for tfstate:  
  `aws s3api create-bucket --bucket ec00-bucket --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1`
- `terraform init`
- Fill credentials:
```bash
$ cat ~/.aws/credentials
[default]
aws_access_key_id = XXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
- `terraform validate`
- Add variable `ANSIBLE_*` 
```bash
export ANSIBLE_CA_PASS=`pwgen 128 1` && echo $ANSIBLE_CA_PASS
```
- Change parameters inside `provision/main.yml` file
- `terraform apply` 

---

#### Links

- [link](https://docs.aws.amazon.com/general/latest/gr/rande.html)
