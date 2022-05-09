# elixir-learning

Elixir 学習用

## コンテナからの実行

```bash
$ docker-compose up
...
Attaching to elixir-learning-livebook-1
elixir-learning-livebook-1  | [Livebook] Application running at http://localhost:8080/?token=xxxxx
```

表示される URL にアクセスする

## WSL からの実行

### WSL 用のエクスポート

コンテナを起動している状態で以下のコマンドを実行する

```bash
docker export elixir-learning-livebook-1 -o elixir.tar.gz
```

### WSL へのインポート

実行する Windows マシンの PowerShell で以下のコマンドを実行する

※ WSL2 導入済とする

```ps1
wsl --import elixir $env:userprofile\AppData\elixir elixir.tar.gz
```

### WSL での起動

実行する Windows マシンの PowerShell で以下のコマンドを実行する

```ps1
wsl -d elixir
```

### 設定

以下のコマンドを実行して環境変数を設定する

```bash
source /home/livebook/setup_for_wsl.sh
```

### LiveBook の起動

LiveBook を起動する

```bash
/app/bin/livebook start
```

## ノード間通信の確認

二つ、異なるターミナルを開き、それぞれで起動したプロセスが通信できることを確認する

### コンテナ内での操作

Docker 上で実行している場合は以下のコマンドで docker コンテナ内に入る

```bash
docker exec -it elixir-learning-livebook-1 /bin/bash
```

### ノードの起動

一方のターミナル (以後、ターミナル foo とする) で以下のコマンドを実行する

```bash
iex --sname foo
```

他方のターミナル (以後、ターミナル bar とする) で以下のコマンドを実行する

```bash
iex --sname bar
```

### Ping Pong Pang

ターミナル foo で以下のコマンドを実行する

```elixir
Node.ping(:bar@<ホスト名>)
```

`:pong` が返ってくることを確認する

ターミナル bar で以下のコマンドを実行する

```elixir
Node.ping(:foo@<ホスト名>)
```

`:pong` が返ってくることを確認する

ターミナル bar で以下のコマンドを実行する

```elixir
Node.ping(:baz@<ホスト名>)
```

`:pang` が返ってくることを確認する

### ノードの接続

ターミナル foo で以下のコマンドを実行する

```elixir
Node.list
```

`[]` が返ってくることを確認する

ターミナル bar で以下のコマンドを実行する

```elixir
Node.list
```

`[]` が返ってくることを確認する

ターミナル foo で以下のコマンドを実行する

```elixir
Node.connect(:bar@<ホスト名>)
```

`true` が返ってくることを確認する

ターミナル foo で以下のコマンドを実行する

```elixir
Node.list
```

`[:bar@<ホスト名>]` が返ってくることを確認する

ターミナル bar で以下のコマンドを実行する

```elixir
Node.list
```

`[:foo@<ホスト名>]` が返ってくることを確認する

### メッセージの送信

ターミナル bar で以下のコマンドを実行する

```elixir
pid = self()
:global.register_name( :reciever, pid )
receive do message -> IO.puts( "received: #{ message }" ) end
```

ターミナル foo で以下のコマンドを実行する

```elixir
to_pid = :global.whereis_name( :reciever )
send( to_pid, "send from foo" )
```

ターミナル bar で `received: send from foo` と表示されることを確認する

ターミナル foo で以下のコマンドを実行する

```elixir
send( to_pid, "second message" )
```

ターミナル bar で以下のコマンドを実行する

```elixir
receive do message -> IO.puts( "received: #{ message }" ) end
```

ターミナル bar で `received: second message` と表示されることを確認する

## Phoenix LiveView の起動

### リポジトリーのクローン

サンプル用のリポジトリーをクローンする

```bash
cd \
  && git clone https://github.com/RyoWakabayashi/phoenix-liveview-example.git \
  && cd phoenix-liveview-example
```

### 依存パッケージの取得

```bash
mix setup
```

### 設定ファイルの編集

コンテナ外部からアクセスできるように設定ファイルを編集する

```bash
sed -i -e 's/127, 0, 0, 1/0, 0, 0, 0/g' config/dev.exs
```

### Phoenix の起動

```bash
mix phx.server
```

表示される URL にアクセスする
