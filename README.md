# Welcome to terrakube-hetzner

## What's This?

terrakube-hetzner is a Infrastructure as Code repository that includes everything needed to create bare metal Kubernetes clusters according to
[Cloud Native Computing Foundation (CNCF)](https://www.cncf.io/webinars/best-practices-for-running-and-implementing-kubernetes/)
best practices. It is written with go, Red Hat Ansible and the Terraform Language.

Order of execution:

- Terraform 
- Ansible 

## Secrets

ansible/host_vars/master.yml:

```
---
env_vars:
  hetzner_token: <YOUR_TOKEN>
```

terraform/secrets/source-me.sh:

```
#!/bin/bash
export TF_VAR_hetzner_token=<YOUR_TOKEN>
```

Source above file.


## Terraform Tasks

1. First Provide your Hetzner API Token on Shell in case you did not create above file

        $ export TF_VAR_hetzner_token=<YOUR_TOKEN>



2. At the command prompt, create a new Terraform plan and apply it

        $ terraform init, plan and apply

   where "init, plan and apply" should be executed one after the other

## Ansible Playbook

The _**Ansible Playbook**_ is responsible for provisioning the Hetzner K8s Nodes 
and bootstrap Kubernetes API with kubeadm and containerd as runtime.


3. Change directory to `ansible` and start the inventory building process

   Gather IPs from Terraforming into your `/etc/ansible/hosts` file. 
   Then proceed bootstrapping K8s:

        $ ansible-playbook 0-reset.yml (this will delete your local known_hosts file!)
        $ ansible-playbook 1-runtime.yml
        $ ansible-playbook 2-unswap.yml
        $ ansible-playbook 3-kubelet.yml
        $ ansible-playbook 4-kubeadm.yml
        $ ansible-playbook 5-cni.yml
        $ ansible-playbook 6-join.yml
        $ ansible-playbook 7-harden.yml


   Run with `--help` or `-h` for options.

4. Use the example files to deploy your first 2 microservices

        $ kubectl apply -f apple.yaml banana.yaml ingress.yaml 

## Contributing

<!-- [![Code Triage Badge](https://www.codetriage.com/rails/rails/badges/users.svg)](https://www.codetriage.com/rails/rails) -->

 I encourage you to contribute to this project! Also 'stuff might not run for you, as they did for me', which is (still) in the nature of the software development process. I'm setting up codetriage maybe much more later.

 On a site note I wanted to name the project 'Terrible Hetzner', because of the Terraform + Ansible part of the project, but I though that sounded kind of unfortunate to the data center. 

        _                   _  _     _      ®
        | |_  ___  _ _  _ _ (_)| |__ | | ___ 
        |  _|/ -_)| '_|| '_|| ||  _ \| |/ -_)
        \__|\___||_|  |_|  |_||____/|_|\___|     (just kidding..)

## Code Status

[![Known Vulnerabilities](https://snyk.io/test/github/{stevek-pro}/{terrakube-hetzner}/badge.svg)](https://snyk.io/test/github/{stevek-pro}/{terrakube-hetzner})



## License

terrakube-hetzner is released under the [MIT License](https://opensource.org/licenses/MIT).
