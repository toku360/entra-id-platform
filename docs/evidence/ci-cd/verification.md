# CI/CD Verification

## Terraform Plan (GitHub Actions)

- [x] Pull Request で自動実行
- [x] dev / stg / prod の matrix 実行成功
- [x] OIDC 認証で Azure ログイン成功
- [x] terraform fmt / validate / plan 成功

## Terraform Apply (GitHub Actions)

- [x] main ブランチ push 時に自動実行
- [x] dev 環境に対して terraform apply 成功
- [x] OIDC 認証で Azure ログイン成功
- [x] state と実リソースが一致していることを確認
- [x] Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

## Evidence

### Plan
- screenshots/github-actions-plan-success.png
- screenshots/github-actions-matrix.png
- screenshots/github-actions-plan-log.png

### Apply
- screenshots/github-actions-apply-success.png

## Notes

- Terraform state は Azure Storage の remote backend を使用
- dev / stg / prod で state を分離
- apply は main ブランチに限定
- dev 環境は apply 実行後に `No changes` を確認し、Terraform 管理状態が正常であることを検証済み


