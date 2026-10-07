SELECT
    LOJA,
    PLU,
    PRODUTO,
    QTDE_NA_LOJA,
    QTDE_TODAS_LOJAS
FROM (
    SELECT
        GI.NROEMPRESA LOJA,
        O.SEQPRODUTO PLU,
        O.DESCCOMPLETA PRODUTO,
        COUNT(*) QTDE_NA_LOJA,
        VA.QTDE_TODAS_LOJAS,
        ROW_NUMBER() OVER (
            ORDER BY COUNT(*) DESC,
                     VA.QTDE_TODAS_LOJAS DESC
        ) RN_FINAL
    FROM consinco.MRL_PROMOCESPECIALHIST GI,
         consinco.MAP_PRODUTO O,
         consinco.MAP_FAMFORNEC FF,
         consinco.GE_PESSOA F,
         (
            SELECT *
            FROM (
                SELECT
                    SEQPRODUTO,
                    COUNT(*) QTDE_TODAS_LOJAS,
                    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) RN
                FROM consinco.MRL_PROMOCESPECIALHIST
                WHERE DTAINICIO BETWEEN :DT1 AND :DT2
                GROUP BY SEQPRODUTO
            )
            WHERE RN <= 20
         ) VA,
         (
            SELECT *
            FROM (
                SELECT
                    NROEMPRESA,
                    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) RN
                FROM consinco.MRL_PROMOCESPECIALHIST
                WHERE DTAINICIO BETWEEN :DT1 AND :DT2
                GROUP BY NROEMPRESA
            )
            WHERE RN <= 20
         ) N
    WHERE GI.SEQPRODUTO = O.SEQPRODUTO
      AND O.SEQFAMILIA = FF.SEQFAMILIA
      AND FF.SEQFORNECEDOR = F.SEQPESSOA
      AND F.SEQPESSOA = :LT1
      AND GI.SEQPRODUTO = VA.SEQPRODUTO
      AND GI.NROEMPRESA = N.NROEMPRESA
      AND GI.DTAINICIO BETWEEN :DT1 AND :DT2
    GROUP BY
        GI.NROEMPRESA,
        O.SEQPRODUTO,
        O.DESCCOMPLETA,
        VA.QTDE_TODAS_LOJAS
)
WHERE RN_FINAL <= 20
ORDER BY QTDE_NA_LOJA DESC,
         QTDE_TODAS_LOJAS DESC;
