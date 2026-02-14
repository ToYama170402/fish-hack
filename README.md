# fish-hack

本レポジトリは、[FISH×TECHハッカソン #いしかわの海の幸をアプデせよ](https://techplay.jp/event/989316)で提供されるデータをPostgreSQLに格納するコードを管理、提供します。なおこのレポジトリの作者[ToYama](https://github.com/ToYama170402)はFISH×TECHハッカソンには参加しておりません。

## ER図

以下はデータベースのER図（Mermaid）です。

```mermaid
erDiagram
    PREFECTURES {
        char(2) prefecture_code PK
        text name
        text name_kana
    }

    CITIES {
        char(6) city_code PK
        char(2) prefecture_code FK
        text name
        text name_kana
    }

    FISHING_CATEGORIES {
        int fishing_category_cd PK
        text fishing_category_name
    }

    STOCKS {
        int stock_cd PK
        text stock_name
    }

    LANDING {
        int id PK
        int year
        int month
        char(6) city_code FK
        int fishing_category_cd FK
        int stock_cd FK
        int quantity
        numeric amount
    }

    PRODUCTS {
        int product_id PK
        text name
    }

    MARKET {
        int id PK
        int year
        int product_id FK
        char(2) prefecture_code FK
        int8 quantity
        int8 amount
    }

    PREFECTURES ||--o{ CITIES : has
    CITIES ||--o{ LANDING : "landing in"
    FISHING_CATEGORIES ||--o{ LANDING : "category"
    STOCKS ||--o{ LANDING : "stock"
    PRODUCTS ||--o{ MARKET : "product"
    PREFECTURES ||--o{ MARKET : "prefecture"
```

## ディレクトリ構造

```text
.
├── README.md                                    # このファイル
├── docker-compose.yml
└── docker-entrypoint.initdb.d                   # PostgreSQLコンテナを初期化するためのクエリとデータを保存
    ├── 00_prefecture_city_code.sql              # 都道府県・市町村コードテーブルを作成する初期化SQL
    ├── 10_landing.sql                           # 水揚げデータテーブルを作成する初期化SQL
    ├── 20_market.sql                            # 金沢中央卸売市場のテーブルを作成する初期化SQL
    ├── 金沢市中央卸売市場_水産物部_塩干.csv
    ├── 金沢市中央卸売市場_水産物部_鮮魚.csv
    ├── 金沢市中央卸売市場_水産物部_冷凍魚.csv
    ├── 石川県水揚げデータ_2025_12_18.csv
    └── 都道府県コード.csv
```

## データソース

### `docker-entrypoint.initdb.d/金沢市中央卸売市場_水産物部_塩干.csv`

- 出典：[石川県オープンデータカタログサイト](https://ckan.opendata.pref.ishikawa.lg.jp/dataset/kanazawa_market_products_by_origin_annual/resource/eaf82644-eeff-4124-8b1c-464820905de9)
- ライセンス：[CC BY 4.0](https://opendefinition.org/licenses/cc-by/)

### `docker-entrypoint.initdb.d/金沢市中央卸売市場_水産物部_鮮魚.csv`

- 出典：[石川県オープンデータカタログサイト](https://ckan.opendata.pref.ishikawa.lg.jp/dataset/kanazawa_market_products_by_origin_annual/resource/65cf9249-739b-48a1-a0f3-686317433b1a)
- ライセンス：[CC BY 4.0](https://opendefinition.org/licenses/cc-by/)

### `docker-entrypoint.initdb.d/金沢市中央卸売市場_水産物部_冷凍魚.csv`

- 出典：[石川県オープンデータカタログサイト](https://ckan.opendata.pref.ishikawa.lg.jp/dataset/kanazawa_market_products_by_origin_annual/resource/efe6e131-395f-4401-b3d2-0d7974f6e11e)
- ライセンス：[CC BY 4.0](https://opendefinition.org/licenses/cc-by/)

### `docker-entrypoint.initdb.d/石川県水揚げデータ_2025_12_18.csv`

- 出典：[石川県オープンデータカタログサイト](https://ckan.opendata.pref.ishikawa.lg.jp/dataset/fish)
- ライセンス：[CC BY 4.0](https://opendefinition.org/licenses/cc-by/)
- 備考：Excel形式からCSVに変換済み。

### `docker-entrypoint.initdb.d/都道府県コード.csv`

- 出典：[総務省 都道府県コード及び市区町村コード](https://www.soumu.go.jp/denshijiti/code.html)
