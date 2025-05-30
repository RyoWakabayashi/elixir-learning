# elixir-learning

Elixir 学習用

## コンテナからの実行

### Livebook 単独での起動

```bash

```bash
$ docker compose up --build
...
Attaching to livebook
livebook  | [Livebook] Application running at http://localhost:8080/?token=xxxxx
```

表示される URL にアクセスする

### Livebook と PostgreSQL 、 SQL Server を同時に起動

Apple Silicon の場合、 SQL Server を使用するために Rosetta を使用する必要がある

```bash
/usr/sbin/softwareupdate --install-rosetta --agree-to-license
```

Rancher Desktop の設定

- `Preferences` > `Virtual Machine` > `Emulation` を `VZ` に設定する
- `Preferences` > `Virtual Machine` > `Volumes` を `virtiofs` に設定する

コンテナを起動する

```bash
$ docker compose -f docker-compose.with-db.yml up --build
...
postgres_for_livebook  | 2023-10-30 11:47:54.930 UTC [1] LOG:  database system is ready to accept connections
...
livebook_with_db       | [Livebook] Application running at http://localhost:8080/?token=xxxxx
```

表示される URL にアクセスする

### Livebook と Neo4j を同時に起動

```bash
$ docker compose -f docker-compose.with-neo4j.yml up --build
...
postgres_for_livebook  | 2023-10-30 11:47:54.930 UTC [1] LOG:  database system is ready to accept connections
...
livebook_with_db       | [Livebook] Application running at http://localhost:8080/?token=xxxxx
```

表示される URL にアクセスする

Neo4j Browser には `http://localhost:7474` でアクセスできる

### Livebook と FalkorDB を同時に起動

```bash
$ docker compose -f docker-compose.with-falkor-db.yml up --build
...
postgres_for_livebook  | 2023-10-30 11:47:54.930 UTC [1] LOG:  database system is ready to accept connections
...
livebook_with_db       | [Livebook] Application running at http://localhost:8080/?token=xxxxx
```

表示される URL にアクセスする

FalkorDB Browser には `http://localhost:3000` でアクセスできる

### Charms 用コンテナの起動

[Charms](https://github.com/beaver-lodge/charms) を使用する場合、以下のコマンドでコンテナを起動する

ただし、 Apple Sillicon 以外には対応していない

```bash
$ docker compose -f docker-compose.charms.yml up --build
...
livebook_charms  | [Livebook] Application running at http://localhost:8080/?token=xxxxx
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
docker exec -it livebook /bin/bash
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

## 新規プロジェクトの作成

以下のコマンドで新規プロジェクトを作成する

※今回は DB を使わないので `--no-ecto` を付けている

```bash
mix phx.new hello_world --no-ecto
```

プロジェクトが `hello_world` ディレクトリーに作成される

`hello_world` ディレクトリーに移動して Phoenix を起動する

```bash
cd hello_world
sed -i -e 's/127, 0, 0, 1/0, 0, 0, 0/g' config/dev.exs
mix phx.server
```
