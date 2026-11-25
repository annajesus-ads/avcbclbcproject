USE firetrack_db;

-- ============================================================================
-- NÍVEL 1: ENTIDADES INDEPENDENTES (SEM CHAVES ESTRANGEIRAS)
-- ============================================================================

-- 1. Povoamento da tabela Cliente (contratantes dos serviços de AVCB/CLCB)
INSERT INTO Cliente (nome_razao_social, cpf_cnpj, tipo_cliente, telefone, email) VALUES
('JOÃO PEDRO DOS REIS', '48958020865', 'Mensal', '11995287234', 'psiannajesus@gmail.com'),
('Indústria Metalúrgica Alto Tietê Ltda', '12345678000190', 'Mensal', '1147261100', 'engenharia@altotiete.com.br'),
('Condomínio Residencial Jardins do Vale', '98765432000155', 'Mensal', '1147992233', 'sindico@jardinsdovale.com.br'),
('Supermercado Estrela do Leste S.A.', '45123789000112', 'Avulso', '1147485566', 'manutencao@estreladoleste.com.br');

-- 2. Povoamento da tabela Categoria_Equipamento (domínio normalizado em 3FN)
INSERT INTO Categoria_Equipamento (nome_categoria, exige_validade) VALUES
('Extintor de Incêndio PQS ABC', TRUE),
('Extintor de Incêndio CO2', TRUE),
('Hidrante e Mangueira de Incêndio', TRUE),
('Iluminação de Emergência', FALSE),
('Placa de Sinalização Fotoluminescente', FALSE);

-- 3. Povoamento da tabela Perfil_Acesso (domínio normalizado em 3FN)
INSERT INTO Perfil_Acesso (nome_perfil, descricoes_permissoes) VALUES
('Engenheiro Responsável Técnico', 'Acesso total ao sistema, emissão de ART, abertura de processos, aprovação de laudos e gestão de vistorias.'),
('Técnico Vistoriador', 'Realização de vistorias em campo, registro de conformidade dos equipamentos e anexação de pareceres técnicos.'),
('Assistente Administrativo', 'Cadastro de clientes, edificações, acompanhamento de protocolos e controle de prazos de vencimento.');

-- ============================================================================
-- NÍVEL 2: ENTIDADES DEPENDENTES DO NÍVEL 1
-- ============================================================================

-- 4. Povoamento da tabela Edificacao (depende de Cliente via id_cliente)
INSERT INTO Edificacao (id_cliente, logradouro, numero, bairro, cidade, uf, cep, area_construida_m2, tipo_ocupacao, nome_contato_local, telefone_contato_local) VALUES
(1, 'Rua Voluntário Fernando Pinheiro Franco', '412', 'Centro', 'Mogi das Cruzes', 'SP', '08710500', 480.50, 'Comercial', 'João Pedro', '11995287234'),
(2, 'Avenida Japão', '2850', 'Alto do Ipiranga', 'Mogi das Cruzes', 'SP', '08730330', 3250.00, 'Industrial', 'Carlos Eduardo Souza', '11988776655'),
(3, 'Rua Dr. Deodato Wertheimer', '1590', 'Mogilar', 'Mogi das Cruzes', 'SP', '08773090', 5400.75, 'Residencial Multifamiliar', 'Mariana Costa', '11977665544'),
(4, 'Estrada de Santa Isabel', '980', 'Monte Belo', 'Itaquaquecetuba', 'SP', '08577000', 1620.00, 'Comercial / Varejo', 'Roberto Almeida', '11966554433');

-- 5. Povoamento da tabela Profissional (depende de Perfil_Acesso via id_perfil)
INSERT INTO Profissional (nome, id_perfil, numero_crea, email, telefone) VALUES
('Eng. Rafael Mendes Oliveira', 1, '5069874123/D', 'rafael.eng@firetrack.com.br', '11991112222'),
('Téc. Lucas Ferreira Santos', 2, '5071234987/T', 'lucas.vistoria@firetrack.com.br', '11993334444'),
('Téc. Camila Rodrigues Lima', 2, '5074567890/T', 'camila.vistoria@firetrack.com.br', '11995556666'),
('Beatriz Nogueira Silva', 3, NULL, 'beatriz.adm@firetrack.com.br', '11997778888');

-- ============================================================================
-- NÍVEL 3: ENTIDADES DEPENDENTES DO NÍVEL 2
-- ============================================================================

-- 6. Povoamento da tabela Equipamento (depende de Edificacao e Categoria_Equipamento)
INSERT INTO Equipamento (id_edificacao, id_categoria, localizacao_interna, quantidade, data_validade) VALUES
(1, 1, 'Recepção Térreo - Hall Principal', 2, '2027-06-15'),
(1, 4, 'Corredor Administrativo 1º Andar', 4, NULL),
(2, 1, 'Galpão de Produção - Setor A', 6, '2026-10-10'),
(2, 3, 'Saída Lateral - Doca de Carga', 2, '2027-03-20'),
(3, 2, 'Subsolo Garagem - Casa de Máquinas', 2, '2027-08-01'),
(4, 5, 'Rota de Fuga - Saída de Emergência Fundos', 8, NULL);

-- 7. Povoamento da tabela Processo (depende de Edificacao e Profissional)
INSERT INTO Processo (id_edificacao, id_profissional, tipo_licenca, numero_protocolo, numero_art, data_abertura, data_emissao, data_vencimento, status_processo) VALUES
(1, 1, 'CLCB', 'VF-2026-001482', '28027230260451234', '2026-02-10', '2026-03-05', '2029-03-05', 'Emitido'),
(2, 1, 'AVCB', 'VF-2026-002915', '28027230260459876', '2026-08-18', NULL, NULL, 'Comunique-se'),
(3, 1, 'AVCB', 'VF-2026-003410', '28027230260461122', '2026-10-01', NULL, NULL, 'Em Análise'),
(4, 1, 'AVCB', 'VF-2023-008741', '28027230230198877', '2023-09-12', '2023-11-20', '2026-11-20', 'Vencido');

-- ============================================================================
-- NÍVEL 4: ENTIDADES DEPENDENTES DO NÍVEL 3
-- ============================================================================

-- 8. Povoamento da tabela Vistoria (depende de Processo e Profissional)
INSERT INTO Vistoria (id_processo, id_profissional, data_vistoria, parecer_geral) VALUES
(1, 2, '2026-02-22', 'Edificação em plena conformidade com o projeto técnico aprovado. Equipamentos sinalizados e dentro da validade.'),
(2, 2, '2026-09-04', 'Identificada necessidade de recarga nos extintores do Galpão A e desobstrução do abrigo de hidrante.'),
(3, 3, '2026-10-15', 'Vistoria preventiva concluída sem restrições operacionais; aguardando análise documental do Corpo de Bombeiros.'),
(4, 3, '2026-11-18', 'Vistoria de renovação realizada. Sinalização de emergência íntegra; processo encaminhado para renovação de AVCB.');

-- ============================================================================
-- NÍVEL 5: TABELA ASSOCIATIVA (DEPENDENTE DE VISTORIA E EQUIPAMENTO)
-- ============================================================================

-- 9. Povoamento da tabela Item_Vistoria (chave primária composta: id_vistoria + id_equipamento)
INSERT INTO Item_Vistoria (id_vistoria, id_equipamento, status_conformidade, descricao_pendencia, observacoes) VALUES
(1, 1, TRUE, NULL, 'Manômetro na faixa verde e lacre inviolado.'),
(1, 2, TRUE, NULL, 'Luminárias testadas com autonomia superior a 1 hora.'),
(2, 3, FALSE, 'Carga vencida em outubro/2026 e etiqueta de inspeção ilegível.', 'Solicitada recarga imediata junto à empresa credenciada.'),
(2, 4, TRUE, NULL, 'Mangueira tipo 2 acondicionada corretamente e teste hidrostático vigente.'),
(3, 5, TRUE, NULL, 'Cilindro de CO2 instalado na altura regulamentar.'),
(4, 6, TRUE, NULL, 'Placas fotoluminescentes visíveis em toda a rota de saída.');
