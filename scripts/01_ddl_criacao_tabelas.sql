-- Criação do banco de dados base (schema) do sistema FireTrack
CREATE DATABASE IF NOT EXISTS firetrack_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE firetrack_db;

-- ============================================================================
-- NÍVEL 1: ENTIDADES INDEPENDENTES (SEM CHAVES ESTRANGEIRAS)
-- ============================================================================

CREATE TABLE IF NOT EXISTS Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_razao_social VARCHAR(150) NOT NULL,
    cpf_cnpj VARCHAR(14) NOT NULL UNIQUE,
    tipo_cliente VARCHAR(20) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Categoria_Equipamento (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(80) NOT NULL UNIQUE,
    exige_validade BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS Perfil_Acesso (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nome_perfil VARCHAR(50) NOT NULL UNIQUE,
    descricoes_permissoes TEXT NOT NULL
);

-- ============================================================================
-- NÍVEL 2: ENTIDADES DEPENDENTES DO NÍVEL 1
-- ============================================================================

CREATE TABLE IF NOT EXISTS Edificacao (
    id_edificacao INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(80) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    area_construida_m2 DECIMAL(10,2) NOT NULL,
    tipo_ocupacao VARCHAR(80) NOT NULL,
    nome_contato_local VARCHAR(100),
    telefone_contato_local VARCHAR(15),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE IF NOT EXISTS Profissional (
    id_profissional INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    id_perfil INT NOT NULL,
    numero_crea VARCHAR(25),
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    FOREIGN KEY (id_perfil) REFERENCES Perfil_Acesso(id_perfil)
);

-- ============================================================================
-- NÍVEL 3: ENTIDADES DEPENDENTES DO NÍVEL 2
-- ============================================================================

CREATE TABLE IF NOT EXISTS Equipamento (
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
    id_edificacao INT NOT NULL,
    id_categoria INT NOT NULL,
    localizacao_interna VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL,
    data_validade DATE,
    FOREIGN KEY (id_edificacao) REFERENCES Edificacao(id_edificacao),
    FOREIGN KEY (id_categoria) REFERENCES Categoria_Equipamento(id_categoria)
);

CREATE TABLE IF NOT EXISTS Processo (
    id_processo INT AUTO_INCREMENT PRIMARY KEY,
    id_edificacao INT NOT NULL,
    id_profissional INT NOT NULL,
    tipo_licenca VARCHAR(20) NOT NULL,
    numero_protocolo VARCHAR(30) UNIQUE,
    numero_art VARCHAR(30),
    data_abertura DATE NOT NULL,
    data_emissao DATE,
    data_vencimento DATE,
    status_processo VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_edificacao) REFERENCES Edificacao(id_edificacao),
    FOREIGN KEY (id_profissional) REFERENCES Profissional(id_profissional)
);

-- ============================================================================
-- NÍVEL 4: ENTIDADES DEPENDENTES DO NÍVEL 3
-- ============================================================================

CREATE TABLE IF NOT EXISTS Vistoria (
    id_vistoria INT AUTO_INCREMENT PRIMARY KEY,
    id_processo INT NOT NULL,
    id_profissional INT NOT NULL,
    data_vistoria DATE NOT NULL,
    parecer_geral TEXT,
    FOREIGN KEY (id_processo) REFERENCES Processo(id_processo),
    FOREIGN KEY (id_profissional) REFERENCES Profissional(id_profissional)
);

-- ============================================================================
-- NÍVEL 5: TABELA ASSOCIATIVA (CHAVE PRIMÁRIA COMPOSTA)
-- ============================================================================

CREATE TABLE IF NOT EXISTS Item_Vistoria (
    id_vistoria INT NOT NULL,
    id_equipamento INT NOT NULL,
    status_conformidade BOOLEAN NOT NULL,
    descricao_pendencia TEXT,
    observacoes TEXT,
    PRIMARY KEY (id_vistoria, id_equipamento),
    FOREIGN KEY (id_vistoria) REFERENCES Vistoria(id_vistoria),
    FOREIGN KEY (id_equipamento) REFERENCES Equipamento(id_equipamento)
);
