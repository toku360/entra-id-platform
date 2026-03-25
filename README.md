# Phase 構成

## Phase1：IaC基盤（完了）

Terraform を用いた Azure 基盤を構築(IaC / CI/CD)

- modules / envs による構成分離
- dev / stg / prod 環境分離
- Azure Storage による remote backend
- Terraform state 分離管理
- Managed Identity + RBAC 設計
- GitHub Actions による CI/CD
  - Pull Request：terraform plan（matrix）
  - main push：terraform apply（dev）
- OIDC 認証によるセキュアな Azure 連携
- 証跡ベースの検証（docs/evidence）


---

## Phase2：Azure設計書（進行中）

企業環境を想定した Azure 設計書を作成。

- Architecture 設計（構成図含む）
- Network 設計（IP設計）
- RBAC 設計
- Security 設計
- Cost / 可用性設計

---

## Phase3：Entra ID設計（次フェーズ）

Identity / SSO 基盤を構築。

- Conditional Access
- MFA 強制
- Access Reviews
- PIM
- SSO（OIDC / SAML）

---

## Phase4：運用設計（予定）

運用フェーズを想定したドキュメント整備。

- 証跡整理
- トラブルシュート集
- 運用手順書
- インシデント対応フロー


