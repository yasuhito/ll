#language: ja
機能: nshow

  ユーザは
  ノードのロック状態を確認するために
  nshow コマンドでロックを表示する

  シナリオ: ロックの表示
    前提 空のロックデータファイル
    かつ nlock "tick001 2hours --from 1979-05-27" でロックをかけた
    もし ロックを表示した
    ならば 次の出力を得る:
      """
      tick001:
        1979/05/27 (Sun) 12:00 - 14:00
      """

  シナリオ: ロックの表示 (2 ノード)
    前提 空のロックデータファイル
    かつ nlock "tick001 2hours --from 1979-05-27" でロックをかけた
    かつ nlock "tick002 2hours --from 1979-05-28" でロックをかけた
    もし ロックを表示した
    ならば 次の出力を得る:
      """
      tick001:
        1979/05/27 (Sun) 12:00 - 14:00
      tick002:
        1979/05/28 (Mon) 12:00 - 14:00
      """
