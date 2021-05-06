select ph.afiliadorfc, a.afiliadofnacmiento, s.sexodesc, ea.estatusafdesc, m.municipiodesc, e.estadodesc,
d.dependenciadesc, o.obligaciondesc,
ph.sueldobase, ph.phfregistro, ph.phfaprobacion, ph.phfcomprometido, ph.phnopagos, ph.phimporte, 
ep.estatusphdesc
from mtie_dbpgh.prestamosph ph 
inner join mtie_dbpgh.catafiliado a on a.afiliadorfc = ph.afiliadorfc
inner join mtie_dbpgh.catsexo s on s.sexoid = a.sexoid
inner join mtie_dbpgh.catestatusaf ea on ea.estatusafid = a.estatusafid
inner join mtie_dbpgh.catmunicipio m on m.municipioid = a.municipioid
inner join mtie_dbpgh.catestado e on e.estadoid = m.estadoid
inner join mtie_dbpgh.catdependencia d on (d.dependenciacve = ph.dependenciacve && d.dependenciaclasif = ph.dependenciaclasif)
inner join mtie_dbpgh.catobligacion o on o.obligacionid = ph.obligacionid
inner join mtie_dbpgh.catestatusph ep on ep.estatusphid = ph.estatusphid
order by ph.phfcomprometido