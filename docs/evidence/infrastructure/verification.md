# Verification - Phase1-3 Terraform Infrastructure

---

# 概要

Terraform modules を用いて Azure 基盤（dev / stg / prod）を構築し、  
環境分離・ネットワーク・セキュリティ・Identity の動作を検証した。

---

# Terraform 検証

## plan

- terraform plan 成功
- 各環境ごとに差分が正しく表示される

## apply

- terraform apply 成功
- Azure リソース作成成功

---

# Azure 検証（証跡）

## Resource Group

- dev  
  screenshots/azure-dev-resource-group-overview.png

- stg  
  screenshots/azure-stg-resource-group-overview.png

- prod  
  screenshots/azure-prod-resource-group-overview.png

---

## VNet

- dev  
  screenshots/azure-dev-vnet-overview.png

- stg  
  screenshots/azure-stg-vnet-overview.png

- prod  
  screenshots/azure-prod-vnet-overview.png

---

## Subnet

- dev  
  screenshots/azure-dev-subnet-lab.png

- stg  
  screenshots/azure-stg-subnet-lab.png

- prod  
  screenshots/azure-prod-subnet-lab.png

---

## NSG

- dev  
  screenshots/azure-dev-nsg-overview.png

- stg  
  screenshots/azure-stg-nsg-overview.png

- prod  
  screenshots/azure-prod-nsg-overview.png

---

## NSG Rule

- dev  
  screenshots/azure-dev-nsg-rule-allow-ssh.png

- stg  
  screenshots/azure-stg-nsg-rule-allow-ssh.png

- prod  
  screenshots/azure-prod-nsg-rule-allow-ssh.png

---

## Subnet × NSG 関連付け

- dev  
  screenshots/azure-dev-subnet-nsg-association.png

- stg  
  screenshots/azure-stg-subnet-nsg-association.png

- prod  
  screenshots/azure-prod-subnet-nsg-association.png

---

## Managed Identity

- dev  
  screenshots/azure-dev-managed-identity.png

- stg  
  screenshots/azure-stg-managed-identity.png

- prod  
  screenshots/azure-prod-managed-identity.png

---

## RBAC

- dev  
  screenshots/azure-dev-rbac-reader-assignment.png

- stg  
  screenshots/azure-stg-rbac-reader-assignment.png

- prod  
  screenshots/azure-prod-rbac-reader-assignment.png

---

# state 分離

- screenshots/azure-storage-tfstate-containers.png

確認内容

- tfstate-dev
- tfstate-stg
- tfstate-prod

---

# destroy テスト

- screenshots/terraform-stg-destroy-result.png

確認内容

- stg 環境のみ削除
- dev / prod に影響なし

---

# 結果

- 環境分離（dev / stg / prod）成功
- state 分離成功
- module 構成正常動作
- RBAC 正常適用
- Azure 上でリソース確認済み


