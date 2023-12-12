CREATE OR REPLACE FUNCTION generate_searchable(_nome VARCHAR, _apelido VARCHAR, _stack JSON)
    RETURNS TEXT AS
$$
BEGIN
    RETURN _nome || _apelido || _stack;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

create table pessoa
(
    uuid       varchar(255) not null
        primary key,
    apelido    varchar(32)  not null
        unique,
    nome       varchar(100) not null,
    nascimento date         not null,
    stack      json,
    search     text generated always as (generate_searchable(nome, apelido, stack)) stored
);
CREATE INDEX idx_search_btree ON pessoa USING btree (search);
