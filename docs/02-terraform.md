# Terraform 設計

本プロジェクトでは、Microsoft Entra ID を中心とした認証・SSO基盤を構築するために、  
Azureインフラを **Terraform (Infrastructure as Code)** により構築している。

目的は以下の通り。

- Azure環境の再現性を確保する
- 手動構築による設定ミスを防ぐ
- Gitによるインフラ構成管理を行う
- 本番環境を想定したIaC構造を採用する

---

# Terraform ディレクトリ構成


terraform/
├─ modules/
│ ├─ resource-group/
│ ├─ network/
│ ├─ security/ (予定)
│ ├─ identity/ (予定)
│ └─ compute/ (予定)
│
└─ envs/
├─ dev/
├─ stg/ (予定)
└─ prod/ (予定)


---

# modules と envs の役割

Terraform構成は **modules / envs の2層構造**としている。

## modules

Azureリソースの **再利用可能な部品**を定義する。

例

- Resource Group
- Virtual Network
- Network Security Group
- Virtual Machine

modules配下では **Azureリソースの定義のみを行う**。


modules/network/main.tf
modules/network/variables.tf
modules/network/outputs.tf


---

## envs

環境ごとの設定を管理する。


envs/dev
envs/stg
envs/prod


envs配下では

- module呼び出し
- 環境ごとの変数
- backend設定

を管理する。

---

# dev環境の構成

現在の dev 環境では、以下のリソースを Terraform module により作成している。

| リソース | 名前 |
|---|---|
| Resource Group | rg-entra-id-platform-dev |
| Virtual Network | vnet-entra-id-platform-dev |
| Subnet | subnet-lab |

ネットワーク構成


VNet
10.10.0.0/16

└ subnet-lab
10.10.1.0/24


---

# Resource Group module

Resource Group は Terraform module として定義している。


modules/resource-group


例


resource "azurerm_resource_group" "this" {
name = var.name
location = var.location
tags = var.tags
}


これにより、環境ごとに Resource Group を簡単に作成できる。

---

# Network module

Network module では以下を管理している。

- Virtual Network
- Subnet


modules/network


構成


VNet
└ Subnet


NSGは **責務分離のため別module(security)で管理する予定**。

---

# Terraform 実行手順

Terraform操作は env ディレクトリで行う。


cd terraform/envs/dev


## 初期化


terraform init


## フォーマット


terraform fmt -recursive


## 構文チェック


terraform validate


## 実行計画


terraform plan -var-file="terraform.tfvars"


## インフラ構築


terraform apply -var-file="terraform.tfvars"


---

# 将来的なTerraform拡張

今後、以下のmoduleを追加予定。

| module | 内容 |
|---|---|
| security | Network Security Group |
| identity | Managed Identity / RBAC |
| compute | Virtual Machine |
| monitoring | Azure Monitor / Log Analytics |

これにより、Azure基盤をすべてTerraformで管理する構成を目指す。

---

# Terraform設計方針

本プロジェクトでは以下のIaC設計を採用している。

- modulesによる再利用設計
- envsによる環境分離
- Terraform state の分離
- Gitによるインフラ構成管理

この構成により、本番環境に近いIaC構成を再現している。



