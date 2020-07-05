# httmpc

mpd サーバのフロントエンドとなる web サーバです。
httmpc が動作するサーバにブラウザでアクセスすることで、mpd サーバの選曲や再生ができます。

主な使い方として、Raspberry Pi 上に [rbtune](https://github.com/fusuian/rbtune) ともどもインストールして、自動録音されたラジオ番組を再生すること（また、聞き終わった番組を手軽に消去すること）を想定しています。
mp3 などのアルバムのコレクションからの再生には向かないので、その場合は他の mpd クライアントをご利用ください。


## インストールと設定

あらかじめ mpd をインストールする必要があります。

    $ sudo apt install mpd

httmpc 本体は gem でインストールできます。Ruby 2.5以降が必要です。

    $ gem install httmpc


## 使い方

### サーバの起動
以下のコマンドで httmpc が起動します。

    $ httmpc -e production

コマンドラインオプションはsinatraに準じます、

    Usage: httmpc [options]
      -p port                          set the port (default is 4567)
      -s server                        specify rack server/handler (default is thin)
      -q                               turn on quiet mode (default is off)
      -x                               turn on the mutex lock (default is off)
      -e env                           set the environment (default is development)
      -o addr                          set the host (default is (env == 'development' ? 'localhost' : '0.0.0.0'))

ただし、ポートを指定する-pオプションは効果がないので、環境変数PORTで設定します。

    $ PORT=80 httmpc -e production


### ブラウザからのアクセス

ホスト recorder.local 上でhttmpcを起動した場合、ブラウザから以下のアドレスにアクセスすると、音声ファイルのリストが表示されます。

デフォルトで起動した場合:
http://recorder.local:4567/

PORT=80 で起動した場合:
http://recorder.local/


#### All List タブ

All List タブをクリックすると、録音された音声ファイルの一覧が表示されます。
タイトル、日付、時:分 でソートできます。音声ファイル名がボタンになっているので、これをクリックするとPlaylist に追加されます。右端のゴミ箱アイコンをクリックするとファイルを削除します。
録音されたはずのファイルが表示されない場合は、ブラウザからリロードを繰り返すと表示されます。


#### Playlist タブ
Playlist タブをクリックすると、プレイリストが表示されます。
これもタイトル、日付、時:分 でソートでき、音声ファイル名のボタンを押すと再生が始まります。
再生が済んでもプレイリストから自動的に消えることはないので、右端のxボタンを押して音声ファイルをプレイリストから取り除きます。（ファイルは消えません）


#### コントロールパネル
どちらのタブでも、上部にはコントロールパネルがあります。
コントロールパネルの機能は以下のようになっています。（上から）
* 再生中のタイトルとプレイリストの進む・戻るボタン
* 再生位置バー
* 30秒戻る、15秒戻る、再生開始、一時停止、15秒進む、30秒進む
* 15分戻る、5分戻る、1分戻る、1分進む、5分進む、15分進む


### サービスとして登録する

httmpcはWebサーバなので、コマンドラインから起動するよりも、自動起動されるようにサービスとして登録する方が便利です。
Raspberry piの場合、以下のような httmpc.service を用意して /etc/systemd/system/ に配置して、

  $ sudo systemctl enable httmpc

としてから再起動すると、OSが起動するときに自動的に httmpc が起動するようになります。

    [Unit]
    Description=httmpc - run mpd Web frontend
    After=network.target

    [Service]
    Type = simple
    Environment=PORT=80
    ExecStart = /usr/local/bin/httmpc -e production
    Restart = always

    [Install]
    WantedBy=multi-user.target



## プロジェクトへの協力

バグ報告やプルリクエストは Github の https://github.com/fusuian/httmpc まで、よろしくお願いします。
