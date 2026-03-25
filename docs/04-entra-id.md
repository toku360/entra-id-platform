# Entra ID

GitHub Actions から Azure へアクセスするため  
Microsoft Entra ID を使用しています。

---

# App Registration


entra-id-platform-github


役割

- GitHub ActionsのID
- OIDC認証
- RBAC付与対象

---

# OIDC構成

GitHub → Entra ID


issuer
https://token.actions.githubusercontent.com


---

# Federated Credential

2つの用途で分離

## PR用


repo:toku360/entra-id-platform:pull_request


Terraform Plan

---

## main用


repo:toku360/entra-id-platform:ref:refs/heads/main


Terraform Apply

---

# なぜ分離するか

GitHub Actions の subject は


pull_request
branch
environment


で変わるため。

誤ると


AADSTS700213


エラーが発生します。

---

# RBAC

App Registration に Azure RBAC を付与します。

例


Contributor


または


Terraform専用カスタムRole


---

# 証跡


docs/evidence/identity
docs/evidence/app-registration


保存対象

- App Registration
- Federated Credential
- OIDCログ



