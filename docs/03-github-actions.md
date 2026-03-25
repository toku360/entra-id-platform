# Matrix構成

本プロジェクトでは Terraform Plan を3環境で同時実行する。

| 環境 | Directory |
|------|----------|
| dev  | terraform/envs/dev |
| stg  | terraform/envs/stg |
| prod | terraform/envs/prod |

---

# tfvars動的生成

GitHub Actions 内で terraform.tfvars を生成することで

- Secretsを使わない
- 環境ごとの差分管理
- IaCの再現性

を実現している。

---

# OIDC認証

Azureへの認証は OIDC を使用

- Client Secret不要
- GitHub → Entra ID 連携
- セキュアなCI/CD

---

# 実行フロー

PR作成
↓
GitHub Actions
↓
Terraform Plan（dev/stg/prod）
↓
レビュー
↓
Merge


# Applyフロー

本プロジェクトでは、main ブランチへの push をトリガーに Terraform Apply を実行する。

対象:
- dev 環境

目的:
- レビュー済みコードのみ反映
- 誤操作防止
- GitOps による安全な IaC 運用

---

# Apply 実行結果

Terraform Apply (dev) が正常終了し、以下を確認した。

- OIDC 認証成功
- Terraform state と Azure 実リソースの整合
- `Apply complete! Resources: 0 added, 0 changed, 0 destroyed.`

---

# 証跡

保存先:

```text
docs/evidence/ci-cd/



