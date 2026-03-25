# Overview

本プロジェクトは、Microsoft Entra ID を中心とした認証基盤を構築し、  
Terraform を用いた Infrastructure as Code により Azure 環境を再現可能な形で管理することを目的とする。

---

# 目的

- Azure インフラを Terraform でコード化する
- Entra ID を中心とした認証・SSO基盤を構築する
- 実務レベルの IaC 設計を再現する
- GitHub によるポートフォリオとして公開する

---

# Phase構成

| Phase | 内容 |
|------|------|
| Phase1 | Terraform基盤（remote state / env分離） |
| Phase2 | Hybrid Identity |
| Phase3 | SSO / Zero Trust |
| Phase4 | SCIM |
| Phase5 | Identity Governance |
| Phase6 | 運用設計 |

---

# 現在の進捗（Phase1-3）

Terraform による Azure 基盤の module 化を実施し、以下を構築済み。

- Resource Group
- Virtual Network / Subnet
- Network Security Group
- Managed Identity
- RBAC（Role Assignment）

---

# 現在の構成

- modules による再利用設計
- envs/dev による環境分離
- Azure リソースのコード管理
- 実環境での検証済み

---

# 今後の予定

- compute module（VM構築）
- Bastion / Private Access
- Azure Monitor
- GitHub Actions によるCI/CD

---

# 本プロジェクトの特徴

- Terraform module 設計（再利用可能）
- Azure実リソースによる検証
- 証跡（ログ / スクリーンショット）管理
- 実務レベルの設計思想


