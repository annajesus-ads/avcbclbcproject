USE firetrack_db;

-- ============================================================================
-- CONSULTA 1: Processos de AVCB/CLCB pendentes ou vencidos (Visão Gerencial)
-- Cláusulas aplicadas: SELECT, INNER JOIN (4 tabelas), WHERE, ORDER BY, LIMIT.
-- ============================================================================
SELECT 
    p.numero_protocolo AS protocolo,
    p.tipo_licenca AS licenca,
    p.status_processo AS status_atual,
    p.data_abertura,
    c.nome_razao_social AS cliente,
    CONCAT(e.logradouro, ', ', e.numero, ' - ', e.cidade, '/', e.uf) AS endereco_edificacao,
    pr.nome AS responsavel_tecnico
FROM Processo p
INNER JOIN Edificacao e ON p.id_edificacao = e.id_edificacao
INNER JOIN Cliente c ON e.id_cliente = c.id_cliente
INNER JOIN Profissional pr ON p.id_profissional = pr.id_profissional
WHERE p.status_processo <> 'Emitido'
ORDER BY p.data_abertura ASC
LIMIT 5;

-- ============================================================================
-- CONSULTA 2: Relatório de Não Conformidades Identificadas em Vistorias
-- Cláusulas aplicadas: SELECT, INNER JOIN (7 tabelas), WHERE, ORDER BY, LIMIT.
-- ============================================================================
SELECT 
    v.id_vistoria,
    v.data_vistoria,
    c.nome_razao_social AS cliente,
    ce.nome_categoria AS equipamento,
    eq.localizacao_interna AS local_instalacao,
    iv.descricao_pendencia AS pendencia_identificada,
    iv.observacoes AS acao_recomendada,
    pr.nome AS tecnico_vistoriador
FROM Item_Vistoria iv
INNER JOIN Vistoria v ON iv.id_vistoria = v.id_vistoria
INNER JOIN Equipamento eq ON iv.id_equipamento = eq.id_equipamento
INNER JOIN Categoria_Equipamento ce ON eq.id_categoria = ce.id_categoria
INNER JOIN Edificacao e ON eq.id_edificacao = e.id_edificacao
INNER JOIN Cliente c ON e.id_cliente = c.id_cliente
INNER JOIN Profissional pr ON v.id_profissional = pr.id_profissional
WHERE iv.status_conformidade = FALSE
ORDER BY v.data_vistoria DESC
LIMIT 10;

-- ============================================================================
-- CONSULTA 3: Top 3 Equipamentos com Controle de Validade em Mogi das Cruzes
-- Cláusulas aplicadas: SELECT, INNER JOIN (4 tabelas), WHERE, ORDER BY, LIMIT.
-- ============================================================================
SELECT 
    eq.id_equipamento,
    ce.nome_categoria AS categoria,
    eq.quantidade,
    eq.data_validade,
    eq.localizacao_interna,
    e.tipo_ocupacao,
    c.nome_razao_social AS proprietario
FROM Equipamento eq
INNER JOIN Categoria_Equipamento ce ON eq.id_categoria = ce.id_categoria
INNER JOIN Edificacao e ON eq.id_edificacao = e.id_edificacao
INNER JOIN Cliente c ON e.id_cliente = c.id_cliente
WHERE ce.exige_validade = TRUE 
  AND e.cidade = 'Mogi das Cruzes'
ORDER BY eq.data_validade ASC
LIMIT 3;

-- ============================================================================
-- CONSULTA 4: Equipe Técnica Habilitada com Registro no CREA
-- Cláusulas aplicadas: SELECT, INNER JOIN (2 tabelas), WHERE, ORDER BY, LIMIT.
-- ============================================================================
SELECT 
    pr.nome AS profissional,
    pr.numero_crea AS registro_crea,
    pr.email,
    pa.nome_perfil AS perfil_sistema,
    pa.descricoes_permissoes AS permissoes
FROM Profissional pr
INNER JOIN Perfil_Acesso pa ON pr.id_perfil = pa.id_perfil
WHERE pr.numero_crea IS NOT NULL
ORDER BY pr.nome ASC
LIMIT 5;
