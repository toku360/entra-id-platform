# Conditional Access Logs Analysis with KQL

## 1. 目的
本ドキュメントは、Microsoft Entra ID の Conditional Access（CA）に関するログを Log Analytics / KQL で分析するための観点とクエリ例を整理する。

本フェーズでは、単に CA ポリシーを作成するだけではなく、以下を確認できる状態を目指す。

- ポリシーが意図どおり適用されているか
- MFA が実際に要求されているか
- どのアプリで失敗が多いか
- どのユーザーに影響が出ているか
- ポリシー変更がいつ・誰によって行われたか

## 2. 前提
Conditional Access の分析を行うためには、Microsoft Entra ID のログを Log Analytics Workspace に送信している必要がある。  
少なくとも以下を有効化する。

- `SigninLogs`
- `AuditLogs`

Microsoft Learn でも、Entra ID の診断設定から `SigninLogs` と `AuditLogs` を Log Analytics に送る構成が案内されている。  
また、`SigninLogs` テーブルには `ConditionalAccessStatus` と `ConditionalAccessPolicies` が含まれる。 :contentReference[oaicite:1]{index=1}

## 3. まず確認すること

### 3.1 Log Analytics にログが届いているか
最初に以下を実行し、データが存在するかを確認する。

```kusto
SigninLogs
| where CreatedDateTime >= ago(24h)
| summarize Count = count()
```

## 4. 基本クエリ

### 4.1 CA が適用されたサインイン一覧

Conditional Access が評価されたサインインを一覧表示する。

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where ConditionalAccessStatus in ("success", "failure", "notApplied")
| project CreatedDateTime,
          UserPrincipalName,
          AppDisplayName,
          ConditionalAccessStatus,
          ResultType,
          ResultDescription,
          IPAddress,
          CorrelationId
| order by CreatedDateTime desc
```

#### 見るポイント
- ConditionalAccessStatus
 - success: ポリシー評価の結果、条件を満たして通過
 - failure: CA が原因で失敗
 - notApplied: 評価対象外または条件不一致

SigninLogs の列定義として ConditionalAccessStatus と ConditionalAccessPolicies が公式に公開されている。


### 4.2 アプリ別の CA 失敗件数

どのアプリで問題が出ているかを確認する。

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where ConditionalAccessStatus == "failure"
| summarize FailureCount = count() by AppDisplayName
| order by FailureCount desc
```

#### 用途
- Grafana / ServiceNow のどちらで失敗が多いか確認
- CA 適用後の影響確認


## 5. Grafana / ServiceNow 向け確認クエリ

### 5.1 Grafana の CA 適用状況

Grafana 向けサインインを絞って確認する。

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where AppDisplayName contains "Grafana"
| project CreatedDateTime,
          UserPrincipalName,
          AppDisplayName,
          ConditionalAccessStatus,
          ResultType,
          ResultDescription,
          ConditionalAccessPolicies
| order by CreatedDateTime desc
```

### 5.2 ServiceNow の CA 適用状況

ServiceNow 向けサインインを絞って確認する。

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where AppDisplayName contains "ServiceNow"
| project CreatedDateTime,
          UserPrincipalName,
          AppDisplayName,
          ConditionalAccessStatus,
          ResultType,
          ResultDescription,
          ConditionalAccessPolicies
| order by CreatedDateTime desc
```

#### 用途
- アプリ単位で CA が本当に効いているか確認
- README / evidence 用のスクリーンショット取得にも使いやすい


## 6. MFA の影響確認

### 6.1 MFA が絡むサインインを確認

MFA の結果と CA の関係を見るための基礎クエリ。

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where AppDisplayName in ("Grafana", "ServiceNow")
| project CreatedDateTime,
          UserPrincipalName,
          AppDisplayName,
          ConditionalAccessStatus,
          AuthenticationRequirement,
          ResultType,
          ResultDescription
| order by CreatedDateTime desc
```

#### 用途
- MFA が要求されたか確認
- CA 有効化後に想定どおり強化されているか確認


### 6.2 MFA 必須化後の失敗傾向

MFA 導入で失敗が増えていないかを見る。

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where AuthenticationRequirement =~ "multiFactorAuthentication"
| summarize Count = count() by AppDisplayName, ConditionalAccessStatus
| order by AppDisplayName asc, Count desc
```


## 7. ポリシー単位の影響確認

ConditionalAccessPolicies は動的データとして格納されるため、展開して確認できる。
公式にも、サインインごとにトリガーされたポリシー一覧が格納されることが示されている。

### 7.1 適用されたポリシー一覧を展開

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where isnotempty(ConditionalAccessPolicies)
| mv-expand CAPolicy = ConditionalAccessPolicies
| project CreatedDateTime,
          UserPrincipalName,
          AppDisplayName,
          ConditionalAccessStatus,
          tostring(CAPolicy.displayName),
          tostring(CAPolicy.result)
| order by CreatedDateTime desc
```

#### 用途
- どの CA ポリシーが実際に効いたか確認
- Report-only と Enforce の影響比較

## 8. CA 失敗の詳細切り分け

### 8.1 失敗理由を確認

```kusto
SigninLogs
| where CreatedDateTime >= ago(7d)
| where ConditionalAccessStatus == "failure"
| project CreatedDateTime,
          UserPrincipalName,
          AppDisplayName,
          ResultType,
          ResultDescription,
          IPAddress,
          Location,
          CorrelationId
| order by CreatedDateTime desc
```


#### 用途
- 失敗時の原因確認
- チケット対応時の一次切り分け

Microsoft Learn では、Conditional Access の詳細はサインインログの Conditional Access タブから確認でき、Helpdesk や Tenant 管理者の典型的な活用シナリオとして「ポリシーが原因かを切り分ける」ことが挙げられている。


## 9. 運用での見方

KQL で CA を見る時は、以下の順で見ると切り分けしやすい。

- そもそもログが来ているか
- ConditionalAccessStatus がどうなっているか
- どのアプリで失敗しているか
- どのユーザーに影響しているか
- どのポリシーが効いたか
- 直近でポリシー変更があったか

10. この分析の価値

本分析により、Conditional Access を「設定した」で終わらせず、以下を説明できるようになる。

- ポリシーが実際に適用されているか
- MFA が期待どおり動いているか
- 失敗原因をどこまで切り分けられるか
- 運用時にどのログを見ればよいか

これは、SSO / Conditional Access を構築できるだけでなく、運用・分析できることを示す重要な証跡である。



