#language: ja
機能: lock

  ユーザは
  ノードをインストールするために
  unlock コマンドでロックをはずす

  シナリオ: 1 ノード、ロック 1 種類
    前提 空のロックデータファイル
    かつ ll lock "tick001 1hour --from 2020-01-01" でロックをかけた
    もし ll unlock "tick001" でアンロックした
    ならば 次の出力を得る:
    """
    tick001:
      0) [yasuhito] 2020/01/01 (Wed) 12:00 - 13:00
    Unlock? [Y/n]
    """
    もし ロックを表示した
    ならば 現在のロックは無し

  シナリオ: 3 ノード、ロック 1 種類
    前提 空のロックデータファイル
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-01" でロックをかけた
    もし ll unlock "tick001,tick002,tick003" でアンロックした
    ならば 次の出力を得る:
    """
    tick001, tick002, tick003:
      0) [yasuhito] 2020/01/01 (Wed) 12:00 - 13:00
    Unlock? [Y/n]
    """
    もし ロックを表示した
    ならば 現在のロックは無し

  シナリオ: 3 ノード、ロック 2 種類
    前提 空のロックデータファイル
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-01" でロックをかけた
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-02" でロックをかけた
    もし ll unlock "tick001,tick002,tick003" でアンロックした
    ならば 次の出力を得る:
    """
    tick001, tick002, tick003:
      0) [yasuhito] 2020/01/01 (Wed) 12:00 - 13:00
      1) [yasuhito] 2020/01/02 (Thu) 12:00 - 13:00
    Select [0..1] (default = 0):
    """
    もし ロックを表示した
    ならば 次の出力を得る:
    """
    tick001:
      [yasuhito] 2020/01/02 (Thu) 12:00 - 13:00
    tick002:
      [yasuhito] 2020/01/02 (Thu) 12:00 - 13:00
    tick003:
      [yasuhito] 2020/01/02 (Thu) 12:00 - 13:00
    """

  シナリオ: 3 ノード、ロック 1 種類、2 ノードだけアンロック
    前提 空のロックデータファイル
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-01" でロックをかけた
    もし ll unlock "tick001,tick002" でアンロックした
    ならば 次の出力を得る:
    """
    tick001, tick002:
      0) [yasuhito] 2020/01/01 (Wed) 12:00 - 13:00
    Unlock? [Y/n]
    """
    もし ロックを表示した
    ならば 次の出力を得る:
    """
    tick003:
      [yasuhito] 2020/01/01 (Wed) 12:00 - 13:00
    """

  シナリオ: 1 ノード、ロック 1 種類 --yes
    前提 空のロックデータファイル
    かつ ll lock "tick001 1hour --from 2020-01-01" でロックをかけた
    もし ll unlock "tick001 --yes" でアンロックした
    ならば 何も表示されない
    もし ロックを表示した
    ならば 現在のロックは無し

  シナリオ: 3 ノード、ロック 1 種類 --yes
    前提 空のロックデータファイル
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-01" でロックをかけた
    もし ll unlock "tick001,tick002,tick003 --yes" でアンロックした
    もし ロックを表示した
    ならば 現在のロックは無し

  シナリオ: 3 ノード、ロック 2 種類 --yes
    前提 空のロックデータファイル
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-01" でロックをかけた
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-02" でロックをかけた
    もし ll unlock "tick001,tick002,tick003 --yes" でアンロックした
    ならば 何も表示されない
    もし ロックを表示した
    ならば 次の出力を得る:
    """
    tick001:
      [yasuhito] 2020/01/02 (Thu) 12:00 - 13:00
    tick002:
      [yasuhito] 2020/01/02 (Thu) 12:00 - 13:00
    tick003:
      [yasuhito] 2020/01/02 (Thu) 12:00 - 13:00
    """

  シナリオ: 3 ノード、ロック 1 種類、2 ノードだけアンロック --yes
    前提 空のロックデータファイル
    かつ ll lock "tick001,tick002,tick003 1hour --from 2020-01-01" でロックをかけた
    もし ll unlock "tick001,tick002 --yes" でアンロックした
    ならば 何も表示されない
    もし ロックを表示した
    ならば 次の出力を得る:
    """
    tick003:
      [yasuhito] 2020/01/01 (Wed) 12:00 - 13:00
    """