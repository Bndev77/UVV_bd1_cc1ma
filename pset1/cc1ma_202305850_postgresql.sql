-- DROP statements são usados para remover objetos de banco de dados existentes, caso necessário

DROP DATABASE IF EXISTS uvv; --DROP DATABASE IF EXISTS uvv; iria remover o banco de dados "uvv", se ele existisse

DROP   USER   IF EXISTS brunomacedo; -- DROP USER IF EXISTS brunomacedo; iria remover o usuário "brunomacedo", se ele existisse

CREATE USER brunomacedo WITH -- CREATE USER é usado para criar um novo usuário no banco de dados
 
 SUPERUSER

 INHERIT

 CREATEDB

 CREATEROLE

 REPLICATION
    
 ENCRYPTED PASSWORD '1234567';

 COMMENT ON ROLE brunomacedo IS 'usuário administrativo do bd uvv.'; -- COMMENT ON ROLE é usado para adicionar um comentário ao usuário
  

CREATE DATABASE uvv -- CREATE DATABASE: permite que o usuário crie bancos de dados
    
OWNER = brunomacedo
    
ENCODING = 'UTF8'
    
LC_COLLATE = 'pt_BR.UTF-8'
    
LC_CTYPE = 'pt_BR.UTF-8'
   
TEMPLATE = template0
    
ALLOW_CONNECTIONS = TRUE;

COMMENT ON DATABASE uvv IS 'Banco de Dados UVV.';

GRANT ALL PRIVILEGES ON DATABASE uvv TO brunomacedo;


\c "dbname=uvv user=brunomacedo password=1234567";





CREATE SCHEMA lojas; -- CREATE SCHEMA é usado para criar um novo esquema no banco de dados
-- Neste caso, estamos criando o esquema "lojas"

COMMENT ON SCHEMA lojas IS 'Schema Lojas.';

ALTER USER brunomacedo SET SEARCH_PATH TO lojas, "$user", public; -- ALTER USER é usado para modificar as configurações de um usuário existente
-- Neste caso, estamos definindo o caminho de pesquisa do usuário "brunomacedo" para incluir o esquema "lojas"


-- CREATE TABLE é usado para criar uma nova tabela no banco de dados
-- Neste caso, estamos criando a tabela "produtos" com várias colunas e restrições
CREATE TABLE produtos (
                produto_id                NUMERIC(38)  NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                detalhes BYTEA,
                preco_unitario            NUMERIC(10,2),
                imagem BYTEA,
                imagem_mime_type          VARCHAR(512),
                imagem_aquivo             VARCHAR(512),
                imagem_charset            VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);

-- ALTER TABLE é usado para modificar uma tabela existente
-- Neste caso, estamos adicionando uma restrição CHECK à coluna "preco_unitario" na tabela "produtos"
ALTER TABLE produtos
ADD CONSTRAINT preco_check
CHECK (preco_unitario >= 0);

COMMENT ON TABLE  produtos                           IS 'Informações dos produtos disponíveis no sistema.';

COMMENT ON COLUMN produtos.produto_id                IS 'Identificador unico do produto.';
COMMENT ON COLUMN produtos.nome                      IS 'Nome do produto.';
COMMENT ON COLUMN produtos.detalhes                  IS 'Detalhes adicionais sobre o produto.';
COMMENT ON COLUMN produtos.imagem                    IS 'Caminho ou URL da imagem representativa do produto.';
COMMENT ON COLUMN produtos.imagem_mime_type          IS 'Tipo MIME da imagem do produto.';
COMMENT ON COLUMN produtos.imagem_aquivo             IS 'Conteudo binario da imagem do produto.';
COMMENT ON COLUMN produtos.imagem_charset            IS 'Conjunto de caracteres utilizado para codificar a imagem do produto.';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Data e hora da ultima atualização da imagem do produto.';

-- CREATE TABLE é usado para criar uma nova tabela no banco de dados
-- Neste caso, estamos criando a tabela "lojas" com várias colunas e restrições
CREATE TABLE lojas (
                loja_id         NUMERIC(38)  NOT NULL,
                nome            VARCHAR(255) NOT NULL,
                latitude        NUMERIC,
                longitude       VARCHAR,
                logo BYTEA,
                logo_mime_type  VARCHAR(512),
                logo_arquivo    VARCHAR(512),
                logo_charset    VARCHAR(512),
                endereco_web    VARCHAR(100),
                logo_ultima_atualizacao DATE NOT NULL,
                endereco_fisico VARCHAR(512),
                CONSTRAINT lojas_pk PRIMARY KEY (loja_id)
);

-- ALTER TABLE é usado para modificar uma tabela existente
-- Neste caso, estamos adicionando uma restrição CHECK à coluna "endereco_web" na tabela "lojas"
ALTER TABLE lojas
ADD CONSTRAINT endereco_check
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

COMMENT ON TABLE lojas                  IS 'Informações sobre as lojas cadastradas no sistema.';

COMMENT ON COLUMN lojas.loja_id         IS 'Identificador unico da loja.';
COMMENT ON COLUMN lojas.nome            IS 'Armazena o nome da loja.';
COMMENT ON COLUMN lojas.latitude        IS 'Armazena a latitude geografica da localizacao da loja.';
COMMENT ON COLUMN lojas.longitude       IS 'Armazena a longitude geografica da localizacao da loja.';
COMMENT ON COLUMN lojas.logo            IS 'Armazena o caminho do arquivo da logo da loja.';
COMMENT ON COLUMN lojas.logo_mime_type  IS 'Armazena o tipo MIME do arquivo da logo da loja.';
COMMENT ON COLUMN lojas.logo_arquivo    IS 'Armazena o arquivo da logo da loja.';
COMMENT ON COLUMN lojas.logo_charset    IS 'Armazena o conjunto de caracteres utilizado para codificar a logo da loja.';
COMMENT ON COLUMN lojas.endereco_web    IS 'Armazena o endereço web da loja.';
COMMENT ON COLUMN lojas.endereco_fisico IS 'endereço fisico da loja';


-- CREATE TABLE é usado para criar uma nova tabela no banco de dados
-- Neste caso, estamos criando a tabela "estoques" com várias colunas e restrições
CREATE TABLE estoques (
  estoque_id NUMERIC(38) NOT NULL,
  loja_id    NUMERIC(38) NOT NULL,
  produto_id NUMERIC(38) NOT NULL,
  quantidade NUMERIC(38) NOT NULL,
  CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);

COMMENT ON TABLE estoques IS 'Informação do estoque dos produtos.';


-- ALTER TABLE é usado para modificar uma tabela existente
-- Neste caso, estamos adicionando restrições FOREIGN KEY à tabela "estoques"
-- para estabelecer relacionamentos com outras tabelas
ALTER TABLE estoques ADD CONSTRAINT estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION 
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- ALTER TABLE é usado para modificar uma tabela existente
-- Neste caso, estamos adicionando uma restrição CHECK à coluna "quantidade" na tabela "estoques"
ALTER TABLE estoques
ADD CONSTRAINT quantidade_check
CHECK (quantidade >= 0);

COMMENT ON COLUMN estoques.estoque_id IS 'Identificador unico do estoque.';
COMMENT ON COLUMN estoques.loja_id    IS 'Identificador unico da loja associada ao estoque.';
COMMENT ON COLUMN estoques.produto_id IS 'Identificador unico do produto associado ao estoque.';
COMMENT ON COLUMN estoques.quantidade IS 'Armazena a quantidade disponivel do produto no estoque.';

-- CREATE TABLE é usado para criar uma nova tabela no banco de dados
-- Neste caso, estamos criando a tabela "clientes" com várias colunas e restrições
CREATE TABLE clientes (
                cliente_id NUMERIC(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);

COMMENT ON TABLE clientes             IS 'Informações sobre clientes registrados no sistema.';

COMMENT ON COLUMN clientes.cliente_id IS 'Identificador único do cliente.';
COMMENT ON COLUMN clientes.email      IS 'Armazena o email do usuario.';
COMMENT ON COLUMN clientes.nome       IS 'Armazena o nome do cliente.';
COMMENT ON COLUMN clientes.telefone1  IS 'Armazena o primeiro telefone do usuario.';
COMMENT ON COLUMN clientes.telefone2  IS 'Armazena o segundo telefone do usuario.';
COMMENT ON COLUMN clientes.telefone3  IS 'Armazena o terceiro telefone do usuario.';

-- CREATE TABLE é usado para criar uma nova tabela no banco de dados
-- Criação da tabela pedidos
CREATE TABLE pedidos (
  pedido_id  NUMERIC(38) NOT NULL,
  data_hora  TIMESTAMP   NOT NULL,
  cliente_id NUMERIC(38) NOT NULL,
  status     VARCHAR(15) NOT NULL,
  loja_id    NUMERIC(38) NOT NULL,
  CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);

COMMENT ON TABLE pedidos IS 'Informações sobre os pedidos feitos pelos clientes.';

-- ALTER TABLE é usado para modificar uma tabela existente
-- Neste caso, estamos adicionando restrições FOREIGN KEY à tabela "pedidos"
-- para estabelecer relacionamentos com outras tabelas
ALTER TABLE pedidos
ADD CONSTRAINT pedidos_status_check
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

COMMENT ON COLUMN pedidos.pedido_id  IS 'Identificador único do pedido.';
COMMENT ON COLUMN pedidos.data_hora  IS 'Armazena a data e hora do pedido.';
COMMENT ON COLUMN pedidos.cliente_id IS 'Identificador único do cliente associado ao pedido.';
COMMENT ON COLUMN pedidos.status     IS 'Armazena o status atual do pedido.';
COMMENT ON COLUMN pedidos.loja_id    IS 'Identificador único da loja associada ao pedido.';

-- CREATE TABLE é usado para criar uma nova tabela no banco de dados
-- Criação da tabela envios
CREATE TABLE envios (
  envio_id         NUMERIC(38)   NOT NULL,
  cliente_id       NUMERIC(38)   NOT NULL,
  loja_id          NUMERIC(38)   NOT NULL,
  status           VARCHAR(15)   NOT NULL,
  endereco_entrega VARCHAR(512)  NOT NULL,
  CONSTRAINT envio_id PRIMARY KEY (envio_id)
);

COMMENT ON TABLE envios IS 'Informações sobre os envios dos produtos para os clientes da loja.';

ALTER TABLE envios
ADD CONSTRAINT envios_status_check
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

COMMENT ON COLUMN envios.envio_id         IS 'Identificador único do envio.';
COMMENT ON COLUMN envios.cliente_id       IS 'Referência à tabela clientes e indica o cliente associado ao envio.';
COMMENT ON COLUMN envios.loja_id          IS 'Faz referência à tabela lojas e indica a loja de origem do envio.';
COMMENT ON COLUMN envios.status           IS 'Indica o status atual do envio (pendente, concluído, em andamento, cancelado etc.).';
COMMENT ON COLUMN envios.endereco_entrega IS 'Armazena o endereço de entrega do envio.';


-- Criação da tabela pedido_itens
CREATE TABLE pedido_itens (
  pedido_id       NUMERIC(38)    NOT NULL,
  produto_id      NUMERIC(38)    NOT NULL,
  numero_da_linha NUMERIC(38)    NOT NULL,
  quantidade      NUMERIC(38)    NOT NULL,
  preco_unitario  NUMERIC(10, 2) NOT NULL,
  envio_id        NUMERIC(38),
  CONSTRAINT pedido_itens_pk          PRIMARY KEY (pedido_id, produto_id),
  CONSTRAINT pedidos_pedido_itens_fk  FOREIGN KEY (pedido_id)   REFERENCES pedidos (pedido_id)   ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE,
  CONSTRAINT produtos_pedido_itens_fk FOREIGN KEY (produto_id)  REFERENCES produtos (produto_id) ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE,
  CONSTRAINT envios_pedido_itens_fk   FOREIGN KEY (envio_id)    REFERENCES envios (envio_id)     ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE
);

COMMENT ON TABLE pedido_itens                  IS 'Informações sobre os itens pedidos em uma loja.';
COMMENT ON COLUMN pedido_itens.pedido_id       IS 'Identificador único do pedido ao qual o item pertence.';
COMMENT ON COLUMN pedido_itens.produto_id      IS 'Identificador único do produto associado ao item do pedido.';
COMMENT ON COLUMN pedido_itens.numero_da_linha IS 'Número da linha do item no pedido.';
COMMENT ON COLUMN pedido_itens.quantidade      IS 'Quantidade do item solicitada no pedido.';
COMMENT ON COLUMN pedido_itens.envio_id        IS 'Identificador único do envio associado ao pedido.';

-- Remover a restrição "pedidos_pedido_itens_fk"
ALTER TABLE pedido_itens DROP CONSTRAINT IF EXISTS pedidos_pedido_itens_fk;

-- Remover a restrição "produtos_pedido_itens_fk"
ALTER TABLE pedido_itens DROP CONSTRAINT IF EXISTS produtos_pedido_itens_fk;

-- Remover a restrição "envios_pedido_itens_fk"
ALTER TABLE pedido_itens DROP CONSTRAINT IF EXISTS envios_pedido_itens_fk;

-- ALTER TABLE é usado para modificar uma tabela existente
-- Neste caso, estamos adicionando restrições FOREIGN KEY à tabela "itens_pedidos"
-- para estabelecer relacionamentos com outras tabelas
ALTER TABLE pedido_itens ADD CONSTRAINT pedidos_pedido_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedido_itens ADD CONSTRAINT produtos_pedido_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedido_itens ADD CONSTRAINT envios_pedido_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;








