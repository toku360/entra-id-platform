# 運用設計

本プロジェクトでは、Microsoft Entra ID を中心とした認証基盤を運用することを想定し、  
Terraformによるインフラ管理および運用ルールを定義している。

---

# Terraform運用方針

Azureインフラは **TerraformによるInfrastructure as Code** で管理する。

運用ルールは以下の通り。

- Azureリソースは Terraform で作成する
- 手動変更は原則禁止
- 変更はGitで管理する
- Terraform plan により差分確認を行う

---

# Terraform 実行ルール

Terraform操作は **envディレクトリで実行する**。


terraform/envs/dev


実行手順


terraform fmt -recursive
terraform validate
terraform plan
terraform apply


---

# tfvars 管理

環境ごとに tfvars を分離する。


envs/dev/terraform.tfvars
envs/stg/terraform.tfvars
envs/prod/terraform.tfvars


tfvarsでは以下を管理する。

- Resource Group 名
- Network設定
- タグ

例


resource_group_name = "rg-entra-id-platform-dev"

location = "Japan East"

tags = {
project = "entra-id-platform"
env = "dev"
owner = "toku360"
}


---

# Terraform state 管理

Terraform state は **remote backend** を利用する。

理由

- stateの共有
- 誤操作防止
- CI/CDとの連携

Remote backend には Azure Storage Account を利用する。


Storage Account
└ Container
├ tfstate-dev
├ tfstate-stg
└ tfstate-prod


---

# 変更管理

インフラ変更は以下の手順で行う。

1. Terraformコード修正
2. terraform validate
3. terraform plan
4. 差分確認
5. terraform apply

---

# 証跡管理

インフラ構築時には以下の証跡を保存する。

## Terraformログ

保存先


docs/evidence/infrastructure/logs


保存内容

- terraform plan
- terraform apply

---

## Azure Portal スクリーンショット

保存先


docs/evidence/infrastructure/screenshots


保存対象

- Resource Group
- Virtual Network
- Subnet
- 作成されたリソース一覧

---

# セキュリティ方針

機密情報は Terraform コードに直接記載しない。

将来的には以下の方式で管理する予定。

- GitHub Secrets
- Azure Key Vault
- CI/CD パイプライン

---

# 将来的な運用拡張

今後以下の運用機能を追加予定。

| 項目 | 内容 |
|---|---|
| NSG管理 | Network Security Group |
| RBAC | Azure権限管理 |
| Monitoring | Azure Monitor |
| Alert | 障害通知 |

これにより、Azure環境の運用管理を自動化する。


## 環境分離テスト

- dev / stg / prod で個別に terraform apply 実施
- 各環境の VNet CIDR が異なることを確認

## state分離確認

- Azure Storage の container が分離されていることを確認

## 影響範囲テスト

- stg を destroy しても dev / prod に影響がないことを確認



