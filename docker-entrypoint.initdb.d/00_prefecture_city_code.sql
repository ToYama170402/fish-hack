create table
  japan_area_code_raw_data (
    area_code text,
    prefecture_name text,
    city_name text,
    prefecture_name_kana text,
    city_name_kana text
  );

copy
  japan_area_code_raw_data
from
  '/docker-entrypoint-initdb.d/都道府県コード.csv'
with
  (format csv, header true, encoding 'utf8');

create table
  prefectures (
    prefecture_code char(2) primary key,
    name text not null,
    name_kana text not null
  );

insert into
  prefectures (prefecture_code, name, name_kana)
select
  substring(
    area_code
    from
      0 for 3
  ),
  prefecture_name,
  prefecture_name_kana
from
  japan_area_code_raw_data
where
  city_name is null;

create table
  cities (
    city_code char(6) primary key,
    prefecture_code char(2) not null,
    name text not null,
    name_kana text not null,
    foreign key (prefecture_code) references prefectures (prefecture_code)
  );

insert into
  cities (city_code, prefecture_code, name, name_kana)
select
  area_code,
  substring(
    area_code
    from
      0 for 3
  ),
  city_name,
  city_name_kana
from
  japan_area_code_raw_data
where
  city_name is not null;

drop table japan_area_code_raw_data;

