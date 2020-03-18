# Aiwolf-docker

Aiwolf-dockerは，[人狼知能プロジェクト](http://aiwolf.org/) から提供されている[人狼知能プラットフォーム](http://aiwolf.org/server)をDocker上に簡単に構築するためのものです．

## 内容

- AutoStarter.ini
  - 人狼知能サーバの設定ファイル
- SampleSetting.cfg
  - 人狼知能サーバ内のゲーム設定ファイル
- agent/
  - 使用するエージェントを入れるフォルダ
- log/
  - 出力されたログデータが保存されるフォルダ
- Dockerfile
  - Dockerイメージを作成するためのファイル
- build.sh
  - docker buildのコマンドが書かれたシェルスクリプト 
- run.sh
  - docker runのコマンドが書かれたシェルスクリプト 
- LICENSE
  - ライセンスについて書かれているファイル
- README.md
  - このファイル



## 使い方(シンプル)

**【前提条件】dockerコマンドが使える環境であること**

1. ターミナルを開き，カレントディレクトリをbuild.shが入っているディレクトリにする
2. `bash build.sh`でdockerイメージを作成する(そこそこ時間がかかる)
3. `run.sh`でdockerを実行する

なお，設定を変えたいときなどは，AutoStarter.iniやSampleSetting.cfgの中身を変更する．自作エージェントや外部エージェントを参加させる場合は，agentフォルダにjarファイルやpythonのプログラムなどを入れる．Javaエージェントの場合はパスを書くのみで動くが，pythonやC#エージェントは仕様上フルパスを書く必要がある．agentフォルダはdocker上では`/home/aiwolf-platform/agent/`になるので，それを前提にフルパスをAutoStarter.iniに書き込む必要がある



## 使い方(シェルスクリプトを使用しない方法)

1. `docker build`コマンドでDockerfileをビルドします
2. `docker run`コマンドでイメージを起動し，実行します．このとき，`-v`オプションを使用して，`AutoStarter.ini`を`/home/aiwolf-platform/AutoStarter.ini`としてマウントしてください．あとは，AutoStarter.iniに書き込んだ *lib=xxx, log=xxx, setting=xxx* にあたる各フォルダ・ファイルを同じく`-v`オプションを使用してマウントしてください



## コンテナへの入り方

Dockerfile上で`bash /home/aiwolf-platform/AutoStarter.sh`が最初に実行されるようにしているだけなので，実行されるコマンドを上書きしてrunすればOKです．よって，

`docker run -it --name [コンテナ名] [イメージ名]:[タグ] bash`といったように，bashが実行されるようにすると，コンテナの中を見ることができます．



## 内部環境

- Java8 (OpenJDK)
- Miniconda3 - Python3.6.5仮想環境構築済
- .NET Core SDK 2.2

