# Terraform Design

## 1. 目的
本ドキュメントは、`entra-id-platform` における Terraform 設計方針を定義する。  
本プロジェクトでは、単一ファイルにすべてを書くのではなく、**module 化・環境分離・remote backend・CI/CD 連携** を前提に構成する。

## 2. 設計方針
- Terraform は modules + envs 構成で管理する
- 環境差分は `envs/dev`, `envs/stg`, `envs/prod` に閉じ込める
- 共通ロジックは modules 配下に切り出す
- Terraform state は Azure Storage remote backend で管理する
- plan / apply は GitHub Actions と整合する構成にする
- ローカル実行可能性も残しつつ、最終的な変更管理は Git ベースで行う

## 3. ディレクトリ設計
想定する構成例は以下。

```text
terraform/
├── modules/
│   ├── network/
│   ├── security/
│   └── identity/
└── envs/
    ├── dev/
    ├── stg/
    └── prod/

```

## 4. modules 設計
### 4.1 module 化の目的

module 化する理由は以下のとおり。

共通設計を再利用できる
dev / stg / prod 間で構成差異を最小化できる
レビュー時に責務境界が明確になる
今後の拡張や差し替えがしやすい


### 4.2 想定 module
module名	役割
network	VNet / Subnet / NSG / 関連ネットワーク
security	セキュリティ関連リソース、診断設定、必要に応じた制御
identity	Managed Identity、RBAC、認証関連の補助構成

※ 実装進捗に応じて module は段階的に拡張する。

## 5. envs 設計
### 5.1 環境分離

envs/dev, envs/stg, envs/prod は、各環境の入口となる root module である。
ここでは以下を持つ。

provider 設定
backend 設定
module 呼び出し
変数定義
環境固有値の投入

### 5.2 環境ごとの差分の持たせ方

環境ごとの差分は、原則として以下に限定する。

Resource Group 名
リージョン
CIDR
タグ
SKU
環境名
必要な権限スコープ

設計・構造自体は極力共通化する。

## 6. backend 設計
### 6.1 remote backend を採用する理由

Terraform state は Azure Storage を用いた remote backend で管理する。
理由は以下のとおり。

ローカル端末依存を避ける
複数端末・CI/CD 間で state を共有できる
state 管理を Azure 側に寄せられる
実務で一般的な運用に近づけられる
6.2 分離方針

state は環境ごとに分離する。
例:

tfstate-dev
tfstate-stg
tfstate-prod

これにより、誤適用時の影響範囲を限定しやすくする。

### 6.3 運用ルール
state を手動で編集しない
terraform state rm や import は必要性を記録した上で実施する
backend 設定の変更時は必ず影響確認を行う
state の分離単位は設計意図と一致させる

## 7. variables 設計
### 7.1 基本方針
variables.tf に入力変数を明示する
terraform.tfvars または環境ごとの tfvars で値を与える
未宣言変数を tfvars に置かない
グローバルに見える設定値も root module で宣言して扱いを明確にする

### 7.2 設計意図

未宣言変数が増えると、以下の問題が起きやすい。

設計意図がコードに残らない
plan 時の warning が増える
レビュー性が落ちる
変数の責務が曖昧になる

そのため、使う値は必ず変数宣言または locals に整理する。

## 8. plan / apply 方針
Pull Request 時: terraform fmt, init, validate, plan
main マージ後: 必要に応じて apply
手元実行時も CI と同じディレクトリ構成・変数投入方式を維持する


## 9. レビュー観点

Terraform 設計では、以下をレビュー対象とする。

module の責務が明確か
環境差分が envs に閉じているか
変数が明示宣言されているか
backend 分離ができているか
plan が安定して再現できるか
GitHub Actions から安全に実行できるか

## 10. この設計の価値

この Terraform 設計は、単に Azure リソースを作るためのものではない。
以下を示すことが目的である。

実務で運用しやすい IaC 構造を理解していること
環境分離と共通化のバランスを取れていること
state 管理と CI/CD を含めて Terraform を設計できること


