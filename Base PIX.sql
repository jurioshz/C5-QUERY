-- Base Pix, Solicitação via Teams - Aline P. 11/01

select
       z.nroempresa loja,
       (select max(emp.fantasia)
          from ge_empresa emp
         where emp.nroempresa = z.nroempresa) empresa,
       z.codoperador,
       max(y.nome) operador,
       sum(z.valordigitado) valor
from fiv_tsnoperadorcaixa y,
     (select a.nroempresa,
             a.dtamovimento,
             a.codoperador,
             a.codmovimento,
             sum(a.valor) valordigitado
        from fi_tsmovtoopedetalhe a
       where nvl(a.versao, 'A') = 'N'
         and a.dtamovimento between :DT1 and :DT2
         and a.nroempresa in (#LS1)
       group by a.nroempresa,
                a.dtamovimento,
                a.codoperador,
                a.codmovimento) z
where z.nroempresa = y.nroempresa
  and to_char(z.codoperador) = to_char(y.codoperador)

  and exists (
        select 1
          from fi_tscodmovimento x
         where to_char(x.codmovimento) = to_char(z.codmovimento)
           and x.nroformapagto in (
73,35,36,114,3502,
346,347,348,349,350,351,352,
357,358,
303,314,353,354,355,
301,302,304,306,307,308,309,
310,311,312,313,315,316,317,
318,319,320,321,322,323,324,
325,326,327,328,329,330,331,
332,333,334,335,336,337,338,
339,340,341,342,343,344,345,
19,22,
414,30,
108,
76
))

  and exists (
        select 1
          from consinco.mfl_doctofiscal df
         where df.nroempresa = z.nroempresa
           and df.dtamovimento between :DT1 and :DT2
           and df.statusdf = 'V'
           and df.pdvorigem is not null
           and df.codgeraloper in
           (37,48,76,123,610,615,613,810,916,910,911,
            38,124,612,614,616,917,68,260,267,268,
            618,922,852)
)

group by
       z.nroempresa,
       z.codoperador
having sum(z.valordigitado) > 0
order by
       1,4
