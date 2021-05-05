select ph.afiliadorfc, a.afiliadofnacmiento, s.sexodesc, ea.estatusafdesc, m.municipiodesc, e.estadodesc,
d.dependenciadesc, o.obligaciondesc,
ph.sueldobase, ph.phfregistro, ph.phfaprobacion, ph.phfcomprometido, ph.phnopagos, ph.phimporte, 
ep.estatusphdesc
from prestamosph ph 
inner join catafiliado a on a.afiliadorfc = ph.afiliadorfc
inner join catsexo s on s.sexoid = a.sexoid
inner join catestatusaf ea on ea.estatusafid = a.estatusafid
inner join catmunicipio m on m.municipioid = a.municipioid
inner join catestado e on e.estadoid = m.estadoid
inner join catdependencia d on (d.dependenciacve = ph.dependenciacve && d.dependenciaclasif = ph.dependenciaclasif)
inner join catobligacion o on o.obligacionid = ph.obligacionid
inner join catestatusph ep on ep.estatusphid = ph.estatusphid
order by ph.phfcomprometido