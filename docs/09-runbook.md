# Runbook（運用手順書）

## 1. 目的
本ドキュメントは、`entra-id-platform` における Azure / Entra ID / SSO 環境の運用手順を定義する。

本 Runbook では、以下を明確にする。

- 日常的に確認すべき項目
- 障害の予兆検知
- 変更作業時のチェック
- ログ確認ポイント
- エスカレーション基準

本環境は検証用途を含むが、**実務運用を想定した手順**を整理することを目的とする。

---

## 2. 対象範囲

本 Runbook の対象は以下とする。

- Azure 基盤
- Microsoft Entra ID
- Conditional Access
- SSO（Grafana / ServiceNow）
- Terraform / GitHub Actions
- Log Analytics

---

## 3. 日次運用（Daily Check）

### 3.1 サインインログ確認（最重要）

#### 確認内容
- ログイン失敗の増加
- Conditional Access failure の有無
- 異常なIP / Location

#### KQL
```kusto
SigninLogs
| where CreatedDateTime >= ago(24h)
| summarize Count = count() by ConditionalAccessStatus
```


### チェックポイント

- failure が急増していないか
- 特定ユーザーに偏っていないか

### 3.2 SSO動作確認

確認内容
- Grafana ログイン可能
0 ServiceNow ログイン可能
- MFA が正常動作

方法
- テストユーザーでログイン
- MFA発動確認

### 3.3 GitHub Actions

確認内容
- workflow エラー有無
- terraform plan/apply 成功

## 4. 週次運用（Weekly Check）

### 4.1 Conditional Access 状況確認

確認内容
- ポリシー適用率
- failure / success 比率
- KQL

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| summarize Count = count() by ConditionalAccessStatus
```

### 4.2 ログ量確認（コスト観点）

確認内容
- Log Analytics 取り込み量
- 異常増加の有無

### 4.3 RBAC確認

確認内容
- 不要な権限付与がないか
- Contributor 範囲が適切か

## 5. 変更作業前チェック

### 5.1 Terraform

- terraform plan 確認
- 差分が意図通りか
- state 影響確認

### 5.2 Conditional Access

- 対象ユーザー確認
- 除外設定確認
- Report-only で検証

### 5.3 SSO
- Redirect URL
- Identifier
- 証明書（SAML）

## 6. 変更作業後チェック
### 6.1 SSO確認（必須）

- Grafana ログイン成功
- ServiceNow ログイン成功
- MFA 動作

### 6.2 ログ確認

```kusto
SigninLogs
| where CreatedDateTime >= ago(1h)
| order by CreatedDateTime desc
```

### 6.3 CA適用確認

```kusto
SigninLogs
| where CreatedDateTime >= ago(1h)
| where isnotempty(ConditionalAccessPolicies)
```

## 7. 障害時の初動確認

### 7.1 切り分け順
- Entra ID ログ確認
- Conditional Access 状態確認
- アプリ側ログ確認
- Terraform変更有無確認

#### 7.2 よくある障害

症状	原因
ログイン不可	CA設定ミス
MFA出ない	CA未適用
ループ	Redirectミス
SAML失敗	NameID不一致

## 8. ログ確認ポイント
必ず見るログ

- SigninLogs
- AuditLogs
- Conditional Access Logs
- Grafana Logs
- ServiceNow Logs

## 9. エスカレーション基準

以下の場合は即対応

- 全ユーザーでログイン不可
- MFAが動作しない
- CA failure急増
- 管理者ログイン不可

## 10. 証跡として残す

- ログ結果（KQL）
- エラー画面
- 修正前後の設定
- GitHub Actionsログ

## 11. 設計意図（運用視点）

本 Runbook により、以下を実現する。

- 障害時の初動短縮
- 設定変更の安全性確保
- ログベースの分析
- 運用の属人化排除

これは、単なる構築ではなく
「運用できる設計」 を示すための重要なドキュメントである。

