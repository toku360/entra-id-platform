# Operations

## 1. 目的
本ドキュメントは、`entra-id-platform` の運用ルールを定義する。  
本プロジェクトでは、構築できることだけでなく、**安全に変更し、検証し、問題時に戻せること** を重視する。

## 2. 運用方針
- 変更は原則 Git 管理で行う
- Terraform state を手動編集しない
- plan を確認してから apply する
- 変更理由・検証結果・証跡を残す
- 権限は最小限に維持する
- ドキュメント更新をコード変更とセットで行う

## 3. 変更管理ルール

### 3.1 基本フロー
1. ブランチ作成
2. Terraform / docs 修正
3. `terraform fmt`
4. `terraform validate`
5. Pull Request 作成
6. GitHub Actions による plan 実行
7. 差分確認
8. マージ
9. 必要に応じて apply
10. 検証結果と証跡を残す

### 3.2 重要原則
- コードだけ変えて docs を放置しない
- tfvars に未宣言変数を増やさない
- backend や state の変更は特に慎重に扱う
- 本番相当環境へ適用する前に dev で確認する

## 4. Terraform 運用ルール

### 4.1 禁止事項
- state ファイルの直接編集
- 目的の記録なしに `terraform import` / `state rm` を実施
- ローカルだけで apply して履歴を残さないこと
- PR / plan を経ずに大きな変更を入れること

### 4.2 推奨事項
- 変更前に対象スコープを明確にする
- module 単位の責務を崩さない
- 命名規則を統一する
- 差分が大きい時は docs に設計理由を書く

## 5. GitHub Actions 運用ルール
- Pull Request で plan を確認する
- OIDC 認証失敗時は subject / audience / Federated Credential を確認する
- Azure 権限不足時はスコープ過大付与ではなく、必要最小限の見直しを行う
- ワークフロー変更時は docs/03-github-actions.md も更新する

## 6. 証跡管理
本プロジェクトでは、実装だけでなく証跡を残す。  
残すべき主な証跡は以下。

- GitHub Actions 実行結果
- Terraform plan / apply ログ
- Azure Portal 上のリソース画面
- App Registration / Federated Credential 画面
- RBAC 割り当て画面
- remote backend 構成確認画面
- 必要に応じたエラーと解消履歴

## 7. 検証項目
各変更後は、最低限以下を確認する。

### 7.1 Terraform
- `terraform fmt` が通る
- `terraform validate` が通る
- `terraform plan` が意図通り
- backend が正しい state を参照している

### 7.2 Azure
- Resource Group / VNet / Subnet / NSG が意図通り
- RBAC が想定スコープに付与されている
- App Registration / Federated Credential が正しい
- GitHub Actions から Azure ログインが成功する

### 7.3 ドキュメント
- docs が最新構成に合っている
- README の概要と矛盾しない
- 設計意図が説明できる状態になっている

## 8. ロールバック方針

### 8.1 基本方針
問題が発生した場合は、**直前の正常コミットへ戻し、再度 plan / apply する** ことを基本とする。  
これは、IaC による変更管理の一貫性を保つためである。

### 8.2 ロールバック時の注意
- まず Azure 側の実リソースと state の整合性を確認する
- 破壊的変更が含まれる場合は、影響範囲を整理する
- state 操作は最後の手段とし、実施時は必ず記録を残す
- OIDC / RBAC の変更は、ロールバック後に認証確認も行う

## 9. よくある失敗

### 9.1 tfvars に変数を書いたが variables.tf に宣言していない
結果:
- plan 時に undeclared variable warning が出る
- 設計意図がコードに残らない

対応:
- 変数を宣言する
- 不要な値なら tfvars から削除する

### 9.2 GitHub Actions は動くが Azure ログインに失敗する
結果:
- OIDC 認証エラー
- subject / audience 不一致

対応:
- Federated Credential 条件を確認する
- GitHub 側トリガーと一致しているか確認する

### 9.3 権限不足を Subscription Contributor で雑に解決してしまう
結果:
- 最小権限設計が崩れる
- 実務レビューで弱い

対応:
- どの Resource Group / Resource に必要かを明確にする
- スコープを絞って再付与する

### 9.4 docs 更新漏れ
結果:
- 実装と設計書が乖離する
- 採用ポートフォリオとして弱くなる

対応:
- PR に docs 更新を必須項目として含める

## 10. この運用設計の価値
この運用ルールにより、本プロジェクトは単なる Azure ハンズオンではなく、**設計・変更・検証・証跡・復旧まで意識した実務型ポートフォリオ** になる。  
特に、レビュー時に「安全に運用できるか」を説明できる点が重要である。



