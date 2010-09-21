#language: ja
機能: show

  ユーザは
  ノードのロック状態を確認するために
  show コマンドでロックを表示する

  シナリオ: ロックの表示
    前提 空のロックデータファイル
    かつ ll lock "tick001 2hours --from 2020-05-27" でロックをかけた
    もし ロックを表示した
    ならば 次の出力を得る:
      """
      tick001:
        [yutaro] 2020/05/27 (Wed) 12:00 - 14:00
      """

  シナリオ: ロックを JSON 形式で表示
    前提 空のロックデータファイル
    かつ ll lock "tick001 2hours --from 2020-05-27" でロックをかけた
    もし ロックを JSON 形式で表示した
    ならば 次の JSON 出力を得る:
      """
      {"tick001":[{"data":{"user":"yutaro","from":"Wed May 27 12:00:00 +0900 2020","to":"Wed May 27 14:00:00 +0900 2020"},"json_class":"Lock"}]}
      """

  シナリオ: ロックの表示 (2 ノード)
    前提 空のロックデータファイル
    かつ ll lock "tick001 2hours --from 2020-05-27" でロックをかけた
    かつ ll lock "tick002 2hours --from 2020-05-28" でロックをかけた
    もし ロックを表示した
    ならば 次の出力を得る:
      """
      tick001:
        [yutaro] 2020/05/27 (Wed) 12:00 - 14:00
      tick002:
        [yutaro] 2020/05/28 (Thu) 12:00 - 14:00
      """

  シナリオ: ロックを JSON 形式で表示 (2 ノード)
    前提 空のロックデータファイル
    かつ ll lock "tick001 2hours --from 2020-05-27" でロックをかけた
    かつ ll lock "tick002 2hours --from 2020-05-28" でロックをかけた
    もし ロックを JSON 形式で表示した
    ならば 次の JSON 出力を得る:
      """
      {"tick001":[{"data":{"user":"yutaro","from":"Wed May 27 12:00:00 +0900 2020","to":"Wed May 27 14:00:00 +0900 2020"},"json_class":"Lock"}],"tick002":[{"data":{"user":"yutaro","from":"Thu May 28 12:00:00 +0900 2020","to":"Thu May 28 14:00:00 +0900 2020"},"json_class":"Lock"}]}
      """

  シナリオ: ロックの表示 (無効なロック)
    前提 空のロックデータファイル
    かつ ll lock "tick001 2hours --from 1977-07-13" でロックをかけた
    かつ ll lock "tick001 2hours --from 2020-05-27" でロックをかけた
    もし ロックを表示した
    ならば 次の出力を得る:
      """
      tick001:
        [yutaro] 2020/05/27 (Wed) 12:00 - 14:00
      """
