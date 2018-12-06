function [Pfa, vt] = test(nfa, np)
delmax = 0.00001;
eps = 0.000000001;
delta = 10000;
Pfa = np * log(2)/nfa;
sqrtpfa = sqrt(-log10(Pfa));
sqrtnp = sqrt(np);
vt0 = np - sqrtnp + 2.3 * sqrtpfa * (sqrtpfa + sqrtnp - 1.0);
vt =vt0;
while(abs(delta) >= vt0)
    igf = incomplete_gamma(vt0, np);
    num = 0.5^(np/nfa) - igf;
    temp = (np - 1) * log(vt0 + eps) - vt0 - factor_(np-1);
    deno = exp(temp);
    vt = vt0 + (num/(deno+eps));
    delta = abs(vt - vt0) * 10000.0;
    vt0 = vt;
end
end
