# tf-ecr-sandbox
TerraformでECRを作成しイメージのビルドとプッシュまで行う

## 作成するリソース
- ECRリポジトリ
  - ECRリポジトリライフサイクルルール
- Dockerイメージ

## 事前条件
- 「作成するリソース」の操作権限を持つアカウントプロファイルで`aws`CLIが実行できること
- バックエンドとして`buildx`を使用する状態で`docker build`が可能なこと
- `terraform`が実行できること
- `go`が実行できること
  - `go`を使った簡単なサンプルプログラムをDockerイメージに含めるため

## 操作手順
1. `cd tool/terraform`
1. `chmod +x deploy.sh`
1. `./deploy.sh`: TerraformのVariableに環境変数経由で値を渡すため、`source`コマンドは使わない方がより安全。
  - `aws_region`はデフォルト`ap-northeast-1`のため、変更したい場合は何かしらの方法で上書きすること。
