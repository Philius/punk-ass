import fontsize;
import plain;
import math;

real WF=297-0.5, HF=210-0.5;
unitsize(1mm);

draw((0.5,0.5)--(WF,0.5)--(WF,HF)--(0.5,HF)--cycle, p=nullpen);
pair d = (297.0/2, 210.0/2);

real m_sz = 40.0/2, m_sz2 = 40.0, h_dist = 31.0/2, axle_r = 12.0, bvl = 4.0;
real sz = m_sz - bvl;
path p_fillet = (m_sz,sz)--(sz,m_sz)--(-sz,m_sz)--(-m_sz,sz)--(-m_sz,-sz)--(-sz,-m_sz)--(sz,-m_sz)--(m_sz,-sz)--cycle;
path p_simple = (m_sz,m_sz2)--(-m_sz,m_sz2)--(-m_sz,-m_sz)--(m_sz,-m_sz)--cycle;

path p = p_simple;
void bkt(transform tx)
{
	draw(tx*p);
	draw(tx*shift(h_dist,h_dist)*scale(1.5)*unitcircle);
	draw(tx*shift(-h_dist,h_dist)*scale(1.5)*unitcircle);
	draw(tx*shift(-h_dist,-h_dist)*scale(1.5)*unitcircle);
	draw(tx*shift(h_dist,-h_dist)*scale(1.5)*unitcircle);
}
// In general we can't let the object centre itself as it might not be symmetrical.
//bkt(identity());
bkt(shift(d));
