# SLO / SLA Design

## 1. 目的
本ドキュメントは、`entra-id-platform` におけるサービス品質指標（SLO / SLA）を定義する。

本設計では以下を目的とする。

- サービス品質の可視化
- 運用の判断基準を明確化
- 障害の影響範囲を定量化
- 継続的改善の指標を提供

---

## 2. 用語定義

| 用語 | 意味 |
|------|------|
| SLA | Service Level Agreement（外部向け保証） |
| SLO | Service Level Objective（内部目標） |
| SLI | Service Level Indicator（測定指標） |

---

## 3. 対象サービス

| サービス | 内容 |
|---|---|
| SSO（Grafana） | OIDC認証 |
| SSO（ServiceNow） | SAML認証 |
| Entra ID | 認証基盤 |
| Terraform / CI | 基盤変更 |

---

## 4. SLI（測定指標）

### 4.1 認証成功率
- 指標：成功ログイン / 総ログイン

### 4.2 MFA成功率
- 指標：MFA成功 / MFA要求

### 4.3 SSOレスポンス時間（将来）
- 指標：ログイン完了までの時間

### 4.4 CA適用率
- 指標：CA適用回数 / ログイン回数

---

## 5. SLO（目標値）

| 指標 | SLO |
|------|-----|
| 認証成功率 | 99.5%以上 |
| MFA成功率 | 99%以上 |
| CA適用率 | 100% |
| 障害検知時間 | 5分以内 |

---

## 6. SLA（想定）

| 項目 | SLA |
|------|-----|
| 認証可用性 | 99.9% |
| 障害復旧時間 | 30分以内 |
| 重大障害対応 | 即時 |

---

## 7. KQLによる測定

### 認証成功率

```kusto
SigninLogs
| where CreatedDateTime >= ago(1d)
| summarize total=count(), success=countif(ResultType == 0)
| extend success_rate = success * 100.0 / total
```

### MFA成功率

```kusto
SigninLogs
| where CreatedDateTime >= ago(1d)
| where AuthenticationRequirement == "multiFactorAuthentication"
| summarize total=count(), success=countif(ResultType == 0)
```

### CA適用率

```kusto
SigninLogs
| where CreatedDateTime >= ago(1d)
| summarize total=count(), applied=countif(isnotempty(ConditionalAccessPolicies))
```

## 8. エラーバジェット

例：

- 99.5% SLO → 0.5% 失敗許容
- 1日1000ログイン → 5件失敗までOK


## 9. 設計意図

本設計により以下を実現する。

- 定量的な品質管理
- 運用判断の明確化
- 障害影響の可視化


