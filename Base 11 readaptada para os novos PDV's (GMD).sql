-- Solicitação Aline, via Teams 29/01

select
to_char(df.dtamovimento, 'YYYY') ano,
to_char(df.dtamovimento, 'MM')  mes,
df.nroempresa  loja,
df.nroformapagto  nro_forma,
(select max(fp.formapagto)
from consinco.mrl_formapagto fp
where fp.nroformapagto = df.nroformapagto) as forma_pagto,
sum(it.vlritem)                  as vlr_vendas
from consinco.mfl_doctofiscal df
join consinco.mfl_dfitem it
on it.seqnf      = df.seqnf
and it.nroempresa = df.nroempresa
where df.statusdf = 'V'
and df.nroformapagto = 1
and df.codgeraloper in (76, 810, 910)
and df.dtamovimento between :DT1 and :DT2
and df.pdvorigem is not null
group by
to_char(df.dtamovimento, 'YYYY'),
to_char(df.dtamovimento, 'MM'),
df.nroempresa,
df.nroformapagto
order by
1, 2, 3, 4;
