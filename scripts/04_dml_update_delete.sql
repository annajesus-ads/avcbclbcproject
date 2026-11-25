USE firetrack_db;

-- ============================================================================
-- ATUALIZAÇÕES SEGURAS (UPDATE COM FILTRO ESTRITO POR CHAVE PRIMÁRIA)
-- ============================================================================

-- UPDATE 1: Renovação de validade de equipamento após recarga anual
UPDATE Equipamento
SET data_validade = '2027-11-25'
WHERE id_equipamento = 3;

-- UPDATE 2: Baixa de não conformidade na tabela associativa Item_Vistoria
UPDATE Item_Vistoria
SET status_conformidade = TRUE,
    descricao_pendencia = NULL,
    observacoes = 'Recarga realizada e etiqueta de inspeção regularizada em re-vistoria.'
WHERE id_vistoria = 2 
  AND id_equipamento = 3;

-- UPDATE 3: Emissão de licença AVCB após cumprimento de Comunique-se
UPDATE Processo
SET status_processo = 'Emitido',
    data_emissao = '2026-11-25',
    data_vencimento = '2029-11-25'
WHERE id_processo = 2;

-- UPDATE 4: Migração de contrato avulso para mensal e atualização de contato
UPDATE Cliente
SET tipo_cliente = 'Mensal',
    telefone = '1147489900'
WHERE id_cliente = 4;

-- ============================================================================
-- EXCLUSÕES SEGURAS (DELETE NA ORDEM INVERSA DE DEPENDÊNCIA: FILHA -> PAI)
-- ============================================================================

-- DELETE 1: Exclusão de item lançado indevidamente em uma vistoria (nível folha)
DELETE FROM Item_Vistoria
WHERE id_vistoria = 1 
  AND id_equipamento = 2;

-- DELETE 2: Exclusão de equipamento desativado após remoção do vínculo filho
DELETE FROM Equipamento
WHERE id_equipamento = 2;

-- DELETE 3: Exclusão de categoria sem equipamentos vinculados
DELETE FROM Categoria_Equipamento
WHERE id_categoria = 4;

-- DELETE 4: Exclusão de colaborador administrativo sem vínculos em Processos/Vistorias
DELETE FROM Profissional
WHERE id_profissional = 4;
