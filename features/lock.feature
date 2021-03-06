#language: ja
機能: lock

  ユーザは
  ノードがインストールされてしまうのを防ぐために
  lock コマンドでロックをかける

  シナリオ: ロック (デフォルト)
    前提 空のロックデータファイル
    もし ll lock "tick001" でロックをかけた
    ならば ノード "tick001" が 1 時間ほどロックされる

  シナリオ: ロック ("?hours" 形式で時間を指定)
    前提 空のロックデータファイル
    もし ll lock "tick001 2hours" でロックをかけた
    ならば ノード "tick001" が 2 時間ほどロックされる

  シナリオ: ロック ("?day" 形式で時間を指定)
    前提 空のロックデータファイル
    もし ll lock "tick001 1day" でロックをかけた
    ならば ノード "tick001" が 24 時間ほどロックされる

  シナリオ: ロック ("today" 形式で時間を指定)
    前提 空のロックデータファイル
    もし ll lock "tick001 today" でロックをかけた
    ならば ノード "tick001" が今日一日の間ロックされる

  シナリオ: ロック ("?days --from ???" 形式で時間を指定)
    前提 空のロックデータファイル
    もし ll lock "tick001 2days --from tomorrow" でロックをかけた
    ならば ノード "tick001" が 48 時間ほどロックされる
