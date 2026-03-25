# entra-id-platform

Azure / Microsoft Entra ID / Terraform / GitHub Actions を使用した  
**IaC × Identity プラットフォーム設計ポートフォリオ**

---

# 概要

本リポジトリは

👉 **企業の Azure / Entra 基盤を IaC で設計・構築・運用できることを証明する**

ことを目的としています。

---

# このポートフォリオで証明できること

- Azure Infrastructure as Code（Terraform）
- 環境分離（dev / stg / prod）
- remote backend 設計（state分離）
- GitHub Actions による CI/CD
- OIDC 認証（GitHub → Entra ID）
- Azure RBAC 設計（最小権限）
- 証跡ベースの運用（ログ / スクリーンショット）

---

# アーキテクチャ




GitHub
│
│ Pull Request
▼
GitHub Actions
│
│ terraform plan
▼
Terraform
│
│ remote state
▼
Azure

┌──────────────────────────────┐
│ Microsoft Entra ID │
│ ├ App Registration │
│ ├ Federated Credential │
│ └ RBAC │
└──────────────────────────────┘

┌──────────────────────────────┐
│ Azure Subscription │
│ └ Resource Group │
│ ├ VNet │
│ │ └ Subnet │
│ │ ├ NSG │
│ │ └ VM（予定） │
│ └ Managed Identity │
│ └ RBAC │
└──────────────────────────────┘



---

# Phase 構成

## Phase1：IaC基盤（完了）

- Terraform modules
- env分離（dev / stg / prod）
- remote backend
- state分離
- RBAC

---

## Phase2：Azure設計書（進行中）

- Architecture設計
- Network設計
- RBAC設計
- Security設計

---

## Phase3：Entra ID設計（予定）

- Conditional Access
- MFA
- Access Reviews
- PIM

---

## Phase4：運用設計（予定）

- 証跡整理
- トラブルシュート
- 運用手順書

---

# ディレクトリ構成

terraform/
├ modules/
│ ├ resource-group/
│ ├ network/
│ ├ security/
│ ├ identity/
│ └ compute/
└ envs/
├ dev/
├ stg/
└ prod/

docs/
├ 00-overview.md
├ 01-architecture.md
├ 02-terraform.md
├ 03-github-actions.md
├ 04-entra-id.md
├ 05-operations.md
└ evidence/
├ infrastructure/
│ ├ logs/
│ ├ screenshots/
│ └ verification.md
└ ci-cd/

.github/
└ workflows/
└ terraform-plan.yml


---

# Terraform backend

Terraform state は Azure Storage で管理

rg-entra-id-platform-tfstate

Storage Account
├ tfstate-dev
├ tfstate-stg
└ tfstate-prod


---

# CI/CD

Pull Request 作成時に Terraform CI を実行

azure/login@v2


Federated Credential

repo:toku360/entra-id-platform:pull_request
repo:toku360/entra-id-platform:ref:refs/heads/main


---

# 検証・証跡

本プロジェクトでは以下の方法で検証を実施

- Terraform plan / apply ログ保存
- Azure Portal によるリソース確認
- 環境分離（dev / stg / prod）検証
- state 分離検証
- destroy テスト

証跡保存先

docs/evidence/
├ infrastructure/
│ ├ logs/
│ ├ screenshots/
│ └ verification.md
└ ci-cd/



---

# 実装済み

- Terraform modules（resource-group / network / security / identity）
- env分離（dev / stg / prod）
- remote backend（Azure Storage）
- GitHub Actions（terraform plan）
- OIDC認証（GitHub → Azure）
- RBAC設計（Managed Identity）
- 証跡管理（logs / screenshots）

---

# 今後の拡張

- compute module（VM）
- Azure Monitor
- Conditional Access
- SSO（OIDC / SAML）
- SCIM

---

# 設計方針

- modules による再利用設計
- env による環境分離
- state 分離
- 最小権限（RBAC）
- シークレットレス（OIDC / Managed Identity）
- 証跡ベース運用

---

# Evidence（証跡あり）

本リポジトリでは、すべての構成を証跡付きで公開しています。

- Terraform Plan（GitHub Actions）
- Azure構成（VNet / NSG / RBAC）
- Managed Identity
- OIDC認証ログ

docs/evidence を参照


