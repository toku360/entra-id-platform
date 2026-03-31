# Overview

## 1. このドキュメントの目的
本リポジトリは、Microsoft Entra ID を中心とした Azure 基盤を Terraform で設計・構築・運用するためのポートフォリオである。  
単なる検証用コードではなく、**実務で説明可能な Azure 設計・IaC・運用ルール** を整理し、採用担当・現場リーダー・レビュー担当に対して、設計意図まで含めて提示できる状態を目指す。

本ドキュメント群では、以下を定義する。

- Azure 全体アーキテクチャ
- Network / Security / RBAC / Cost / 可用性の設計方針
- Terraform による環境分離と remote state 管理
- GitHub Actions + OIDC による CI/CD 方針
- Entra ID と Azure 管理の接続方針
- 実運用を意識した変更管理、検証、ロールバック手順

## 2. 想定する対象読者
- 採用担当者
- Azure / Terraform のレビュー担当者
- 社内のクラウド基盤担当
- 今後この環境を拡張する自分自身

## 3. 本プロジェクトの狙い
本プロジェクトの狙いは、Entra ID × Azure 基盤 × IaC を横断して扱えることを示すことである。  
特に、以下の観点を重視する。

- Terraform による再現性のある Azure 構築
- dev / stg / prod を前提とした環境分離
- remote backend による安全な state 管理
- GitHub Actions OIDC による安全な CI/CD
- 最小権限を前提とした RBAC 設計
- Public IP 依存を減らした安全な管理経路
- ログ・監査証跡を残せる運用方針

## 4. 現時点の設計前提
- Cloud: Microsoft Azure
- Main Region: Japan East
- IaC: Terraform
- CI/CD: GitHub Actions
- Azure Authentication for CI/CD: OIDC
- State Management: Azure Storage remote backend
- Environment Separation: dev / stg / prod
- Operation Principle: least privilege / no manual state edit / evidence-first

## 5. ドキュメント一覧
- [01-architecture.md](./01-architecture.md)  
  Azure 全体構成、ネットワーク、セキュリティ、可用性・コスト設計
- [02-terraform.md](./02-terraform.md)  
  Terraform のディレクトリ構成、module 設計、backend 設計
- [03-github-actions.md](./03-github-actions.md)  
  GitHub Actions と OIDC による plan/apply 設計
- [04-entra-id.md](./04-entra-id.md)  
  Entra ID 側の認証・権限・アプリ登録方針
- [05-operations.md](./05-operations.md)  
  運用ルール、変更手順、検証、ロールバック、証跡管理

## 6. この docs で示す価値
この docs 群は、単なる「手順書」ではない。  
以下の説明ができることを目的としている。

- なぜその構成にしたのか
- どこまでを自動化し、どこを運用ルールで補うのか
- どのように安全性・監査性・拡張性を担保するのか
- 学習用構成であっても、どの部分が実務に接続するのか

## 7. 今後の拡張
本プロジェクトは今後、以下の要素を段階的に強化する。

- Entra ID 連携アプリの拡充
- Conditional Access / MFA / PIM を含むガバナンス設計
- ログ集約と可視化の強化
- 監視・アラート・運用Runbookの整備
- より本番想定に近いネットワーク・権限分離


