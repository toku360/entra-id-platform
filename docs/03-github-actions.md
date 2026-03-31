# GitHub Actions Design

## 1. 目的
本ドキュメントは、`entra-id-platform` における GitHub Actions を利用した Terraform CI/CD 設計を定義する。  
本構成では、Azure との接続に OIDC を利用し、長期シークレットを極力持たない安全な自動化を目指す。

## 2. 設計方針
- GitHub Actions を Terraform plan / apply の実行基盤とする
- Azure 認証には OIDC を使用する
- Pull Request と main ブランチで責務を分離する
- 最小権限の Azure RBAC を適用する
- CI はコード品質と影響確認の場として使う
- 実行結果はレビュー証跡として活用する

## 3. GitHub Actions の役割
GitHub Actions では主に以下を実施する。

- Terraform format check
- Terraform init
- Terraform validate
- Terraform plan
- 必要に応じた apply

これにより、Pull Request ベースで以下を実現する。

- コード変更の可視化
- plan 結果の共有
- apply 前レビュー
- Azure 側との認証・権限整合確認

## 4. OIDC を使う理由
Azure 認証を GitHub Secrets の固定シークレットではなく、OIDC にする理由は以下のとおり。

- 長期クライアントシークレットの保管を避けられる
- シークレット期限切れ運用を減らせる
- GitHub リポジトリ / ブランチ / PR 条件と連動できる
- 実務でのモダンな CI/CD 構成に近い

## 5. 想定構成
```text
GitHub Repository
  └─ GitHub Actions Workflow
      └─ OIDC Token
          └─ Microsoft Entra App Registration
              └─ Federated Credential
                  └─ Azure RBAC
```

## 6. ワークフロー設計
### 6.1 Pull Request 時

Pull Request では、原則として以下を行う。

terraform fmt
terraform init
terraform validate
terraform plan

目的は、変更前に影響範囲を把握できること である。

### 6.2 main ブランチ

main ブランチでは、必要に応じて apply を行う。
ただし、初期段階では plan 中心で運用し、apply は手動確認や段階的導入と組み合わせてもよい。

## 7. 権限設計
### 7.1 Azure 側

GitHub Actions 用のサービスプリンシパル相当には、必要最小限のロールを付与する。
原則として、Subscription 全体ではなく、対象 Resource Group 単位で Contributor を付与する。

### 7.2 GitHub 側

ワークフローには最低限必要な permission を設定する。
例:

contents: read
id-token: write

## 8. Federated Credential 設計

Federated Credential は、用途ごとに分離する考え方が望ましい。

例:

Pull Request 用
main ブランチ用

これにより、以下のメリットがある。

どのトリガーで何が動けるかを制御しやすい
誤った subject 条件を切り分けやすい
セキュリティレビューしやすい

## 9. レビュー時に重視する点
ワークフローが対象ディレクトリを正しく見ているか
Azure Login が OIDC で成立しているか
Federated Credential の subject が GitHub 側条件と一致しているか
Terraform plan が再現可能か
未宣言変数や backend 不整合がないか

## 10. 想定する証跡

GitHub Actions は設計だけでなく、証跡としても重要である。
残すべき例は以下。

Pull Request の All checks passed
plan 実行ログ
Azure App Registration の Federated Credential 一覧
Azure RBAC 割り当て画面
OIDC 認証エラーとその解消ログ

## 11. この設計の価値

この設計により、単なるローカル Terraform 実行ではなく、レビュー可能で実務に近い GitOps / IaC 運用 を示せる。
特に、OIDC + 最小権限 + PR plan の組み合わせは、設計者レベルとして評価されやすい。



