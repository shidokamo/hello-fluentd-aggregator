# Hello Fluentd Aggregator on GKE
Fluentd のサイドカーコンテナからの出力を Aggregator に Forward するサンプルです。

## Requirements
事前に、以下の２つのイメージをビルドしておく必要があります。

* [fluentd-image](https://github.com/shidokamo/fluentd-image)
* [test-logger-image](https://github.com/shidokamo/test-logger-image)

ローカルにイメージを保存するか、もしくはクラウドレポジトリに登録しておく必要があります。
gcr.io のコンテナレジストリ以外を使う場合は、イメージのパスを書き換えてください。

## デプロイ
```
make
```

## Forwarder の動作
Pod 内に2つのコンテナを起動します。
* logger コンテナは、`/var/log/app.log` へログローテートを行いながらログを出力し続けます。
* sidecar コンテナは、`/var/log/app.log` を監視し、得たログを Aggregator に Forward します。
* Pod は 3 つ起動されます。

## Forwarder の動作
Pod 内に1つのコンテナを起動します。
* aggregator コンテナは、GCS へローテートを行いながらログを出力し続けます。
* aggregator コンテナは、標準出力へも同時に出力を行います。

## ログの確認
Fluentd の Aggregator コンテナの最終出力結果は以下のように確認できます。
Pod の名前は、`kubectl get pod` で得たものに置き換えてください。

```
kubectl logs aggregator-59cb4fdbc6-6kd4s
```

## クリーンナップ
```
make clean
```
